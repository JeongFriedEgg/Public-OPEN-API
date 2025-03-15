<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="service.BookmarkService" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>와이파이 상세 정보</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }

        table {
            width: 50%;
            border-collapse: collapse;
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

        #input-section {
            margin-bottom: 20px;
        }
        input[type="text"] {
            padding: 8px;
            width: 120px;
            margin-right: 10px;
        }
        button {
            padding: 8px 16px;
            cursor: pointer;
        }

    </style>
</head>
<body>

<h2>와이파이 상세 정보</h2>

<div id="bookmark-section">
    <h3>북마크 목록</h3>
    <form method="post" action="addHistory.jsp">
        <label for="bookmark">북마크 선택:</label>
        <select name="bookmark" id="bookmark">
            <option value="">-- 선택하세요 --</option>
            <%
                BookmarkService bookmarkService = new BookmarkService();
                List<Map<String, String>> bookmarks = bookmarkService.getBookmarks();

                if (bookmarks != null && !bookmarks.isEmpty()) {
                    for (Map<String, String> bookmark : bookmarks) {
                        String id = bookmark.get("id");
                        String name = bookmark.get("name");
            %>
                        <option value="<%= id %>"><%= name %></option>
            <%
                    }
                } else {
                    out.println("<option value=''>저장된 북마크가 없습니다.</option>");
                }
            %>
        </select>
        <input type="hidden" name="mgrNo" value="<%= request.getParameter("mgrNo") %>" />
        <button type="submit">북마크 추가하기</button>
    </form>

    <%
        String selectedBookmark = request.getParameter("bookmark");
        if (selectedBookmark != null && !selectedBookmark.isEmpty()) {
            BookmarkService service = new BookmarkService();
            Map<String, String> bookmark = service.getBookmarkById(selectedBookmark);
            if (bookmark != null) {
    %>
                <p><strong>선택된 북마크:</strong> <%= bookmark.get("name") %></p>
    <%
            } else {
                out.println("<p>선택된 북마크를 찾을 수 없습니다.</p>");
            }
        }
    %>
</div>

<div class="detail-container">
    <table>
        <tr>
            <th>관리번호</th>
            <td><%= request.getParameter("mgrNo") %></td>
        </tr>
        <tr>
            <th>위도</th>
            <td><%= request.getParameter("lat") %></td>
        </tr>
        <tr>
            <th>경도</th>
            <td><%= request.getParameter("lon") %></td>
        </tr>
        <tr>
            <th>거리(KM)</th>
            <td><%= request.getParameter("distance") %></td>
        </tr>
        <tr>
            <th>도로명주소</th>
            <td><%= request.getParameter("address1") %> <%= request.getParameter("address2") %></td>
        </tr>
        <tr>
            <th>설치위치</th>
            <td><%= request.getParameter("floor") %></td>
        </tr>
        <tr>
            <th>설치유형</th>
            <td><%= request.getParameter("instlType") %></td>
        </tr>
        <tr>
            <th>설치기관</th>
            <td><%= request.getParameter("instlMby") %></td>
        </tr>
        <tr>
            <th>서비스구분</th>
            <td><%= request.getParameter("svcSe") %></td>
        </tr>
        <tr>
            <th>설치년도</th>
            <td><%= request.getParameter("cnstcYear") %></td>
        </tr>
        <tr>
            <th>실내외구분</th>
            <td><%= request.getParameter("inOutDoor") %></td>
        </tr>
        <tr>
            <th>wifi접속환경</th>
            <td><%= request.getParameter("remars3") %></td>
        </tr>
        <tr>
            <th>X좌표</th>
            <td><%= request.getParameter("lat") %></td>
        </tr>
        <tr>
            <th>Y좌표</th>
            <td><%= request.getParameter("lon") %></td>
        </tr>
        <tr>
            <th>작업일자</th>
            <td><%= request.getParameter("workDttm") %></td>
        </tr>
    </table>

</div>

</body>
</html>