<%@ page import="service.WifiInfoService" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.IOException" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>

<%
    request.setCharacterEncoding("UTF-8");
    String selectedBookmark = request.getParameter("bookmark");
    String wifiId = request.getParameter("mgrNo");

    if (selectedBookmark != null && !selectedBookmark.isEmpty() && wifiId != null && !wifiId.isEmpty()) {
        WifiInfoService wifiInfoService = new WifiInfoService();
        boolean added = wifiInfoService.addBookmarkHistory(selectedBookmark, wifiId);

        if (added) {
            response.sendRedirect("history.jsp");  // Redirect to the history page
        } else {
            out.println("<p>북마크 추가에 실패했습니다.</p>");
        }
    } else {
        out.println("<p>필수 정보를 모두 입력해 주세요.</p>");
    }
%>