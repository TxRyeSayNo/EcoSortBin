<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Smart Waste Bin IoT</title>
    <!-- Fonts and Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/login.css">
</head>
<body>
    <div class="login-container">
        <div class="login-card card">
            <div class="login-header">
                <div class="login-logo">
                    <i class="fa-solid fa-recycle"></i>
                </div>
                <h2>EcoSortBin Dashboard</h2>
                <p>Hệ thống giám sát phân loại rác thông minh</p>
            </div>
            
            <!-- Trong giai đoạn tĩnh, form GET đến trang dashboard để mô phỏng -->
            <form action="${pageContext.request.contextPath}/dashboard" method="GET" class="login-form">
                <div class="form-group">
                    <label class="form-label" for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="admin@ecosortbin.vn" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="password">Mật khẩu</label>
                    <div class="password-input">
                        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <i class="fa-regular fa-eye" id="toggleIcon"></i>
                        </button>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary login-btn">
                    Đăng nhập <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>
        </div>
    </div>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('toggleIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>
