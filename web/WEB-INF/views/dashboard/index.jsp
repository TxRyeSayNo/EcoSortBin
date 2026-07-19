<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<% 
    request.setAttribute("pageTitle", "Tổng quan hệ thống"); 
    request.setAttribute("activeMenu", "dashboard");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Smart Waste Bin IoT</title>
    <!-- Fonts and Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/dashboard.css">
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/fragments/sidebar.jspf" %>
        
        <main class="app-main">
            <!-- Header -->
            <%@ include file="/WEB-INF/fragments/header.jspf" %>
            
            <div class="page-content">
                <!-- Bins List Header -->
                <div class="dashboard-header-actions mb-4" style="display: flex; justify-content: space-between; align-items: center;">
                    <h3 style="font-size: 18px; font-weight: 600; color: var(--text-primary);">Danh sách thùng rác</h3>
                    <button class="btn btn-primary btn-sm" onclick="openAddBinModal()">
                        <i class="fa-solid fa-plus"></i> Thêm thùng rác
                    </button>
                </div>

                <!-- Device Status Grid (2 per row) -->
                <div class="grid grid-cols-2 mb-6" id="binCardsContainer">
                    <!-- Bin cards will be dynamically inserted here -->
                </div>
                
                <!-- Stats Grid -->
                <div class="grid grid-cols-4 mb-6">
                    <div class="card stat-card">
                        <div class="stat-icon primary">
                            <i class="fa-solid fa-cubes-stacked"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-label">Tổng số rác</div>
                            <div class="stat-value" id="statTotal">148</div>
                        </div>
                    </div>
                    
                    <div class="card stat-card">
                        <div class="stat-icon plastic">
                            <i class="fa-solid fa-bottle-water"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-label">Nhựa</div>
                            <div class="stat-value" id="statPlastic">62</div>
                        </div>
                    </div>
                    
                    <div class="card stat-card">
                        <div class="stat-icon metal">
                            <i class="fa-solid fa-magnet"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-label">Kim loại</div>
                            <div class="stat-value" id="statMetal">47</div>
                        </div>
                    </div>
                    
                    <div class="card stat-card">
                        <div class="stat-icon glass">
                            <i class="fa-solid fa-wine-bottle"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-label">Thủy tinh</div>
                            <div class="stat-value" id="statGlass">39</div>
                        </div>
                    </div>
                </div>
                
                <!-- Charts Grid -->
                <div style="display: grid; grid-template-columns: 1fr;" class="mb-6">
                    
                    <div class="card chart-card">
                        <div class="card-header">
                            <h3 class="card-title">Số lượng 7 ngày qua</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="weeklyTrendChart"></canvas>
                        </div>
                    </div>
                </div>
                
                <!-- Lists Grid -->
                <div style="display: grid; grid-template-columns: 1fr;">
                    <div class="card list-card">
                        <div class="card-header">
                            <h3 class="card-title">Sự kiện gần nhất</h3>
                        </div>
                        <div class="recent-events-list" id="recentEventsBody">
                            <div class="event-item">
                                <div class="event-icon plastic"><i class="fa-solid fa-bottle-water"></i></div>
                                <div class="event-details">
                                    <div class="event-title">Nhựa <span class="text-secondary">(95.2%)</span></div>
                                    <div class="event-time">Vừa xong</div>
                                </div>
                                <div class="event-status text-success"><i class="fa-solid fa-check"></i></div>
                            </div>
                            <div class="event-item">
                                <div class="event-icon metal"><i class="fa-solid fa-magnet"></i></div>
                                <div class="event-details">
                                    <div class="event-title">Kim loại <span class="text-secondary">(88.4%)</span></div>
                                    <div class="event-time">2 phút trước</div>
                                </div>
                                <div class="event-status text-success"><i class="fa-solid fa-check"></i></div>
                            </div>
                            <div class="event-item">
                                <div class="event-icon unknown"><i class="fa-solid fa-circle-question"></i></div>
                                <div class="event-details">
                                    <div class="event-title">Không xác định <span class="text-secondary">(45.1%)</span></div>
                                    <div class="event-time">15 phút trước</div>
                                </div>
                                <div class="event-status text-warning"><i class="fa-solid fa-triangle-exclamation"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Add Bin Modal -->
    <div class="modal-backdrop" id="addBinModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background-color: rgba(15, 23, 42, 0.5); z-index: 100; align-items: center; justify-content: center;">
        <div class="modal-dialog" style="background-color: var(--surface); border-radius: var(--radius-lg); width: 100%; max-width: 500px; box-shadow: var(--shadow-md);">
            <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; padding: var(--space-5); border-bottom: 1px solid var(--border);">
                <h3 class="modal-title" style="font-size: 18px; font-weight: 600;">Thêm thùng rác mới</h3>
                <button class="modal-close" onclick="closeAddBinModal()" style="background: none; border: none; font-size: 20px; color: var(--text-secondary); cursor: pointer;">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            <div class="modal-body" style="padding: var(--space-5);">
                <form id="addBinForm">
                    <div class="form-group mb-4">
                        <label class="form-label" for="binId">ID Thùng rác (Device ID)</label>
                        <input type="text" id="binId" class="form-control" placeholder="VD: SMART_BIN_003" required>
                    </div>
                    <div class="form-group mb-4">
                        <label class="form-label" for="binName">Tên hiển thị</label>
                        <input type="text" id="binName" class="form-control" placeholder="VD: Thùng rác sảnh B" required>
                    </div>
                    <div class="form-group mb-4">
                        <label class="form-label" for="binLocation">Vị trí</label>
                        <input type="text" id="binLocation" class="form-control" placeholder="VD: Sảnh chính, Tòa B">
                    </div>
                </form>
            </div>
            <div class="modal-footer" style="padding: var(--space-4) var(--space-5); border-top: 1px solid var(--border); display: flex; justify-content: flex-end; gap: 12px;">
                <button class="btn btn-outline" onclick="closeAddBinModal()">Hủy</button>
                <button class="btn btn-primary" onclick="submitAddBin()">Thêm thùng rác</button>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>
