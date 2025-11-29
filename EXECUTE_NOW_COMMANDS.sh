#!/bin/bash

# ProTrader Backend - Git Commit and Push
# Execute this to complete the deployment

cd ~/protrader-backend || exit 1

echo "=========================================================================="
echo "🚀 Executing ProTrader Backend Deployment"
echo "=========================================================================="
echo ""

# Make scripts executable
echo "📋 Making scripts executable..."
chmod +x deploy_to_render.sh 2>/dev/null || true
chmod +x verify_api_keys.sh 2>/dev/null || true
chmod +x execute_deployment.sh 2>/dev/null || true
chmod +x PUSH_NOW.sh 2>/dev/null || true
chmod +x EXECUTE_NOW_COMMANDS.sh 2>/dev/null || true
echo "✅ Scripts are now executable"
echo ""

# Show current status
echo "📋 Current directory:"
pwd
echo ""

echo "📋 Git status BEFORE commit:"
git status --short
echo ""

# Stage all changes
echo "📋 Staging all changes..."
git add -A
echo "✅ All changes staged"
echo ""

# Show what will be committed
echo "📋 Files staged for commit:"
git diff --cached --name-only
echo ""

# Commit changes
echo "📋 Committing changes..."
commit_message="Fix Flask route ordering bug + add deployment scripts"
git commit -m "$commit_message" || {
    echo "⚠️  No new changes to commit (already committed)"
}
echo ""

# Get commit hash
commit_hash=$(git rev-parse --short HEAD)
echo "✅ Current commit: $commit_hash"
echo ""

# Determine current branch
current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
echo "📋 Current branch: $current_branch"
echo ""

# Push to remote
echo "📋 Pushing to GitHub..."
echo "   This will trigger Render auto-deployment..."
echo ""

if git push origin "$current_branch" 2>&1; then
    echo ""
    echo "=========================================================================="
    echo "✅ SUCCESS! Pushed to origin/$current_branch"
    echo "=========================================================================="
else
    echo ""
    echo "⚠️  Push to $current_branch failed. Trying 'main'..."
    if git push origin main 2>&1; then
        echo ""
        echo "=========================================================================="
        echo "✅ SUCCESS! Pushed to origin/main"
        echo "=========================================================================="
    else
        echo ""
        echo "⚠️  Push to main failed. Trying 'master'..."
        if git push origin master 2>&1; then
            echo ""
            echo "=========================================================================="
            echo "✅ SUCCESS! Pushed to origin/master"
            echo "=========================================================================="
        else
            echo ""
            echo "=========================================================================="
            echo "❌ PUSH FAILED"
            echo "=========================================================================="
            echo ""
            echo "Possible issues:"
            echo "1. No push access to repository"
            echo "2. Remote not configured: git remote -v"
            echo "3. Branch doesn't exist on remote"
            echo ""
            echo "Try manual push:"
            echo "  git push origin main"
            echo "  - OR -"
            echo "  git push origin master"
            exit 1
        fi
    fi
fi

echo ""
echo "📊 Git status AFTER push:"
git status
echo ""

echo "=========================================================================="
echo "✅ DEPLOYMENT TRIGGERED!"
echo "=========================================================================="
echo ""
echo "🎯 Next Steps:"
echo ""
echo "1. 🌐 Go to Render Dashboard:"
echo "   https://dashboard.render.com/"
echo ""
echo "2. 👀 Watch your service rebuild (3-5 minutes)"
echo ""
echo "3. 🔑 Set environment variables in Render:"
echo "   - ALPACA_KEY_ID"
echo "   - ALPACA_SECRET_KEY"
echo "   - ALPACA_ENV=paper"
echo ""
echo "4. 🧪 Test the deployed API:"
echo "   curl https://your-service.onrender.com/health"
echo ""
echo "=========================================================================="
echo ""
echo "✨ ProTrader backend is now deploying to Render! 🚀"
echo ""
