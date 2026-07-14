-- Script cập nhật tiếng Việt cho bảng sys_menu của RuoYi
-- Chạy script này trực tiếp trên database của bạn (ví dụ ry_vue) để dịch Menu và Nút bấm sang Tiếng Việt.

-- Một số menu chính và thư mục
UPDATE sys_menu SET menu_name = 'Quản lý hệ thống', remark = 'Thư mục quản lý hệ thống' WHERE menu_id = 1;
UPDATE sys_menu SET menu_name = 'Giám sát hệ thống', remark = 'Thư mục giám sát hệ thống' WHERE menu_id = 2;
UPDATE sys_menu SET menu_name = 'Công cụ hệ thống', remark = 'Thư mục công cụ hệ thống' WHERE menu_id = 3;
UPDATE sys_menu SET menu_name = 'Trang chủ RuoYi Nest', remark = 'Địa chỉ trang chủ RuoYi Nest' WHERE menu_id = 4;

-- Các menu chức năng con
UPDATE sys_menu SET menu_name = 'Quản lý người dùng', remark = 'Menu quản lý người dùng' WHERE menu_id = 100;
UPDATE sys_menu SET menu_name = 'Quản lý vai trò', remark = 'Menu quản lý vai trò' WHERE menu_id = 101;
UPDATE sys_menu SET menu_name = 'Quản lý menu', remark = 'Menu quản lý menu' WHERE menu_id = 102;
UPDATE sys_menu SET menu_name = 'Quản lý phòng ban', remark = 'Menu quản lý phòng ban' WHERE menu_id = 103;
UPDATE sys_menu SET menu_name = 'Quản lý chức vụ', remark = 'Menu quản lý chức vụ' WHERE menu_id = 104;
UPDATE sys_menu SET menu_name = 'Quản lý từ điển', remark = 'Menu quản lý từ điển' WHERE menu_id = 105;
UPDATE sys_menu SET menu_name = 'Cấu hình tham số', remark = 'Menu cấu hình tham số' WHERE menu_id = 106;
UPDATE sys_menu SET menu_name = 'Thông báo & công cáo', remark = 'Menu thông báo & công cáo' WHERE menu_id = 107;
UPDATE sys_menu SET menu_name = 'Quản lý nhật ký', remark = 'Menu quản lý nhật ký' WHERE menu_id = 108;
UPDATE sys_menu SET menu_name = 'Người dùng online', remark = 'Menu người dùng online' WHERE menu_id = 109;
UPDATE sys_menu SET menu_name = 'Công việc định kỳ', remark = 'Menu công việc định kỳ' WHERE menu_id = 110;
UPDATE sys_menu SET menu_name = 'Giám sát dữ liệu', remark = 'Menu giám sát dữ liệu' WHERE menu_id = 111;
UPDATE sys_menu SET menu_name = 'Giám sát dịch vụ', remark = 'Menu giám sát dịch vụ' WHERE menu_id = 112;
UPDATE sys_menu SET menu_name = 'Giám sát bộ nhớ đệm', remark = 'Menu giám sát bộ nhớ đệm' WHERE menu_id = 113;
UPDATE sys_menu SET menu_name = 'Danh sách bộ nhớ đệm', remark = 'Menu danh sách bộ nhớ đệm' WHERE menu_id = 114;
UPDATE sys_menu SET menu_name = 'Xây dựng biểu mẫu', remark = 'Menu xây dựng biểu mẫu' WHERE menu_id = 115;
UPDATE sys_menu SET menu_name = 'Tạo mã nguồn', remark = 'Menu tạo mã nguồn' WHERE menu_id = 116;
UPDATE sys_menu SET menu_name = 'Giao diện hệ thống', remark = 'Menu giao diện hệ thống (Swagger)' WHERE menu_id = 117;

-- Menu con nhật ký
UPDATE sys_menu SET menu_name = 'Nhật ký hoạt động', remark = 'Menu nhật ký hoạt động' WHERE menu_id = 500;
UPDATE sys_menu SET menu_name = 'Nhật ký đăng nhập', remark = 'Menu nhật ký đăng nhập' WHERE menu_id = 501;

-- Các nút chức năng trong hệ thống (Quyền hạn)
UPDATE sys_menu SET menu_name = 'Truy vấn người dùng' WHERE menu_id = 1000;
UPDATE sys_menu SET menu_name = 'Thêm người dùng' WHERE menu_id = 1001;
UPDATE sys_menu SET menu_name = 'Sửa người dùng' WHERE menu_id = 1002;
UPDATE sys_menu SET menu_name = 'Xóa người dùng' WHERE menu_id = 1003;
UPDATE sys_menu SET menu_name = 'Xuất người dùng' WHERE menu_id = 1004;
UPDATE sys_menu SET menu_name = 'Nhập người dùng' WHERE menu_id = 1005;
UPDATE sys_menu SET menu_name = 'Đặt lại mật khẩu' WHERE menu_id = 1006;

UPDATE sys_menu SET menu_name = 'Truy vấn vai trò' WHERE menu_id = 1007;
UPDATE sys_menu SET menu_name = 'Thêm vai trò' WHERE menu_id = 1008;
UPDATE sys_menu SET menu_name = 'Sửa vai trò' WHERE menu_id = 1009;
UPDATE sys_menu SET menu_name = 'Xóa vai trò' WHERE menu_id = 1010;
UPDATE sys_menu SET menu_name = 'Xuất vai trò' WHERE menu_id = 1011;

