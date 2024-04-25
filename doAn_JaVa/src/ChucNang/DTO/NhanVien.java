/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ChucNang.DTO;

/**
 *
 * @author Hao Le
 */
public class NhanVien {

    public String MaNV;
    public String HoTen;
    public String SDT;
    public String Email;
    public String DiaChi;
    public String CCCD;
    public String MaCV;

    public String getMaNV() {
        return MaNV;
    }

    public void setMaNV(String MaNV) {
        this.MaNV = MaNV;
    }

    public String getHoTen() {
        return HoTen;
    }

    public void setHoTen(String HoTen) {
        this.HoTen = HoTen;
    }

    public String getSDT() {
        return SDT;
    }

    public void setSDT(String SDT) {
        this.SDT = SDT;
    }

    public String getEmail() {
        return Email;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public String getDiaChi() {
        return DiaChi;
    }

    public void setDiaChi(String DiaChi) {
        this.DiaChi = DiaChi;
    }

    public String getCCCD() {
        return CCCD;
    }

    public void setCCCD(String CCCD) {
        this.CCCD = CCCD;
    }

    public String getMaCV() {
        return MaCV;
    }

    public void setMaCV(String MaCV) {
        this.MaCV = MaCV;
    }
    
    public NhanVien() {
    }

    public NhanVien(String MaNV, String HoTen, String SDT, String Email, String DiaChi, String CCCD, String MaCV) {
        this.MaNV = MaNV;
        this.HoTen = HoTen;
        this.SDT = SDT;
        this.Email = Email;
        this.DiaChi = DiaChi;
        this.CCCD = CCCD;
        this.MaCV = MaCV;
    }
    
}
