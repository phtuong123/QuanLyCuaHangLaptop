												-- TABLE --
CREATE TABLE LoaiSP (
  MaLoai INT PRIMARY KEY AUTO_INCREMENT,
  TenLoai VARCHAR(100) NOT NULL,
  MoTa TEXT
);

CREATE TABLE SanPham (
  MaSP INT PRIMARY KEY AUTO_INCREMENT,
  TenSP VARCHAR(100) NOT NULL,
  MaLoai INT,
  GiaNhap DECIMAL(10,2),
  GiaBan DECIMAL(10,2),
  SoLuongTon INT,
  MoTa TEXT,
  FOREIGN KEY (MaLoai) REFERENCES LoaiSP(MaLoai)
);

CREATE TABLE KhachHang (
  MaKH INT PRIMARY KEY AUTO_INCREMENT,
  HoTen VARCHAR(100),
  SDT VARCHAR(15),
  Email VARCHAR(100),
  DiaChi TEXT
);

CREATE TABLE NhanVien (
  MaNV INT PRIMARY KEY AUTO_INCREMENT,
  HoTen VARCHAR(100),
  ChucVu VARCHAR(50),
  NgaySinh DATE,
  Luong DECIMAL(10,2),
  TaiKhoan VARCHAR(50),
  MatKhau VARCHAR(100)
);

