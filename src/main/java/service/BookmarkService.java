package service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import static java.sql.DriverManager.getConnection;

public class BookmarkService {
    private String dbUrl;

    public BookmarkService() throws SQLException {
        Properties properties = new Properties();
        loadProperties(properties);
        dbUrl = properties.getProperty("db.url");
    }

    private void loadProperties(Properties properties) throws SQLException {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                throw new FileNotFoundException("config.properties not found in classpath");
            }
            properties.load(input);
        } catch (IOException e) {
            throw new SQLException("Error loading properties file", e);
        }
    }

    // SQLite에서 북마크 정보 가져오기
    public List<Map<String, String>> getBookmarks() throws SQLException, ClassNotFoundException {
        List<Map<String, String>> bookmarkList = fetchBookmarkData();
        return bookmarkList;
    }

    private List<Map<String, String>> fetchBookmarkData() throws SQLException, ClassNotFoundException {
        List<Map<String, String>> bookmarkList = new ArrayList<>();
        Connection sqliteConnection = getSQLiteConnection();

        String sql = "SELECT id, name, orders, created_date, updated_date FROM bookmarks";
        try (PreparedStatement pstmt = sqliteConnection.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Map<String, String> bookmarkInfo = new HashMap<>();
                bookmarkInfo.put("id", rs.getString("id"));
                bookmarkInfo.put("name", rs.getString("name"));
                bookmarkInfo.put("orders", rs.getString("orders"));
                bookmarkInfo.put("created_date", rs.getString("created_date"));
                bookmarkInfo.put("updated_date", rs.getString("updated_date"));
                bookmarkList.add(bookmarkInfo);
            }
        } finally {
            sqliteConnection.close();
        }
        return bookmarkList;
    }

    private Connection getSQLiteConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.sqlite.JDBC");
        return getConnection(dbUrl);
    }


    public boolean addBookmark(String name, int order) throws ClassNotFoundException, SQLException {
        String sql = "INSERT INTO bookmarks (name, orders, created_date, updated_date) VALUES (?, ?, ?, ?)";

        // 현재 날짜/시간을 문자열로 생성 (ISO-8601 형식 or 원하는 포맷)
        LocalDateTime now = LocalDateTime.now();
        String formattedDateTime = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        Connection conn = getSQLiteConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);

        stmt.setString(1, name);
        stmt.setInt(2, order);
        stmt.setString(3, formattedDateTime); // created_date
        stmt.setString(4, formattedDateTime); // updated_date

        int rowsAffected = stmt.executeUpdate();
        return rowsAffected > 0;

    }

    public Map<String, String> getBookmarkById(String id) throws SQLException, ClassNotFoundException {
        Map<String, String> bookmarkInfo = new HashMap<>();
        Connection sqliteConnection = getSQLiteConnection();

        String sql = "SELECT id, name, orders, created_date, updated_date FROM bookmarks WHERE id = ?";
        try (PreparedStatement pstmt = sqliteConnection.prepareStatement(sql)) {
            pstmt.setString(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    bookmarkInfo.put("id", rs.getString("id"));
                    bookmarkInfo.put("name", rs.getString("name"));
                    bookmarkInfo.put("orders", rs.getString("orders"));
                    bookmarkInfo.put("created_date", rs.getString("created_date"));
                    bookmarkInfo.put("updated_date", rs.getString("updated_date"));
                }
            }
        } finally {
            sqliteConnection.close();
        }
        return bookmarkInfo;
    }

    public boolean updateBookmark(String id, String name, String orders) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE bookmarks SET name = ?, orders = ?, updated_date = ? WHERE id = ?";

        // 현재 날짜/시간을 문자열로 생성 (ISO-8601 형식 또는 원하는 포맷)
        LocalDateTime now = LocalDateTime.now();
        String formattedDateTime = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        Connection conn = getSQLiteConnection();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setString(2, orders);
            stmt.setString(3, formattedDateTime); // updated_date
            stmt.setString(4, id);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            conn.close();
        }
    }

    public boolean deleteBookmark(String id) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM bookmarks WHERE id = ?";

        Connection conn = getSQLiteConnection();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            conn.close();
        }
    }

}
