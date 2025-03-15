<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="service.BookmarkService" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>북마크 목록</title>
    <style>
        body { font-family: Arial, sans-serif; }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            text-align: center;
            padding: 8px;
        }
        th {
            background-color: #f4f4f4;
        }
        button {
            padding: 8px 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<h2>북마크 목록</h2>
<a href="index.jsp"><button>홈</button></a>
<a href="addBookmark.jsp" ><button>북마크 추가</button></a>
<table>
    <thead>
        <tr>
            <th>아이디</th>
            <th>북마크 이름</th>
            <th>순서</th>
            <th>등록일자</th>
            <th>수정일자</th>
            <th>비고</th>
        </tr>
    </thead>
    <tbody>
        <%
            // 북마크 목록을 가져오는 로직
            BookmarkService bookmarkService = new BookmarkService();
            List<Map<String, String>> bookmarkList = bookmarkService.getBookmarks();

            if (bookmarkList != null && !bookmarkList.isEmpty()) {
                for (Map<String, String> bookmark : bookmarkList) {
        %>
        <tr>
            <td><%= bookmark.get("id") %></td>
            <td><%= bookmark.get("name") %></td>
            <td><%= bookmark.get("orders") %></td>
            <td><%= bookmark.get("created_date") %></td>
            <td><%= bookmark.get("updated_date") %></td>
            <td>
                <a href="editBookmark.jsp?id=<%= bookmark.get("id") %>"><button>수정</button></a>
                <form method="post" action="deleteBookmark.jsp" style="display:inline;">
                    <input type="hidden" name="id" value="<%= bookmark.get("id") %>">
                    <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                </form>
            </td>
        </tr>
        <%
                }
            } else {
                out.println("<tr><td colspan='6'>등록된 북마크가 없습니다.</td></tr>");
            }
        %>
    </tbody>
</table>

</body>
</html>