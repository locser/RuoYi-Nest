-- Script dọn dẹp lỗi hiển thị tên "è‹¥ä¾" (若依 - RuoYi) trong Database
SET NAMES utf8mb4;

-- 1. Sửa biệt danh người dùng (Nick name)
UPDATE sys_user SET nick_name = 'RuoYi' WHERE nick_name IN ('è‹¥ä¾', '若依');

-- 2. Sửa tên người phụ trách phòng ban (Leader)
UPDATE sys_dept SET leader = 'RuoYi' WHERE leader IN ('è‹¥ä¾', '若依');

-- 3. Sửa tên phòng ban gốc (Công nghệ RuoYi)
UPDATE sys_dept SET dept_name = 'RuoYi Technology' WHERE dept_name IN ('è‹¥ä¾§§æ‹技', '若依科技') OR dept_id = 100;
