from flask import Blueprint, request, jsonify

bp = Blueprint("backtest", __name__, url_prefix="/api/backtest")

@bp.post("/")
def run_backtest():
    payload = request.get_json(silent=True) or {}
    # TODO: replace with real backtest implementation
    return jsonify({"ok": True, "received": payload, "equity_curve": [], "metrics": {"sharpe": 0.0}})
