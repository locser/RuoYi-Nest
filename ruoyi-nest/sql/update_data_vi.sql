-- Script cập nhật tiếng Việt cho các bảng dữ liệu mẫu của RuoYi (sys_dept, sys_post, sys_role, sys_dict_type, sys_dict_data, sys_config, sys_job, sys_notice)
-- Chạy script này trực tiếp trên database của bạn (ví dụ ry_vue) để dịch dữ liệu mẫu sang Tiếng Việt.

SET NAMES utf8mb4;

-- 1. Dịch dữ liệu bảng sys_dept (Phòng ban)
UPDATE sys_dept SET dept_name = 'RuoYi Technology' WHERE dept_id = 100;
UPDATE sys_dept SET dept_name = 'Tổng công ty Thâm Quyến' WHERE dept_id = 101;
UPDATE sys_dept SET dept_name = 'Chi nhánh Trường Sa' WHERE dept_id = 102;
UPDATE sys_dept SET dept_name = 'Phòng R&D' WHERE dept_id = 103;
UPDATE sys_dept SET dept_name = 'Phòng Marketing' WHERE dept_id = 104;
UPDATE sys_dept SET dept_name = 'Phòng Kiểm thử' WHERE dept_id = 105;
UPDATE sys_dept SET dept_name = 'Phòng Tài chính' WHERE dept_id = 106;
UPDATE sys_dept SET dept_name = 'Phòng Vận hành' WHERE dept_id = 107;
UPDATE sys_dept SET dept_name = 'Phòng Marketing' WHERE dept_id = 108;
UPDATE sys_dept SET dept_name = 'Phòng Tài chính' WHERE dept_id = 109;

-- 2. Dịch dữ liệu bảng sys_post (Chức vụ)
UPDATE sys_post SET post_name = 'Chủ tịch' WHERE post_id = 1;
UPDATE sys_post SET post_name = 'Quản lý dự án' WHERE post_id = 2;
UPDATE sys_post SET post_name = 'Nhân sự' WHERE post_id = 3;
UPDATE sys_post SET post_name = 'Nhân viên' WHERE post_id = 4;

-- 3. Dịch dữ liệu bảng sys_role (Vai trò)
UPDATE sys_role SET role_name = 'Quản trị viên cấp cao', remark = 'Quản trị viên cấp cao' WHERE role_id = 1;
UPDATE sys_role SET role_name = 'Vai trò thông thường', remark = 'Vai trò thông thường' WHERE role_id = 2;

-- 4. Dịch dữ liệu bảng sys_dict_type (Loại từ điển)
UPDATE sys_dict_type SET dict_name = 'Giới tính người dùng', remark = 'Danh sách giới tính người dùng' WHERE dict_id = 1;
UPDATE sys_dict_type SET dict_name = 'Trạng thái menu', remark = 'Danh sách trạng thái menu' WHERE dict_id = 2;
UPDATE sys_dict_type SET dict_name = 'Trạng thái hệ thống', remark = 'Danh sách trạng thái hệ thống' WHERE dict_id = 3;
UPDATE sys_dict_type SET dict_name = 'Trạng thái công việc', remark = 'Danh sách trạng thái công việc' WHERE dict_id = 4;
UPDATE sys_dict_type SET dict_name = 'Nhóm công việc', remark = 'Danh sách nhóm công việc' WHERE dict_id = 5;
UPDATE sys_dict_type SET dict_name = 'Hệ thống Có/Không', remark = 'Danh sách Có/Không' WHERE dict_id = 6;
UPDATE sys_dict_type SET dict_name = 'Loại thông báo', remark = 'Danh sách loại thông báo' WHERE dict_id = 7;
UPDATE sys_dict_type SET dict_name = 'Trạng thái thông báo', remark = 'Danh sách trạng thái thông báo' WHERE dict_id = 8;
UPDATE sys_dict_type SET dict_name = 'Loại hoạt động', remark = 'Danh sách loại hoạt động' WHERE dict_id = 9;
UPDATE sys_dict_type SET dict_name = 'Trạng thái đăng nhập', remark = 'Danh sách trạng thái đăng nhập' WHERE dict_id = 10;

