# 🎯 ProTrader Deployment - Command Card

**Quick Reference for Deployment Commands**

---

## ⚡ INSTANT DEPLOY (ONE COMMAND)

```bash
cd ~/protrader-backend && chmod +x *.sh && bash deploy_complete.sh
```

**What it does:**
1. Navigate to backend directory
2. Make scripts executable  
3. Run complete deployment
4. Test locally
5. Push to Git
6. Auto-deploy to Render

**Time:** ~8 minutes total

---

## 📋 STEP-BY-STEP COMMANDS

### 1. Navigate
```bash
cd ~/protrader-backend
```

### 2. Make Executable
```bash
chmod +x integrate_frontend.sh
chmod +x deploy_complete.sh
chmod +x verify_fix.sh
```

**Or all at once:**
```bash
chmod +x *.sh
```

### 3. Verify (Optional)
```bash
bash verify_fix.sh
```

**Checks:**
- ✅ UI source exists
- ✅ Backend directory exists
- ✅ Required files present
- ✅ Python installed
- ✅ Git configured

### 4. Integrate Frontend
```bash
bash integrate_frontend.sh
```

**What happens:**
- Copies UI from ~/protrader-terminal-v2/
- Creates templates/index.html
- Creates static/css, static/js, static/img
- Fixes asset paths

### 5. Test Locally
```bash
python app.py
```

**Then open:**
http://localhost:10000

**Expected:** ProTrader UI loads

**Stop server:** Ctrl+C

### 6. Deploy Complete
```bash
bash deploy_complete.sh
```

**What happens:**
- Runs integration
- Installs dependencies
- Tests locally
- Commits to Git
- Pushes to origin
- Render auto-deploys

### 7. Verify Production
**URL:** https://protrader-backend-web.onrender.com

**Monitor:** https://dashboard.render.com

---

## 🔧 MANUAL INTEGRATION

If you want to run steps manually:

```bash
# Copy UI files
cp ~/protrader-terminal-v2/index.html templates/
cp -r ~/protrader-terminal-v2/static/* static/

# Install dependencies
pip install -r requirements.txt

# Run server
python app.py
```

---

## 🧪 TESTING COMMANDS

### Test Health Endpoint
```bash
curl http://localhost:10000/health
```

**Expected:**
```json
{"status": "ok", "message": "ProTrader Backend is running"}
```

### Test UI Endpoint
```bash
curl http://localhost:10000/ | head -n 10
```

**Expected:** HTML content (not JSON)

### Test API Endpoint
```bash
curl http://localhost:10000/api/portfolio
```

**Expected:** JSON portfolio data or error

---

## 📦 GIT COMMANDS

### Check Status
```bash
git status
```

### Add All Changes
```bash
git add .
```

### Commit
```bash
git commit -m "Fix: Integrate UI with Flask backend"
```

### Push to Production
```bash
git push origin main
```

**Render will auto-deploy in ~2-3 minutes**

### View Commit Log
```bash
git log --oneline -5
```

---

## 🔍 DEBUGGING COMMANDS

### Check if UI Source Exists
```bash
ls -la ~/protrader-terminal-v2/
```

**Should show:**
- index.html
- static/

### Check Backend Files
```bash
ls -la ~/protrader-backend/
```

**Should have:**
- app.py
- templates/
- static/
- requirements.txt

### Check Templates
```bash
ls -la ~/protrader-backend/templates/
```

**Should contain:** index.html

### Check Static Files
```bash
ls -la ~/protrader-backend/static/
```

**Should contain:** css/, js/, img/

### Check Python Dependencies
```bash
pip list | grep -i flask
pip list | grep -i httpx
```

**Should show:**
- Flask
- httpx
- flask-cors

### View Server Logs
```bash
python app.py
```

**Watch for:**
- ✅ "Running on http://0.0.0.0:10000"
- ❌ Any error messages

### Check Port Usage
```bash
lsof -i :10000
```

**If port is busy:**
```bash
kill -9 <PID>
```

---

## 🔄 ROLLBACK COMMANDS

### Revert Last Commit
```bash
git reset --soft HEAD~1
```

### Revert to Previous Version
```bash
git log --oneline
git checkout <commit-hash>
```

