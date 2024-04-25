create database Ql_ShopQA
use Ql_ShopQA											

CREATE TABLE DanhMuc (
    MADM varchar(10) PRIMARY KEY,
    TenDM nvarchar(100)
	TrangThai bit
);
go

CREATE TABLE ChucVu(
	MaCV varchar(10) primary key,
	ChucVu nvarchar(100),
	TrangThai bit
);
go

CREATE TABLE NhanVien (
    MaNV varchar(10) PRIMARY KEY,
    Hoten nvarchar(100),
    SoDT nvarchar(11),
    Email nvarchar(100),
    DiaChi nvarchar(100),
    CCCD nvarchar(100) unique,
	MaCv varchar(10),
	TrangThai bit,
	foreign key (MaCv) REFERENCES ChucVu(MaCV)
);
go
 
CREATE TABLE SanPham (
    MaSp varchar(10) PRIMARY KEY,
	MaNCC varchar(25),
    MADM varchar(10),
    TenSp nvarchar(100),
    MoTa nvarchar(100),
    ThuongHieu nvarchar(100),
    GiaBan decimal(18, 2) check(GiaBan >= 0),
	SoLuong int check(SoLuong >= 0),
	TrangThai bit,
    FOREIGN KEY (MaNCC) REFERENCES NHACUNGCAP(MaNCC),
	FOREIGN KEY (MADM) REFERENCES DanhMuc(MADM)
);
go

create table LoaiTK
(
	MaLoai varchar(10) primary key,
	LoaiTK bit,
	TrangThai bit
);
go

CREATE TABLE TaiKhoan (
    MaNV varchar(10) unique,
    TenDangNhap nvarchar(100) PRIMARY KEY,
    MatKhau nvarchar(100) not null,
	MaLoaiTK varchar(10),
	TrangThai bit,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
	FOREIGN KEY (MaLoaiTK) REFERENCES LoaiTK(MaLoai)
);
go

CREATE TABLE KhachHang (
    MaKH varchar(10) PRIMARY KEY,
    Hoten nvarchar(100),
    SoDT nvarchar(11),
    DiaChi nvarchar(100),
    Email nvarchar(100),
	TrangThai bit
);
go

CREATE TABLE HoaDon (
    MaHD varchar(100) PRIMARY KEY,
    MaNV varchar(10),
    MaKH varchar(10),
    NgayBanHang datetime,
    TongGT decimal check(TongGT >= 0),
	TrangThai bit,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);
go

CREATE TABLE NHACUNGCAP(
	MaNCC varchar(25) PRIMARY KEY,
	TenNCC nvarchar(100),
	TrangThai bit
);
go

CREATE TABLE PhieuNhap (
    MaPN varchar(100) PRIMARY KEY,
    MaNV varchar(10),
    NgayNhap datetime,
	TongTien decimal check(TongTien >= 0),
	TrangThai bit,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);
go

CREATE TABLE ChiTietHoaDon (
    MaSp varchar(10),
    MaHD varchar(100),
    SoLuong int check(Soluong >= 0),
	Gia decimal(10,2) check (Gia>=0),
    PRIMARY KEY (MaSp, MaHD),
	TrangThai bit,
    FOREIGN KEY (MaSp) REFERENCES SanPham(MaSp),
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD)
);
go

CREATE TABLE ChiTietPhieuNhap (
    MaSp varchar(10),
    MaPN varchar(100),
    SoLuong int check(Soluong>=0),
	DonGia decimal check(DonGia >= 0),
	TrangThai bit,
    PRIMARY KEY (MaSp, MaPN),
    FOREIGN KEY (MaSp) REFERENCES SanPham(MaSp),
    FOREIGN KEY (MaPN) REFERENCES PhieuNhap(MaPN)
);
go

