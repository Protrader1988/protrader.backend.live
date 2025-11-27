# protrader.backend.live/api/backtest.py
from flask import Blueprint, jsonify, request

bp = Blueprint("backtest", __name__, url_prefix="/backtest")

@bp.get("/")
def ping():
    return jsonify({"ok": True, "service": "backtest"})

# If you already have real backtest code in the top-level module, you can expose it:
# from ..backtest import run_backtest  # adjust function name to yours
# @bp.post("/run")
# def run():
#     payload = request.get_json(silent=True) or {}
#     symbols = payload.get("symbols", [])
#     params = payload.get("params", {})
#     result = run_backtest(symbols=symbols, **params)
#     return jsonify({"ok": True, "result": result})