### Clean Integration Files
```bash
rm -rf templates/index.html
rm -rf static/css static/js static/img
```

**Then re-run integration:**
```bash
bash integrate_frontend.sh
```

---

## 📊 MONITORING COMMANDS

### Watch Server Logs (Local)
```bash
python app.py
```

### View Render Logs
**Dashboard:** https://dashboard.render.com  
**Click on:** protrader-backend-web → Logs

### Monitor Deployment Status
**Check Build:**
```bash
git push origin main
# Wait 2-3 minutes
# Check: https://protrader-backend-web.onrender.com
```

---

## ⚙️ RENDER CONFIGURATION

**Build Command:**
```bash
bash integrate_frontend.sh && pip install -r requirements.txt
```

**Start Command:**
```bash
gunicorn app:app --bind 0.0.0.0:$PORT --timeout 120
```

**Update via Dashboard:**
1. Go to https://dashboard.render.com
2. Select: protrader-backend-web
3. Settings → Build & Deploy
4. Update commands above
5. Save Changes
6. Manual Deploy (if needed)

---

## 🚨 TROUBLESHOOTING

### Scripts Won't Run
```bash
chmod +x *.sh
bash integrate_frontend.sh
```

### UI Source Not Found
```bash
# Check if path exists
ls ~/protrader-terminal-v2/

# If different location, update in integrate_frontend.sh
# Edit line: UI_SOURCE_DIR="$HOME/protrader-terminal-v2"
```

### Integration Fails
```bash
# Clean and retry
rm -rf templates/index.html static/css static/js static/img
bash integrate_frontend.sh
```

### Local Server Won't Start
```bash
# Check port
lsof -i :10000

# Kill if busy
kill -9 <PID>

# Restart
python app.py
```

### UI Loads but Shows Errors
```bash
# Check browser console (F12)
# Check network tab for 404s
# Verify static files exist:
ls -la static/css static/js static/img
```

### Production Not Updating
```bash
# Force rebuild on Render
# Dashboard → Manual Deploy

# Or clear cache:
git commit --allow-empty -m "Trigger rebuild"
git push origin main
```

---

## 📁 FILE LOCATIONS

```
~/protrader-terminal-v2/     ← UI Source
    ├── index.html
    └── static/
        ├── css/
        ├── js/
        └── img/

~/protrader-backend/         ← Flask Backend
    ├── app.py
    ├── templates/
    │   └── index.html       ← Copied from source
    ├── static/              ← Copied from source
    │   ├── css/
    │   ├── js/
    │   └── img/
    ├── integrate_frontend.sh
    ├── deploy_complete.sh
    ├── verify_fix.sh
    └── requirements.txt
```

---

## 🎯 SUCCESS CHECKLIST

- [ ] Scripts are executable (`chmod +x *.sh`)
- [ ] UI source exists (`~/protrader-terminal-v2/`)
- [ ] Integration runs without errors
- [ ] `templates/index.html` exists
- [ ] `static/` folder has css, js, img
- [ ] Local server starts on port 10000
- [ ] http://localhost:10000 shows UI (not JSON)
- [ ] Git changes committed
- [ ] Changes pushed to origin
- [ ] Render deployment triggered
- [ ] Production URL shows UI

---

## 📞 QUICK HELP

**Problem:** Script errors
**Solution:** Check file permissions, paths

**Problem:** UI not loading
**Solution:** Re-run integration script

**Problem:** Production not updating  
**Solution:** Force Render rebuild

**Problem:** 404 errors
**Solution:** Check static file paths

**For detailed help:**
- See: QUICK_DEPLOY.md
- See: FIX_DEPLOYMENT_INSTRUCTIONS.md

---

## 🚀 SHORTCUTS

### Full Deploy
```bash
cd ~/protrader-backend && bash deploy_complete.sh
```

### Just Integrate
```bash
cd ~/protrader-backend && bash integrate_frontend.sh
```

### Just Verify
```bash
cd ~/protrader-backend && bash verify_fix.sh
```

### Test Local
```bash
cd ~/protrader-backend && python app.py
```

### Push to Production
```bash
cd ~/protrader-backend && git push origin main
```

---

*Command Card - ProTrader Deployment*  
*All commands in one place*  
*Copy, paste, deploy! 🚀*