-- 5. Dịch dữ liệu bảng sys_dict_data (Dữ liệu từ điển)
UPDATE sys_dict_data SET dict_label = 'Nam', remark = 'Nam' WHERE dict_code = 1;
UPDATE sys_dict_data SET dict_label = 'Nữ', remark = 'Nữ' WHERE dict_code = 2;
UPDATE sys_dict_data SET dict_label = 'Chưa xác định', remark = 'Chưa xác định' WHERE dict_code = 3;
UPDATE sys_dict_data SET dict_label = 'Hiển thị', remark = 'Hiển thị menu' WHERE dict_code = 4;
UPDATE sys_dict_data SET dict_label = 'Ẩn', remark = 'Ẩn menu' WHERE dict_code = 5;
UPDATE sys_dict_data SET dict_label = 'Bình thường', remark = 'Trạng thái bình thường' WHERE dict_code = 6;
UPDATE sys_dict_data SET dict_label = 'Tạm dừng', remark = 'Trạng thái tạm dừng' WHERE dict_code = 7;
UPDATE sys_dict_data SET dict_label = 'Bình thường', remark = 'Trạng thái bình thường' WHERE dict_code = 8;
UPDATE sys_dict_data SET dict_label = 'Tạm dừng', remark = 'Trạng thái tạm dừng' WHERE dict_code = 9;
UPDATE sys_dict_data SET dict_label = 'Mặc định', remark = 'Nhóm mặc định' WHERE dict_code = 10;
UPDATE sys_dict_data SET dict_label = 'Hệ thống', remark = 'Nhóm hệ thống' WHERE dict_code = 11;
UPDATE sys_dict_data SET dict_label = 'Có', remark = 'Mặc định hệ thống là Có' WHERE dict_code = 12;
UPDATE sys_dict_data SET dict_label = 'Không', remark = 'Mặc định hệ thống là Không' WHERE dict_code = 13;
UPDATE sys_dict_data SET dict_label = 'Thông báo', remark = 'Thông báo' WHERE dict_code = 14;
UPDATE sys_dict_data SET dict_label = 'Công cáo', remark = 'Công cáo' WHERE dict_code = 15;
UPDATE sys_dict_data SET dict_label = 'Bình thường', remark = 'Trạng thái bình thường' WHERE dict_code = 16;
UPDATE sys_dict_data SET dict_label = 'Đóng', remark = 'Trạng thái đóng' WHERE dict_code = 17;
UPDATE sys_dict_data SET dict_label = 'Khác', remark = 'Thao tác khác' WHERE dict_code = 18;
UPDATE sys_dict_data SET dict_label = 'Thêm mới', remark = 'Thao tác thêm mới' WHERE dict_code = 19;
UPDATE sys_dict_data SET dict_label = 'Chỉnh sửa', remark = 'Thao tác chỉnh sửa' WHERE dict_code = 20;
UPDATE sys_dict_data SET dict_label = 'Xóa', remark = 'Thao tác xóa' WHERE dict_code = 21;
UPDATE sys_dict_data SET dict_label = 'Ủy quyền', remark = 'Thao tác ủy quyền' WHERE dict_code = 22;
UPDATE sys_dict_data SET dict_label = 'Xuất file', remark = 'Thao tác xuất file' WHERE dict_code = 23;
UPDATE sys_dict_data SET dict_label = 'Nhập file', remark = 'Thao tác nhập file' WHERE dict_code = 24;
UPDATE sys_dict_data SET dict_label = 'Cưỡng chế đăng xuất', remark = 'Cưỡng chế đăng xuất' WHERE dict_code = 25;
UPDATE sys_dict_data SET dict_label = 'Tạo mã', remark = 'Thao tác tạo mã nguồn' WHERE dict_code = 26;
UPDATE sys_dict_data SET dict_label = 'Xóa sạch dữ liệu', remark = 'Thao tác xóa sạch dữ liệu' WHERE dict_code = 27;
UPDATE sys_dict_data SET dict_label = 'Thành công', remark = 'Trạng thái thành công' WHERE dict_code = 28;
UPDATE sys_dict_data SET dict_label = 'Thất bại', remark = 'Trạng thái thất bại' WHERE dict_code = 29;

-- 6. Dịch dữ liệu bảng sys_config (Cấu hình hệ thống)
UPDATE sys_config SET config_name = 'Giao diện chính - Tên kiểu giao diện mặc định', remark = 'Xanh dương skin-blue, Xanh lá skin-green, Tím skin-purple, Đỏ skin-red, Vàng skin-yellow' WHERE config_id = 1;
UPDATE sys_config SET config_name = 'Quản lý người dùng - Mật khẩu mặc định khởi tạo', remark = 'Mật khẩu khởi tạo 123456' WHERE config_id = 2;
UPDATE sys_config SET config_name = 'Giao diện chính - Chủ đề thanh bên', remark = 'Chủ đề tối theme-dark, Chủ đề sáng theme-light' WHERE config_id = 3;
UPDATE sys_config SET config_name = 'Tự phục vụ tài khoản - Bật/tắt mã xác minh (Captcha)', remark = 'Có bật tính năng mã xác minh hay không (true: bật, false: tắt)' WHERE config_id = 4;
UPDATE sys_config SET config_name = 'Tự phục vụ tài khoản - Bật/tắt đăng ký người dùng', remark = 'Có bật tính năng đăng ký tài khoản hay không (true: bật, false: tắt)' WHERE config_id = 5;
UPDATE sys_config SET config_name = 'Đăng nhập người dùng - Danh sách IP đen', remark = 'Cấu hình giới hạn IP đen đăng nhập, các mục ngăn cách bằng dấu chấm phẩy, hỗ trợ ký tự đại diện (*)' WHERE config_id = 6;

-- 7. Dịch dữ liệu bảng sys_job (Công việc định kỳ)
UPDATE sys_job SET job_name = 'Mặc định hệ thống (Không tham số)' WHERE job_id = 1;
UPDATE sys_job SET job_name = 'Mặc định hệ thống (Có tham số)' WHERE job_id = 2;
UPDATE sys_job SET job_name = 'Mặc định hệ thống (Nhiều tham số)' WHERE job_id = 3;

-- 8. Dịch dữ liệu bảng sys_notice (Thông báo)
UPDATE sys_notice SET notice_title = 'Nhắc nhở: Phiên bản RuoYi mới đã được phát hành!', notice_content = 'Nội dung phiên bản mới', remark = 'Quản trị viên' WHERE notice_id = 1;
UPDATE sys_notice SET notice_title = 'Thông báo bảo trì: Hệ thống bảo trì vào rạng sáng', notice_content = 'Nội dung bảo trì', remark = 'Quản trị viên' WHERE notice_id = 2;
