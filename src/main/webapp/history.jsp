<%@ page import="service.WifiInfoService" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>북마크 히스토리</title>
    <style>
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

<h2>북마크 히스토리</h2>
<a href="index.jsp"><button>홈</button></a>
<%
    WifiInfoService wifiInfoService = new WifiInfoService();
    List<Map<String, String>> historyList = wifiInfoService.getHistory();
    if (historyList != null && !historyList.isEmpty()) {
%>
    <table border="1">
        <tr>
            <th>히스토리 ID</th>
            <th>북마크 이름</th>
            <th>와이파이 이름</th>
            <th>등록일자</th>
        </tr>
        <%
        for (Map<String, String> history : historyList) {
        %>
        <tr>
            <td><%= history.get("history_id") %></td> <!-- 히스토리 ID 출력 -->
            <td><%= history.get("bookmark_name") %></td> <!-- 북마크 이름 출력 -->
            <td><%= history.get("wifi_name") %></td> <!-- 와이파이 이름 출력 -->
            <td><%= history.get("created_date") %></td> <!-- 등록일자 출력 -->
        </tr>
        <%
        }
        %>
    </table>
<%
    } else {
        out.println("<p>저장된 히스토리가 없습니다.</p>");
    }
%>

</body>
</html>