-----------------------------TRIGGER-----------------------------
--Trigger cho việc cập nhật SoLuong trong SanPham khi có thao tác insert hoặc update trong ChiTietPhieuNhap
CREATE TRIGGER UpdateSoLuongTrigger
ON ChiTietPhieuNhap
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Khai báo biến cho cursor
    DECLARE @MaSp varchar(10)
    DECLARE @SoLuong int

    -- Khai báo cursor
    DECLARE cursorUpdateSoLuong CURSOR FOR
    SELECT MaSp, SoLuong
    FROM deleted

    OPEN cursorUpdateSoLuong

    FETCH NEXT FROM cursorUpdateSoLuong INTO @MaSp, @SoLuong

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE SanPham
        SET SoLuong = SoLuong - @SoLuong
        WHERE MaSp = @MaSp

        FETCH NEXT FROM cursorUpdateSoLuong INTO @MaSp, @SoLuong
    END

    CLOSE cursorUpdateSoLuong
    DEALLOCATE cursorUpdateSoLuong

    -- Khai báo biến cho cursor
    DECLARE @InsertedMaSp varchar(10)
    DECLARE @InsertedSoLuong int

    -- Khai báo cursor
    DECLARE cursorInsertSoLuong CURSOR FOR
    SELECT MaSp, SoLuong
    FROM inserted

    OPEN cursorInsertSoLuong

    FETCH NEXT FROM cursorInsertSoLuong INTO @InsertedMaSp, @InsertedSoLuong

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE SanPham
        SET SoLuong = SoLuong + @InsertedSoLuong
        WHERE MaSp = @InsertedMaSp

        FETCH NEXT FROM cursorInsertSoLuong INTO @InsertedMaSp, @InsertedSoLuong
    END

    CLOSE cursorInsertSoLuong
    DEALLOCATE cursorInsertSoLuong
END;
go

--Trigger cho việc cập nhật SoLuong trong SanPham khi có thao tác insert hoặc update trong ChiTietHoaDon
CREATE TRIGGER UpdateGiamSoLuongTrigger
ON ChiTietHoaDon
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Khai báo biến cho cursor
    DECLARE @MaSp varchar(10)
    DECLARE @SoLuong int

    -- Khai báo cursor
    DECLARE cursorUpdateSoLuong CURSOR FOR
    SELECT MaSp, SoLuong
    FROM deleted

    OPEN cursorUpdateSoLuong

    FETCH NEXT FROM cursorUpdateSoLuong INTO @MaSp, @SoLuong

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE SanPham
        SET SoLuong = SoLuong + @SoLuong
        WHERE MaSp = @MaSp

        FETCH NEXT FROM cursorUpdateSoLuong INTO @MaSp, @SoLuong
    END

    CLOSE cursorUpdateSoLuong
    DEALLOCATE cursorUpdateSoLuong

    -- Khai báo biến cho cursor
    DECLARE @InsertedMaSp varchar(10)
    DECLARE @InsertedSoLuong int

    -- Khai báo cursor
    DECLARE cursorInsertSoLuong CURSOR FOR
    SELECT MaSp, SoLuong
    FROM inserted

    OPEN cursorInsertSoLuong

    FETCH NEXT FROM cursorInsertSoLuong INTO @InsertedMaSp, @InsertedSoLuong

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE SanPham
        SET SoLuong = SoLuong - @InsertedSoLuong
        WHERE MaSp = @InsertedMaSp

        FETCH NEXT FROM cursorInsertSoLuong INTO @InsertedMaSp, @InsertedSoLuong
    END

    CLOSE cursorInsertSoLuong
    DEALLOCATE cursorInsertSoLuong
END;
go

