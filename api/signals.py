# api/signals.py
from flask import Blueprint, request, jsonify
from datetime import datetime

bp = Blueprint("signals", __name__, url_prefix="/api/signals")

@bp.get("/")
def list_signals():
    """
    GET /api/signals/?symbol=AAPL&tf=1d
    Returns a placeholder signal so the UI has something to render.
    """
    symbol = (request.args.get("symbol") or "AAPL").upper()
    tf = request.args.get("tf", "1d")
    # TODO: call your model(s) here
    signal = {
        "symbol": symbol,
        "timeframe": tf,
        "signal": "neutral",
        "confidence": 0.52,
        "generated_at": datetime.utcnow().isoformat() + "Z",
        "notes": "Stub signal. Plug models here.",
    }
    return jsonify({"ok": True, "signals": [signal]})
