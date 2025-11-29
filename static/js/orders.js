// ProTrader Terminal - Order Management
// Professional order entry with validation and risk warnings

let selectedOrderSide = 'buy';

// Select Order Side
function selectSide(side) {
    selectedOrderSide = side;
    
    const btnBuy = document.getElementById('btnBuy');
    const btnSell = document.getElementById('btnSell');
    
    if (side === 'buy') {
        btnBuy.classList.add('active');
        btnSell.classList.remove('active');
    } else {
        btnSell.classList.add('active');
        btnBuy.classList.remove('active');
    }
}

// Toggle Limit Price Field
function toggleLimitPrice() {
    const orderType = document.getElementById('orderType').value;
    const limitPriceGroup = document.getElementById('limitPriceGroup');
    
    if (orderType === 'limit') {
        limitPriceGroup.style.display = 'block';
    } else {
        limitPriceGroup.style.display = 'none';
    }
}

// Submit Order
async function submitOrder() {
    const symbol = document.getElementById('orderSymbol').value.trim().toUpperCase();
    const qty = parseInt(document.getElementById('orderQty').value);
    const orderType = document.getElementById('orderType').value;
    const limitPrice = orderType === 'limit' ? parseFloat(document.getElementById('limitPrice').value) : null;
    
    // Validation
    if (!symbol) {
        showOrderResult('Please enter a symbol', 'error');
        return;
    }
    
    if (!qty || qty <= 0) {
        showOrderResult('Please enter a valid quantity', 'error');
        return;
    }
    
    if (orderType === 'limit' && (!limitPrice || limitPrice <= 0)) {
        showOrderResult('Please enter a valid limit price', 'error');
        return;
    }
    
    // Prepare order payload
    const orderPayload = {
        symbol: symbol,
        qty: qty,
        side: selectedOrderSide,
        type: orderType
    };
    
    if (orderType === 'limit') {
        orderPayload.limit_price = limitPrice;
    }
    
    console.log('📝 Submitting order:', orderPayload);
    
    // Update button state
    const submitBtn = document.getElementById('orderBtnText');
    const originalText = submitBtn.textContent;
    submitBtn.textContent = 'Submitting...';
    submitBtn.parentElement.disabled = true;
    
    try {
        const response = await fetch('/api/order/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(orderPayload)
        });
        
        const data = await response.json();
        
        if (response.ok && data.ok) {
            const orderDetails = `${selectedOrderSide.toUpperCase()} ${qty} ${symbol} @ ${orderType.toUpperCase()}`;
            showOrderResult(`✓ Order placed: ${orderDetails}`, 'success');
            
            // Clear form
            setTimeout(() => {
                document.getElementById('orderSymbol').value = '';
                document.getElementById('orderQty').value = '1';
                document.getElementById('orderType').value = 'market';
                document.getElementById('limitPrice').value = '';
                toggleLimitPrice();
            }, 2000);
            
            // Refresh portfolio
            setTimeout(refreshPortfolio, 3000);
            
        } else {
            const errorMsg = data.error || data.message || 'Order failed';
            showOrderResult(`⚠️ ${errorMsg}`, 'error');
        }
        
    } catch (error) {
        console.error('Order submission failed:', error);
        showOrderResult(`❌ Error: ${error.message}`, 'error');
    } finally {
        submitBtn.textContent = originalText;
        submitBtn.parentElement.disabled = false;
    }
}

// Quick Order
async function quickOrder(side) {
    const symbol = document.getElementById('quickSymbol').value.trim().toUpperCase();
    const qty = parseInt(document.getElementById('quickQty').value);
    
    if (!symbol) {
        showNotification('Please enter a symbol', 'warning');
        return;
    }
    
    if (!qty || qty <= 0) {
        showNotification('Please enter a valid quantity', 'warning');
        return;
    }
    
    const orderPayload = {
        symbol: symbol,
        qty: qty,
        side: side,
        type: 'market'
    };
    
    console.log('⚡ Quick order:', orderPayload);
    showNotification(`Placing ${side.toUpperCase()} order...`, 'info');
    
    try {
        const response = await fetch('/api/order/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(orderPayload)
        });
        
        const data = await response.json();
        
        if (response.ok && data.ok) {
            showNotification(`✓ ${side.toUpperCase()} ${qty} ${symbol}`, 'success');
            
            // Clear quick order inputs
            document.getElementById('quickSymbol').value = '';
            document.getElementById('quickQty').value = '1';
            
            // Refresh portfolio
            setTimeout(refreshPortfolio, 2000);
            
        } else {
            const errorMsg = data.error || data.message || 'Order failed';
            showNotification(`⚠️ ${errorMsg}`, 'error');
        }
        
    } catch (error) {
        console.error('Quick order failed:', error);
        showNotification(`❌ Error: ${error.message}`, 'error');
    }
}

// Show Order Result
function showOrderResult(message, type) {
    const resultDiv = document.getElementById('orderResult');
    resultDiv.textContent = message;
    resultDiv.className = `order-result ${type}`;
    resultDiv.style.display = 'block';
    
    // Auto-hide after 10 seconds
    setTimeout(() => {
        resultDiv.style.display = 'none';
    }, 10000);
}

// Export for global access
window.selectSide = selectSide;
window.toggleLimitPrice = toggleLimitPrice;
window.submitOrder = submitOrder;
window.quickOrder = quickOrder;

console.log('✓ Orders.js loaded');
