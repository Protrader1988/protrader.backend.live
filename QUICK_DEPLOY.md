# ⚡ ProTrader Quick Deploy Guide

## 🎯 One-Command Deploy

```bash
cd ~/protrader-backend && chmod +x *.sh && bash deploy_complete.sh
```

---

## 📋 Step-by-Step (If one-command fails)

### 1️⃣ Setup (30 seconds)
```bash
cd ~/protrader-backend
chmod +x integrate_frontend.sh deploy_complete.sh verify_fix.sh
```

### 2️⃣ Verify (15 seconds)
```bash
bash verify_fix.sh
```
**Expected:** All checks pass ✅

### 3️⃣ Deploy Locally (2 minutes)
```bash
bash deploy_complete.sh
```
**Expected:** Server starts, tests pass

### 4️⃣ Test in Browser (10 seconds)
```
Open: http://localhost:10000
```
**Expected:** ProTrader Terminal UI loads

### 5️⃣ Push to Production (1 minute)
```bash
git add .
git commit -m "Fix: Integrate UI with Flask backend"
git push origin main
```
**Expected:** Git push successful

### 6️⃣ Monitor Render (2-3 minutes)
```
Visit: https://dashboard.render.com
```
**Expected:** Build completes, deploy successful

### 7️⃣ Test Production (10 seconds)
```
Open: https://protrader-backend-web.onrender.com
```
**Expected:** ProTrader Terminal UI loads

---

## ✅ Success Indicators

| Stage | Success Sign |
|-------|-------------|
| Verify | "All checks passed! Ready to deploy." |
| Local Deploy | "Local deployment successful!" |
| Local Browser | ProTrader UI with charts visible |
| Git Push | "Successfully pushed to origin main" |
| Render Build | Green checkmark in dashboard |
| Production | ProTrader UI loads at production URL |

---

## ❌ Troubleshooting

### Problem: verify_fix.sh fails
```bash
# Re-run integration
bash integrate_frontend.sh

# Check if UI files copied
ls -la templates/index.html
ls -la static/
```

### Problem: Local server won't start
```bash
# Check if port is in use
lsof -i :10000

# Kill existing process
kill -9 $(lsof -t -i:10000)

# Try again
python app.py
```

### Problem: UI shows blank page
```bash
# Check app.py has UI routes
grep "def index" app.py

# If missing, copy from template
cp app_new.py app.py
```

### Problem: Static files 404
```bash
# Re-run integration
bash integrate_frontend.sh

# Check Flask configuration
grep "static_folder" app.py
```

### Problem: Render build fails
```bash
# Check Render build command
# Should be: bash integrate_frontend.sh && pip install -r requirements.txt

# Check all files committed
git status

# Add missing files
git add .
git commit -m "Add missing files"
git push
```

---

## 🔍 Quick Checks

### Is UI integrated?
```bash
ls -la templates/index.html static/
```
**Expected:** Files exist

### Is app.py updated?
```bash
grep "render_template" app.py
```
**Expected:** Found

### Are dependencies installed?
```bash
pip list | grep -E "Flask|gunicorn|httpx"
```
**Expected:** All present

### Is server running?
```bash
curl http://localhost:10000/health
```
**Expected:** `{"status":"ok",...}`

### Does UI load?
```bash
curl http://localhost:10000/ | head -n 20
```
**Expected:** HTML with "ProTrader"

---

## 📞 Need Help?

### Check these files:
1. `DEPLOYMENT_STATUS.md` - Full status report
2. `FIX_DEPLOYMENT_INSTRUCTIONS.md` - Detailed instructions
3. `EXECUTE_NOW.md` - Command reference

### Verify setup:
```bash
bash verify_fix.sh
```

### Review logs:
```bash
# Local
tail -f /tmp/protrader.log

# Render
# Check dashboard logs
```

---

## 🎯 Expected Timeline

| Task | Time |
|------|------|
| Setup & Verify | 1 min |
| Local Deploy | 2 min |
| Local Testing | 1 min |
| Git Push | 1 min |
| Render Deploy | 2-3 min |
| Production Test | 1 min |
| **TOTAL** | **~8-10 minutes** |

---

## 🚀 Production URLs

- **Local:** http://localhost:10000
- **Production:** https://protrader-backend-web.onrender.com
- **Health Check:** https://protrader-backend-web.onrender.com/health
- **API Portfolio:** https://protrader-backend-web.onrender.com/api/portfolio

---

## ⚙️ Render Configuration

### Build Command
```bash
bash integrate_frontend.sh && pip install -r requirements.txt
```

### Start Command
```bash
gunicorn app:app --bind 0.0.0.0:$PORT --timeout 120
```

### Environment Variables
```
ALPACA_API_KEY=<your-key>
ALPACA_API_SECRET=<your-secret>
ALPACA_PAPER=1
```

---

## 📦 Files Created

- ✅ `integrate_frontend.sh` - UI integration
- ✅ `app_new.py` - Updated Flask app
- ✅ `deploy_complete.sh` - Full deployment
- ✅ `verify_fix.sh` - Pre-flight checks
- ✅ `FIX_DEPLOYMENT_INSTRUCTIONS.md` - Full guide
- ✅ `EXECUTE_NOW.md` - Command list
- ✅ `DEPLOYMENT_STATUS.md` - Status report
- ✅ `QUICK_DEPLOY.md` - This file

---

## 🎉 Ready to Deploy!

**Just run:**
```bash
cd ~/protrader-backend && bash deploy_complete.sh
```

**Then test:**
```
http://localhost:10000
```

**Then push:**
```bash
git push origin main
```

**Done! 🚀**
