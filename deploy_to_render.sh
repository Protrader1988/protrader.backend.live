#!/bin/bash

# ProTrader Backend Deployment Script for Render
# This script checks requirements, commits changes, and pushes to GitHub to trigger Render deployment

set -e  # Exit on error

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         ProTrader Backend - Render Deployment Script          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Step 1: Check for required files
echo "📋 Step 1: Checking for required files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

REQUIRED_FILES=("app.py" "requirements.txt" "render.yaml")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "Found: $file"
    else
        print_error "Missing: $file"
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -ne 0 ]; then
    print_error "Deployment cannot proceed. Missing required files:"
    for file in "${MISSING_FILES[@]}"; do
        echo "  - $file"
    done
    exit 1
fi

echo ""

# Step 2: Check if we're in a git repository
echo "🔍 Step 2: Checking Git repository status..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not a git repository. Please initialize git first:"
    echo "  git init"
    echo "  git remote add origin <your-repo-url>"
    exit 1
fi

print_success "Git repository detected"

# Check if remote origin is configured
if ! git remote get-url origin > /dev/null 2>&1; then
    print_warning "No remote 'origin' configured"
    echo "Please add a remote repository:"
    echo "  git remote add origin <your-github-repo-url>"
    exit 1
fi

REMOTE_URL=$(git remote get-url origin)
print_success "Remote origin: $REMOTE_URL"

echo ""

# Step 3: Show current git status
echo "📊 Step 3: Current Git Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git status
echo ""

# Check if there are changes to commit
if git diff-index --quiet HEAD -- 2>/dev/null; then
    print_warning "No changes detected to commit"
    read -p "Do you want to push anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Deployment cancelled"
        exit 0
    fi
else
    print_info "Changes detected and ready to commit"
fi

echo ""

# Step 4: Show what will be committed
echo "📝 Step 4: Files to be committed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git status --short
echo ""

# Step 5: Prompt for confirmation
echo "⚡ Step 5: Deployment Confirmation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_warning "This will:"
echo "  1. Stage all changes (git add .)"
echo "  2. Commit with message: 'Fix Flask route ordering bug + add deployment scripts'"
echo "  3. Push to GitHub (triggering Render auto-deploy)"
echo ""
read -p "Proceed with deployment? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Deployment cancelled by user"
    exit 0
fi

echo ""

# Step 6: Stage all changes
echo "➕ Step 6: Staging changes..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git add .
print_success "All changes staged"
echo ""

# Step 7: Commit changes
echo "💾 Step 7: Committing changes..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
COMMIT_MESSAGE="Fix Flask route ordering bug + add deployment scripts"

if git commit -m "$COMMIT_MESSAGE"; then
    COMMIT_HASH=$(git rev-parse --short HEAD)
    print_success "Changes committed successfully"
    print_info "Commit hash: $COMMIT_HASH"
    print_info "Commit message: $COMMIT_MESSAGE"
else
    # If commit fails (e.g., nothing to commit), try to get current hash
    if git diff-index --quiet HEAD -- 2>/dev/null; then
        print_warning "Nothing to commit (working tree clean)"
        COMMIT_HASH=$(git rev-parse --short HEAD)
        print_info "Current commit hash: $COMMIT_HASH"
    else
        print_error "Commit failed"
        exit 1
    fi
fi

echo ""

# Step 8: Push to GitHub
echo "🚀 Step 8: Pushing to GitHub..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
print_info "Pushing to branch: $CURRENT_BRANCH"

if git push origin "$CURRENT_BRANCH"; then
    print_success "Successfully pushed to GitHub!"
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                    🎉 DEPLOYMENT INITIATED! 🎉                 ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    print_success "Changes pushed to GitHub successfully"
    print_success "Render auto-deploy should trigger automatically"
    echo ""
    print_info "Next Steps:"
    echo "  1. Check Render Dashboard: https://dashboard.render.com"
    echo "  2. Monitor deployment logs for any errors"
    echo "  3. Verify deployment completes successfully"
    echo "  4. Test the live API endpoints"
    echo ""
    print_warning "Remember to set environment variables in Render Dashboard:"
    echo "  - ALPACA_API_KEY"
    echo "  - ALPACA_SECRET_KEY"
    echo "  - ALPACA_BASE_URL"
    echo "  - Run ./verify_api_keys.sh for detailed checklist"
    echo ""
else
    print_error "Failed to push to GitHub"
    print_info "Troubleshooting:"
    echo "  1. Check your internet connection"
    echo "  2. Verify GitHub credentials/SSH keys"
    echo "  3. Ensure you have push permissions"
    echo "  4. Try: git push -u origin $CURRENT_BRANCH"
    exit 1
fi

echo "✨ Deployment script completed successfully!"
echo ""
