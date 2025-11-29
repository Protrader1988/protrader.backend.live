// ProTrader Terminal - Main Application Logic
// Bloomberg Terminal-Style Professional Trading Interface

// Global State
const appState = {
    currentPanel: 'portfolio',
    selectedSide: 'buy',
    isLoading: false,
    connectionStatus: 'connected'
};

// Initialize Application
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 ProTrader Terminal initializing...');
    
    // Initialize clock
    updateClock();
    setInterval(updateClock, 1000);
    
    // Setup navigation
    setupNavigation();
    
    // Check system health
    checkSystemHealth();
    
    // Load initial data
    loadInitialData();
    
    // Setup auto-refresh intervals
    setupAutoRefresh();
    
    console.log('✓ ProTrader Terminal ready');
});

// Clock Update
function updateClock() {
    const now = new Date();
    const options = {
        timeZone: 'America/New_York',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false
    };
    
    const timeString = now.toLocaleTimeString('en-US', options);
    document.getElementById('marketClock').textContent = timeString + ' EST';
}

// Navigation System
function setupNavigation() {
    const navItems = document.querySelectorAll('.nav-item');
    
    navItems.forEach(item => {
        item.addEventListener('click', function() {
            const panelName = this.dataset.panel;
            switchPanel(panelName);
            
            // Update active state
            navItems.forEach(nav => nav.classList.remove('active'));
            this.classList.add('active');
        });
    });
}

function switchPanel(panelName) {
    // Hide all panels
    document.querySelectorAll('.panel').forEach(panel => {
        panel.classList.remove('active');
    });
    
    // Show selected panel
    const targetPanel = document.getElementById(panelName + 'Panel');
    if (targetPanel) {
        targetPanel.classList.add('active');
        appState.currentPanel = panelName;
        
        // Load panel-specific data
        loadPanelData(panelName);
    }
}

function loadPanelData(panelName) {
    switch(panelName) {
        case 'portfolio':
            refreshPortfolio();
            break;
        case 'chart':
            // Chart loads on demand
            break;
        case 'news':
            refreshNews();
            break;
        case 'settings':
            checkBrokerStatus();
            break;
    }
}

// System Health Check
async function checkSystemHealth() {
    try {
        const response = await fetch('/health');
        const data = await response.json();
        
        if (data.ok) {
            updateConnectionStatus('connected');
            updateSystemStatus('System Online');
        } else {
            updateConnectionStatus('warning');
            updateSystemStatus('System Degraded');
        }
    } catch (error) {
        console.error('Health check failed:', error);
        updateConnectionStatus('disconnected');
        updateSystemStatus('System Offline');
    }
}

function updateConnectionStatus(status) {
    const dot = document.getElementById('connectionDot');
    const text = document.getElementById('connectionText');
    
    dot.className = 'connection-dot';
    
    switch(status) {
        case 'connected':
            dot.style.background = 'var(--success)';
            text.textContent = 'Connected';
            break;
        case 'warning':
            dot.style.background = 'var(--warning)';
            text.textContent = 'Limited';
            break;
        case 'disconnected':
            dot.style.background = 'var(--danger)';
            text.textContent = 'Offline';
            break;
    }
}

function updateSystemStatus(status) {
    document.getElementById('systemStatus').textContent = status;
}

// Load Initial Data
function loadInitialData() {
    // Load portfolio data
    refreshPortfolio();
    
    // Load news
    refreshNews();
}

// Auto-refresh Setup
function setupAutoRefresh() {
    // Refresh portfolio every 30 seconds
    setInterval(refreshPortfolio, 30000);
    
    // Refresh news every 5 minutes
    setInterval(refreshNews, 300000);
    
    // Health check every minute
    setInterval(checkSystemHealth, 60000);
}

// Update last update time
function updateLastUpdateTime() {
    const now = new Date();
    const timeString = now.toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
    document.getElementById('lastUpdate').textContent = `Last Updated: ${timeString}`;
}

// Format currency
function formatCurrency(value) {
    if (value === null || value === undefined || isNaN(value)) {
        return '$0.00';
    }
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    }).format(value);
}

// Format percentage
function formatPercentage(value) {
    if (value === null || value === undefined || isNaN(value)) {
        return '0.00%';
    }
    const sign = value >= 0 ? '+' : '';
    return sign + value.toFixed(2) + '%';
}

// Format number with commas
function formatNumber(value) {
    if (value === null || value === undefined || isNaN(value)) {
        return '0';
    }
    return new Intl.NumberFormat('en-US').format(value);
}

// Show loading state
function showLoading(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.classList.add('loading');
    }
}

function hideLoading(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.classList.remove('loading');
    }
}

// Show notification
function showNotification(message, type = 'info') {
    console.log(`[${type.toUpperCase()}] ${message}`);
    
    // Update status bar
    const statusElement = document.getElementById('systemStatus');
    const originalText = statusElement.textContent;
    
    statusElement.textContent = message;
    
    setTimeout(() => {
        statusElement.textContent = originalText;
    }, 5000);
}

// API Error Handler
function handleApiError(error, context = '') {
    console.error(`API Error${context ? ' (' + context + ')' : ''}:`, error);
    
    let message = 'An error occurred. Please try again.';
    
    if (error.message) {
        message = error.message;
    } else if (typeof error === 'string') {
        message = error;
    }
    
    showNotification(message, 'error');
    return null;
}

// Export functions for use in other modules
window.appState = appState;
window.formatCurrency = formatCurrency;
window.formatPercentage = formatPercentage;
window.formatNumber = formatNumber;
window.showLoading = showLoading;
window.hideLoading = hideLoading;
window.showNotification = showNotification;
window.handleApiError = handleApiError;
window.updateLastUpdateTime = updateLastUpdateTime;

console.log('✓ App.js loaded');
