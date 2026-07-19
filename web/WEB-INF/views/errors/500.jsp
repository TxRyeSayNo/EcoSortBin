<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi hệ thống - EcoSortBin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
</head>
<body style="display: flex; align-items: center; justify-content: center; min-height: 100vh; background-color: var(--background);">
    <div class="empty-state" style="background: white; border-radius: var(--radius-lg); box-shadow: var(--shadow-md); padding: 60px; max-width: 500px; text-align: center;">
        <div class="empty-icon" style="color: var(--error); font-size: 64px; margin-bottom: 24px;">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>
        <h1 style="font-size: 24px; color: var(--text-primary); margin-bottom: 16px;">500 - Lỗi máy chủ</h1>
        <p style="margin-bottom: 32px; color: var(--text-secondary);">Đã xảy ra lỗi không mong muốn trên hệ thống. Vui lòng thử lại sau.</p>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary" style="display: inline-flex;">
            <i class="fa-solid fa-rotate-right"></i> Thử lại
        </a>
    </div>
</body>
</html>