UPDATE sys_menu SET menu_name = 'Truy vấn menu' WHERE menu_id = 1012;
UPDATE sys_menu SET menu_name = 'Thêm menu' WHERE menu_id = 1013;
UPDATE sys_menu SET menu_name = 'Sửa menu' WHERE menu_id = 1014;
UPDATE sys_menu SET menu_name = 'Xóa menu' WHERE menu_id = 1015;

UPDATE sys_menu SET menu_name = 'Truy vấn phòng ban' WHERE menu_id = 1016;
UPDATE sys_menu SET menu_name = 'Thêm phòng ban' WHERE menu_id = 1017;
UPDATE sys_menu SET menu_name = 'Sửa phòng ban' WHERE menu_id = 1018;
UPDATE sys_menu SET menu_name = 'Xóa phòng ban' WHERE menu_id = 1019;

UPDATE sys_menu SET menu_name = 'Truy vấn chức vụ' WHERE menu_id = 1020;
UPDATE sys_menu SET menu_name = 'Thêm chức vụ' WHERE menu_id = 1021;
UPDATE sys_menu SET menu_name = 'Sửa chức vụ' WHERE menu_id = 1022;
UPDATE sys_menu SET menu_name = 'Xóa chức vụ' WHERE menu_id = 1023;
UPDATE sys_menu SET menu_name = 'Xuất chức vụ' WHERE menu_id = 1024;

UPDATE sys_menu SET menu_name = 'Truy vấn từ điển' WHERE menu_id = 1025;
UPDATE sys_menu SET menu_name = 'Thêm từ điển' WHERE menu_id = 1026;
UPDATE sys_menu SET menu_name = 'Sửa từ điển' WHERE menu_id = 1027;
UPDATE sys_menu SET menu_name = 'Xóa từ điển' WHERE menu_id = 1028;
UPDATE sys_menu SET menu_name = 'Xuất từ điển' WHERE menu_id = 1029;

UPDATE sys_menu SET menu_name = 'Truy vấn tham số' WHERE menu_id = 1030;
UPDATE sys_menu SET menu_name = 'Thêm tham số' WHERE menu_id = 1031;
UPDATE sys_menu SET menu_name = 'Sửa tham số' WHERE menu_id = 1032;
UPDATE sys_menu SET menu_name = 'Xóa tham số' WHERE menu_id = 1033;
UPDATE sys_menu SET menu_name = 'Xuất tham số' WHERE menu_id = 1034;

UPDATE sys_menu SET menu_name = 'Truy vấn thông báo' WHERE menu_id = 1035;
UPDATE sys_menu SET menu_name = 'Thêm thông báo' WHERE menu_id = 1036;
UPDATE sys_menu SET menu_name = 'Sửa thông báo' WHERE menu_id = 1037;
UPDATE sys_menu SET menu_name = 'Xóa thông báo' WHERE menu_id = 1038;

UPDATE sys_menu SET menu_name = 'Truy vấn hoạt động' WHERE menu_id = 1039;
UPDATE sys_menu SET menu_name = 'Xóa hoạt động' WHERE menu_id = 1040;
UPDATE sys_menu SET menu_name = 'Xuất nhật ký' WHERE menu_id = 1041;

UPDATE sys_menu SET menu_name = 'Truy vấn đăng nhập' WHERE menu_id = 1042;
UPDATE sys_menu SET menu_name = 'Xóa đăng nhập' WHERE menu_id = 1043;
UPDATE sys_menu SET menu_name = 'Xuất nhật ký' WHERE menu_id = 1044;
UPDATE sys_menu SET menu_name = 'Mở khóa tài khoản' WHERE menu_id = 1045;

UPDATE sys_menu SET menu_name = 'Truy vấn online' WHERE menu_id = 1046;
UPDATE sys_menu SET menu_name = 'Cưỡng chế đăng xuất hàng loạt' WHERE menu_id = 1047;
UPDATE sys_menu SET menu_name = 'Cưỡng chế đăng xuất' WHERE menu_id = 1048;

UPDATE sys_menu SET menu_name = 'Truy vấn công việc' WHERE menu_id = 1049;
UPDATE sys_menu SET menu_name = 'Thêm công việc' WHERE menu_id = 1050;
UPDATE sys_menu SET menu_name = 'Sửa công việc' WHERE menu_id = 1051;
UPDATE sys_menu SET menu_name = 'Xóa công việc' WHERE menu_id = 1052;
UPDATE sys_menu SET menu_name = 'Thay đổi trạng thái' WHERE menu_id = 1053;
UPDATE sys_menu SET menu_name = 'Xuất công việc' WHERE menu_id = 1054;

UPDATE sys_menu SET menu_name = 'Truy vấn tạo mã' WHERE menu_id = 1055;
UPDATE sys_menu SET menu_name = 'Sửa tạo mã' WHERE menu_id = 1056;
UPDATE sys_menu SET menu_name = 'Xóa tạo mã' WHERE menu_id = 1057;
UPDATE sys_menu SET menu_name = 'Nhập mã nguồn' WHERE menu_id = 1058;
UPDATE sys_menu SET menu_name = 'Xem trước mã nguồn' WHERE menu_id = 1059;
UPDATE sys_menu SET menu_name = 'Tạo mã nguồn' WHERE menu_id = 1060;
