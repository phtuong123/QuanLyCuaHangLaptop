import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Đăng ký driver
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            // Đường dẫn kết nối (nhớ sửa tên DB và pass)
            String url = "jdbc:mysql://localhost:3306/qlch"; 
            String user = "tuong";
            String pass = "1234"; // <---  MẬT KHẨU 
            
            conn = DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}