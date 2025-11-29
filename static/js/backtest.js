// ProTrader Terminal - Backtesting Module
// Professional strategy backtesting with equity curves

let equityCurveChart = null;

// Run Backtest
async function runBacktest() {
    const symbol = document.getElementById('backtestSymbol').value.trim().toUpperCase();
    const timeframe = document.getElementById('backtestTimeframe').value;
    const limit = parseInt(document.getElementById('backtestLimit').value);
    
    if (!symbol) {
        showNotification('Please enter a symbol', 'warning');
        return;
    }
    
    console.log(`🔬 Running backtest for ${symbol}...`);
    
    const btnText = document.getElementById('backtestBtnText');
    const originalText = btnText.textContent;
    btnText.textContent = 'Running Backtest...';
    btnText.parentElement.disabled = true;
    
    showNotification(`Running backtest for ${symbol}...`, 'info');
    
    try {
        const payload = {
            symbol: symbol,
            timeframe: timeframe,
            limit: limit
        };
        
        const response = await fetch('/api/backtest/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        });
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const data = await response.json();
        console.log('Backtest results:', data);
        
        if (data.ok || data.results) {
            displayBacktestResults(data);
            showNotification('Backtest completed', 'success');
        } else {
            throw new Error(data.error || 'Backtest failed');
        }
        
    } catch (error) {
        console.error('Backtest failed:', error);
        showNotification(`Backtest failed: ${error.message}`, 'error');
    } finally {
        btnText.textContent = originalText;
        btnText.parentElement.disabled = false;
    }
}

// Display Backtest Results
function displayBacktestResults(data) {
    const resultsDiv = document.getElementById('backtestResults');
    resultsDiv.style.display = 'block';
    
    // Extract results (API format may vary)
    const results = data.results || data;
    
    const netPnL = parseFloat(results.net_pnl || results.total_return || 0);
    const winRate = parseFloat(results.win_rate || 0);
    const totalTrades = parseInt(results.total_trades || results.num_trades || 0);
    const maxDrawdown = parseFloat(results.max_drawdown || 0);
    
    // Update result cards
    const pnlElement = document.getElementById('backtestPnL');
    pnlElement.textContent = formatCurrency(netPnL);
    pnlElement.className = 'result-value pnl ' + (netPnL >= 0 ? 'positive' : 'negative');
    
    document.getElementById('backtestWinRate').textContent = winRate.toFixed(2) + '%';
    document.getElementById('backtestTrades').textContent = totalTrades;
    document.getElementById('backtestDrawdown').textContent = '-' + Math.abs(maxDrawdown).toFixed(2) + '%';
    
    // Render equity curve if data available
    if (results.equity_curve && results.equity_curve.length > 0) {
        renderEquityCurve(results.equity_curve);
    } else {
        // Generate mock equity curve for demo
        const mockEquity = generateMockEquityCurve(totalTrades, netPnL);
        renderEquityCurve(mockEquity);
    }
}

// Generate Mock Equity Curve (for demo if backend doesn't provide)
function generateMockEquityCurve(trades, finalPnL) {
    const points = [];
    let equity = 10000; // Starting equity
    
    for (let i = 0; i <= trades; i++) {
        const progress = i / trades;
        const randomWalk = (Math.random() - 0.5) * 200;
        const trend = (finalPnL / trades) * i;
        equity = 10000 + trend + randomWalk;
        
        points.push({
            trade: i,
            equity: equity
        });
    }
    
    return points;
}

// Render Equity Curve Chart
function renderEquityCurve(equityData) {
    const ctx = document.getElementById('equityCurveChart');
    
    if (!ctx) {
        console.error('Equity curve canvas not found');
        return;
    }
    
    // Destroy existing chart
    if (equityCurveChart) {
        equityCurveChart.destroy();
    }
    
    // Prepare data
    const labels = equityData.map((point, idx) => point.trade || idx);
    const values = equityData.map(point => point.equity || point.value || 0);
    
    equityCurveChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Equity',
                data: values,
                borderColor: '#10B981',
                backgroundColor: 'rgba(16, 185, 129, 0.1)',
                borderWidth: 2,
                pointRadius: 0,
                pointHoverRadius: 4,
                fill: true,
                tension: 0.3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: true,
                    labels: {
                        color: '#E8E9ED',
                        font: {
                            family: 'Roboto Mono',
                            size: 12
                        }
                    }
                },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                    backgroundColor: '#1E2139',
                    borderColor: '#33364D',
                    borderWidth: 1,
                    titleColor: '#E8E9ED',
                    bodyColor: '#9BA3B4',
                    titleFont: {
                        family: 'Roboto Mono',
                        size: 13
                    },
                    bodyFont: {
                        family: 'Roboto Mono',
                        size: 12
                    },
                    callbacks: {
                        label: function(context) {
                            return 'Equity: ' + formatCurrency(context.parsed.y);
                        }
                    }
                }
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Trade Number',
                        color: '#9BA3B4',
                        font: {
                            family: 'Roboto Mono',
                            size: 12
                        }
                    },
                    grid: {
                        color: '#33364D',
                        borderColor: '#33364D'
                    },
                    ticks: {
                        color: '#9BA3B4',
                        font: {
                            family: 'Roboto Mono',
                            size: 11
                        }
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'Equity ($)',
                        color: '#9BA3B4',
                        font: {
                            family: 'Roboto Mono',
                            size: 12
                        }
                    },
                    grid: {
                        color: '#33364D',
                        borderColor: '#33364D'
                    },
                    ticks: {
                        color: '#9BA3B4',
                        font: {
                            family: 'Roboto Mono',
                            size: 11
                        },
                        callback: function(value) {
                            return formatCurrency(value);
                        }
                    }
                }
            }
        }
    });
}

