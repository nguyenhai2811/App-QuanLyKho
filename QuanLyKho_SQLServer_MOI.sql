/* Chay toan bo file nay trong SQL Server Management Studio (SSMS). */
IF DB_ID(N'QuanLyKho_SoDo') IS NULL CREATE DATABASE QuanLyKho_SoDo;
GO
USE QuanLyKho_SoDo;
GO

CREATE TABLE dbo.NhomHang (
    MaNhomHang INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_NhomHang PRIMARY KEY,
    TenNhomHang NVARCHAR(100) NOT NULL CONSTRAINT UQ_NhomHang_Ten UNIQUE,
    MoTa NVARCHAR(500) NULL
);
GO

CREATE TABLE dbo.SanPham (
    MaSanPham INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_SanPham PRIMARY KEY,
    MaHang NVARCHAR(50) NOT NULL CONSTRAINT UQ_SanPham_MaHang UNIQUE,
    TenSanPham NVARCHAR(200) NOT NULL,
    MaNhomHang INT NOT NULL,
    DonViTinh NVARCHAR(50) NOT NULL,
    GiaThamChieu DECIMAL(18,2) NOT NULL CONSTRAINT DF_SanPham_Gia DEFAULT (0),
    MucTonToiThieu DECIMAL(18,3) NOT NULL CONSTRAINT DF_SanPham_TonMin DEFAULT (0),
    CONSTRAINT CK_SanPham_GiaTon CHECK (GiaThamChieu >= 0 AND MucTonToiThieu >= 0),
    CONSTRAINT FK_SanPham_NhomHang FOREIGN KEY (MaNhomHang) REFERENCES dbo.NhomHang(MaNhomHang)
);
GO

CREATE TABLE dbo.DoiTac (
    MaDoiTac INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DoiTac PRIMARY KEY,
    TenDoiTac NVARCHAR(200) NOT NULL,
    DienThoai NVARCHAR(30) NULL,
    DiaChi NVARCHAR(500) NULL,
    LoaiDoiTac NVARCHAR(20) NOT NULL,
    CONSTRAINT CK_DoiTac_Loai CHECK (LoaiDoiTac IN (N'customer', N'supplier'))
);
GO

/* Mot dong PhieuKho la mot san pham tren phieu; cung SoPhieu la cung mot phieu. */
CREATE TABLE dbo.PhieuKho (
    MaPhieuKho INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PhieuKho PRIMARY KEY,
    SoPhieu NVARCHAR(100) NOT NULL,
    LoaiPhieu NVARCHAR(20) NOT NULL,
    ThoiGianUnixMs BIGINT NOT NULL,
    MaDoiTac INT NULL,
    TenDoiTacLuu NVARCHAR(200) NOT NULL CONSTRAINT DF_PhieuKho_TenDoiTac DEFAULT (N''),
    DienThoaiLuu NVARCHAR(30) NOT NULL CONSTRAINT DF_PhieuKho_DienThoai DEFAULT (N''),
    GhiChu NVARCHAR(1000) NOT NULL CONSTRAINT DF_PhieuKho_GhiChu DEFAULT (N''),
    MaSanPham INT NOT NULL,
    MaHangLuu NVARCHAR(50) NOT NULL,
    TenSanPhamLuu NVARCHAR(200) NOT NULL,
    DonViTinhLuu NVARCHAR(50) NOT NULL,
    SoLuong DECIMAL(18,3) NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    ThanhTien DECIMAL(18,2) NOT NULL,
    CONSTRAINT CK_PhieuKho_Loai CHECK (LoaiPhieu IN (N'income', N'expense')),
    CONSTRAINT CK_PhieuKho_SoLieu CHECK (SoLuong > 0 AND DonGia >= 0 AND ThanhTien >= 0),
    CONSTRAINT FK_PhieuKho_DoiTac FOREIGN KEY (MaDoiTac) REFERENCES dbo.DoiTac(MaDoiTac),
    CONSTRAINT FK_PhieuKho_SanPham FOREIGN KEY (MaSanPham) REFERENCES dbo.SanPham(MaSanPham)
);
GO
CREATE INDEX IX_PhieuKho_SoPhieu ON dbo.PhieuKho(SoPhieu);
CREATE INDEX IX_PhieuKho_MaDoiTac ON dbo.PhieuKho(MaDoiTac);
CREATE INDEX IX_PhieuKho_MaSanPham ON dbo.PhieuKho(MaSanPham);
GO

