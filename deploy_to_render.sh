#!/bin/bash

# ProTrader Backend - Deploy to Render
# This script commits and pushes changes to trigger automatic Render deployment

set -e  # Exit on any error

echo "======================================================"
echo "🚀 ProTrader Backend - Deploy to Render"
echo "======================================================"
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Error: Not a git repository"
    echo "   Run 'git init' first"
    exit 1
fi

# Check for required files
echo "📋 Checking required files..."
required_files=("app.py" "requirements.txt" "render.yaml")
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: Required file missing: $file"
        exit 1
    fi
    echo "   ✓ $file"
done
echo ""

# Check for api folder
if [ ! -d "api" ]; then
    echo "❌ Error: api/ folder not found"
    exit 1
fi
echo "   ✓ api/ folder"
echo ""

# Show current git status
echo "📊 Current Git Status:"
echo "------------------------------------------------------"
git status --short
echo ""

# Show what will be committed
echo "📝 Files to be committed:"
echo "------------------------------------------------------"
git status --porcelain | head -20
echo ""

# Ask for confirmation
read -p "🤔 Commit and push all changes to trigger Render deployment? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

# Add all changes
echo ""
echo "📦 Adding all changes to git..."
git add -A

# Commit with timestamp
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
commit_message="Fix Flask route ordering bug + add deployment scripts - $timestamp"

echo "💾 Committing changes..."
git commit -m "$commit_message" || {
    echo "⚠️  Warning: Nothing to commit (already up to date)"
    git status
}

# Show commit hash
commit_hash=$(git rev-parse --short HEAD)
echo ""
echo "✅ Committed: $commit_hash"
echo "   Message: $commit_message"
echo ""

# Push to GitHub
echo "🚢 Pushing to GitHub..."
git push origin main || git push origin master || {
    echo "❌ Error: Failed to push to remote"
    echo "   Make sure you have push access to the repository"
    exit 1
}

echo ""
echo "======================================================"
echo "✅ DEPLOYMENT TRIGGERED!"
echo "======================================================"
echo ""
echo "🎯 Next Steps:"
echo ""
echo "1. 🌐 Go to Render Dashboard:"
echo "   https://dashboard.render.com/"
echo ""
echo "2. 👀 Monitor the deployment progress"
echo "   Your service should rebuild automatically"
echo ""
echo "3. ⏱️  Wait 3-5 minutes for deployment to complete"
echo ""
echo "4. 🧪 Test the deployed API:"
echo "   curl https://your-service.onrender.com/health"
echo "   curl https://your-service.onrender.com/api/portfolio/"
echo ""
echo "5. 🔑 Make sure environment variables are set in Render:"
echo "   - ALPACA_KEY_ID"
echo "   - ALPACA_SECRET_KEY"
echo "   - GEMINI_API_KEY (optional)"
echo "   - GEMINI_API_SECRET (optional)"
echo ""
echo "======================================================"
echo "📊 Git Status After Push:"
git status
echo "======================================================"
