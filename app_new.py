import os
from flask import Flask, send_from_directory, jsonify, request, render_template
from flask_cors import CORS

def create_app():
    # Flask app configuration with static and template folders
    app = Flask(__name__, 
                static_folder='static',
                static_url_path='/static',
                template_folder='templates')
    
    # Enable CORS for API endpoints only
    CORS(app, resources={r"/api/*": {"origins": "*"}})
    
    # ==================== UI ROUTES ====================
    
    @app.route('/')
    def index():
        """Serve the ProTrader Terminal UI"""
        try:
            return render_template('index.html')
        except Exception as e:
            # Fallback if template not found
            return jsonify({
                "ok": True,
                "service": "protrader-backend",
                "message": "UI not integrated yet. Run integrate_frontend.sh",
                "error": str(e),
                "endpoints": [
                    "/api/health",
                    "/api/brokers/",
                    "/api/brokers/available",
                    "/api/news/",
                    "/api/portfolio/",
                    "/api/signals/",
                    "/api/screener/",
                    "/api/backtest/"
                ]
            })
    
    @app.route('/<path:path>')
    def serve_static_or_spa(path):
        """Serve static files or fallback to index.html for SPA routing"""
        # If requesting a file in static folder
        if path.startswith('static/'):
            return send_from_directory('.', path)
        
        # Check if file exists in static folder
        static_file = os.path.join(app.static_folder, path)
        if os.path.exists(static_file) and os.path.isfile(static_file):
            return send_from_directory(app.static_folder, path)
        
        # For all other routes, serve index.html (SPA client-side routing)
        try:
            return render_template('index.html')
        except:
            return jsonify({"error": "Page not found"}), 404
    
    # ==================== API ROUTES ====================
    
    # Import and register all API blueprints
    try:
        from api.health import bp as health_bp
        from api.brokers import bp as brokers_bp
        from api.news import bp as news_bp
        from api.portfolio import bp as portfolio_bp
        from api.signals import bp as signals_bp
        from api.screener import bp as screener_bp
        from api.backtest import bp as backtest_bp
        from api.debug import bp as debug_bp
        
        app.register_blueprint(health_bp)
        app.register_blueprint(brokers_bp)
        app.register_blueprint(news_bp)
        app.register_blueprint(portfolio_bp, name='portfolio_unique')
        app.register_blueprint(signals_bp)
        app.register_blueprint(screener_bp)
        app.register_blueprint(backtest_bp)
        app.register_blueprint(debug_bp)
        
        print("✓ All API blueprints registered successfully")
    except Exception as e:
        print(f"⚠️  Warning: Some API blueprints failed to register: {e}")
    
    return app

# Create the app instance
app = create_app()

if __name__ == '__main__':
    port = int(os.getenv('PORT', 10000))
    debug = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    
    print("=" * 50)
    print("🚀 ProTrader Backend Starting")
    print("=" * 50)
    print(f"📡 Port: {port}")
    print(f"🐛 Debug: {debug}")
    print(f"🌐 URL: http://localhost:{port}")
    print("=" * 50)
    
    app.run(host='0.0.0.0', port=port, debug=debug)