--Trigger cho việc cập nhật giá trong PhieuNhap khi có thao tác insert hoặc update hoặc delete trong ChiTietPhieuNhap
CREATE TRIGGER trg_CapNhatTongTien_PhieuNhap
ON ChiTietPhieuNhap
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @MaPN varchar(100);

    -- Lấy danh sách MaPN từ bảng Inserted (nếu là INSERT hoặc UPDATE)
    SELECT @MaPN = MaPN
    FROM Inserted;

    -- Nếu MaPN không tồn tại (DELETE), lấy danh sách từ bảng Deleted
    IF @MaPN IS NULL
    BEGIN
        SELECT @MaPN = MaPN
        FROM Deleted;
    END;

    -- Cập nhật TongTien trong bảng PhieuNhap dựa trên MaPN
    UPDATE PhieuNhap
    SET TongTien = ISNULL((
        SELECT SUM(SoLuong * DonGia)
        FROM ChiTietPhieuNhap
        WHERE MaPN = @MaPN), 0
    )
    WHERE MaPN = @MaPN;
END;
go

--Trigger cho việc cập nhật TongGT trong HoaDon khi có thao tác insert hoặc update trong ChiTietHoaDon
CREATE TRIGGER UpdateTongGT_Trigger
ON ChiTietHoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    -- Cập nhật TongGT trong HoaDon
    UPDATE HoaDon
    SET TongGT = (SELECT SUM(ChiTietHoaDon.SoLuong * SanPham.GiaBan)
                  FROM ChiTietHoaDon
                  INNER JOIN SanPham ON ChiTietHoaDon.MaSp = SanPham.MaSp
                  WHERE ChiTietHoaDon.MaHD = HoaDon.MaHD)
    FROM HoaDon
    INNER JOIN INSERTED ON HoaDon.MaHD = INSERTED.MaHD;
END;
go

-----Cập nhật giá trong chi tiết hóa đơn = giá mới trong sản phẩm mỗi khi insert chi tiết hóa đơn
CREATE TRIGGER UpdateGia
ON CHITIETHOADON
AFTER INSERT
AS
BEGIN
    UPDATE CHITIETHOADON
    SET GIA = SANPHAM.GiaBan
    FROM CHITIETHOADON
    INNER JOIN SANPHAM ON CHITIETHOADON.MASP = SANPHAM.MASP
    INNER JOIN inserted ON CHITIETHOADON.MAHD = inserted.MAHD
END;
go

-----Cập nhật giá trong chi tiết hóa đơn khi giá bán trong sản phẩm thay đổi
CREATE TRIGGER UpdateGiaBan
ON SANPHAM
AFTER UPDATE
AS
BEGIN
    IF UPDATE(GIABAN)
    BEGIN
        UPDATE CHITIETHOADON
        SET GIA = i.GIABAN
        FROM CHITIETHOADON c
        JOIN inserted i ON c.MaSP = i.MaSP
        JOIN deleted d ON c.MaSP = d.MaSP
    END
END;
go

--Trigger cho việc cập nhật giá trong SanPham khi có thao tác insert hoặc update trong ChiTietPhieuNhap
----CREATE TRIGGER UpdateGiaBanTrigger
----ON ChiTietPhieuNhap
----AFTER INSERT, UPDATE
----AS
----BEGIN
----    UPDATE SanPham
----    SET GiaBan = INSERTED.DonGia
----    FROM SanPham
----    INNER JOIN INSERTED ON SanPham.MaSp = INSERTED.MaSp;
----END;
----go
select hoten from NhanVien where NhanVien.MaNV='NV001'
-------------data-------------
INSERT INTO DanhMuc (MADM, TenDM)
VALUES
    ('DM001', N'Áo nam'),
    ('DM002', N'Áo nữ'),
    ('DM003', N'Quần nam'),
    ('DM004', N'Quần nữ');

INSERT INTO ChucVu(MaCV, ChucVu)
VALUES
(1,N'Nhân Viên Bán Hàng'),
(0,N'Quản lí kho'),
(2,N'Quản lí')

INSERT INTO NhanVien (MaNV, Hoten, SoDT, Email, DiaChi, CCCD, MaCV)
VALUES
    ('NV001', N'Nguyễn Văn A', '1234567890', 'nv1@email.com', N'Địa chỉ 1', '123456789', 1),
    ('NV002', N'Trần Thị B', '0987654321', 'nv2@email.com', N'Địa chỉ 2', '987654321', 1),
    ('NV003', N'Lê Văn C', '0123456789', 'nv3@email.com', N'Địa chỉ 3', '012345678', 0);
	
