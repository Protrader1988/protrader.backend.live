# ⚠️ Frontend Creation Blocked - Node.js Required

## 📋 Task Status

**Current Task:** Create new React frontend from scratch using Vite + TypeScript

**Status:** ⚠️ **BLOCKED** - Node.js not installed or not in PATH

---

## 🔍 Problem

Attempted to run:
```bash
npm create vite@latest protrader.frontend.live -- --template react-ts
```

**Error:**
```
/bin/sh: npm: command not found
```

**Verification:**
- `which node` → Not found in PATH
- `node --version` → Command not available

---

## ✅ Repository Setup Complete

**Backend Repository:**
- Location: `/Users/nikkoshkreli/fellou_protrader_temp/protrader.backend.live`
- Git Remote: `https://github.com/Protrader1988/protrader.backend.live`
- Status: Clean, up-to-date with origin/main
- Ready for integration

---

## 🎯 User Provided Instructions

The user wants to create a NEW React frontend with:

1. **Vite + React + TypeScript** template
2. **Dependencies:**
   - `recharts` (for charts)
   - `lucide-react` (for icons)
   - `sonner` (for toasts)
   - `tailwindcss`, `postcss`, `autoprefixer`

3. **Features:**
   - Bloomberg-style terminal UI
   - Portfolio display
   - Real-time price charts
   - Watchlist
   - Backtesting interface
   - Order execution
   - Dark/light mode

4. **API Integration:**
   - Connect to: `https://protrader-backend-web.onrender.com`
   - Endpoints: `/api/portfolio`, `/api/history`, `/api/order`, `/api/backtest`

---

## 🚨 Required Actions

### Option 1: Install Node.js (Recommended)
```bash
# Install Node.js via Homebrew
brew install node

# Or download from: https://nodejs.org/
```

### Option 2: Use Existing Node.js Installation
If Node.js is installed but not in PATH, add to `~/.zshrc` or `~/.bash_profile`:
```bash
export PATH="/usr/local/bin:$PATH"
# or wherever node is installed
```

### Option 3: Manual Frontend Setup
1. Install Node.js on your system
2. Run the commands provided by the user
3. The complete command sequence is saved below

---

## 📝 Complete Frontend Setup Commands

Once Node.js is available, run:

```bash
# 0) Navigate to workspace
cd ~/fellou_protrader_temp

# 1) Create Vite React TypeScript app
npm create vite@latest protrader.frontend.live -- --template react-ts
cd protrader.frontend.live

# 2) Install dependencies
npm i recharts lucide-react sonner
npm i -D tailwindcss postcss autoprefixer

# 3) Initialize Tailwind
npx tailwindcss init -p

# 4) Configure Tailwind
cat > tailwind.config.js <<'TAILWIND_EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html","./src/**/*.{ts,tsx}"],
  darkMode: "class",
  theme: { extend: {} },
  plugins: [],
}
TAILWIND_EOF

# 5) Add Tailwind CSS
cat > src/index.css <<'CSS_EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
:root { --background:#ffffff; --border:#e5e7eb; }
.dark { --background:#09090b; --border:#27272a; }
CSS_EOF

# 6) Set API base URL
echo "VITE_API_BASE=https://protrader-backend-web.onrender.com" > .env

# 7) Create main entry point
cat > src/main.tsx <<'MAIN_EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import './index.css'
import App from './App'
ReactDOM.createRoot(document.getElementById('root')!).render(<App />)
MAIN_EOF

# 8) Create minimal App
cat > src/App.tsx <<'APP_EOF'
import React from "react";
import ProTraderTerminal from "./ProTraderTerminal";
export default function App() { return <ProTraderTerminal />; }
APP_EOF

# 9) Create terminal component (see ProTraderTerminal.tsx below)
# [4000+ line terminal component - see user's provided code]

# 10) Test locally
npm run dev

# 11) Build for production
npm run build
```

---

## 🎯 Next Steps After Node.js Installation

1. **Install Node.js** (if not already installed)
2. **Run frontend creation commands** (provided above)
3. **Update integration script** to use the new frontend
4. **Update app.py** to serve React UI
5. **Deploy to production**

---

## 📌 Variables Stored

- **repoPath:** `/Users/nikkoshkreli/fellou_protrader_temp/protrader.backend.live`
- **frontendBuildPath:** Will be `~/fellou_protrader_temp/protrader.frontend.live/dist` after creation

---

## ✅ What's Ready

- ✅ Backend repository cloned and verified
- ✅ Git configured and up-to-date
- ✅ User instructions received
- ✅ Frontend code template provided
- ⚠️ **Waiting for Node.js installation**

---

## 🔄 Handoff to User

**Please install Node.js and re-run this task, or:**

1. Install Node.js: `brew install node`
2. Verify: `node --version && npm --version`
3. Re-run the task for automatic frontend creation

**Status:** Repository setup complete, waiting for Node.js environment
