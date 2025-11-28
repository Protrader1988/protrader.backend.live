from flask import Blueprint, request, jsonify
bp = Blueprint("backtest", __name__, url_prefix="/api/backtest")

@bp.post("/")
def run_backtest():
    """
    POST /api/backtest/
    Body: { "symbol": "AAPL", "strategy": "wick_master", "start": "2023-01-01", "end": "2023-12-31" }
    """
    payload = request.get_json(silent=True) or {}
    # TODO: call your backtester
    return jsonify({"ok": True, "received": payload, "equity_curve": [], "metrics": {"sharpe": 0.0}})