insert into LoaiTK(MaLoai,LoaiTK)
values (1,1),(2,0)

INSERT INTO TaiKhoan( MaNV, TenDangNhap, MatKhau, MaLoaiTK)
VALUES
    ( 'NV001', 'user1', '37213902101311706410244100199109113607173', 1),
    ( 'NV002', 'user2', '37213902101311706410244100199109113607173', 2),
    ( 'NV003', 'user3', '37213902101311706410244100199109113607173', 1);

INSERT INTO SanPham (MaSp, MADM, TenSp, MoTa, ThuongHieu, GiaBan, SoLuong)
VALUES
    ('SP001', 'DM001', N'Áo sơ mi nam', N'Áo sơ mi nam công sở', 'Zara', 0, 0),
    ('SP002', 'DM002', N'Áo đầm nữ', N'Áo đầm nữ dự tiệc', 'H&M', 0, 0),
    ('SP003', 'DM003', N'Quần jean nam', N'Quần jean nam slim fit', 'Levi', 0, 0);

INSERT INTO KhachHang (MaKH)
VALUES('KHVL0')
INSERT INTO KhachHang (MaKH, Hoten, SoDT, DiaChi, Email)
VALUES
	('KH003', N'Nguyễn Thị D', '0999999999', N'Địa chỉ A', 'kh1@email.com'),
    ('KH001', N'Nguyễn Thị D', '0988888888', N'Địa chỉ A', 'kh1@email.com'),
    ('KH002', N'Lê Văn E', '0977777777', N'Địa chỉ B', 'kh2@email.com');

INSERT INTO NHACUNGCAP
VALUES('NCC1', N'Đại lí Tân Phú'),
	  ('NCC2', N'Đại lí Phú Bình'),
	  ('NCC3', N'Đại lí Bình Tân'),
	  ('NCC4', N'Đại lí Tân Bình');
go

select * from DanhMuc
select * from NhanVien
select * from TaiKhoan
select * from KhachHang
select * from HoaDon
select * from ChiTietHoaDon
select * from PhieuNhap
select * from ChiTietPhieuNhap
select * from LoaiTK
select * from SanPham
select * from NHACUNGCAP 
select * from SP_NCC

----------------------------------------------------------------------------------------------------
--proc dùng để in hóa đơn
create proc InHoaDon @mahd varchar(100)
as
begin
select CTHD.*, NgayBanHang, MaNV, (GiaBan * CTHD.SoLuong) as TongCong
from ChiTietHoaDon CTHD 
inner join HoaDon HD on CTHD.MaHD = HD.MaHD
inner join SanPham SP on CTHD.MaSp = SP.MaSp
where CTHD.MaHD = @mahd
end
go

--proc lấy danh sách chi tiết hoá đơn, hóa đơn
create proc d_chitiethd @mahd varchar(100)
as
begin
select mahd, ct.MaSp,s.TenSp,ct.SoLuong,ct.Gia 
from ChiTietHoaDon ct,SanPham s 
where ct.MaSp=s.MaSp and ct.MaHD=@mahd
end
go

--store proceduce
create proc HienthiNV
as
begin
select MaNV, Hoten, SoDT, Email, DiaChi,CCCD, ChucVu.ChucVu from NhanVien, ChucVu where NhanVien.MaCv= ChucVu.MaCV
end;
go

--tránh lỗi sql injection
create proc usp_login 
@userName nvarchar(100), @pass nvarchar(100)
as
begin
	select*from TaiKhoan where TenDangNhap=@userName and MatKhau=@pass
end;
go

