from flask import Flask, jsonify

# Import the blueprints you already created
from api.health import bp as health_bp
from api.screener import bp as screener_bp
from api.signals import bp as signals_bp
from api.backtest import bp as backtest_bp
from api.news import bp as news_bp
from api.portfolio import bp as portfolio_bp
from api.brokers import bp as brokers_bp

app = Flask(__name__)

# Mount blueprints under /api/...
app.register_blueprint(health_bp,    url_prefix="/api/health")
app.register_blueprint(screener_bp,  url_prefix="/api/screener")
app.register_blueprint(signals_bp,   url_prefix="/api/signals")
app.register_blueprint(backtest_bp,  url_prefix="/api/backtest")
app.register_blueprint(news_bp,      url_prefix="/api/news")
app.register_blueprint(portfolio_bp, url_prefix="/api/portfolio")
app.register_blueprint(brokers_bp,   url_prefix="/api/brokers")

# NEW: make "/" return something so your homepage isn't 404
@app.get("/")
def index():
    return jsonify({
        "ok": True,
        "service": "protrader-backend",
        "endpoints": [
            "/api/health",
            "/api/brokers", "/api/brokers/available",
            "/api/news", "/api/portfolio",
            "/api/signals", "/api/screener", "/api/backtest"
        ]
    })

# Gunicorn will import "app:app"; no need to run app.run() here.
