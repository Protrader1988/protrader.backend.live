# api/news.py
from flask import Blueprint, request, jsonify
import yfinance as yf

bp = Blueprint("news", __name__, url_prefix="/api/news")

@bp.get("/")
def get_news():
    """
    GET /api/news/?q=AAPL&limit=5
    If no ?q is provided, defaults to NVDA.
    Uses yfinance (no API key required).
    """
    symbol = request.args.get("q", "NVDA").upper()
    limit = max(1, min(int(request.args.get("limit", 5)), 20))
    try:
        ticker = yf.Ticker(symbol)
        items = ticker.news or []
        out = []
        for n in items[:limit]:
            out.append({
                "symbol": symbol,
                "title": n.get("title"),
                "publisher": n.get("publisher"),
                "link": n.get("link"),
                "providerPublishTime": n.get("providerPublishTime"),
            })
        return jsonify({"ok": True, "symbol": symbol, "count": len(out), "news": out})
    except Exception as e:
        return jsonify({"ok": False, "error": str(e)}), 500

