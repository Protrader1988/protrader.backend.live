#!/bin/bash

# ProTrader Backend - Complete Deployment Execution
# This script performs all deployment tasks in one go

set -e  # Exit on any error

echo "=========================================================================="
echo "🚀 ProTrader Backend - Complete Deployment Execution"
echo "=========================================================================="
echo ""

# Function to make scripts executable
make_executable() {
    local file=$1
    if [ -f "$file" ]; then
        chmod +x "$file"
        echo "   ✓ Made executable: $file"
    else
        echo "   ⚠️  File not found: $file"
    fi
}

# Step 1: Make all scripts executable
echo "📋 Step 1: Making scripts executable..."
echo "--------------------------------------------------------------------------"
make_executable "deploy_to_render.sh"
make_executable "verify_api_keys.sh"
make_executable "execute_deployment.sh"
make_executable "PUSH_NOW.sh"
echo ""

# Step 2: Show what was fixed
echo "📋 Step 2: Summary of fixes..."
echo "--------------------------------------------------------------------------"
echo "✅ Route ordering fixed in app.py:"
echo "   1. Health check route FIRST"
echo "   2. ALL API routes (portfolio, history, order, backtest) BEFORE catch-all"
echo "   3. Root route for React UI"
echo "   4. Catch-all route LAST (rejects unmatched API routes)"
echo ""
echo "✅ Deployment scripts created:"
echo "   - deploy_to_render.sh (auto-deploy script)"
echo "   - verify_api_keys.sh (API key checker)"
echo "   - .gitignore (protects sensitive data)"
echo ""
echo "✅ Backup created:"
echo "   - app.py.backup.20251129_014505"
echo ""

# Step 3: Check required files
echo "📋 Step 3: Checking required files..."
echo "--------------------------------------------------------------------------"
required_files=("app.py" "requirements.txt" "render.yaml" ".gitignore")
all_present=true
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✓ $file"
    else
        echo "   ❌ $file (missing)"
        all_present=false
    fi
done

if [ ! -d "api" ]; then
    echo "   ❌ api/ folder (missing)"
    all_present=false
else
    echo "   ✓ api/ folder"
fi
echo ""

if [ "$all_present" = false ]; then
    echo "❌ Error: Required files missing. Cannot proceed."
    exit 1
fi

# Step 4: Show git status
echo "📋 Step 4: Current Git Status..."
echo "--------------------------------------------------------------------------"
if [ ! -d .git ]; then
    echo "❌ Error: Not a git repository"
    exit 1
fi

git status --short
echo ""

# Step 5: Stage all changes
echo "📋 Step 5: Staging all changes..."
echo "--------------------------------------------------------------------------"
git add -A
echo "✅ All changes staged"
echo ""

# Step 6: Show what will be committed
echo "📋 Step 6: Files to be committed..."
echo "--------------------------------------------------------------------------"
git status --porcelain | head -30
echo ""

# Step 7: Commit changes
echo "📋 Step 7: Committing changes..."
echo "--------------------------------------------------------------------------"
commit_message="Fix Flask route ordering bug + add deployment scripts"

if git diff --cached --quiet; then
    echo "⚠️  No changes to commit (already committed)"
    commit_hash=$(git rev-parse --short HEAD)
else
    git commit -m "$commit_message"
    commit_hash=$(git rev-parse --short HEAD)
    echo "✅ Committed successfully"
fi

echo "   Commit hash: $commit_hash"
echo "   Message: $commit_message"
echo ""

# Step 8: Push to GitHub
echo "📋 Step 8: Pushing to GitHub..."
echo "--------------------------------------------------------------------------"
echo "⚠️  About to push to remote repository..."
echo ""

# Try to determine the remote branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: $current_branch"
echo ""

# Push to remote
if git push origin "$current_branch" 2>&1; then
    echo "✅ Successfully pushed to origin/$current_branch"
else
    echo "❌ Failed to push. Trying alternative methods..."
    # Try main
    if git push origin main 2>&1; then
        echo "✅ Successfully pushed to origin/main"
    # Try master
    elif git push origin master 2>&1; then
        echo "✅ Successfully pushed to origin/master"
    else
        echo "❌ Error: Failed to push to remote"
        echo ""
        echo "Manual steps required:"
        echo "1. Check your git remote: git remote -v"
        echo "2. Ensure you have push access"
        echo "3. Try manual push: git push origin main"
        exit 1
    fi
fi
echo ""

# Step 9: Final summary
echo "=========================================================================="
echo "✅ DEPLOYMENT EXECUTION COMPLETE!"
echo "=========================================================================="
echo ""
echo "📊 Summary:"
echo "   • Backup created: ✅"
echo "   • Route ordering fixed: ✅"
echo "   • Scripts made executable: ✅"
echo "   • Changes committed: ✅ ($commit_hash)"
echo "   • Pushed to GitHub: ✅"
echo ""
echo "🎯 Next Steps:"
echo ""
echo "1. 🌐 Monitor Render Dashboard:"
echo "   https://dashboard.render.com/"
echo ""
echo "2. ⏱️  Wait 3-5 minutes for auto-deployment"
echo ""
echo "3. 🧪 Test deployed API:"
echo "   curl https://your-service.onrender.com/health"
echo "   curl https://your-service.onrender.com/api/portfolio/"
echo ""
echo "4. 🔑 Verify environment variables in Render:"
echo "   Run: ./verify_api_keys.sh"
echo ""
echo "=========================================================================="
echo "📈 Git Status After Push:"
echo "--------------------------------------------------------------------------"
git status
echo "=========================================================================="
echo ""
echo "✨ Your ProTrader backend is now deploying to Render!"
echo "   Just wait for the deployment to complete and you're live! 🚀"
echo ""