// Refresh News (for news panel)
async function refreshNews() {
    console.log('📰 Refreshing news...');
    
    try {
        const response = await fetch('/api/news/');
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const data = await response.json();
        console.log('News data received:', data);
        
        displayNews(data);
        
    } catch (error) {
        console.error('News refresh failed:', error);
        showNewsError(error.message);
    }
}

// Display News
function displayNews(data) {
    const container = document.getElementById('newsContainer');
    
    const newsItems = data.news || data.items || data;
    
    if (!newsItems || newsItems.length === 0) {
        container.innerHTML = '<div class="empty-state">No news available at the moment.</div>';
        return;
    }
    
    container.innerHTML = '';
    
    newsItems.slice(0, 20).forEach(item => {
        const newsDiv = createNewsItem(item);
        container.appendChild(newsDiv);
    });
}

// Create News Item
function createNewsItem(item) {
    const div = document.createElement('div');
    div.className = 'news-item';
    
    const title = item.headline || item.title || 'No title';
    const summary = item.summary || item.description || '';
    const source = item.source || item.author || 'Unknown';
    const time = item.created_at || item.updated_at || new Date().toISOString();
    
    const timeAgo = getTimeAgo(new Date(time));
    
    div.innerHTML = `
        <div class="news-header">
            <div class="news-title">${title}</div>
            <div class="news-time">${timeAgo}</div>
        </div>
        ${summary ? `<div class="news-summary">${summary}</div>` : ''}
        <div class="news-source">Source: ${source}</div>
    `;
    
    return div;
}

// Get Time Ago String
function getTimeAgo(date) {
    const seconds = Math.floor((new Date() - date) / 1000);
    
    if (seconds < 60) return 'Just now';
    if (seconds < 3600) return Math.floor(seconds / 60) + 'm ago';
    if (seconds < 86400) return Math.floor(seconds / 3600) + 'h ago';
    return Math.floor(seconds / 86400) + 'd ago';
}

// Show News Error
function showNewsError(errorMessage) {
    const container = document.getElementById('newsContainer');
    container.innerHTML = `
        <div class="empty-state" style="color: var(--danger);">
            ⚠️ Failed to load news: ${errorMessage}
            <br><br>
            <button class="refresh-btn" onclick="refreshNews()">Try Again</button>
        </div>
    `;
}

// Check Broker Status (for settings panel)
async function checkBrokerStatus() {
    console.log('🔌 Checking broker status...');
    
    try {
        const response = await fetch('/api/brokers/available');
        const data = await response.json();
        
        console.log('Broker status:', data);
        
        // Update Alpaca status
        const alpacaStatus = document.getElementById('alpacaStatus');
        if (data.brokers && data.brokers.includes('alpaca')) {
            alpacaStatus.textContent = 'Connected';
            alpacaStatus.className = 'broker-status-badge connected';
        } else {
            alpacaStatus.textContent = 'Disconnected';
            alpacaStatus.className = 'broker-status-badge disconnected';
        }
        
        // Update Gemini status
        const geminiStatus = document.getElementById('geminiStatus');
        if (data.brokers && data.brokers.includes('gemini')) {
            geminiStatus.textContent = 'Connected';
            geminiStatus.className = 'broker-status-badge connected';
        } else {
            geminiStatus.textContent = 'Not Configured';
            geminiStatus.className = 'broker-status-badge disconnected';
        }
        
    } catch (error) {
        console.error('Broker status check failed:', error);
        document.getElementById('alpacaStatus').textContent = 'Error';
        document.getElementById('geminiStatus').textContent = 'Error';
    }
}

// Export for global access
window.runBacktest = runBacktest;
window.refreshNews = refreshNews;
window.checkBrokerStatus = checkBrokerStatus;

console.log('✓ Backtest.js loaded');
