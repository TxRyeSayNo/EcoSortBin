let trendChart = null; // Store trend chart instance for updates

// Dashboard Logic & Charts
document.addEventListener('DOMContentLoaded', () => {
    initCharts();
    startPolling();
});

function startPolling() {
    // Initial fetch
    fetchDashboardData();
    fetchBinCapacities();
    
    // Poll every 3 seconds
    setInterval(() => {
        fetchDashboardData();
        fetchBinCapacities();
    }, 3000);
}

const SUPABASE_URL = 'https://tstnufzxpdnmxdbciawt.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRzdG51Znp4cGRubXhkYmNpYXd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ0NDE3NjIsImV4cCI6MjEwMDAxNzc2Mn0.hsgP-XGp64ANtTehutxHXmWDw6CRM4ctWNLpuqkb4Y4';

async function fetchDashboardData() {
    try {
        // Fetch all events from Supabase to count stats
        const allRes = await fetch(`${SUPABASE_URL}/rest/v1/events?select=waste_type,created_at`, {
            headers: {
                'apikey': SUPABASE_KEY,
                'Authorization': `Bearer ${SUPABASE_KEY}`
            }
        });
        const allEvents = await allRes.json();
        
        let stats = { totalCount: 0, plastic: 0, metal: 0, glass: 0 };
        
        // Prepare arrays for last 7 days
        const last7Days = [];
        for (let i = 6; i >= 0; i--) {
            const d = new Date();
            d.setDate(d.getDate() - i);
            const ds = d.toLocaleDateString('vi-VN', {day:'2-digit', month:'2-digit'});
            last7Days.push(ds);
        }
        let plasticData = [0, 0, 0, 0, 0, 0, 0];
        let metalData = [0, 0, 0, 0, 0, 0, 0];
        let glassData = [0, 0, 0, 0, 0, 0, 0];

        allEvents.forEach(e => {
            const type = e.waste_type ? e.waste_type.toUpperCase() : '';
            if (type === 'PLASTIC') stats.plastic++;
            else if (type === 'METAL') stats.metal++;
            else if (type === 'GLASS') stats.glass++;
            
            // Weekly trend logic
            if (e.created_at) {
                const eDate = new Date(e.created_at);
                const eDs = eDate.toLocaleDateString('vi-VN', {day:'2-digit', month:'2-digit'});
                const idx = last7Days.indexOf(eDs);
                if (idx !== -1) {
                    if (type === 'PLASTIC') plasticData[idx]++;
                    else if (type === 'METAL') metalData[idx]++;
                    else if (type === 'GLASS') glassData[idx]++;
                }
            }
        });
        stats.totalCount = stats.plastic + stats.metal + stats.glass;
        
        updateDashboardUI(stats);
        
        // Update trend chart
        if (trendChart) {
            trendChart.data.labels = last7Days;
            trendChart.data.datasets[0].data = plasticData;
            trendChart.data.datasets[1].data = metalData;
            trendChart.data.datasets[2].data = glassData;
            trendChart.update();
        }
        
        // Fetch recent events from Supabase directly
        const eventsRes = await fetch(`${SUPABASE_URL}/rest/v1/events?select=*,bins(name)&order=created_at.desc&limit=5`, {
            headers: {
                'apikey': SUPABASE_KEY,
                'Authorization': `Bearer ${SUPABASE_KEY}`
            }
        });
        const events = await eventsRes.json();
        updateRecentEvents(events);
        
    } catch (error) {
        console.error('Error fetching dashboard data:', error);
    }
}

function updateRecentEvents(events) {
    const tbody = document.getElementById('recentEventsBody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    events.forEach(ev => {
        let iconHtml = '';
        let typeClass = '';
        let typeLabel = '';
        
        const type = ev.waste_type.toUpperCase();
        if (type === 'UNKNOWN') return; // Skip unknown events
        
        if (type === 'PLASTIC') {
            iconHtml = '<i class="fa-solid fa-bottle-water"></i>';
            typeClass = 'type-plastic';
            typeLabel = 'Nhựa';
        } else if (type === 'METAL') {
            iconHtml = '<i class="fa-solid fa-magnet"></i>';
            typeClass = 'type-metal';
            typeLabel = 'Kim loại';
        } else if (type === 'GLASS') {
            iconHtml = '<i class="fa-solid fa-wine-bottle"></i>';
            typeClass = 'type-glass';
            typeLabel = 'Thủy tinh';
        }
        
        // Parse date correctly
        const dateObj = new Date(ev.created_at);
        const timeStr = dateObj.toLocaleTimeString('vi-VN', {hour: '2-digit', minute:'2-digit', second:'2-digit'});
        const dateStr = dateObj.toLocaleDateString('vi-VN', {day: '2-digit', month: '2-digit', year: 'numeric'});
        
        // Get bin name if available
        const binName = ev.bins && ev.bins.name ? ev.bins.name : ev.bin_id;

        const html = `
            <div class="event-item">
                <div class="event-icon ${typeClass}">${iconHtml}</div>
                <div class="event-details">
                    <div class="event-title">${typeLabel} (${parseFloat(ev.confidence).toFixed(2)}%)</div>
                    <div class="event-time">${timeStr} ${dateStr} - ${binName}</div>
                </div>
                <div class="event-status success"><i class="fa-solid fa-check"></i></div>
            </div>
        `;
        tbody.insertAdjacentHTML('beforeend', html);
    });
}

