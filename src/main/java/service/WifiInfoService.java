package service;

import org.w3c.dom.*;
import org.xml.sax.SAXException;

import javax.xml.parsers.*;
import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

public class WifiInfoService {

    private String dbUrl;
    private String apiKey;

    public WifiInfoService() throws IOException {
        Properties properties = new Properties();
        loadProperties(properties);
        dbUrl = properties.getProperty("db.url");
        apiKey = properties.getProperty("api.key");
    }

    private void loadProperties(Properties properties) throws IOException {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                throw new FileNotFoundException("config.properties not found in classpath");
            }
            properties.load(input);
        }
    }

    public List<Map<String, String>> getWifiInfo(double userLat, double userLon) throws IOException, ParserConfigurationException, SAXException, SQLException, ClassNotFoundException {
        List<Map<String, String>> wifiList = fetchWifiData(userLat, userLon);
        storeWifiData(wifiList);
        sortWifiData(wifiList);
        return wifiList;
    }

    private List<Map<String, String>> fetchWifiData(double userLat, double userLon) throws IOException, ParserConfigurationException, SAXException {
        String apiUrl = "http://openapi.seoul.go.kr:8088/" + apiKey + "/xml/TbPublicWifiInfo/1/20/";

        String xmlData = makeApiRequest(apiUrl);
        return parseXmlData(xmlData, userLat, userLon);
    }

    private String makeApiRequest(String apiUrl) throws IOException {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();
        return sb.toString();
    }

    private List<Map<String, String>> parseXmlData(String xmlData, double userLat, double userLon) throws ParserConfigurationException, SAXException, IOException {
        List<Map<String, String>> wifiList = new ArrayList<>();
        Document doc = parseXmlString(xmlData);

        NodeList rows = doc.getElementsByTagName("row");
        for (int i = 0; i < rows.getLength(); i++) {
            Element row = (Element) rows.item(i);
            wifiList.add(parseWifiInfo(row, userLat, userLon));
        }
        return wifiList;
    }

    private Document parseXmlString(String xmlData) throws ParserConfigurationException, SAXException, IOException {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        InputStream is = new ByteArrayInputStream(xmlData.getBytes("UTF-8"));
        return builder.parse(is);
    }

    private Map<String, String> parseWifiInfo(Element row, double userLat, double userLon) {
        String lat = getTagValue(row, "LAT");
        String lon = getTagValue(row, "LNT");

        double distance = distance(userLat, userLon, Double.parseDouble(lat), Double.parseDouble(lon));

        Map<String, String> wifiInfo = new HashMap<>();
        wifiInfo.put("distance", String.format("%.4f", distance));
        wifiInfo.put("X_SWIFI_MGR_NO", getTagValue(row, "X_SWIFI_MGR_NO"));
        wifiInfo.put("X_SWIFI_WRDOFC", getTagValue(row, "X_SWIFI_WRDOFC"));
        wifiInfo.put("X_SWIFI_MAIN_NM", getTagValue(row, "X_SWIFI_MAIN_NM"));
        wifiInfo.put("X_SWIFI_ADRES1", getTagValue(row, "X_SWIFI_ADRES1"));
        wifiInfo.put("X_SWIFI_ADRES2", getTagValue(row, "X_SWIFI_ADRES2"));
        wifiInfo.put("X_SWIFI_INSTL_FLOOR", getTagValue(row, "X_SWIFI_INSTL_FLOOR"));
        wifiInfo.put("X_SWIFI_INSTL_TY", getTagValue(row, "X_SWIFI_INSTL_TY"));
        wifiInfo.put("X_SWIFI_INSTL_MBY", getTagValue(row, "X_SWIFI_INSTL_MBY"));
        wifiInfo.put("X_SWIFI_SVC_SE", getTagValue(row, "X_SWIFI_SVC_SE"));
        wifiInfo.put("X_SWIFI_CNSTC_YEAR", getTagValue(row, "X_SWIFI_CNSTC_YEAR"));
        wifiInfo.put("X_SWIFI_INOUT_DOOR", getTagValue(row, "X_SWIFI_INOUT_DOOR"));
        wifiInfo.put("X_SWIFI_REMARS3", getTagValue(row, "X_SWIFI_REMARS3"));
        wifiInfo.put("LAT", lat);
        wifiInfo.put("LNT", lon);
        wifiInfo.put("WORK_DTTM", getTagValue(row, "WORK_DTTM"));
        return wifiInfo;
    }

    private void storeWifiData(List<Map<String, String>> wifiList) throws SQLException, ClassNotFoundException {
        Connection sqliteConnection = getSQLiteConnection();
        for (Map<String, String> wifiInfo : wifiList) {
            insertWifiInfo(sqliteConnection, wifiInfo);
        }
        sqliteConnection.close();
    }

    private void insertWifiInfo(Connection conn, Map<String, String> wifiInfo) throws SQLException {
        String sql = "INSERT INTO wifi_info (distance, manager_no, district, wifi_name, road_address, detailed_address, install_location, install_type, install_agency, service_type, install_year, indoor_outdoor, wifi_environment, latitude, longitude, work_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                "ON CONFLICT(manager_no) DO UPDATE SET " +
                "distance = excluded.distance, " +
                "district = excluded.district, " +
                "wifi_name = excluded.wifi_name, " +
                "road_address = excluded.road_address, " +
                "detailed_address = excluded.detailed_address, " +
                "install_location = excluded.install_location, " +
                "install_type = excluded.install_type, " +
                "install_agency = excluded.install_agency, " +
                "service_type = excluded.service_type, " +
                "install_year = excluded.install_year, " +
                "indoor_outdoor = excluded.indoor_outdoor, " +
                "wifi_environment = excluded.wifi_environment, " +
                "latitude = excluded.latitude, " +
                "longitude = excluded.longitude, " +
                "work_date = excluded.work_date";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, wifiInfo.get("distance"));
            pstmt.setString(2, wifiInfo.get("X_SWIFI_MGR_NO"));
            pstmt.setString(3, wifiInfo.get("X_SWIFI_WRDOFC"));
            pstmt.setString(4, wifiInfo.get("X_SWIFI_MAIN_NM"));
            pstmt.setString(5, wifiInfo.get("X_SWIFI_ADRES1"));
            pstmt.setString(6, wifiInfo.get("X_SWIFI_ADRES2"));
            pstmt.setString(7, wifiInfo.get("X_SWIFI_INSTL_FLOOR"));
            pstmt.setString(8, wifiInfo.get("X_SWIFI_INSTL_TY"));
            pstmt.setString(9, wifiInfo.get("X_SWIFI_INSTL_MBY"));
            pstmt.setString(10, wifiInfo.get("X_SWIFI_SVC_SE"));
            pstmt.setString(11, wifiInfo.get("X_SWIFI_CNSTC_YEAR"));
            pstmt.setString(12, wifiInfo.get("X_SWIFI_INOUT_DOOR"));
            pstmt.setString(13, wifiInfo.get("X_SWIFI_REMARS3"));
            pstmt.setString(14, wifiInfo.get("LAT"));
            pstmt.setString(15, wifiInfo.get("LNT"));
            pstmt.setString(16, wifiInfo.get("WORK_DTTM"));
            pstmt.executeUpdate();
        }
    }

    private void sortWifiData(List<Map<String, String>> wifiList) {
        Collections.sort(wifiList, new Comparator<Map<String, String>>() {
            public int compare(Map<String, String> a, Map<String, String> b) {
                return Double.compare(Double.parseDouble(a.get("distance")), Double.parseDouble(b.get("distance")));
            }
        });
    }

    private Connection getSQLiteConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.sqlite.JDBC");
        return DriverManager.getConnection(dbUrl);
    }

    private String getTagValue(Element elem, String tagName) {
        NodeList nodeList = elem.getElementsByTagName(tagName);
        if (nodeList.getLength() == 0) return "";
        Node node = nodeList.item(0);
        return node == null ? "" : node.getTextContent();
    }

    private double distance(double lat1, double lon1, double lat2, double lon2) {
        double R = 6371;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                        Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    public boolean addBookmarkHistory(String bookmarkId, String wifiId) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO history (bookmark_id, wifi_id, created_date) VALUES (?, ?, ?)";
        Connection conn = getSQLiteConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);

        String currentDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        pstmt.setString(1, bookmarkId);
        pstmt.setString(2, wifiId);
        pstmt.setString(3, currentDate);

        int rowsAffected = pstmt.executeUpdate();
        return rowsAffected > 0;
    }

    public List<Map<String, String>> getHistory() throws SQLException, ClassNotFoundException {
        List<Map<String, String>> historyList = new ArrayList<>();
        String sql = "SELECT id, bookmark_id, wifi_id, created_date FROM history";

        Connection conn = getSQLiteConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
            Map<String, String> historyRecord = new HashMap<>();
            String historyId = rs.getString("id");
            String bookmarkId = rs.getString("bookmark_id");
            String wifiId = rs.getString("wifi_id");
            String createdDate = rs.getString("created_date");

            String bookmarkName = getBookmarkNameById(bookmarkId, conn);

            String wifiName = getWifiNameById(wifiId, conn);


            historyRecord.put("history_id", historyId);
            historyRecord.put("bookmark_name", bookmarkName);
            historyRecord.put("wifi_name", wifiName);
            historyRecord.put("created_date", createdDate);

            historyList.add(historyRecord);
        }

        rs.close();
        stmt.close();
        conn.close();

        return historyList;
    }

    private String getBookmarkNameById(String bookmarkId, Connection conn) throws SQLException {
        String sql = "SELECT name FROM bookmarks WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, bookmarkId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            return rs.getString("name");
        }
        return "알 수 없음";
    }

    private String getWifiNameById(String wifiId, Connection conn) throws SQLException {
        String sql = "SELECT wifi_name FROM wifi_info WHERE manager_no = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, wifiId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            return rs.getString("wifi_name");
        }
        return "알 수 없음";
    }
}