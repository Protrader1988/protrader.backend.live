# ✅ ProTrader Deployment Checklist

**Date:** _____________  
**Deployer:** _____________  
**Goal:** Fix UI loading issue (replace JSON response with ProTrader Terminal)

---

## 📋 Pre-Deployment Checklist

### Environment Setup
- [ ] Terminal open in `~/protrader-backend/`
- [ ] Git repository up-to-date (`git pull`)
- [ ] Internet connection stable
- [ ] Sufficient disk space (>500MB)

### File Verification
- [ ] `integrate_frontend.sh` exists
- [ ] `deploy_complete.sh` exists
- [ ] `verify_fix.sh` exists
- [ ] `app_new.py` exists
- [ ] `requirements.txt` exists
- [ ] `~/protrader-terminal-v2/index.html` exists

### Permissions
- [ ] Scripts are executable (`chmod +x *.sh`)
- [ ] Write access to `~/protrader-backend/`
- [ ] Git push access to repository

---

## 🚀 Deployment Steps

### Step 1: Verify Setup ⏱️ 30 seconds
```bash
bash verify_fix.sh
```
- [ ] Script runs without errors
- [ ] All checks show ✅ (green checkmarks)
- [ ] "All checks passed! Ready to deploy." message displayed
- [ ] No ❌ (red X) marks in output

**If fails:** Fix issues indicated by script, then re-run

---

### Step 2: Deploy Locally ⏱️ 2 minutes
```bash
bash deploy_complete.sh
```
- [ ] Script starts without errors
- [ ] "Frontend integration complete!" message displayed
- [ ] Python dependencies install successfully
- [ ] Local server starts on port 10000
- [ ] Health endpoint test passes
- [ ] Root endpoint returns HTML (not JSON)
- [ ] "Local deployment successful!" message displayed

**If fails:** Check error messages, review logs, try manual steps

---

### Step 3: Test Local UI ⏱️ 1 minute

#### Browser Test
```
Open: http://localhost:10000
```
- [ ] Page loads (not blank)
- [ ] ProTrader Terminal UI visible
- [ ] Charts display area present
- [ ] Order panel visible
- [ ] Portfolio section visible
- [ ] No browser console errors

#### Command Line Test
```bash
curl http://localhost:10000/ | head -n 20
```
- [ ] Returns HTML content
- [ ] Contains "ProTrader" text
- [ ] Contains `<html>` tags
- [ ] Does NOT return `{"ok":true}`

---

### Step 4: Test Local API ⏱️ 1 minute

#### Health Check
```bash
curl http://localhost:10000/health
```
- [ ] Returns JSON: `{"status": "ok", ...}`
- [ ] Status code 200

#### Portfolio Test (if API keys configured)
```bash
curl http://localhost:10000/api/portfolio
```
- [ ] Returns JSON portfolio data OR
- [ ] Returns error about missing API keys (expected if not configured)
- [ ] Does NOT return HTML

---

### Step 5: Prepare Git Commit ⏱️ 1 minute

#### Check Status
```bash
git status
```
- [ ] Modified files listed
- [ ] New files listed (scripts, docs)
- [ ] No unexpected changes

#### Stage Files
```bash
git add .
```
- [ ] All files staged successfully
- [ ] No git errors

#### Commit Changes
```bash
git commit -m "Fix: Integrate UI with Flask backend - serve at root"
```
- [ ] Commit successful
- [ ] Commit hash displayed
- [ ] Files count displayed

---

### Step 6: Push to Production ⏱️ 1 minute

#### Push to Remote
```bash
git push origin main
```
- [ ] Push starts successfully
- [ ] Upload progress shown
- [ ] "Successfully pushed to origin main" message
- [ ] No authentication errors
- [ ] No merge conflicts

**If fails:** Resolve conflicts, authenticate, or check network

---

### Step 7: Monitor Render Deploy ⏱️ 2-3 minutes

#### Dashboard Check
```
Visit: https://dashboard.render.com
```
- [ ] Service shows "Deploying" status
- [ ] Build logs visible
- [ ] "Running build command..." shown
- [ ] `integrate_frontend.sh` executes
- [ ] `pip install` completes
- [ ] Build finishes with green checkmark
- [ ] Service status changes to "Live"

**Build Log Checks:**
- [ ] "Frontend integration complete!" appears
- [ ] No "Error" messages
- [ ] "Successfully installed" for Python packages
- [ ] Gunicorn starts

---

### Step 8: Test Production UI ⏱️ 1 minute

