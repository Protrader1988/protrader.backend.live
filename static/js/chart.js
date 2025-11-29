// ProTrader Terminal - Professional Charting
// TradingView-style candlestick charts with real-time data

let priceChart = null;

// Load Chart Data
async function loadChart() {
    const symbol = document.getElementById('symbolInput').value.trim().toUpperCase();
    const timeframe = document.getElementById('timeframeSelect').value;
    
    if (!symbol) {
        showNotification('Please enter a symbol', 'warning');
        return;
    }
    
    console.log(`📈 Loading chart for ${symbol} (${timeframe})...`);
    showNotification(`Loading ${symbol} chart...`, 'info');
    
    try {
        // Note: The API endpoint might be /api/history/ based on the backend
        const url = `/api/history/?symbol=${symbol}&timeframe=${timeframe}&limit=100`;
        const response = await fetch(url);
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const data = await response.json();
        console.log('Chart data received:', data);
        
        if (data.bars && data.bars.length > 0) {
            renderChart(data.bars, symbol, timeframe);
            updateChartInfo(data.bars[data.bars.length - 1]);
            showNotification(`${symbol} chart loaded`, 'success');
        } else {
            showNotification('No data available for this symbol', 'warning');
        }
        
    } catch (error) {
        console.error('Chart load failed:', error);
        showNotification(`Failed to load chart: ${error.message}`, 'error');
        showChartError(error.message);
    }
}

// Render Chart
function renderChart(bars, symbol, timeframe) {
    const ctx = document.getElementById('priceChart');
    
    if (!ctx) {
        console.error('Chart canvas not found');
        return;
    }
    
    // Destroy existing chart
    if (priceChart) {
        priceChart.destroy();
    }
    
    // Prepare data
    const labels = bars.map(bar => new Date(bar.t || bar.timestamp));
    const prices = bars.map(bar => ({
        x: new Date(bar.t || bar.timestamp),
        o: parseFloat(bar.o || bar.open),
        h: parseFloat(bar.h || bar.high),
        l: parseFloat(bar.l || bar.low),
        c: parseFloat(bar.c || bar.close)
    }));
    
    const volumes = bars.map(bar => parseFloat(bar.v || bar.volume || 0));
    
    // Create chart
    priceChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: `${symbol} Price`,
                data: prices.map(p => p.c),
                borderColor: '#3B82F6',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                borderWidth: 2,
                pointRadius: 0,
                pointHoverRadius: 4,
                fill: true,
                tension: 0.1
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
                            const price = prices[context.dataIndex];
                            return [
                                `Open: ${formatCurrency(price.o)}`,
                                `High: ${formatCurrency(price.h)}`,
                                `Low: ${formatCurrency(price.l)}`,
                                `Close: ${formatCurrency(price.c)}`
                            ];
                        }
                    }
                }
            },
            scales: {
                x: {
                    type: 'time',
                    time: {
                        unit: getTimeUnit(timeframe),
                        displayFormats: {
                            minute: 'HH:mm',
                            hour: 'HH:mm',
                            day: 'MMM dd',
                            week: 'MMM dd',
                            month: 'MMM yyyy'
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
                    position: 'right',
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
            },
            interaction: {
                mode: 'nearest',
                axis: 'x',
                intersect: false
            }
        }
    });
}

// Get appropriate time unit for chart
function getTimeUnit(timeframe) {
    const map = {
        '1Min': 'minute',
        '5Min': 'minute',
        '15Min': 'minute',
        '1Hour': 'hour',
        '1Day': 'day'
    };
    return map[timeframe] || 'day';
}

// Update Chart Info
function updateChartInfo(lastBar) {
    if (!lastBar) return;
    
    const open = parseFloat(lastBar.o || lastBar.open || 0);
    const high = parseFloat(lastBar.h || lastBar.high || 0);
    const low = parseFloat(lastBar.l || lastBar.low || 0);
    const close = parseFloat(lastBar.c || lastBar.close || 0);
    const volume = parseFloat(lastBar.v || lastBar.volume || 0);
    
    document.getElementById('chartOpen').textContent = formatCurrency(open);
    document.getElementById('chartHigh').textContent = formatCurrency(high);
    document.getElementById('chartLow').textContent = formatCurrency(low);
    document.getElementById('chartClose').textContent = formatCurrency(close);
    document.getElementById('chartVolume').textContent = formatNumber(volume);
}

// Show Chart Error
function showChartError(errorMessage) {
    const chartInfo = document.getElementById('chartInfo');
    chartInfo.innerHTML = `
        <div class="empty-state" style="color: var(--danger); padding: 20px;">
            ⚠️ Failed to load chart: ${errorMessage}
        </div>
    `;
}

// Export for global access
window.loadChart = loadChart;

// Auto-load default chart on panel switch
console.log('✓ Chart.js loaded');
