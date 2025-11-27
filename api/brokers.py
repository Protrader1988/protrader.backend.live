from flask import Blueprint, jsonify

bp = Blueprint("brokers", __name__)

@bp.get("/")
def ping():
    return jsonify({"ok": True, "service": "brokers"})

@bp.get("/available")
def available():
    return jsonify({
        "ok": True,
        "brokers": ["alpaca", "paper", "gemini"]
    })