#### Browser Test
```
Open: https://protrader-backend-web.onrender.com
```
- [ ] Page loads (not blank)
- [ ] ProTrader Terminal UI visible
- [ ] Charts display area present
- [ ] Order panel visible
- [ ] Portfolio section visible
- [ ] No browser console errors
- [ ] Does NOT show `{"ok":true}`

#### Command Line Test
```bash
curl https://protrader-backend-web.onrender.com/ | head -n 20
```
- [ ] Returns HTML content
- [ ] Contains "ProTrader" text
- [ ] Does NOT return JSON

---

### Step 9: Test Production API ⏱️ 1 minute

#### Health Check
```bash
curl https://protrader-backend-web.onrender.com/health
```
- [ ] Returns `{"status": "ok", ...}`
- [ ] Response time < 5 seconds

#### Portfolio Test
```bash
curl https://protrader-backend-web.onrender.com/api/portfolio
```
- [ ] Returns portfolio data OR
- [ ] Returns API key error (if not configured)
- [ ] Response is JSON (not HTML)

---

## ✅ Success Validation

### Local Success Indicators
- ✅ http://localhost:10000 → ProTrader UI
- ✅ /health → JSON OK response
- ✅ /api/* → JSON responses
- ✅ Static assets load (no 404s)
- ✅ Browser console clean

### Production Success Indicators
- ✅ https://protrader-backend-web.onrender.com → ProTrader UI
- ✅ /health → JSON OK response
- ✅ /api/* → JSON responses
- ✅ Render status: Live (green)
- ✅ No build errors in logs

---

## 🎯 Final Verification

### Functionality Test
- [ ] Can access UI on both local and production
- [ ] UI displays correctly (not JSON)
- [ ] Health endpoint responds
- [ ] API endpoints respond (or show config errors)
- [ ] No 404 errors in browser network tab
- [ ] Page loads in < 5 seconds

### Documentation Check
- [ ] All deployment docs available
- [ ] Scripts are in repository
- [ ] README updated (if needed)
- [ ] Environment variables documented

---

## 📊 Deployment Summary

**Deployment Date:** _____________  
**Deployment Time:** _____________ (Start to finish)  
**Deployed By:** _____________  

### Checklist Results
- Total Steps: 9
- Completed: _____ / 9
- Failed: _____ / 9
- Skipped: _____ / 9

### Issues Encountered
_______________________________________________
_______________________________________________
_______________________________________________

### Resolution Steps Taken
_______________________________________________
_______________________________________________
_______________________________________________

### Final Status
- [ ] ✅ Fully Successful - All steps completed
- [ ] ⚠️ Partially Successful - Some issues but functional
- [ ] ❌ Failed - Deployment did not complete

---

## 🚨 Rollback Procedure (If Needed)

### If Local Deployment Fails
```bash
# Stop local server
pkill -f "python app.py"

# Restore previous state
git checkout HEAD~1 app.py

# Restart
python app.py
```

### If Production Deployment Fails
```bash
# Revert commit
git revert HEAD
git push origin main

# Wait for Render to redeploy
# Monitor: https://dashboard.render.com
```

### If Both Fail
```bash
# Hard reset to previous working commit
git log  # Find last working commit hash
git reset --hard <commit-hash>
git push -f origin main

# Contact support with error logs
```

---

## 📞 Emergency Contacts

**Technical Support:** _____________  
**Project Lead:** _____________  
**DevOps:** _____________  

---

## 📝 Notes & Observations

_______________________________________________
_______________________________________________
_______________________________________________
_______________________________________________
_______________________________________________

---

## 🎉 Post-Deployment Tasks

### Immediate (Within 1 hour)
- [ ] Monitor Render logs for errors
- [ ] Test all UI features manually
- [ ] Check API response times
- [ ] Verify static assets caching
- [ ] Test from different browsers

### Short-term (Within 24 hours)
- [ ] Monitor user feedback
- [ ] Check error tracking (if configured)
- [ ] Review performance metrics
- [ ] Test with real API keys
- [ ] Verify backtest functionality

### Long-term (Within 1 week)
- [ ] Optimize load times
- [ ] Review and update documentation
- [ ] Plan next improvements
- [ ] Archive old versions
- [ ] Update monitoring alerts

---

## ✨ Deployment Complete!

**Signature:** _____________  
**Date/Time:** _____________  

**Confirmation:**
- [ ] Local UI working
- [ ] Production UI working
- [ ] API endpoints functional
- [ ] Documentation complete
- [ ] Team notified

---

*This checklist should be filled out during each deployment for audit purposes.*
