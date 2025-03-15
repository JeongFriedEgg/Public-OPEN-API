<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
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
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
        }
        button:hover {
            background-color: #0056b3;
        }

    </style>
</head>
<body>

<h2>와이파이 상세 정보</h2>

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