<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    // Xử lý logic forward để xem trước giao diện (Preview Mode)
    String pageName = request.getParameter("page");
    
    // Nếu không có tham số page, mặc định hiển thị trang dashboard
    if (pageName == null || pageName.isEmpty()) {
        pageName = "dashboard";
    }
    
    String jspPath = "";
    switch (pageName) {
        case "login": jspPath = "/WEB-INF/views/auth/login.jsp"; break;
        case "dashboard": jspPath = "/WEB-INF/views/dashboard/index.jsp"; break;
        case "history": jspPath = "/WEB-INF/views/history/index.jsp"; break;
        case "notifications": jspPath = "/WEB-INF/views/notifications/index.jsp"; break;
        case "device": jspPath = "/WEB-INF/views/device/index.jsp"; break;
        case "account": jspPath = "/WEB-INF/views/account/index.jsp"; break;
        case "404": jspPath = "/WEB-INF/views/errors/404.jsp"; break;
        case "500": jspPath = "/WEB-INF/views/errors/500.jsp"; break;
        default: jspPath = "/WEB-INF/views/errors/404.jsp";
    }
    request.getRequestDispatcher(jspPath).forward(request, response);
%>
