from flask import Flask, jsonify

def create_app():
    app = Flask(__name__)
    
    # import & register all blueprints
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
    app.register_blueprint(portfolio_bp)
    app.register_blueprint(signals_bp)
    app.register_blueprint(screener_bp)
    app.register_blueprint(backtest_bp)
    app.register_blueprint(debug_bp)
    
    @app.get("/")
    def index():
        return jsonify({
            "ok": True,
            "service": "protrader-backend",
            "endpoints": [
                "/api/health/",
                "/api/brokers/",
                "/api/brokers/available",
                "/api/news/",
                "/api/portfolio/",
                "/api/signals/",
                "/api/screener/",
                "/api/backtest/"
            ]
        })
    
    return app

app = create_app()
