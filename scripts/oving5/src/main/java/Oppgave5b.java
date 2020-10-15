import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

class Oppgave5b{

    private static Map<String, String> getProperties() {
        Map<String, String> result = new HashMap<>();
        try (InputStream input = new FileInputStream("config.properties")) {
            Properties prop = new Properties();
            prop.load(input);
            result.put("user", prop.getProperty("DBUsername"));
            result.put("pass", prop.getProperty("DBPassword"));
            result.put("url", prop.getProperty("DBUrl"));
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        return result;
    }

    public static Connection connect()throws SQLException {
        String pass = getProperties().get("pass");
        String user = getProperties().get("user");
        String url = getProperties().get("url");
        Connection c = DriverManager.getConnection(url,user,pass);
        return c;
    }

    public static void getInfoByIsbn(String isbn){
        try{
            Connection c = connect();
            PreparedStatement stmt;
            stmt = c.prepareStatement("select forfatter, tittel, count(*) as antall "+
                    "from boktittel join eksemplar on boktittel.isbn = eksemplar.isbn where eksemplar.isbn = ?");
            stmt.setString(1, isbn);
            printInfo(stmt.executeQuery());
        }catch(SQLException e){
            e.printStackTrace();
        }
    }
    private static void printInfo(ResultSet s) throws SQLException {
        while(s.next()) {
            System.out.println("forfatter: " + s.getString("forfatter") + "\n" +
                    "tittel: " + s.getString("tittel") + "\n" +
                    "antall: " + s.getInt("antall"));
        }
    }

    public static int updateInfoByIsbn(String isbn, String laant_av, int eks_nr){
        try{
            Connection c = connect();
            PreparedStatement stmt;
            stmt = c.prepareStatement("update eksemplar set laant_av = ? "+
                    "where isbn = ? and eks_nr = ? and laant_av is null;");
            stmt.setString(1, laant_av);
            stmt.setString(2,isbn);
            stmt.setInt(3, eks_nr);
            return stmt.executeUpdate();
        }catch(SQLException e){
            e.printStackTrace();
            return  -1;
        }
    }

    public static void main(String[] args) {
        getInfoByIsbn("0-07-241163-5");
        System.out.println("rows affected: "+updateInfoByIsbn("0-07-241163-5","Per Olsen", 1));
    }





}