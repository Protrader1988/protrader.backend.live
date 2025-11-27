from flask import Flask

# Import all blueprints from the api package
from api.health import bp as health_bp
from api.screener import bp as screener_bp
from api.signals import bp as signals_bp
from api.backtest import bp as backtest_bp
from api.news import bp as news_bp
from api.portfolio import bp as portfolio_bp
from api.brokers import bp as brokers_bp

app = Flask(__name__)

# Register all API endpoints
app.register_blueprint(health_bp, url_prefix="/api/health")
app.register_blueprint(screener_bp, url_prefix="/api/screener")
app.register_blueprint(signals_bp, url_prefix="/api/signals")
app.register_blueprint(backtest_bp, url_prefix="/api/backtest")
app.register_blueprint(news_bp, url_prefix="/api/news")
app.register_blueprint(portfolio_bp, url_prefix="/api/portfolio")
app.register_blueprint(brokers_bp, url_prefix="/api/brokers")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