CREATE TABLE dbo.LichSuKho (
    MaLichSu INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_LichSuKho PRIMARY KEY,
    SoPhieu NVARCHAR(100) NULL,
    MaSanPham INT NULL,
    MaDoiTac INT NULL,
    LoaiThaoTac NVARCHAR(30) NOT NULL,
    MoTa NVARCHAR(1000) NOT NULL,
    ThoiGianUnixMs BIGINT NOT NULL,
    CONSTRAINT FK_LichSu_SanPham FOREIGN KEY (MaSanPham) REFERENCES dbo.SanPham(MaSanPham),
    CONSTRAINT FK_LichSu_DoiTac FOREIGN KEY (MaDoiTac) REFERENCES dbo.DoiTac(MaDoiTac)
);
GO
CREATE INDEX IX_LichSu_ThoiGian ON dbo.LichSuKho(ThoiGianUnixMs);
GO

CREATE TABLE dbo.BaoCaoKho (
    MaBaoCao INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_BaoCaoKho PRIMARY KEY,
    TenBaoCao NVARCHAR(200) NOT NULL,
    TuNgay DATE NOT NULL,
    DenNgay DATE NOT NULL,
    TongTienNhap DECIMAL(18,2) NOT NULL CONSTRAINT DF_BaoCao_TongNhap DEFAULT (0),
    TongTienXuat DECIMAL(18,2) NOT NULL CONSTRAINT DF_BaoCao_TongXuat DEFAULT (0),
    ChenhLech DECIMAL(18,2) NOT NULL CONSTRAINT DF_BaoCao_ChenhLech DEFAULT (0),
    ThoiGianLapUnixMs BIGINT NOT NULL,
    GhiChu NVARCHAR(1000) NULL,
    CONSTRAINT CK_BaoCao_KhoangNgay CHECK (DenNgay >= TuNgay)
);
GO

CREATE TABLE dbo.CaiDatBaoMat (
    MaCaiDat INT NOT NULL CONSTRAINT PK_CaiDatBaoMat PRIMARY KEY,
    BatKhoaPIN BIT NOT NULL CONSTRAINT DF_CaiDat_BatPIN DEFAULT (0),
    MaPINHash NVARCHAR(256) NULL,
    BatKhoaVanTay BIT NOT NULL CONSTRAINT DF_CaiDat_VanTay DEFAULT (0),
    KhoaKhiMoUngDung BIT NOT NULL CONSTRAINT DF_CaiDat_KhiMo DEFAULT (0),
    SoPhutTuDongKhoa INT NULL,
    CapNhatUnixMs BIGINT NOT NULL,
    CONSTRAINT CK_CaiDat_MaDon CHECK (MaCaiDat = 1),
    CONSTRAINT CK_CaiDat_ThoiGianKhoa CHECK (SoPhutTuDongKhoa IS NULL OR SoPhutTuDongKhoa > 0)
);
GO

CREATE TABLE dbo.TinNhanAI (
    MaTinNhan INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_TinNhanAI PRIMARY KEY,
    NoiDung NVARCHAR(MAX) NULL,
    LoaiNguoiGui INT NOT NULL, -- 0 = AI, 1 = nguoi dung
    ThoiGianUnixMs BIGINT NOT NULL
);
GO

/* Trong SSMS: Databases > QuanLyKho_SoDo > Database Diagrams > New Database Diagram, chon 8 bang. */
