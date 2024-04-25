/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ChucNang.DAL;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 *
 * @author Hao Le
 */
public class SQLServerDataProvider {
    private Connection connection;
    public void open()
    {
        try {
            
            String user = "sa";
            String pass = "123";
            String url = "jdbc:sqlserver://localhost:1433;databaseName=QLSINHVIEN";
            Connection con = (Connection) DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void close()
    {
        try {
            this.connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public ResultSet executeQuery(String sql)
    {
        ResultSet rs = null;
        try {
                Statement sm = connection.createStatement();
                rs = sm.executeQuery(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rs;
    }
    
    public int executeUpdate(String sql)
    {
        int n = -1;
        try {
                Statement sm = connection.createStatement();
                n = sm.executeUpdate(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
    }
    
}