------------------Dùng để thống kê hóa đơn------------------
create proc USP_GetBillByDate @dayStart date, @dayEnd date, @MaNV varchar(10) 
as
begin
	select * from HoaDon
	where NgayBanHang >= @dayStart and NgayBanHang <= @dayEnd and MaNV = @MaNV
end;
go

------------------Dùng để thống kê phiếu nhập------------------
create proc USP_GetImportByDate @dayStart date, @dayEnd date, @MaNV varchar(10) 
as
begin
	select * from PhieuNhap
	where NgayNhap >= @dayStart and NgayNhap <= @dayEnd and MaNV = @MaNV
end;
go

------------------Dùng để đổi mật khẩu------------------
create proc USP_UpdatePassword @userName nvarchar(100), @newPass nvarchar(100)
as
begin
	update TaiKhoan
	set MatKhau = @newPass
	where TenDangNhap = @userName
end
go

---proc tìm nhân viên
create proc SearchNV @manv varchar(10)
as
begin
	SELECT * FROM NhanVien WHERE MaNV =@manv
end
go

--proc tìm tài khoản
create proc SearchTK @matk varchar(10)
as
begin
		SELECT * FROM TaiKhoan WHERE TenDangNhap=@matk
end
go

---proc tìm danh mục
create proc SeachDM @madm varchar(10)
as
begin
	SELECT * FROM DanhMuc WHERE MaDM =@madm
end
go

--proc tìm sản phẩm
create proc SearchSP @masp varchar(10)
as
begin 
	select *from sanpham where masp =@masp
end
go

--proc tìm khách hàng
create proc SearchKH @makh varchar(10)
as
begin
	SELECT * FROM KhachHang WHERE MaKh =@makh
end
go

--proc load dongia san pham
create proc LoadDonGiaSp @masp varchar(10)
as
begin
	select giaban from sanpham where masp = @masp
end
go	

--proc tạo phiếu tự động bằng cách lấy ngày hiện tạik
create proc TaoMaTuDong @ngay date
as
begin
	select count(MaPN) from phieunhap where ngaynhap=@ngay
end
go

--proc load combo sản phẩm khi chọn nhà cung cấp
create proc cboSanPham @MaNCC varchar(25)
as
begin
select SanPham.MaSp, TenSp from SanPham
inner join SP_NCC on SanPham.MaSp = SP_NCC.MaSp
inner join NHACUNGCAP on SP_NCC.MaNCC = NHACUNGCAP.MaNCC
where NHACUNGCAP.MaNCC = @MaNCC
end
go

--proc load combo nhà cung cấp khi chọn sản phẩm
create proc cboNCC @MaSP varchar(10)
as
begin
select NHACUNGCAP.MaNCC from NHACUNGCAP
inner join SP_NCC on SP_NCC.MaNCC = NHACUNGCAP.MaNCC
inner join SanPham on SanPham.MaSp = SP_NCC.MaSp
where SanPham.MaSp = @MaSP
end
go

--proc Quản lí danh mục
create proc themDanhmuc @madm varchar(10),@tendm varchar(50)
as
begin 
insert into DanhMuc(MADM,TenDM) values(@madm,@tendm)
end
go

create proc xoaDanhmuc @madm varchar(10)
as
begin 
delete from DanhMuc where MADM=@madm;
end
go

create proc capnhatDanhmuc @madm varchar(10),@tendm varchar(50)
as
begin 
update DanhMuc set TenDM=@tendm where MADM=@madm;
end
go

CREATE PROCEDURE TimKiemDanhMucTheoTen
    @tendm NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;    
    SELECT * 
    FROM DanhMuc 
    WHERE TenDM LIKE '%' + @tendm + '%';
END
go

--proc quản lí nhân viên
CREATE PROC themNV @MaNV varchar(10), @Hoten nvarchar(100), @SoDT nvarchar(11), @Email nvarchar(100), @DiaChi nvarchar(100),
					@CCCD nvarchar(100), @MaCv varchar(10)
AS
BEGIN

END
GO