from flask import Blueprint, request, jsonify
bp = Blueprint("screener", __name__, url_prefix="/api/screener")

@bp.get("/")
def run_screener():
    # Example params: ?min_volume=10000000
    min_vol = int(request.args.get("min_volume", 10_000_000))
    # TODO: implement logic; return stub
    return jsonify({"ok": True, "criteria": {"min_volume": min_vol}, "results": []})
