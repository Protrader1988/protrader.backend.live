import os
from flask import Flask, send_from_directory, jsonify, request, render_template
from flask_cors import CORS

def create_app():
    """
    Flask app with Bloomberg Terminal UI and proper route ordering.
    
    Route Order (CRITICAL):
    1. Health check (highest priority)
    2. API blueprints (specific routes)
    3. Root route (Bloomberg Terminal UI)
    4. Catch-all route (LAST - for SPA routing)
    """
    
    # Flask app configuration
    app = Flask(__name__, 
                static_folder='static',
                static_url_path='/static',
                template_folder='templates')
    
    # Enable CORS for all routes (production-ready configuration)
    CORS(app, resources={
        r"/api/*": {
            "origins": "*",
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization"]
        }
    })
    
    # ==================== ERROR HANDLERS ====================
    # Production-grade error handling
    # =========================================================
    
    @app.errorhandler(404)
    def not_found(error):
        """Handle 404 errors gracefully"""
        if request.path.startswith('/api/'):
            return jsonify({
                "ok": False,
                "error": "API endpoint not found",
                "path": request.path,
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
        # For non-API 404s, serve the main UI (SPA routing)
        try:
            return render_template('index.html')
        except:
            return jsonify({"error": "Page not found"}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        """Handle 500 errors gracefully"""
        return jsonify({
            "ok": False,
            "error": "Internal server error",
            "message": "An unexpected error occurred. Please try again later."
        }), 500
    
    @app.errorhandler(Exception)
    def handle_exception(error):
        """Handle all unhandled exceptions"""
        app.logger.error(f"Unhandled exception: {error}")
        if request.path.startswith('/api/'):
            return jsonify({
                "ok": False,
                "error": "An error occurred processing your request",
                "details": str(error) if app.debug else None
            }), 500
        try:
            return render_template('index.html')
        except:
            return jsonify({"error": "Service unavailable"}), 500
    
    # ==================== ROUTE ORDER ====================
    # CRITICAL: Routes must be registered in this specific order!
    # =====================================================
    
    # 1. HEALTH CHECK ROUTE (First - highest priority)
    @app.route('/health')
    @app.route('/api/health')
    def health_check():
        """Health check endpoint for Render deployment monitoring"""
        return jsonify({
            "ok": True, 
            "status": "healthy", 
            "service": "protrader-backend",
            "ui": "Bloomberg Terminal UI Active"
        }), 200
    
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
    
    # 3. ROOT ROUTE (Bloomberg Terminal UI)
    @app.route('/')
    def index():
        """Serve the ProTrader Bloomberg Terminal-style UI"""
        try:
            return render_template('index.html')
        except Exception as e:
            app.logger.error(f"Failed to render index.html: {e}")
            # Fallback: Show API endpoints if UI fails to load
            return jsonify({
                "ok": True,
                "service": "protrader-backend",
                "version": "2.0.0",
                "status": "running",
                "message": "ProTrader API is running. UI template not found.",
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
                "note": "Bloomberg Terminal UI should be available after deployment."
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
        
        # For all other routes, serve the Bloomberg Terminal UI (SPA routing)
        try:
            return render_template('index.html')
        except Exception as e:
            app.logger.error(f"Failed to serve SPA route {path}: {e}")
            return jsonify({
                "error": "Page not found",
                "path": f"/{path}",
                "message": "Bloomberg Terminal UI not available"
            }), 404
    
    return app

# Create the app instance
app = create_app()

if __name__ == '__main__':
    port = int(os.getenv('PORT', 10000))
    debug = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    
    print("=" * 60)
    print("🚀 ProTrader Backend - Bloomberg Terminal UI")
    print("=" * 60)
    print(f"📡 Port: {port}")
    print(f"🐛 Debug: {debug}")
    print(f"🌐 URL: http://localhost:{port}")
    print(f"🏥 Health: http://localhost:{port}/health")
    print(f"💼 Terminal UI: http://localhost:{port}/")
    print("=" * 60)
    print("✅ Route ordering optimized:")
    print("   1. Health check (/health)")
    print("   2. API routes (/api/*)")
    print("   3. Root route (/) - Bloomberg Terminal UI")
    print("   4. Catch-all (SPA routing)")
    print("=" * 60)
    print("🎯 Bloomberg Terminal-quality UI active!")
    print("=" * 60)
    
    app.run(host='0.0.0.0', port=port, debug=debug)