async function fetchBinCapacities() {
    try {
        const binsRes = await fetch(`${SUPABASE_URL}/rest/v1/bins?select=*`, {
            headers: {
                'apikey': SUPABASE_KEY,
                'Authorization': `Bearer ${SUPABASE_KEY}`
            }
        });
        const bins = await binsRes.json();
        
        const container = document.getElementById('binCardsContainer');
        if (!container) return;
        
        container.innerHTML = '';
        
        bins.forEach(bin => {
            // parse date
            let timeStr = 'Chưa cập nhật';
            let isOnline = false;
            if (bin.last_updated) {
                const dateObj = new Date(bin.last_updated);
                timeStr = dateObj.toLocaleTimeString('vi-VN', {hour: '2-digit', minute:'2-digit', second:'2-digit'});
                // Check if online (updated within last 5 minutes)
                const diff = (new Date() - dateObj) / 1000 / 60;
                isOnline = diff < 5;
            }
            
            const statusHtml = isOnline 
                ? `<span class="badge badge-online">Đang hoạt động</span>`
                : `<span class="badge" style="background-color: #FEE2E2; color: #DC2626;">Mất kết nối</span>`;
                
            const plasticCap = bin.capacity_plastic || 0;
            const metalCap = bin.capacity_metal || 0;
            const glassCap = bin.capacity_glass || 0;
            
            const html = `
                <div class="card device-status-card">
                    <div class="device-info-wrapper">
                        <div class="device-icon" style="background-color: ${isOnline ? 'var(--primary)' : 'var(--text-secondary)'}">
                            <i class="fa-solid fa-dumpster"></i>
                        </div>
                        <div class="device-details">
                            <h2 class="device-name">${bin.name}</h2>
                            <div class="device-meta">
                                <span><i class="fa-solid fa-hashtag"></i> ${bin.id}</span>
                            </div>
                            <div class="device-meta" style="margin-top: 4px;">
                                <span><i class="fa-solid fa-location-dot"></i> ${bin.location || 'Chưa cập nhật'}</span>
                            </div>
                            <!-- Bin Capacities -->
                            <div class="device-meta" style="margin-top: 12px; display: block; width: 100%;">
                                <div style="font-size: 11px; color: var(--text-secondary); margin-bottom: 4px; display: flex; justify-content: space-between;">
                                    <span>Độ đầy thùng:</span>
                                </div>
                                <div style="display: flex; gap: 8px; width: 100%;">
                                    <div style="flex: 1; display: flex; flex-direction: column; justify-content: flex-end; gap: 4px;" title="Nhựa">
                                        <div style="display: flex; justify-content: space-between; gap: 4px; width: 100%; font-size: 10px; color: #3B82F6; white-space: nowrap;">
                                            <span>Nhựa</span> <span>${plasticCap}%</span>
                                        </div>
                                        <div style="height: 6px; background: #E2E8F0; border-radius: 3px; overflow: hidden; width: 100%;">
                                            <div style="width: ${plasticCap}%; height: 100%; background: #3B82F6; transition: width 0.5s;"></div>
                                        </div>
                                    </div>
                                    <div style="flex: 1; display: flex; flex-direction: column; justify-content: flex-end; gap: 4px;" title="Kim loại">
                                        <div style="display: flex; justify-content: space-between; gap: 4px; width: 100%; font-size: 10px; color: #64748B; white-space: nowrap;">
                                            <span>Kim loại</span> <span>${metalCap}%</span>
                                        </div>
                                        <div style="height: 6px; background: #E2E8F0; border-radius: 3px; overflow: hidden; width: 100%;">
                                            <div style="width: ${metalCap}%; height: 100%; background: #64748B; transition: width 0.5s;"></div>
                                        </div>
                                    </div>
                                    <div style="flex: 1; display: flex; flex-direction: column; justify-content: flex-end; gap: 4px;" title="Thủy tinh">
                                        <div style="display: flex; justify-content: space-between; gap: 4px; width: 100%; font-size: 10px; color: #0EA5E9; white-space: nowrap;">
                                            <span>Thủy tinh</span> <span>${glassCap}%</span>
                                        </div>
                                        <div style="height: 6px; background: #E2E8F0; border-radius: 3px; overflow: hidden; width: 100%;">
                                            <div style="width: ${glassCap}%; height: 100%; background: #0EA5E9; transition: width 0.5s;"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="device-status-indicator">
                        ${statusHtml}
                        <div class="last-updated">
                            Cập nhật lúc: <span>${timeStr}</span>
                        </div>
                    </div>
                </div>
            `;
            container.insertAdjacentHTML('beforeend', html);
        });
        
    } catch (e) {
        console.error("Error fetching bins:", e);
    }
}

