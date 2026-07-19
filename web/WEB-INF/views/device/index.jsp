<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<% 
    request.setAttribute("pageTitle", "Chi tiết thiết bị"); 
    request.setAttribute("activeMenu", "device");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Smart Waste Bin IoT</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
</head>
<body>
    <div class="app-container">
        <%@ include file="/WEB-INF/fragments/sidebar.jspf" %>
        
        <main class="app-main">
            <%@ include file="/WEB-INF/fragments/header.jspf" %>
            
            <div class="page-content">
                <div class="grid grid-cols-2 mb-6" style="margin-bottom: 24px;">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Thông tin chung</h3>
                        </div>
                        <div class="detail-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                            <div class="detail-item" style="background: var(--background); padding: 12px; border-radius: 8px;">
                                <div class="detail-label" style="font-size: 12px; color: var(--text-secondary);">Tên thiết bị</div>
                                <div class="detail-value" style="font-weight: 500;">Thùng Rác Thông Minh Tầng 1</div>
                            </div>
                            <div class="detail-item" style="background: var(--background); padding: 12px; border-radius: 8px;">
                                <div class="detail-label" style="font-size: 12px; color: var(--text-secondary);">Mã thiết bị (Device Code)</div>
                                <div class="detail-value font-mono" style="font-family: monospace; font-weight: 500;">SMART_BIN_001</div>
                            </div>
                            <div class="detail-item" style="background: var(--background); padding: 12px; border-radius: 8px;">
                                <div class="detail-label" style="font-size: 12px; color: var(--text-secondary);">Trạng thái</div>
                                <div class="detail-value"><span class="badge badge-online">ONLINE</span></div>
                            </div>
                            <div class="detail-item" style="background: var(--background); padding: 12px; border-radius: 8px;">
                                <div class="detail-label" style="font-size: 12px; color: var(--text-secondary);">Vị trí</div>
                                <div class="detail-value" style="font-weight: 500;">Hành lang A, Tòa nhà C</div>
                            </div>
                            <div class="detail-item" style="background: var(--background); padding: 12px; border-radius: 8px;">
                                <div class="detail-label" style="font-size: 12px; color: var(--text-secondary);">Lần cuối hoạt động</div>
                                <div class="detail-value" style="font-weight: 500;">11/07/2026 20:35:12</div>
                            </div>
                            <div class="detail-item" style="background: var(--background); padding: 12px; border-radius: 8px;">
                                <div class="detail-label" style="font-size: 12px; color: var(--text-secondary);">Phiên bản Firmware</div>
                                <div class="detail-value font-mono" style="font-family: monospace; font-weight: 500;">v1.0.0</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Tình trạng hệ thống (Heartbeat)</h3>
                        </div>
                        <div class="detail-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                            <div class="detail-item" style="background: var(--background); padding: 12px; border-radius: 8px;">
                                <div class="detail-label" style="font-size: 12px; color: var(--text-secondary);">Tín hiệu Wi-Fi (RSSI)</div>
                                <div class="detail-value text-success" style="color: var(--success); font-weight: 500;">-57 dBm (Tốt)</div>
                            </div>
                            <div class="detail-item" style="background: var(--background); padding: 12px; border-radius: 8px;">
                                <div class="detail-label" style="font-size: 12px; color: var(--text-secondary);">Thời gian hoạt động (Uptime)</div>
                                <div class="detail-value" style="font-weight: 500;">8 giờ 45 phút</div>
                            </div>
                            <div class="detail-item" style="background: var(--background); padding: 12px; border-radius: 8px;">
                                <div class="detail-label" style="font-size: 12px; color: var(--text-secondary);">Bộ nhớ khả dụng (Free Heap)</div>
                                <div class="detail-value font-mono" style="font-family: monospace; font-weight: 500;">184.3 KB</div>
                            </div>
                            <div class="detail-item" style="background: var(--background); padding: 12px; border-radius: 8px;">
                                <div class="detail-label" style="font-size: 12px; color: var(--text-secondary);">Tổng số sự kiện xử lý</div>
                                <div class="detail-value" style="font-weight: 500;">148</div>
                            </div>
                        </div>
                        
                        <div style="margin-top: 16px; padding: 16px; background-color: #F8FAFC; border-radius: 8px;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                                <span style="font-size: 13px; font-weight: 500;">Dung lượng lưu trữ cục bộ</span>
                                <span style="font-size: 13px; font-weight: 600;">12%</span>
                            </div>
                            <div style="width: 100%; height: 8px; background-color: var(--border); border-radius: 4px; overflow: hidden;">
                                <div style="width: 12%; height: 100%; background-color: var(--primary);"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
