<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="service.WifiInfoService" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>와이파이 정보 구하기</title>
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

<h2>서울시 공공 와이파이 정보 조회</h2>
<a href="index.jsp"><button>홈</button></a>
<a href="bookmark.jsp"><button>북마크 페이지</button></a>
<a href="history.jsp"><button>히스토리 페이지</button></a>

<div id="input-section">
    <form method="get" action="index.jsp">
        위도(lat): <input type="text" name="lat" placeholder="위도" value="<%= request.getParameter("lat") == null ? "" : request.getParameter("lat") %>">
        경도(lon): <input type="text" name="lon" placeholder="경도" value="<%= request.getParameter("lon") == null ? "" : request.getParameter("lon") %>">
        <button type="button" onclick="getCurrentLocation()">내 위치 가져오기</button>
        <button type="submit">데이터 조회</button>
    </form>
</div>

<table>
    <thead>
        <tr>
            <th>거리(KM)</th>
            <th>관리번호</th>
            <th>자치구</th>
            <th>와이파이명</th>
            <th>도로명주소</th>
            <th>상세주소</th>
            <th>설치위치</th>
            <th>설치유형</th>
            <th>설치기관</th>
            <th>서비스구분</th>
            <th>설치년도</th>
            <th>실내외구분</th>
            <th>wifi접속환경</th>
            <th>X좌표</th>
            <th>Y좌표</th>
            <th>작업일자</th>
        </tr>
    </thead>
    <tbody>
        <%
            String latParam = request.getParameter("lat");
            String lonParam = request.getParameter("lon");

            if (latParam != null && lonParam != null && !latParam.isEmpty() && !lonParam.isEmpty()) {
                double userLat = Double.parseDouble(latParam);
                double userLon = Double.parseDouble(lonParam);

                WifiInfoService wifiInfoService = new WifiInfoService();
                List<Map<String, String>> wifiList = wifiInfoService.getWifiInfo(userLat, userLon);

                if (wifiList != null && !wifiList.isEmpty()) {
                    for (Map<String, String> wifi : wifiList) {
        %>
        <tr>
            <td><%= wifi.get("distance") %></td>
            <td><%= wifi.get("X_SWIFI_MGR_NO") %></td>
            <td><%= wifi.get("X_SWIFI_WRDOFC") %></td>
            <td><a href="wifiDetail.jsp?mgrNo=<%= wifi.get("X_SWIFI_MGR_NO") %>&lat=<%= wifi.get("LAT") %>&lon=<%= wifi.get("LNT") %>&distance=<%= wifi.get("distance") %>&address1=<%= wifi.get("X_SWIFI_ADRES1") %>&address2=<%= wifi.get("X_SWIFI_ADRES2") %>&floor=<%= wifi.get("X_SWIFI_INSTL_FLOOR") %>&instlType=<%= wifi.get("X_SWIFI_INSTL_TY") %>&instlMby=<%= wifi.get("X_SWIFI_INSTL_MBY") %>&svcSe=<%= wifi.get("X_SWIFI_SVC_SE") %>&cnstcYear=<%= wifi.get("X_SWIFI_CNSTC_YEAR") %>&inOutDoor=<%= wifi.get("X_SWIFI_INOUT_DOOR") %>&remars3=<%= wifi.get("X_SWIFI_REMARS3") %>&workDttm=<%= wifi.get("WORK_DTTM") %>">
                                    <%= wifi.get("X_SWIFI_MAIN_NM") %>
                                </a>
            </td>
            <td><%= wifi.get("X_SWIFI_ADRES1") %></td>
            <td><%= wifi.get("X_SWIFI_ADRES2") %></td>
            <td><%= wifi.get("X_SWIFI_INSTL_FLOOR") %></td>
            <td><%= wifi.get("X_SWIFI_INSTL_TY") %></td>
            <td><%= wifi.get("X_SWIFI_INSTL_MBY") %></td>
            <td><%= wifi.get("X_SWIFI_SVC_SE") %></td>
            <td><%= wifi.get("X_SWIFI_CNSTC_YEAR") %></td>
            <td><%= wifi.get("X_SWIFI_INOUT_DOOR") %></td>
            <td><%= wifi.get("X_SWIFI_REMARS3") %></td>
            <td><%= wifi.get("LAT") %></td>
            <td><%= wifi.get("LNT") %></td>
            <td><%= wifi.get("WORK_DTTM") %></td>
        </tr>
        <%
                    }
                } else {
                    out.println("<tr><td colspan='16'>와이파이 정보를 가져오는 데 실패했습니다.</td></tr>");
                }
            } else {
                out.println("<tr><td colspan='16'>위도(lat)와 경도(lon)를 입력 후 조회 버튼을 눌러주세요.</td></tr>");
            }
        %>
    </tbody>
</table>

<script>
    function getCurrentLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function(position) {
                    const lat = position.coords.latitude;
                    const lon = position.coords.longitude;

                    document.querySelector('input[name="lat"]').value = lat.toFixed(6);
                    document.querySelector('input[name="lon"]').value = lon.toFixed(6);
                },
                function(error) {
                    alert("위치 정보를 가져오는 데 실패했습니다. 브라우저 권한을 확인하세요.");
                }
            );
        } else {
            alert("이 브라우저에서는 위치 정보를 지원하지 않습니다.");
        }
    }
</script>

</body>
</html>