function updateDashboardUI(data) {
    // Update summary stats
    const totalEl = document.getElementById('statTotal');
    if(totalEl) totalEl.textContent = data.totalCount;
    const plasticEl = document.getElementById('statPlastic');
    if(plasticEl) plasticEl.textContent = data.plastic;
    const metalEl = document.getElementById('statMetal');
    if(metalEl) metalEl.textContent = data.metal;
    const glassEl = document.getElementById('statGlass');
    if(glassEl) glassEl.textContent = data.glass;
    
    // Update time displays
    const timeEls = document.querySelectorAll('.lastUpdatedTime');
    const now = new Date();
    const timeStr = now.toLocaleTimeString('vi-VN', { hour12: false });
    timeEls.forEach(el => el.textContent = timeStr);
}

// Thêm thùng rác mới (UI mock)
function openAddBinModal() {
    const modal = document.getElementById('addBinModal');
    if (modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
}

function closeAddBinModal() {
    const modal = document.getElementById('addBinModal');
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = '';
    }
}

function submitAddBin() {
    const id = document.getElementById('binId').value;
    const name = document.getElementById('binName').value;
    const loc = document.getElementById('binLocation').value;
    
    if (!id || !name) {
        alert('Vui lòng nhập ID và Tên hiển thị!');
        return;
    }
    
    const cardHtml = `
        <div class="card device-status-card">
            <div class="device-info-wrapper">
                <div class="device-icon">
                    <i class="fa-solid fa-dumpster"></i>
                </div>
                <div class="device-details">
                    <h2 class="device-name">${name}</h2>
                    <div class="device-meta">
                        <span><i class="fa-solid fa-hashtag"></i> ${id}</span>
                    </div>
                    <div class="device-meta" style="margin-top: 4px;">
                        <span><i class="fa-solid fa-location-dot"></i> ${loc || 'Chưa cập nhật'}</span>
                    </div>
                </div>
            </div>
            <div class="device-status-indicator">
                <span class="badge badge-online">Đang hoạt động</span>
                <div class="last-updated">
                    Cập nhật lúc: <span class="lastUpdatedTime">Vừa xong</span>
                </div>
            </div>
        </div>
    `;
    
    const container = document.getElementById('binCardsContainer');
    if (container) {
        container.insertAdjacentHTML('beforeend', cardHtml);
    }
    
    document.getElementById('addBinForm').reset();
    closeAddBinModal();
}

function initCharts() {
    // Colors based on CSS tokens
    const colors = {
        plastic: '#2563EB',
        metal: '#64748B',
        glass: '#0891B2'
    };

    // 1. Weekly Trend Chart (Bar/Line)
    const ctxTrend = document.getElementById('weeklyTrendChart');
    if (ctxTrend) {
        trendChart = new Chart(ctxTrend, {
            type: 'bar',
            data: {
                labels: [], // Populated dynamically
                datasets: [
                    {
                        label: 'Nhựa',
                        data: [],
                        backgroundColor: colors.plastic,
                        borderRadius: 4
                    },
                    {
                        label: 'Kim loại',
                        data: [],
                        backgroundColor: colors.metal,
                        borderRadius: 4
                    },
                    {
                        label: 'Thủy tinh',
                        data: [],
                        backgroundColor: colors.glass,
                        borderRadius: 4
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: { stacked: true, grid: { display: false } },
                    y: { stacked: true, beginAtZero: true, border: { dash: [4, 4] } }
                },
                plugins: {
                    legend: {
                        position: 'top',
                        labels: { usePointStyle: true, font: { family: 'Inter' } }
                    }
                }
            }
        });
    }
}
