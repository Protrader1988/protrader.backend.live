#!/bin/bash
echo "🔧 ProTrader Frontend Integration Script"
echo "=========================================="

# Define paths
BACKEND_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERMINAL_DIR="$HOME/protrader-terminal-v2"

# Check if terminal directory exists
if [ ! -d "$TERMINAL_DIR" ]; then
    echo "❌ Error: protrader-terminal-v2 directory not found at $TERMINAL_DIR"
    exit 1
fi

# Create Flask directories if they don't exist
echo "📂 Creating static and templates directories..."
mkdir -p "$BACKEND_DIR/static"
mkdir -p "$BACKEND_DIR/templates"

# Clear old files
echo "🧹 Cleaning old build files..."
rm -rf "$BACKEND_DIR/static"/*
rm -f "$BACKEND_DIR/templates/index.html"

# Copy UI files from terminal to backend
echo "📂 Copying UI files to Flask backend..."

# Copy index.html to templates
if [ -f "$TERMINAL_DIR/index.html" ]; then
    cp "$TERMINAL_DIR/index.html" "$BACKEND_DIR/templates/"
    echo "   ✓ Copied index.html to templates/"
else
    echo "   ⚠️  Warning: index.html not found"
fi

# Copy static assets
if [ -d "$TERMINAL_DIR/static" ]; then
    cp -r "$TERMINAL_DIR/static"/* "$BACKEND_DIR/static/" 2>/dev/null || true
    echo "   ✓ Copied static assets"
else
    echo "   ⚠️  Warning: static directory not found"
fi

# No asset path fixing needed since we're keeping the same structure

echo ""
echo "✅ Frontend integration complete!"
echo "   - UI template: templates/index.html"
echo "   - Static assets: static/css/, static/js/"
echo ""
echo "📝 Next step: Update app.py to serve the UI"
