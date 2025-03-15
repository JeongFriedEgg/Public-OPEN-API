<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="service.BookmarkService" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>북마크 삭제 처리</title>
</head>
<body>

<%
    String id = request.getParameter("id");
    BookmarkService bookmarkService = new BookmarkService();
    boolean result = bookmarkService.deleteBookmark(id);

    if (result) {
        // 삭제 성공 시 alert 창과 함께 bookmark.jsp로 리다이렉트
        out.println("<script>alert('북마크가 삭제되었습니다.'); window.location.href='bookmark.jsp';</script>");
    } else {
        // 삭제 실패 시 alert 창과 함께 이전 페이지로 돌아감
        out.println("<script>alert('삭제에 실패하였습니다.'); window.history.back();</script>");
    }
%>

</body>
</html>