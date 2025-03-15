<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="service.BookmarkService" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>북마크 수정 처리</title>
</head>
<body>

<%
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String orders = request.getParameter("orders");

    // 값이 없을 경우 에러 처리
    if (name == null || orders == null) {
        out.println("<script>alert('입력 값이 부족합니다.'); window.history.back();</script>");
        return;
    }

    try {
        BookmarkService bookmarkService = new BookmarkService();
        boolean isSuccess = bookmarkService.updateBookmark(id, name, orders);

        if (isSuccess) {
            out.println("<script>alert('북마크가 수정되었습니다.'); window.location.href='bookmark.jsp';</script>");
        } else {
            out.println("<script>alert('북마크 수정에 실패했습니다.'); window.history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('서버 오류가 발생했습니다.'); window.history.back();</script>");
    }
%>

</body>
</html>