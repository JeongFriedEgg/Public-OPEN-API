<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="service.BookmarkService" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("name");
    String order = request.getParameter("order");

    // 값이 없을 경우 에러 처리
    if (name == null || order == null) {
        out.println("입력 값이 부족합니다.");
        return;
    }

    try {
        BookmarkService bookmarkService = new BookmarkService();
        boolean isSuccess = bookmarkService.addBookmark(name, Integer.parseInt(order));

        if (isSuccess) {
            out.println("<script>alert('북마크가 추가되었습니다.'); window.location.href='bookmark.jsp';</script>");
        } else {
            out.println("<script>alert('북마크 추가에 실패했습니다.'); window.history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('서버 오류가 발생했습니다.'); window.history.back();</script>");
    }
%>