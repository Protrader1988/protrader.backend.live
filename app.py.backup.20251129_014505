import os
from flask import Flask, send_from_directory, jsonify, request
from flask_cors import CORS

def create_app():
    """
    Flask app with CORRECT route ordering to fix deployment bug.
    
    Route Order (CRITICAL):
    1. Health check (highest priority)
    2. API blueprints (specific routes)
    3. Root route (for React UI)
    4. Catch-all route (LAST - for SPA routing)
    """
    
    # Flask app configuration
    app = Flask(__name__, 
                static_folder='static',
                static_url_path='/static',
                template_folder='templates')
    
    # Enable CORS for API endpoints
    CORS(app, resources={r"/api/*": {"origins": "*"}})
    
    # ==================== ROUTE ORDER FIX ====================
    # CRITICAL: Routes must be registered in this specific order!
    # =========================================================
    
    # 1. HEALTH CHECK ROUTE (First - highest priority)
    @app.route('/health')
    @app.route('/api/health')
    def health_check():
        """Health check endpoint for Render deployment monitoring"""
        return jsonify({"ok": True, "status": "healthy", "service": "protrader-backend"}), 200
    
    # 2. REGISTER API BLUEPRINTS (Before catch-all!)
    # NOTE: Some blueprints have url_prefix in their definition, some don't
    # We only add url_prefix here for those that don't have it
    try:
        from api.health import bp as health_bp
        from api.brokers import bp as brokers_bp
        from api.news import bp as news_bp
        from api.portfolio import bp as portfolio_bp
        from api.signals import bp as signals_bp
        from api.screener import bp as screener_bp
        from api.backtest import bp as backtest_bp
        from api.debug import bp as debug_bp
        
        # Register all API blueprints BEFORE catch-all route
        # Blueprints with url_prefix already defined: portfolio, backtest
        # Blueprints needing url_prefix: health, brokers, news, signals, screener, debug
        app.register_blueprint(health_bp, url_prefix='/api/health')
        app.register_blueprint(brokers_bp, url_prefix='/api/brokers')
        app.register_blueprint(news_bp, url_prefix='/api/news')
        app.register_blueprint(portfolio_bp)  # Already has /api/portfolio
        app.register_blueprint(signals_bp, url_prefix='/api/signals')
        app.register_blueprint(screener_bp, url_prefix='/api/screener')
        app.register_blueprint(backtest_bp)  # Already has /api/backtest
        app.register_blueprint(debug_bp, url_prefix='/api/debug')
        
        print("✓ All API blueprints registered successfully")
    except Exception as e:
        print(f"⚠️  Warning: Some API blueprints failed to register: {e}")
    
    # 3. ROOT ROUTE (For React UI or API listing)
    @app.route('/')
    def index():
        """Serve the ProTrader Terminal UI or API endpoint list"""
        # Check if React build exists
        if os.path.exists(os.path.join(app.template_folder or 'templates', 'index.html')):
            try:
                from flask import render_template
                return render_template('index.html')
            except Exception as e:
                pass
        
        # Fallback: Show API endpoints
        return jsonify({
            "ok": True,
            "service": "protrader-backend",
            "version": "2.0.0",
            "status": "running",
            "message": "ProTrader API is running. Frontend UI not integrated yet.",
            "endpoints": {
                "health": "/api/health",
                "brokers": "/api/brokers/",
                "brokers_available": "/api/brokers/available",
                "news": "/api/news/",
                "portfolio": "/api/portfolio/",
                "signals": "/api/signals/",
                "screener": "/api/screener/",
                "backtest": "/api/backtest/"
            },
            "docs": "https://github.com/yourusername/protrader-backend"
        })
    
    # 4. CATCH-ALL ROUTE (LAST - for SPA routing)
    @app.route('/<path:path>')
    def catch_all(path):
        """
        Catch-all route for SPA client-side routing.
        MUST be registered LAST to avoid intercepting API routes.
        """
        # Reject API routes that didn't match
        if path.startswith('api/'):
            return jsonify({
                "ok": False,
                "error": "API endpoint not found",
                "path": f"/{path}",
                "available_endpoints": [
                    "/api/health",
                    "/api/brokers/",
                    "/api/portfolio/",
                    "/api/signals/",
                    "/api/screener/",
                    "/api/backtest/",
                    "/api/news/",
                    "/api/debug/"
                ]
            }), 404
        
        # Serve static files if they exist
        static_file = os.path.join(app.static_folder or 'static', path)
        if os.path.exists(static_file) and os.path.isfile(static_file):
            return send_from_directory(app.static_folder or 'static', path)
        
        # For non-API routes, serve index.html (SPA client-side routing)
        if os.path.exists(os.path.join(app.template_folder or 'templates', 'index.html')):
            try:
                from flask import render_template
                return render_template('index.html')
            except Exception:
                pass
        
        # Ultimate fallback
        return jsonify({"error": "Page not found", "path": f"/{path}"}), 404
    
    return app

# Create the app instance
app = create_app()

if __name__ == '__main__':
    port = int(os.getenv('PORT', 10000))
    debug = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    
    print("=" * 60)
    print("🚀 ProTrader Backend Starting")
    print("=" * 60)
    print(f"📡 Port: {port}")
    print(f"🐛 Debug: {debug}")
    print(f"🌐 URL: http://localhost:{port}")
    print(f"🏥 Health: http://localhost:{port}/health")
    print("=" * 60)
    print("✅ Route ordering bug FIXED!")
    print("   1. Health check (/health)")
    print("   2. API routes (/api/*)")
    print("   3. Root route (/)")
    print("   4. Catch-all (SPA routing)")
    print("=" * 60)
    
    app.run(host='0.0.0.0', port=port, debug=debug)
