<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<% 
    request.setAttribute("pageTitle", "Lịch sử phân loại"); 
    request.setAttribute("activeMenu", "history");
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/history.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/fragments/sidebar.jspf" %>
        
        <main class="app-main">
            <!-- Header -->
            <%@ include file="/WEB-INF/fragments/header.jspf" %>
            
            <div class="page-content">
                <div class="card mb-6">
                    <!-- Filter Bar -->
                    <div class="filter-bar">
                        <div class="filter-group">
                            <label class="form-label">Từ ngày</label>
                            <input type="date" class="form-control filter-input">
                        </div>
                        <div class="filter-group">
                            <label class="form-label">Đến ngày</label>
                            <input type="date" class="form-control filter-input">
                        </div>
                        <div class="filter-group">
                            <label class="form-label">Loại rác</label>
                            <select class="form-control filter-input">
                                <option value="">Tất cả</option>
                                <option value="PLASTIC">Nhựa</option>
                                <option value="METAL">Kim loại</option>
                                <option value="GLASS">Thủy tinh</option>
                                <option value="UNKNOWN">Không xác định</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="form-label">Kết quả</label>
                            <select class="form-control filter-input">
                                <option value="">Tất cả</option>
                                <option value="true">Thành công</option>
                                <option value="false">Thất bại</option>
                            </select>
                        </div>
                        <div class="filter-actions">
                            <button class="btn btn-outline" style="margin-top: 26px;">
                                <i class="fa-solid fa-rotate-right"></i> Đặt lại
                            </button>
                            <button class="btn btn-primary" style="margin-top: 26px;">
                                <i class="fa-solid fa-filter"></i> Lọc
                            </button>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <!-- Data Table -->
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Thời gian</th>
                                    <th>Loại rác</th>
                                    <th>Confidence</th>
                                    <th>Class. Time</th>
                                    <th>Sort Time</th>
                                    <th>Tổng TG</th>
                                    <th>Kết quả</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Sample Rows -->
                                <tr>
                                    <td>#125</td>
                                    <td>11/07/2026 20:35:12</td>
                                    <td><span class="waste-badge waste-plastic">Nhựa</span></td>
                                    <td>95.2%</td>
                                    <td>1.2s</td>
                                    <td>0.8s</td>
                                    <td>2.0s</td>
                                    <td><span class="text-success"><i class="fa-solid fa-check"></i></span></td>
                                    <td>
                                        <button class="btn btn-outline btn-sm" onclick="openDetailModal(125)">
                                            Chi tiết
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#124</td>
                                    <td>11/07/2026 20:30:45</td>
                                    <td><span class="waste-badge waste-metal">Kim loại</span></td>
                                    <td>88.4%</td>
                                    <td>1.5s</td>
                                    <td>0.9s</td>
                                    <td>2.4s</td>
                                    <td><span class="text-success"><i class="fa-solid fa-check"></i></span></td>
                                    <td>
                                        <button class="btn btn-outline btn-sm" onclick="openDetailModal(124)">
                                            Chi tiết
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#123</td>
                                    <td>11/07/2026 20:15:00</td>
                                    <td><span class="waste-badge waste-unknown">Unknown</span></td>
                                    <td>45.1%</td>
                                    <td>2.1s</td>
                                    <td>-</td>
                                    <td>2.1s</td>
                                    <td><span class="text-warning"><i class="fa-solid fa-triangle-exclamation"></i></span></td>
                                    <td>
                                        <button class="btn btn-outline btn-sm" onclick="openDetailModal(123)">
                                            Chi tiết
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#122</td>
                                    <td>11/07/2026 19:45:22</td>
                                    <td><span class="waste-badge waste-glass">Thủy tinh</span></td>
                                    <td>92.8%</td>
                                    <td>1.1s</td>
                                    <td>3.5s</td>
                                    <td>4.6s</td>
                                    <td><span class="text-error"><i class="fa-solid fa-xmark"></i></span></td>
                                    <td>
                                        <button class="btn btn-outline btn-sm" onclick="openDetailModal(122)">
                                            Chi tiết
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="pagination-wrapper">
                        <div class="pagination-info">
                            Hiển thị 1-20 trong tổng số 148 kết quả
                        </div>
                        <div class="pagination-controls">
                            <select class="form-control select-pagesize">
                                <option>10 / trang</option>
                                <option selected>20 / trang</option>
                                <option>50 / trang</option>
                            </select>
                            <button class="btn btn-outline btn-icon" disabled><i class="fa-solid fa-chevron-left"></i></button>
                            <span class="page-number">1 / 8</span>
                            <button class="btn btn-outline btn-icon"><i class="fa-solid fa-chevron-right"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Detail Modal Placeholder -->
    <%@ include file="detail.jsp" %>
    
    <script src="${pageContext.request.contextPath}/assets/js/history.js"></script>
</body>
</html>
