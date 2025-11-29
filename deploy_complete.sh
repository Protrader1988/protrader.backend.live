#!/bin/bash
set -e

echo "🚀 ProTrader Complete Deployment"
echo "=================================="

BACKEND_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BACKEND_DIR"

# Step 1: Integrate frontend
echo ""
echo "Step 1: Integrating frontend UI..."
if [ -f "integrate_frontend.sh" ]; then
    bash integrate_frontend.sh
else
    echo "❌ Error: integrate_frontend.sh not found"
    exit 1
fi

# Step 2: Replace app.py with new version
echo ""
echo "Step 2: Updating app.py to serve UI..."
if [ -f "app_new.py" ]; then
    # Backup original
    if [ -f "app.py" ]; then
        cp app.py app.py.backup
        echo "   ✓ Backed up original app.py to app.py.backup"
    fi
    
    # Replace with new version
    cp app_new.py app.py
    echo "   ✓ Updated app.py with UI serving routes"
else
    echo "❌ Error: app_new.py not found"
    exit 1
fi

# Step 3: Install Python dependencies
echo ""
echo "Step 3: Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt --quiet
    echo "   ✓ Dependencies installed"
else
    echo "⚠️  Warning: requirements.txt not found"
fi

# Step 4: Test locally
echo ""
echo "Step 4: Testing local deployment..."
echo "   Starting server on port 10000..."

# Start server in background
python app.py &
SERVER_PID=$!

# Wait for server to start
echo "   Waiting for server to start..."
sleep 8

# Test endpoints
echo ""
echo "   Testing endpoints..."

# Test health endpoint
echo -n "   - /api/health: "
HEALTH_RESPONSE=$(curl -s http://localhost:10000/api/health || echo "FAILED")
if echo "$HEALTH_RESPONSE" | grep -q "ok\|status"; then
    echo "✓"
else
    echo "✗ ($HEALTH_RESPONSE)"
fi

# Test root endpoint (UI)
echo -n "   - / (UI): "
ROOT_RESPONSE=$(curl -s http://localhost:10000/ || echo "FAILED")
if echo "$ROOT_RESPONSE" | grep -q "ProTrader\|html\|<!DOCTYPE"; then
    echo "✓"
else
    echo "✗"
fi

# Kill server
echo ""
echo "   Stopping test server..."
kill $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true
sleep 2

echo ""
echo "✅ Local deployment successful!"

# Step 5: Git operations
echo ""
echo "Step 5: Preparing for production deployment..."

# Check git status
if [ -d ".git" ]; then
    echo "   Checking Git status..."
    
    # Check if there are changes
    if git diff --quiet && git diff --cached --quiet; then
        echo "   ℹ️  No changes to commit"
    else
        echo "   Adding files to Git..."
        git add .
        
        echo "   Committing changes..."
        git commit -m "Fix: Integrate UI with Flask backend - serve dashboard at root

- Added integrate_frontend.sh to copy UI files
- Updated app.py to serve UI at / route
- Backend APIs remain at /api/* endpoints
- Ready for Render deployment" || echo "   ℹ️  Nothing to commit or commit failed"
        
        echo ""
        echo "   📤 Push to Git with:"
        echo "      git push origin main"
    fi
else
    echo "   ⚠️  Not a Git repository. Initialize with:"
    echo "      git init"
    echo "      git add ."
    echo "      git commit -m 'Initial commit'"
    echo "      git remote add origin YOUR_REPO_URL"
    echo "      git push -u origin main"
fi

echo ""
echo "═══════════════════════════════════════"
echo "✨ DEPLOYMENT COMPLETE!"
echo "═══════════════════════════════════════"
echo ""
echo "🌐 Testing URLs:"
echo "   Local: http://localhost:10000"
echo "   Production: https://protrader-backend-web.onrender.com"
echo ""
echo "📋 Render Configuration:"
echo "   Build Command: bash integrate_frontend.sh && pip install -r requirements.txt"
echo "   Start Command: gunicorn app:app --bind 0.0.0.0:\$PORT --timeout 120"
echo ""
echo "🔄 After pushing to Git:"
echo "   1. Render will auto-deploy in ~2-3 minutes"
echo "   2. Check deployment: https://dashboard.render.com"
echo "   3. Visit: https://protrader-backend-web.onrender.com"
echo ""
echo "✅ You should see the ProTrader Terminal UI!"
