<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<% 
    request.setAttribute("pageTitle", "Thông báo hệ thống"); 
    request.setAttribute("activeMenu", "notifications");
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/notifications.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/fragments/sidebar.jspf" %>
        
        <main class="app-main">
            <!-- Header -->
            <%@ include file="/WEB-INF/fragments/header.jspf" %>
            
            <div class="page-content">
                <div class="card">
                    <div class="notifications-header">
                        <div class="tabs">
                            <button class="tab-btn active">Tất cả</button>
                            <button class="tab-btn">Chưa đọc <span class="tab-badge">3</span></button>
                            <button class="tab-btn">Cảnh báo</button>
                            <button class="tab-btn">Lỗi</button>
                        </div>
                        <div class="notifications-actions">
                            <button class="btn btn-outline btn-sm">
                                <i class="fa-solid fa-check-double"></i> Đánh dấu tất cả đã đọc
                            </button>
                        </div>
                    </div>
                    
                    <div class="notifications-list full-list">
                        <!-- Unread Items -->
                        <div class="notification-item unread">
                            <div class="notification-icon warning"><i class="fa-solid fa-triangle-exclamation"></i></div>
                            <div class="notification-content">
                                <div class="notification-title">Độ tin cậy thấp</div>
                                <div class="notification-desc">Hệ thống không thể nhận diện chính xác vật thể (Confidence: 45.1%). Loại rác được ghi nhận là Không xác định (UNKNOWN).</div>
                                <div class="notification-time">15 phút trước</div>
                            </div>
                            <div class="notification-actions">
                                <button class="btn btn-outline btn-sm" title="Đánh dấu đã đọc"><i class="fa-solid fa-check"></i></button>
                            </div>
                        </div>
                        
                        <div class="notification-item unread">
                            <div class="notification-icon info"><i class="fa-solid fa-wifi"></i></div>
                            <div class="notification-content">
                                <div class="notification-title">Thiết bị đã kết nối lại</div>
                                <div class="notification-desc">SMART_BIN_001 đã online trở lại. Tín hiệu mạng ổn định (-57 dBm).</div>
                                <div class="notification-time">2 giờ trước</div>
                            </div>
                            <div class="notification-actions">
                                <button class="btn btn-outline btn-sm" title="Đánh dấu đã đọc"><i class="fa-solid fa-check"></i></button>
                            </div>
                        </div>
                        
                        <div class="notification-item unread">
                            <div class="notification-icon error"><i class="fa-solid fa-plug-circle-xmark"></i></div>
                            <div class="notification-content">
                                <div class="notification-title">Mất kết nối thiết bị</div>
                                <div class="notification-desc">Không nhận được tín hiệu heartbeat từ SMART_BIN_001 trong hơn 60 giây. Thiết bị có thể đã mất điện hoặc lỗi mạng.</div>
                                <div class="notification-time">2 giờ trước</div>
                            </div>
                            <div class="notification-actions">
                                <button class="btn btn-outline btn-sm" title="Đánh dấu đã đọc"><i class="fa-solid fa-check"></i></button>
                            </div>
                        </div>

                        <!-- Read Items -->
                        <div class="notification-item">
                            <div class="notification-icon success"><i class="fa-solid fa-check-double"></i></div>
                            <div class="notification-content">
                                <div class="notification-title">Khởi động hệ thống</div>
                                <div class="notification-desc">Thùng rác SMART_BIN_001 khởi động thành công. Firmware version 1.0.0.</div>
                                <div class="notification-time">Hôm qua, 08:30</div>
                            </div>
                        </div>
                        
                        <div class="notification-item">
                            <div class="notification-icon warning"><i class="fa-solid fa-triangle-exclamation"></i></div>
                            <div class="notification-content">
                                <div class="notification-title">Độ tin cậy thấp</div>
                                <div class="notification-desc">Hệ thống không thể nhận diện chính xác vật thể (Confidence: 52.3%).</div>
                                <div class="notification-time">Hôm qua, 14:15</div>
                            </div>
                        </div>
                        
                        <div class="notification-item">
                            <div class="notification-icon error"><i class="fa-solid fa-gears"></i></div>
                            <div class="notification-content">
                                <div class="notification-title">Lỗi Servo</div>
                                <div class="notification-desc">Servo phân luồng phản hồi chậm. Sự kiện #102 không được phân luồng đúng vị trí.</div>
                                <div class="notification-time">10/07/2026 16:45</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Pagination -->
                    <div class="pagination-wrapper">
                        <div class="pagination-info">
                            Hiển thị 1-6 trong tổng số 24 thông báo
                        </div>
                        <div class="pagination-controls">
                            <button class="btn btn-outline btn-icon" disabled><i class="fa-solid fa-chevron-left"></i></button>
                            <span class="page-number">1 / 4</span>
                            <button class="btn btn-outline btn-icon"><i class="fa-solid fa-chevron-right"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/notifications.js"></script>
</body>
</html>
