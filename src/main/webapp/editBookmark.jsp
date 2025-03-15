<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="service.BookmarkService" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>북마크 수정</title>
    <style>
        body { font-family: Arial, sans-serif; }
        input, button {
            padding: 8px 16px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<h2>북마크 수정</h2>

<%
    String id = request.getParameter("id");
    BookmarkService bookmarkService = new BookmarkService();
    Map<String, String> bookmark = bookmarkService.getBookmarkById(id);

    if (bookmark != null) {
%>
    <form method="post" action="updateBookmark.jsp">
        <input type="hidden" name="id" value="<%= bookmark.get("id") %>">
        <label for="name">북마크 이름:</label>
        <input type="text" id="name" name="name" value="<%= bookmark.get("name") %>" required><br>
        <label for="orders">순서:</label>
        <input type="text" id="orders" name="orders" value="<%= bookmark.get("orders") %>" required><br>
        <button type="submit">수정 완료</button>
    </form>
<%
    } else {
        out.println("<p>북마크 정보를 찾을 수 없습니다.</p>");
    }
%>

</body>
</html>