/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ChucNang.DAL;

import ChucNang.DTO.NhanVien;
import java.sql.Connection;
import java.sql.Statement;
import javax.swing.JOptionPane;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;


/**
 *
 * @author Hao Le
 */
public class QuanLiDAO {
    public ArrayList<NhanVien> LayDanhSach() throws SQLException
    {
        ArrayList<NhanVien> ListNV = new ArrayList<NhanVien>();
        try {
            String sql = "select * from NhanVien";
            SQLServerDataProvider provider = new SQLServerDataProvider();
            provider.open();
            ResultSet rs = provider.executeQuery(sql);
            while(rs.next())
            {
                NhanVien nv = new NhanVien();
                nv.MaNV = rs.getString("MaNV");
                nv.HoTen = rs.getString("Hoten");
                nv.SDT = rs.getString("SDT");
                nv.Email = rs.getString("Email");
                nv.DiaChi = rs.getString("DiaChi");
                nv.CCCD = rs.getString("CCCD");
                nv.MaCV = rs.getString("Macv");
                ListNV.add(nv);
            }
            provider.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ListNV;  
    }
    
    /*public static boolean ThemNhanVien(NhanVien nv)
    {
        boolean kq = false;
        String sql = String.format("");
    }*/
}
