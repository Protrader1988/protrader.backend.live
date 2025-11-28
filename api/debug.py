from flask import Blueprint, jsonify, current_app

bp = Blueprint("debug", __name__, url_prefix="/api/debug")

@bp.get("/routes")
def routes():
    rules = []
    for r in current_app.url_map.iter_rules():
        rules.append({"rule": str(r), "methods": sorted(list(r.methods - {'HEAD'}))})
    return jsonify({"ok": True, "routes": rules})
