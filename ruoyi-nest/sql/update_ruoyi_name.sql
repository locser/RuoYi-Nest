-- Script dọn dẹp lỗi hiển thị tên "è‹¥ä¾" (若依 - RuoYi) trong Database
SET NAMES utf8mb4;

-- 1. Sửa biệt danh người dùng (Nick name)
UPDATE sys_user SET nick_name = 'RuoYi' WHERE nick_name IN ('è‹¥ä¾', '若依');

-- 2. Sửa tên người phụ trách phòng ban (Leader)
UPDATE sys_dept SET leader = 'RuoYi' WHERE leader IN ('è‹¥ä¾', '若依');

-- 3. Sửa tên phòng ban gốc (Công nghệ RuoYi)
UPDATE sys_dept SET dept_name = 'RuoYi Technology' WHERE dept_name IN ('è‹¥ä¾§§æ‹技', '若依科技') OR dept_id = 100;

-- 4. Sửa các trạng thái trong bảng dữ liệu từ điển sys_dict_data bị lỗi font hoặc vẫn là tiếng Trung
UPDATE sys_dict_data SET dict_label = 'Bình thường' WHERE dict_label IN ('æ£å¸¸', '正常');
UPDATE sys_dict_data SET dict_label = 'Tạm dừng' WHERE dict_label IN ('å œç”¨', '停用', '暂停');
UPDATE sys_dict_data SET dict_label = 'Đóng' WHERE dict_label IN ('å…³é—­', '关闭');
UPDATE sys_dict_data SET dict_label = 'Khác' WHERE dict_label IN ('å…¶ä»–', '其他');
UPDATE sys_dict_data SET dict_label = 'Thêm mới' WHERE dict_label IN ('æ–°å¢ž', '新增');
UPDATE sys_dict_data SET dict_label = 'Chỉnh sửa' WHERE dict_label IN ('ä¿®æ”¹', '修改');
UPDATE sys_dict_data SET dict_label = 'Xóa' WHERE dict_label IN ('åˆ é™¤', '删除');
UPDATE sys_dict_data SET dict_label = 'Ủy quyền' WHERE dict_label IN ('æŽˆæƒ', '授权');
UPDATE sys_dict_data SET dict_label = 'Xuất file' WHERE dict_label IN ('å¯¼å‡º', '导出');
UPDATE sys_dict_data SET dict_label = 'Nhập file' WHERE dict_label IN ('å¯¼å…¥', '导入');
UPDATE sys_dict_data SET dict_label = 'Cưỡng chế đăng xuất' WHERE dict_label IN ('å¼ºé€€', '强退');
UPDATE sys_dict_data SET dict_label = 'Tạo mã' WHERE dict_label IN ('ç”Ÿæˆä»£ç ', '生成代码');
UPDATE sys_dict_data SET dict_label = 'Xóa sạch dữ liệu' WHERE dict_label IN ('æ¸…ç©ºæ•°æ®', '清空数据');
UPDATE sys_dict_data SET dict_label = 'Thành công' WHERE dict_label IN ('æˆåŠŸ', '成功');
UPDATE sys_dict_data SET dict_label = 'Thất bại' WHERE dict_label IN ('å¤±è´¥', '失败');
UPDATE sys_dict_data SET dict_label = 'Nam' WHERE dict_label IN ('ç”·', '男');
UPDATE sys_dict_data SET dict_label = 'Nữ' WHERE dict_label IN ('å¥³', '女');
UPDATE sys_dict_data SET dict_label = 'Chưa xác định' WHERE dict_label IN ('æœªçŸ¥', '未知');
UPDATE sys_dict_data SET dict_label = 'Hiển thị' WHERE dict_label IN ('æ˜¾ç¤º', '显示');
UPDATE sys_dict_data SET dict_label = 'Ẩn' WHERE dict_label IN ('éšè—', '隐藏');
UPDATE sys_dict_data SET dict_label = 'Có' WHERE dict_label IN ('æ˜¯', '是');
UPDATE sys_dict_data SET dict_label = 'Không' WHERE dict_label IN ('å¦', '否');
UPDATE sys_dict_data SET dict_label = 'Thông báo' WHERE dict_label IN ('é€šçŸ¥', '通知');
UPDATE sys_dict_data SET dict_label = 'Công cáo' WHERE dict_label IN ('å…¬å‘Š', '公告');

