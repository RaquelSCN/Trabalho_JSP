<%@ page import="java.sql.*" %>
<%!
    public class BaseDados {
        private static final String URL = "jdbc:mysql://localhost:8080/felixbus";
        private static final String USER = "root";
        private static final String PASS = "";
        
        public static Connection getConnection() throws SQLException {
            return DriverManager.getConnection(URL, USER, PASS);
        }
        
        public static void closeConnection(Connection conn) {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        public static boolean verificarCredenciais(String username, String password, String perfil) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            boolean autenticado = false;
            
            try {
                conn = getConnection();
                String sql = "SELECT * FROM utilizadores WHERE username = ? AND password = ? AND perfil = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                stmt.setString(2, password);
                stmt.setString(3, perfil);
                rs = stmt.executeQuery();
                
                if (rs.next()) {
                    autenticado = true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                closeConnection(conn);
            }
            
            return autenticado;
        }
    }
%>

