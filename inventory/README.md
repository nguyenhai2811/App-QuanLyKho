# Module quản lý nhập xuất kho

Module Android library :inventory chứa:
- Repository quản lý tạo, sửa, xóa phiếu nhập/xuất và kiểm tra tồn kho.
- Model sản phẩm, đối tác, giao dịch; DAO và Room database.
- StockCalculator tính tồn kho và kiểm tra lịch sử không âm.
- StockDocuments nhóm dòng phiếu, tính tổng và đánh số phiếu.
- Unit test cho tính tồn kho và phiếu kho.

:app phụ thuộc :inventory và tiếp tục cung cấp giao diện, ViewModel,
chat và báo cáo. Module không phụ thuộc ngược vào :app.

Giữ nguyên package Java, tên database, schema và migration để các màn hình
và dữ liệu đã lưu tiếp tục hoạt động. ChatMessage/ChatDao nằm cùng module
vì chúng thuộc cùng AppDatabase và TransactionRepository hiện có.

Kiểm tra: gradlew :inventory:testDebugUnitTest :app:testDebugUnitTest :app:assembleDebug