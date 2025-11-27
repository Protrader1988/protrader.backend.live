# protrader.backend.live/api/signals.py
from flask import Blueprint, jsonify, request

bp = Blueprint("signals", __name__, url_prefix="/signals")

@bp.get("/")
def ping():
    return jsonify({"ok": True, "service": "signals"})

# If you already have logic in the top-level `signals.py`, you can expose it here:
# from ..signals import generate_signals  # adjust name as needed
# @bp.post("/generate")
# def generate():
#     payload = request.get_json(silent=True) or {}
#     symbols = payload.get("symbols", [])
#     result = generate_signals(symbols)
#     return jsonify({"results": result})
