#!/bin/bash

# ProTrader API Keys Verification Script
# This script checks local .env file and provides guidance for Render dashboard setup

set -e

echo "=========================================="
echo "  ProTrader API Keys Verification"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Required API keys
REQUIRED_KEYS=(
    "ALPACA_API_KEY"
    "ALPACA_SECRET_KEY"
    "ALPACA_BASE_URL"
)

# Optional but recommended keys
OPTIONAL_KEYS=(
    "FLASK_ENV"
    "FLASK_DEBUG"
    "PORT"
)

# Check if .env file exists
if [ -f ".env" ]; then
    echo -e "${GREEN}✅ Found .env file${NC}"
    echo ""
else
    echo -e "${RED}❌ No .env file found${NC}"
    echo ""
    echo "Creating .env.example template..."
    cat > .env.example << 'EOF'
# Alpaca API Configuration
ALPACA_API_KEY=your_alpaca_api_key_here
ALPACA_SECRET_KEY=your_alpaca_secret_key_here
ALPACA_BASE_URL=https://paper-api.alpaca.markets

# Flask Configuration
FLASK_ENV=production
FLASK_DEBUG=False
PORT=5000
EOF
    echo -e "${GREEN}✅ Created .env.example${NC}"
    echo ""
fi

# Function to check if a key exists and has a value
check_env_key() {
    local key=$1
    local required=$2
    
    if [ -f ".env" ]; then
        # Source the .env file to get the value
        local value=$(grep "^${key}=" .env 2>/dev/null | cut -d '=' -f2- | tr -d '"' | tr -d "'")
        
        if [ -z "$value" ]; then
            if [ "$required" = "true" ]; then
                echo -e "${RED}❌ ${key}: NOT SET (REQUIRED)${NC}"
                return 1
            else
                echo -e "${YELLOW}⚠️  ${key}: NOT SET (optional)${NC}"
                return 2
            fi
        elif [ "$value" = "your_alpaca_api_key_here" ] || [ "$value" = "your_alpaca_secret_key_here" ]; then
            echo -e "${RED}❌ ${key}: PLACEHOLDER VALUE (needs real value)${NC}"
            return 1
        else
            # Mask the value for security
            local masked_value="${value:0:4}...${value: -4}"
            echo -e "${GREEN}✅ ${key}: ${masked_value}${NC}"
            return 0
        fi
    else
        if [ "$required" = "true" ]; then
            echo -e "${RED}❌ ${key}: NOT SET (REQUIRED)${NC}"
            return 1
        else
            echo -e "${YELLOW}⚠️  ${key}: NOT SET (optional)${NC}"
            return 2
        fi
    fi
}

# Check required keys
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Required API Keys:${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

MISSING_REQUIRED=0
for key in "${REQUIRED_KEYS[@]}"; do
    check_env_key "$key" "true" || MISSING_REQUIRED=$((MISSING_REQUIRED + 1))
done

echo ""

# Check optional keys
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Optional Configuration:${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

for key in "${OPTIONAL_KEYS[@]}"; do
    check_env_key "$key" "false" || true
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Summary
echo ""
if [ $MISSING_REQUIRED -eq 0 ]; then
    echo -e "${GREEN}✅ All required API keys are set!${NC}"
else
    echo -e "${RED}❌ Missing ${MISSING_REQUIRED} required API key(s)${NC}"
fi

echo ""
echo "=========================================="
echo "  Render Dashboard Configuration"
echo "=========================================="
echo ""
echo "To configure environment variables in Render:"
echo ""
echo "1. Go to: https://dashboard.render.com"
echo "2. Select your 'protrader-backend' service"
echo "3. Click 'Environment' tab"
echo "4. Add the following environment variables:"
echo ""
echo -e "${BLUE}Required Variables:${NC}"
echo "   • ALPACA_API_KEY"
echo "   • ALPACA_SECRET_KEY"
echo "   • ALPACA_BASE_URL (https://paper-api.alpaca.markets or https://api.alpaca.markets)"
echo ""
echo -e "${BLUE}Recommended Variables:${NC}"
echo "   • FLASK_ENV=production"
echo "   • FLASK_DEBUG=False"
echo "   • PORT=10000 (Render default)"
echo ""
echo "5. Click 'Save Changes'"
echo "6. Render will automatically redeploy your service"
echo ""

# Get Alpaca API key instructions
echo "=========================================="
echo "  How to Get Alpaca API Keys"
echo "=========================================="
echo ""
echo "1. Go to: https://alpaca.markets"
echo "2. Sign up for a free account"
echo "3. Navigate to: Paper Trading → API Keys"
echo "4. Click 'Generate New Key'"
echo "5. Copy both API Key and Secret Key"
echo "6. For testing, use Paper Trading URL:"
echo "   https://paper-api.alpaca.markets"
echo "7. For live trading, use:"
echo "   https://api.alpaca.markets"
echo ""

# Exit status
if [ $MISSING_REQUIRED -eq 0 ]; then
    echo -e "${GREEN}✅ Verification Complete - Ready for deployment!${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Verification Failed - Please configure missing API keys${NC}"
    echo ""
    exit 1
fi
