-- Lược đồ SQLite của Room: AppDatabase phiên bản 2
-- Dùng để import cấu trúc bảng vào công cụ tạo ERD.
-- Ứng dụng không khai báo FOREIGN KEY thật trong Room; productId/partnerId
-- được lưu trong phiếu như mã tham chiếu và dữ liệu tên/số điện thoại được chụp lại.

PRAGMA foreign_keys = OFF;

CREATE TABLE IF NOT EXISTS products (
    id             INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    sku            TEXT NOT NULL,
    name           TEXT NOT NULL,
    unit           TEXT NOT NULL,
    category       TEXT NOT NULL,
    referencePrice REAL NOT NULL,
    minimumStock   REAL NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS index_products_sku
    ON products (sku);

CREATE TABLE IF NOT EXISTS partners (
    id      INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name    TEXT,
    phone   TEXT,
    address TEXT,
    type    TEXT
);

CREATE TABLE IF NOT EXISTS transactions (
    id           INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title        TEXT,
    category     TEXT,
    amount       REAL NOT NULL,
    type         TEXT,
    timestamp    INTEGER NOT NULL,
    productId    INTEGER NOT NULL,
    quantity     REAL NOT NULL,
    unitPrice    REAL NOT NULL,
    unit         TEXT,
    sku          TEXT,
    documentId   TEXT DEFAULT '',
    partnerId    INTEGER NOT NULL DEFAULT 0,
    partnerName  TEXT DEFAULT '',
    partnerPhone TEXT DEFAULT '',
    note         TEXT DEFAULT ''
);

CREATE TABLE IF NOT EXISTS chat_messages (
    id         INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    content    TEXT,
    senderType INTEGER NOT NULL,
    timestamp  INTEGER NOT NULL
);
