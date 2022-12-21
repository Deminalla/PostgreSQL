import java.sql.*;
import java.util.Scanner;

public class Main {
    public static void loadDriver(){
        try {
            Class.forName("org.postgresql.Driver");
        }
        catch (ClassNotFoundException cnfe) {
            System.out.println("Nesurastas draiveris"); // Couldn't find driver class!
            cnfe.printStackTrace();
            System.exit(1);
        }
    }
    public static Connection getConnection() {
        Connection postGresConn = null;
        try {
            postGresConn = DriverManager.getConnection("jdbc:postgresql://pgsql3.mif/studentu", "deal8003", "GatherInfo100") ;
        }
        catch (SQLException sqle) {
            System.out.println("Nepavyko prisijungti prie duomenu bazes"); // Couldn't connect to database!
            sqle.printStackTrace();
            return null ;
        }
        System.out.println("Sekmingai prisijungta prie duomenu bazes"); // Successfully connected to Postgres Database"
        return postGresConn ;
    }
    /********************************************************/

    public static void main(String[] args)
    {
        loadDriver() ;
        Connection con = getConnection() ;

        Scanner input = new Scanner(System.in);
        loop: while(true) {
            System.out.println("\n************************************************");
            System.out.println("Ka norite padaryti");
            System.out.println("1. Sukurti nauja uzsakyma \n2. Istrinti uzsakyma \n3. Modifikuoti uzsakyma \n4. Parodyti visus uzsakymus \n5. Baigti darba");
            int choice = Integer.parseInt(input.nextLine());

            switch (choice){
                case 1:
                    Create(con, input);
                    break;
                case 2:
//                will it throw me cascade issues and such?
//                    System.out.println("Delete according to:");
//                    System.out.println("1. UzsakymoNr\n2. KlientoAK\n3. Statusas");
//
//                    int choiced2 = Integer.parseInt(input.nextLine());
//                    DeleteOptions(choiced2, con);
                    DeleteByUzsakymoNr(con, input);
                    break;
                case 3:
                    System.out.println("Ka modifikuoti?");
                    System.out.println("1. Uzsakymo nr\n2. Imones nr\n3. Uzsakymo statusa");

                    int choiceu2 = Integer.parseInt(input.nextLine());
                    UpdateOptions(choiceu2, con);
                    break;
                case 4:
                    ReadAll(con);
                    break;
                case 5:
                    System.out.println("Iseinama....");
                    break loop;
            }
        }

        if( null != con ) {
            try {
                con.close() ;
            }
            catch (SQLException exp) {
                System.out.println("Nepavyko uzdaryti rysio"); // Can't close connection!
                exp.printStackTrace();
            }
        }
    }

    static void Create(Connection con, Scanner input){

        ReadKlientaiAK(con);
        System.out.print("Kliento asmens kodas: ");
        long klientoAK = Long.parseLong(input.nextLine()); // foreign key

        System.out.print("Kaina: ");
        double kaina = Double.parseDouble(input.nextLine());

        ReadImonesNr(con);
        System.out.print("Imones nr: ");
        long imonesNr = Long.parseLong(input.nextLine()); //foreign key

        System.out.print("Statusas: ");
        String statusas = input.nextLine(); // yra check

        System.out.print("Sumoketa: ");
        boolean sumoketa = Boolean.parseBoolean(input.nextLine());


        try {
            String insertSQL = "INSERT INTO Uzsakymai (KlientoAK, Kaina, ImonesNr, Statusas, Sumoketa) " +
                    "VALUES (?, ?, ?, ?, ? )";
            PreparedStatement preparedStatement = con.prepareStatement(insertSQL);
            preparedStatement.setLong(1, klientoAK);
            preparedStatement.setDouble(2, kaina);
            preparedStatement.setLong(3, imonesNr);
            preparedStatement.setString(4, statusas);
            preparedStatement.setBoolean(5, sumoketa);

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            printSQLException(e);
        }
    }


//    public static void DeleteOptions(int choice, Connection con){
//        Scanner input = new Scanner(System.in);
//        switch (choice){
//            case 1:
//                DeleteByUzsakymoNr(con, input);
//                break;
//            case 2:
//                DeleteByKlientoAK(con, input);
//                break;
//            case 3:
//                DeleteByStatusas(con, input);
//                break;
//        }
//    }

    static void DeleteByUzsakymoNr (Connection con, Scanner input){
        System.out.print("Istrinti, kai uzsakymo nr = ");
        long uzsakymoNr = Long.parseLong(input.nextLine());
        String deleteSql = "DELETE FROM Uzsakymai WHERE UzsakymoNr = ?;";
        try {
            PreparedStatement preparedStatement = con.prepareStatement(deleteSql);
            preparedStatement.setLong(1, uzsakymoNr);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            printSQLException(e);
        }
    }

//    static void DeleteByKlientoAK (Connection con, Scanner input){
//        System.out.print("Delete when KlientoAK = ");
//        long klientoAk = Long.parseLong(input.nextLine());
//        String deleteSql = "DELETE FROM Uzsakymai WHERE KlientoAK = ?;";
//        try {
//            PreparedStatement preparedStatement = con.prepareStatement(deleteSql);
//            preparedStatement.setLong(1, klientoAk);
//            preparedStatement.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//
//    static void DeleteByStatusas (Connection con, Scanner input){
//        System.out.print("Delete when Statusas = ");
//        String statusas = input.nextLine();
//        String deleteSql = "DELETE FROM Uzsakymai WHERE Statusas = ?;";
//        try {
//            PreparedStatement preparedStatement = con.prepareStatement(deleteSql);
//            preparedStatement.setString(1, statusas);
//            preparedStatement.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }

    static void ReadAll(Connection con){
        try {
            Statement stm = con.createStatement();
            String sqlAll = "SELECT * FROM Uzsakymai;";
            ResultSet rs = stm.executeQuery( sqlAll);
            System.out.println("UzsakymoNr | KlientoAK | UzsakymoData | Kaina | ImonesNr | Statusas | Sumoketa");
            while ( rs.next() ) {
                long uzsakymoNr = rs.getLong("UzsakymoNr");
                long klientoAK = rs.getLong("KlientoAK");
                Timestamp uzsakymoData = rs.getTimestamp("UzsakymoData");
                float kaina = rs.getFloat("Kaina");
                long imonesNr = rs.getLong("ImonesNr");
                String statusas = rs.getString("Statusas");
                boolean sumoketa = rs.getBoolean("Sumoketa");

                System.out.println(uzsakymoNr + " | " + klientoAK + " | " + uzsakymoData + " | " + kaina + " | " +
                        imonesNr + " | " + statusas + " | " + sumoketa);
            }

        } catch (SQLException e) {
            printSQLException(e);
        }
    }

    static void ReadKlientaiAK(Connection con){
        try {
            System.out.println("Esamu klientu asmens kodai:");
            Statement stm = con.createStatement();
            String sqlAK = "SELECT AsmensKodas FROM Klientai;";
            ResultSet rs = stm.executeQuery(sqlAK);
            while ( rs.next() ) {
                long klientoAK = rs.getLong("AsmensKodas");
                System.out.println(klientoAK);
            }
            System.out.println("----------------");
        } catch (SQLException e) {
            printSQLException(e);
        }
    }
    static void ReadImonesNr(Connection con){
        try {
            System.out.println("Esamu imoniu nr:");
            Statement stm = con.createStatement();
            String sqlAK = "SELECT ImonesNr FROM Imones;";
            ResultSet rs = stm.executeQuery(sqlAK);
            while ( rs.next() ) {
                long imonesNr = rs.getLong("ImonesNr");
                System.out.println(imonesNr);
            }
            System.out.println("------------------------");
        } catch (SQLException e) {
            printSQLException(e);
        }
    }

    public static void UpdateOptions(int choice, Connection con){
        Scanner input = new Scanner(System.in);
        System.out.print("Modifikuoti uzsakyma su nr: ");
        long uzsakymoNr = Long.parseLong(input.nextLine());

        switch (choice){
            case 1:
                UpdateUzsakymoNr(con, input, uzsakymoNr);
                break;
            case 2:
                UpdateImonesNr(con, input, uzsakymoNr);
                break;
            case 3:
                UpdateStatusas(con, input, uzsakymoNr);
                // check
                break;
        }
    }

    public static void UpdateUzsakymoNr(Connection con, Scanner input, long uzsakymoNr){
        System.out.print("Keisti uzsakymo nr i: ");
        long uzsakymoNr2 = input.nextLong();

        String updateSql = "UPDATE Uzsakymai set UzsakymoNr = ? where UzsakymoNr = ?;";

        try {
            PreparedStatement preparedStatement = con.prepareStatement(updateSql);
            preparedStatement.setLong(1, uzsakymoNr);
            preparedStatement.setLong(2, uzsakymoNr2);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            printSQLException(e);
        }
    }

    public static void UpdateImonesNr(Connection con, Scanner input, long uzsakymoNr) {
        ReadImonesNr(con);
        System.out.print("Keisti imones nr i: ");
        long imonesNr = Long.parseLong(input.nextLine());

        String updateSql = "UPDATE Uzsakymai set ImonesNr = ? where UzsakymoNr = ?;";

        try {
            PreparedStatement preparedStatement = con.prepareStatement(updateSql);
            preparedStatement.setLong(1, imonesNr);
            preparedStatement.setLong(2, uzsakymoNr);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            printSQLException(e);
        }
    }

    public static void UpdateStatusas(Connection con, Scanner input, long uzsakymoNr){
        System.out.print("Keisti uzsakymo statusa i: ");
        String statusas = input.nextLine();

        String updateSql = "UPDATE Uzsakymai set Statusas = ? where UzsakymoNr = ?;";

        try {
            PreparedStatement preparedStatement = con.prepareStatement(updateSql);
            preparedStatement.setString(1, statusas);
            preparedStatement.setLong(2, uzsakymoNr);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            printSQLException(e);
        }
    }

    public static void printSQLException(SQLException ex) {
        for (Throwable e: ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();

                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }
}