CREATE TABLE HoaDon (
  MaHD INT PRIMARY KEY AUTO_INCREMENT,
  NgayLap DATE,
  MaNV INT,
  MaKH INT,
  TongTien DECIMAL(12,2),
  FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
  FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE ChiTietHD (
  MaHD INT,
  MaSP INT,
  SoLuong INT,
  DonGia DECIMAL(10,2),
  ThanhTien DECIMAL(12,2),
  PRIMARY KEY (MaHD, MaSP),
  FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
  FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

										-- INSERT VALUES
-- LOẠI SẢN PHẨM
INSERT INTO LoaiSP (TenLoai) VALUES
('Laptop Dell'),
('Laptop HP'),
('Laptop ASUS'),
('Laptop Lenovo'),
('Macbook'),
('Laptop Acer'),
('Laptop MSI'),
('Laptop GIGABYTE');

-- SẢN PHẨM (LAPTOP)
INSERT INTO SanPham (TenSP, MaLoai, GiaNhap, GiaBan, SoLuongTon, MoTa) VALUES
('Asus TUF Gaming F15', 1, 18000000, 21000000, 10, 'Core i5 11400H, RTX 3050'),
('Acer Nitro 5 Eagle', 1, 19000000, 22500000, 5, 'Chiến game quốc dân'),
('Dell Inspiron 15', 2, 14000000, 16500000, 20, 'Bền bỉ, màn hình to'),
('HP Pavilion 14', 2, 15000000, 17900000, 15, 'Vỏ nhôm, màu gold'),
('MacBook Air M1', 3, 18500000, 23000000, 8, 'Màu Gold, 256GB SSD'),
('MacBook Pro M2', 3, 28000000, 32000000, 3, 'Touchbar, cấu hình khủng');

-- NHÂN VIÊN 
INSERT INTO NhanVien (MaNV, HoTen, ChucVu, NgaySinh, Luong, TaiKhoan, MatKhau) VALUES 
(1, 'Nguyễn Quản Lý', 'Quản lý', '1990-01-01', 20000000, 'admin', '123456'),
(2, 'Trần Thu Ngân', 'Kế toán', '1995-05-05', 12000000, 'ketoan', '123'),
(3, 'Lê Bán Hàng', 'Nhân viên', '1998-08-08', 8000000, 'nv01', '123'),
(4, 'Phạm Tư Vấn', 'Nhân viên', '2000-10-20', 8000000, 'nv02', '123');

-- KHÁCH HÀNG
INSERT INTO KhachHang (HoTen, SDT, Email, DiaChi) VALUES 
('Khách Vãng Lai', '0000000000', 'khachle@gmail.com', 'Tại cửa hàng'),
('Nguyễn Văn Giàu', '0909123456', 'giau@gmail.com', 'Quận 1, TP.HCM'),
('Trần Thị Sinh Viên', '0912345678', 'sv@ctu.edu.vn', 'Cần Thơ');

-- HÓA ĐƠN 
-- Hóa đơn 1: 
INSERT INTO HoaDon (MaHD, NgayLap, MaNV, MaKH, TongTien) VALUES 
(1, '2025-11-01 10:30:00', 3, 2, 45500000);

-- Chi tiết HĐ 1: Mua 1 Macbook Air + 1 Asus TUF
INSERT INTO ChiTietHD (MaHD, MaSP, SoLuong, DonGia, ThanhTien) VALUES 
(1, 5, 1, 23000000, 23000000),
(1, 1, 1, 22500000, 22500000);

-- Hóa đơn 2: 
INSERT INTO HoaDon (MaHD, NgayLap, MaNV, MaKH, TongTien) VALUES 
(2, '2025-11-20 15:00:00', 4, 1, 16500000);

-- Chi tiết HĐ 2: Mua 1 Dell Inspiron
INSERT INTO ChiTietHD (MaHD, MaSP, SoLuong, DonGia, ThanhTien) VALUES 
(2, 3, 1, 16500000, 16500000);

-- ----------------------------------------------------------------------------------------------
-- 													CÁC THỦ TỤC HÀM
-- 1. STORED PROCEDURE 
	-- a. Thủ tục Thống kê Doanh thu theo tháng
DROP PROCEDURE IF EXISTS sp_ThongKeDoanhThuThang;

DELIMITER //
CREATE PROCEDURE sp_ThongKeDoanhThuThang(IN thang INT, IN nam INT)
BEGIN
    SELECT 
        DATE(NgayLap) AS Ngay, 
        COUNT(*) AS SoDonHang, 
        SUM(TongTien) AS DoanhThu
    FROM HoaDon
    WHERE MONTH(NgayLap) = thang AND YEAR(NgayLap) = nam
    GROUP BY DATE(NgayLap);
END //
DELIMITER ;
-- TEST: 
CALL sp_ThongKeDoanhThuThang(11, 2025);

	-- b. Thủ tục Kiểm tra Đăng nhập
DROP PROCEDURE IF EXISTS sp_KiemTraDangNhap;

DELIMITER //
CREATE PROCEDURE sp_KiemTraDangNhap(IN tk VARCHAR(50), IN mk VARCHAR(100), OUT ketqua INT)
BEGIN
    -- Nếu tìm thấy trả về 1, không thấy trả về 0
    DECLARE count_user INT;
    SELECT COUNT(*) INTO count_user 
    FROM NhanVien 
    WHERE TaiKhoan = tk AND MatKhau = mk;
    
    SET ketqua = count_user;
END //
DELIMITER ;
-- TEST
	-- Trường hợp 1: Đăng nhập ĐÚNG (User: admin, Pass: 123456)
	CALL sp_KiemTraDangNhap('admin', '123456', @ketqua);
	SELECT @ketqua AS KetQua_DangNhap_Dung; 
	-- Mong đợi: Trả về 1

	-- Trường hợp 2: Đăng nhập SAI (User: admin, Pass: sai_pass)
	CALL sp_KiemTraDangNhap('admin', 'sai_pass', @ketqua);
	SELECT @ketqua AS KetQua_DangNhap_Sai; 
	-- Mong đợi: Trả về 0

-- 2. TRIGGER
	-- a. Trigger tự trừ Tồn kho khi bán hàng
DROP TRIGGER IF EXISTS trg_TruTonKho;

DELIMITER //
CREATE TRIGGER trg_TruTonKho
AFTER INSERT ON ChiTietHD
FOR EACH ROW
BEGIN
    -- Tự động trừ số lượng tồn trong bảng SanPham
    UPDATE SanPham
    SET SoLuongTon = SoLuongTon - NEW.SoLuong
    WHERE MaSP = NEW.MaSP;
END //
DELIMITER ;
-- TEST:
-- Chọn 1 sản phẩm để test (Ví dụ SP mã 1)
-- Ghi nhớ số lượng tồn và giá bán hiện tại
SELECT * FROM SanPham WHERE MaSP = 1;

-- Lấy cái Mã Hóa Đơn vừa tạo ở bước trên (ví dụ là số 1 hoặc số to nhất)
SELECT * FROM HoaDon WHERE MaHD = @MoiTao; 
-- (Lúc này TongTien đang là 0)

-- Giả sử bán 2 cái Laptop (Mã SP 1) vào Hóa đơn vừa tạo (@MoiTao)
-- Giá bán ví dụ 20 triệu, Thành tiền 40 triệu
INSERT INTO ChiTietHD (MaHD, MaSP, SoLuong, DonGia, ThanhTien) 
VALUES (@MoiTao, 1, 2, 20000000, 40000000);

-- 2. Kiểm tra Tổng tiền Hóa đơn (Trigger trg_CapNhatTongTien)
-- Mong đợi: TongTien bây giờ phải là 40,000,000 (thay vì 0)
SELECT * FROM HoaDon WHERE MaHD = @MoiTao;


	-- b. Trigger tự cộng dồn Tổng tiền Hóa đơn
DROP TRIGGER IF EXISTS trg_CapNhatTongTien;

DELIMITER //
CREATE TRIGGER trg_CapNhatTongTien
AFTER INSERT ON ChiTietHD
FOR EACH ROW
BEGIN
    UPDATE HoaDon
    SET TongTien = TongTien + NEW.ThanhTien
    WHERE MaHD = NEW.MaHD;
END //
DELIMITER ;
-- TEST:

-- 3. TRANSACTION (GIAO DỊCH)
DROP PROCEDURE IF EXISTS sp_TaoHoaDonMoi;

DELIMITER //
CREATE PROCEDURE sp_TaoHoaDonMoi(
    IN p_MaNV INT, 
    IN p_MaKH INT, 
    OUT p_MaHDMoi INT
)
BEGIN
    -- 1. Bắt đầu giao dịch
    START TRANSACTION;

    -- 2. Thử thêm hóa đơn (Tổng tiền tạm để 0)
    INSERT INTO HoaDon (NgayLap, MaNV, MaKH, TongTien) 
    VALUES (NOW(), p_MaNV, p_MaKH, 0);
    
    -- Lấy ID vừa tạo
    SET p_MaHDMoi = LAST_INSERT_ID();

    -- 3. Kiểm tra lỗi (Ví dụ mẫu)
    IF p_MaHDMoi > 0 THEN
        COMMIT; -- Thành công thì chốt đơn
    ELSE
        ROLLBACK; -- Lỗi thì hủy hết
    END IF;
END //
DELIMITER ;
-- TEST:
	-- Giả sử Nhân viên mã 1 bán cho Khách hàng mã 1
	-- Gọi thủ tục và hứng kết quả vào biến @MoiTao
	CALL sp_TaoHoaDonMoi(1, 1, @MoiTao);

	-- Xem Mã Hóa Đơn vừa được tạo là số mấy
	SELECT @MoiTao AS Ma_Hoa_Don_Vua_Tao;

	-- Kiểm tra trong bảng HoaDon xem có dòng đó chưa
	SELECT * FROM HoaDon WHERE MaHD = @MoiTao;


