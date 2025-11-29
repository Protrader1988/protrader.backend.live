#!/bin/bash

echo "🔍 ProTrader Deployment Verification Script"
echo "============================================"
echo ""

BACKEND_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BACKEND_DIR"

PASSED=0
FAILED=0

# Function to check file exists
check_file() {
    if [ -f "$1" ]; then
        echo "✅ $2"
        ((PASSED++))
    else
        echo "❌ $2 - File not found: $1"
        ((FAILED++))
    fi
}

# Function to check directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo "✅ $2"
        ((PASSED++))
    else
        echo "❌ $2 - Directory not found: $1"
        ((FAILED++))
    fi
}

# Function to check file contains text
check_contains() {
    if grep -q "$2" "$1" 2>/dev/null; then
        echo "✅ $3"
        ((PASSED++))
    else
        echo "❌ $3"
        ((FAILED++))
    fi
}

echo "📂 Checking Integration Files..."
echo "--------------------------------"
check_file "integrate_frontend.sh" "Integration script exists"
check_file "deploy_complete.sh" "Deployment script exists"
check_file "app_new.py" "New app.py template exists"
check_file "FIX_DEPLOYMENT_INSTRUCTIONS.md" "Instructions document exists"
check_file "EXECUTE_NOW.md" "Quick start guide exists"

echo ""
echo "📁 Checking Directory Structure..."
echo "-----------------------------------"
check_dir "templates" "Templates directory exists"
check_dir "static" "Static directory exists"
check_dir "api" "API directory exists"

echo ""
echo "📄 Checking UI Files..."
echo "------------------------"
check_file "templates/index.html" "UI template file exists"

if [ -f "templates/index.html" ]; then
    check_contains "templates/index.html" "ProTrader Terminal" "UI template contains ProTrader content"
fi

echo ""
echo "🐍 Checking app.py Configuration..."
echo "------------------------------------"
check_file "app.py" "app.py exists"

if [ -f "app.py" ]; then
    check_contains "app.py" "render_template" "app.py has render_template import"
    check_contains "app.py" "static_folder" "app.py has static_folder configured"
    check_contains "app.py" "template_folder" "app.py has template_folder configured"
    
    if grep -q "def index():" "app.py"; then
        echo "✅ app.py has index() route"
        ((PASSED++))
    else
        echo "❌ app.py missing index() route"
        ((FAILED++))
    fi
fi

echo ""
echo "📦 Checking Dependencies..."
echo "---------------------------"
check_file "requirements.txt" "requirements.txt exists"

if [ -f "requirements.txt" ]; then
    check_contains "requirements.txt" "Flask" "Flask in requirements"
    check_contains "requirements.txt" "Flask-CORS" "Flask-CORS in requirements"
    check_contains "requirements.txt" "gunicorn" "gunicorn in requirements"
fi

echo ""
echo "🔧 Checking Script Permissions..."
echo "----------------------------------"
if [ -x "integrate_frontend.sh" ]; then
    echo "✅ integrate_frontend.sh is executable"
    ((PASSED++))
else
    echo "⚠️  integrate_frontend.sh needs chmod +x"
fi

if [ -x "deploy_complete.sh" ]; then
    echo "✅ deploy_complete.sh is executable"
    ((PASSED++))
else
    echo "⚠️  deploy_complete.sh needs chmod +x"
fi

echo ""
echo "📊 Verification Summary"
echo "======================="
echo "✅ Passed: $PASSED"
echo "❌ Failed: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "🎉 All checks passed! Ready to deploy."
    echo ""
    echo "Next steps:"
    echo "1. Run: bash deploy_complete.sh"
    echo "2. Test: http://localhost:10000"
    echo "3. Push: git push origin main"
    exit 0
else
    echo "⚠️  Some checks failed. Review errors above."
    echo ""
    echo "To fix:"
    echo "1. Make scripts executable: chmod +x *.sh"
    echo "2. Run integration: bash integrate_frontend.sh"
    echo "3. Update app.py: cp app_new.py app.py"
    exit 1
fi
