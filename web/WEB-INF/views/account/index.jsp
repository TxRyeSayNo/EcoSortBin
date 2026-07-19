<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<% 
    request.setAttribute("pageTitle", "Tài khoản của tôi"); 
    request.setAttribute("activeMenu", "account");
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
            
            <div class="page-content" style="max-width: 600px; margin: 0 auto;">
                <div class="card mb-6" style="margin-bottom: 24px;">
                    <div class="card-header">
                        <h3 class="card-title">Thông tin cá nhân</h3>
                    </div>
                    <form action="#" method="POST">
                        <div class="form-group">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" value="Quản trị viên" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" value="admin@ecosortbin.vn" disabled>
                            <small style="color: var(--text-secondary); display: block; margin-top: 4px; font-size: 12px;">Không thể thay đổi email đã đăng ký.</small>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Vai trò</label>
                            <input type="text" class="form-control" value="ADMIN" disabled>
                        </div>
                        <button type="submit" class="btn btn-primary" style="margin-top: 8px;">Cập nhật thông tin</button>
                    </form>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Đổi mật khẩu</h3>
                    </div>
                    <form action="#" method="POST">
                        <div class="form-group">
                            <label class="form-label">Mật khẩu hiện tại</label>
                            <input type="password" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Mật khẩu mới</label>
                            <input type="password" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Xác nhận mật khẩu mới</label>
                            <input type="password" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-outline" style="margin-top: 8px;">Đổi mật khẩu</button>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
