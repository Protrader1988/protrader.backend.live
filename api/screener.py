# protrader.backend.live/api/screener.py
from flask import Blueprint, jsonify, request

bp = Blueprint("screener", __name__, url_prefix="/screener")

@bp.get("/")
def ping():
    return jsonify({"ok": True, "service": "screener"})

# OPTIONAL: expose any real screener functionality you already have
# If you have logic in the top-level screener.py, you can import and call it here.
# Example:
# from ..screener import run_screen  # if that module/function exists at repo root
# @bp.post("/run")
# def run():
#     payload = request.get_json(silent=True) or {}
#     symbols = payload.get("symbols", [])
#     results = run_screen(symbols)
#     return jsonify({"results": results})
