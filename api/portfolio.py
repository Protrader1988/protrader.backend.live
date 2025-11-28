from flask import Blueprint, jsonify, request
import os, requests

bp = Blueprint("portfolio", __name__, url_prefix="/api/portfolio")

ALPACA_ENV = os.getenv("ALPACA_ENV", "paper").lower()
BASE_URL = "https://paper-api.alpaca.markets" if ALPACA_ENV == "paper" else "https://api.alpaca.markets"
KEY = os.getenv("ALPACA_KEY_ID")
SECRET = os.getenv("ALPACA_SECRET_KEY")

def alpaca_headers():
    if not KEY or not SECRET:
        return None
    return {
        "APCA-API-KEY-ID": KEY,
        "APCA-API-SECRET-KEY": SECRET,
    }

@bp.get("/")
def summary():
    hdrs = alpaca_headers()
    if not hdrs:
        return jsonify({"ok": False, "error": "Missing ALPACA_KEY_ID/ALPACA_SECRET_KEY"}), 400
    
    try:
        out = {}
        if request.args.get("account", "1") == "1":
            r = requests.get(f"{BASE_URL}/v2/account", headers=hdrs, timeout=15)
            out["account"] = r.json()
        
        r = requests.get(f"{BASE_URL}/v2/positions", headers=hdrs, timeout=15)
        out["positions"] = r.json()
        
        return jsonify({"ok": True, "broker": "alpaca", "env": ALPACA_ENV, **out})
    except Exception as e:
        return jsonify({"ok": False, "error": str(e)}), 500
