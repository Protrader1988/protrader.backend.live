# protrader.backend.live/api/portfolio.py
from flask import Blueprint, jsonify, request

bp = Blueprint("portfolio", __name__, url_prefix="/portfolio")

@bp.get("/")
def ping():
    return jsonify({"ok": True, "service": "portfolio"})

@bp.get("/holdings")
def holdings():
    # TODO: wire to your real portfolio module
    return jsonify({"ok": True, "holdings": []})

@bp.get("/value")
def value():
    # Optional query: currency=USD
    currency = (request.args.get("currency") or "USD").upper()
    return jsonify({"ok": True, "currency": currency, "total_value": 0.0})
