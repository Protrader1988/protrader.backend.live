// ProTrader Terminal - Portfolio Management
// Professional portfolio display and real-time P&L tracking

// Refresh Portfolio Data
async function refreshPortfolio() {
    console.log('📊 Refreshing portfolio...');
    
    try {
        const response = await fetch('/api/portfolio/');
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const data = await response.json();
        console.log('Portfolio data received:', data);
        
        updatePortfolioDisplay(data);
        updateLastUpdateTime();
        
        showNotification('Portfolio updated', 'success');
        
    } catch (error) {
        console.error('Portfolio refresh failed:', error);
        showPortfolioError(error.message);
    }
}

// Update Portfolio Display
function updatePortfolioDisplay(data) {
    // Update account summary
    if (data.account) {
        const equity = parseFloat(data.account.equity || 0);
        const cash = parseFloat(data.account.cash || 0);
        const dayPnL = parseFloat(data.account.day_pl || 0);
        const totalPnL = parseFloat(data.account.total_pl || 0);
        
        document.getElementById('totalEquity').textContent = formatCurrency(equity);
        document.getElementById('cashAvailable').textContent = formatCurrency(cash);
        document.getElementById('accountEquity').textContent = formatCurrency(equity);
        
        // Update P&L with color coding
        const dayPnLElement = document.getElementById('dayPnL');
        dayPnLElement.textContent = formatCurrency(dayPnL);
        dayPnLElement.className = 'summary-value pnl ' + (dayPnL >= 0 ? 'positive' : 'negative');
        
        const totalPnLElement = document.getElementById('totalPnL');
        totalPnLElement.textContent = formatCurrency(totalPnL);
        totalPnLElement.className = 'summary-value pnl ' + (totalPnL >= 0 ? 'positive' : 'negative');
    }
    
    // Update positions table
    if (data.positions && Array.isArray(data.positions)) {
        updatePositionsTable(data.positions);
    } else {
        showEmptyPositions();
    }
}

// Update Positions Table
function updatePositionsTable(positions) {
    const tbody = document.getElementById('positionsBody');
    
    if (!positions || positions.length === 0) {
        showEmptyPositions();
        return;
    }
    
    tbody.innerHTML = '';
    
    positions.forEach(position => {
        const row = createPositionRow(position);
        tbody.appendChild(row);
    });
}

// Create Position Row
function createPositionRow(position) {
    const row = document.createElement('tr');
    
    const symbol = position.symbol || '--';
    const qty = parseFloat(position.qty || 0);
    const avgPrice = parseFloat(position.avg_entry_price || 0);
    const currentPrice = parseFloat(position.current_price || avgPrice);
    const marketValue = parseFloat(position.market_value || (qty * currentPrice));
    const unrealizedPL = parseFloat(position.unrealized_pl || 0);
    const unrealizedPLPC = parseFloat(position.unrealized_plpc || 0) * 100;
    
    // Calculate P&L if not provided
    let pnl = unrealizedPL;
    let pnlPercent = unrealizedPLPC;
    
    if (pnl === 0 && avgPrice > 0 && currentPrice > 0) {
        pnl = (currentPrice - avgPrice) * qty;
        pnlPercent = ((currentPrice - avgPrice) / avgPrice) * 100;
    }
    
    const pnlClass = pnl >= 0 ? 'positive' : 'negative';
    
    row.innerHTML = `
        <td><strong>${symbol}</strong></td>
        <td>${formatNumber(qty)}</td>
        <td>${formatCurrency(avgPrice)}</td>
        <td>${formatCurrency(currentPrice)}</td>
        <td>${formatCurrency(marketValue)}</td>
        <td class="${pnlClass}">${formatCurrency(pnl)}</td>
        <td class="${pnlClass}">${formatPercentage(pnlPercent)}</td>
    `;
    
    return row;
}

// Show Empty Positions
function showEmptyPositions() {
    const tbody = document.getElementById('positionsBody');
    tbody.innerHTML = `
        <tr>
            <td colspan="7" class="empty-state">
                No open positions. Your portfolio is 100% cash.
            </td>
        </tr>
    `;
}

// Show Portfolio Error
function showPortfolioError(errorMessage) {
    const tbody = document.getElementById('positionsBody');
    tbody.innerHTML = `
        <tr>
            <td colspan="7" class="empty-state" style="color: var(--danger);">
                ⚠️ Failed to load portfolio: ${errorMessage}
                <br><br>
                <button class="refresh-btn" onclick="refreshPortfolio()" style="margin-top: 10px;">
                    Try Again
                </button>
            </td>
        </tr>
    `;
    
    // Reset account values
    document.getElementById('totalEquity').textContent = '$0.00';
    document.getElementById('cashAvailable').textContent = '$0.00';
    document.getElementById('accountEquity').textContent = '$0.00';
    document.getElementById('dayPnL').textContent = '$0.00';
    document.getElementById('totalPnL').textContent = '$0.00';
}

// Export for global access
window.refreshPortfolio = refreshPortfolio;

console.log('✓ Portfolio.js loaded');
