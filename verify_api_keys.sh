#!/bin/bash

# ProTrader Backend - Verify API Keys Configuration
# Checks local .env and shows what needs to be set in Render dashboard

echo "======================================================"
echo "🔑 ProTrader Backend - API Keys Verification"
echo "======================================================"
echo ""

# Check for .env file
if [ -f .env ]; then
    echo "📋 Local .env file found"
    echo "------------------------------------------------------"
    
    # Check each required key
    keys=("ALPACA_KEY_ID" "ALPACA_SECRET_KEY" "ALPACA_ENV" "GEMINI_API_KEY" "GEMINI_API_SECRET")
    
    for key in "${keys[@]}"; do
        if grep -q "^${key}=" .env 2>/dev/null; then
            value=$(grep "^${key}=" .env | cut -d'=' -f2 | tr -d '"' | tr -d "'")
            if [ -n "$value" ]; then
                # Show only first/last 4 chars for security
                if [ ${#value} -gt 8 ]; then
                    masked="${value:0:4}...${value: -4}"
                else
                    masked="***"
                fi
                echo "   ✓ $key = $masked"
            else
                echo "   ⚠️  $key = (empty)"
            fi
        else
            echo "   ❌ $key = (not set)"
        fi
    done
    echo ""
else
    echo "⚠️  No .env file found in current directory"
    echo ""
fi

echo "======================================================"
echo "🌐 Render Dashboard Environment Variables"
echo "======================================================"
echo ""
echo "You MUST set these in your Render service settings:"
echo ""
echo "Required for Alpaca Trading:"
echo "   • ALPACA_KEY_ID       - Your Alpaca API key"
echo "   • ALPACA_SECRET_KEY   - Your Alpaca secret key"
echo "   • ALPACA_ENV          - Set to 'paper' for testing"
echo ""
echo "Optional for Gemini Trading:"
echo "   • GEMINI_API_KEY      - Your Gemini API key"
echo "   • GEMINI_API_SECRET   - Your Gemini API secret"
echo ""
echo "======================================================"
echo "📍 How to Set Environment Variables in Render:"
echo "======================================================"
echo ""
echo "1. Go to: https://dashboard.render.com/"
echo ""
echo "2. Select your service: protrader-backend-web"
echo ""
echo "3. Click 'Environment' in left sidebar"
echo ""
echo "4. Add each environment variable:"
echo "   - Click 'Add Environment Variable'"
echo "   - Enter key name (e.g., ALPACA_KEY_ID)"
echo "   - Enter value (paste your API key)"
echo "   - Click 'Save Changes'"
echo ""
echo "5. Service will auto-restart with new variables"
echo ""
echo "======================================================"
echo "🔒 Security Notes:"
echo "======================================================"
echo ""
echo "• NEVER commit .env file to git"
echo "• Add .env to .gitignore"
echo "• Use paper/sandbox APIs for testing"
echo "• Rotate keys regularly"
echo "• Use separate keys for production"
echo ""
echo "======================================================"

# Check .gitignore
if [ -f .gitignore ]; then
    if grep -q "^\.env$" .gitignore; then
        echo "✅ .env is properly ignored in .gitignore"
    else
        echo "⚠️  WARNING: .env is NOT in .gitignore"
        echo "   Add it now: echo '.env' >> .gitignore"
    fi
else
    echo "⚠️  No .gitignore file found"
    echo "   Create one: echo '.env' > .gitignore"
fi

echo "======================================================"
