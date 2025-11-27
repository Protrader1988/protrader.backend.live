# protrader.backend.live/api/news.py
from flask import Blueprint, jsonify, request

bp = Blueprint("news", __name__, url_prefix="/news")

@bp.get("/")
def ping():
    return jsonify({"ok": True, "service": "news"})

@bp.get("/latest")
def latest():
    """
    Optional: /news/latest?symbol=AAPL
    Stub response for now. Replace with your real fetcher later.
    """
    symbol = (request.args.get("symbol") or "").upper()
    data = {"symbol": symbol, "headlines": []} if symbol else {"headlines": []}
    return jsonify({"ok": True, "data": data})
