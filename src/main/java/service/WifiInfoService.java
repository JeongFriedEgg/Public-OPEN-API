package service;

import org.w3c.dom.*;
import javax.xml.parsers.*;
import java.io.*;
import java.net.*;
import java.util.*;

public class WifiInfoService {

    public List<Map<String, String>> getWifiInfo(double userLat, double userLon) {
        List<Map<String, String>> wifiList = new ArrayList<>();

        try {
            String apiKey = "56714d796477696236307672454373"; // 실제 키 사용
            String apiUrl = "http://openapi.seoul.go.kr:8088/" + apiKey + "/xml/TbPublicWifiInfo/1/1000/";

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

            String xmlData = sb.toString();

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            InputStream is = new ByteArrayInputStream(xmlData.getBytes("UTF-8"));
            Document doc = builder.parse(is);

            NodeList rows = doc.getElementsByTagName("row");

            for (int i = 0; i < rows.getLength(); i++) {
                Element row = (Element) rows.item(i);

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

                wifiList.add(wifiInfo);
            }

            Collections.sort(wifiList, new Comparator<Map<String, String>>() {
                public int compare(Map<String, String> a, Map<String, String> b) {
                    return Double.compare(Double.parseDouble(a.get("distance")), Double.parseDouble(b.get("distance")));
                }
            });

        } catch (Exception e) {
            e.printStackTrace();
        }

        return wifiList;
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
}