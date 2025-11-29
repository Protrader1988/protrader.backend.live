#!/bin/bash

echo "========================================="
echo "🚀 ProTrader Backend - Push to GitHub"
echo "========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "app.py" ]; then
    echo "❌ Error: Not in protrader-backend directory"
    exit 1
fi

# Show what we're about to push
echo "📦 Changes to push:"
git log origin/main..HEAD --oneline
echo ""

# Attempt push
echo "🔄 Pushing to GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "✅ SUCCESS! Changes pushed to GitHub"
    echo "========================================="
    echo ""
    echo "🎯 Next Steps:"
    echo "1. Go to your Render dashboard"
    echo "2. Watch the deployment logs"
    echo "3. Once deployed, test: https://your-app.onrender.com/health"
    echo ""
else
    echo ""
    echo "========================================="
    echo "❌ Push failed - Authentication needed"
    echo "========================================="
    echo ""
    echo "📝 To fix this, you need to authenticate with GitHub."
    echo ""
    echo "Option 1 - Use GitHub CLI (if installed):"
    echo "  gh auth login"
    echo ""
    echo "Option 2 - Use Personal Access Token:"
    echo "  git push https://YOUR_TOKEN@github.com/Protrader1988/protrader.backend.live.git main"
    echo ""
    echo "Option 3 - Configure credential helper:"
    echo "  git config credential.helper store"
    echo "  git push (then enter your GitHub username and PAT when prompted)"
    echo ""
fi
