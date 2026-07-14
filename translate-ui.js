const fs = require('fs');
const path = require('path');

// Từ điển dịch thuật RuoYi (Trung -> Việt)
// Sắp xếp các cụm từ dài lên trước để tránh việc dịch các từ con trước làm hỏng ngữ nghĩa.
const dict = {
  // Cảnh báo & Xác nhận
  "显示排序": "Thứ tự hiển thị",
  "Hiển thị排序": "Thứ tự hiển thị",
  "岗位排序": "Thứ tự chức vụ",
  "字典排序": "Thứ tự từ điển",
  "排序": "Sắp xếp",
  "是否确认删除": "Bạn có chắc chắn muốn xóa",
  "的数据项？": " không?",
  "的数据项": " không?",
  "确认要": "Bạn có chắc chắn muốn",
  "用户吗？": " không?",
  "修改成功": "Chỉnh sửa thành công",
  "新增成功": "Thêm mới thành công",
  "删除成功": "Xóa thành công",
  "清空": "Xóa sạch",
  "清空成功": "Xóa sạch thành công",
  "操作成功": "Thao tác thành công",
  "不能包含非法字符": "Không được chứa ký tự đặc biệt",

  // Placeholder và câu lệnh nhập
  "请输入角色名称": "Vui lòng nhập tên vai trò",
  "请输入权限字符": "Vui lòng nhập key quyền hạn",
  "请输入用户名称": "Vui lòng nhập tên đăng nhập",
  "请输入用户昵称": "Vui lòng nhập tên hiển thị",
  "请输入手机号码": "Vui lòng nhập số điện thoại",
  "请输入部门名称": "Vui lòng nhập tên phòng ban",
  "请输入负责人": "Vui lòng nhập người phụ trách",
  "请输入联系电话": "Vui lòng nhập số điện thoại",
  "请输入邮箱": "Vui lòng nhập email",
  "请输入路由地址": "Vui lòng nhập đường dẫn route",
  "请输入组件路径": "Vui lòng nhập đường dẫn component",
  "请输入路由参数": "Vui lòng nhập tham số route",
  "请输入岗位编码": "Vui lòng nhập mã chức vụ",
  "请输入岗位名称": "Vui lòng nhập tên chức vụ",
  "请输入字典名称": "Vui lòng nhập tên từ điển",
  "请输入字典类型": "Vui lòng nhập loại từ điển",
  "请输入字典键值": "Vui lòng nhập giá trị từ điển",
  "请输入字典标签": "Vui lòng nhập nhãn từ điển",
  "请输入参数名称": "Vui lòng nhập tên tham số",
  "请输入参数键名": "Vui lòng nhập key tham số",
  "请输入参数键值": "Vui lòng nhập giá trị tham số",
  "请输入公告标题": "Vui lòng nhập tiêu đề thông báo",
  "请输入公告内容": "Vui lòng nhập nội dung thông báo",
  "请选择归属部门": "Vui lòng chọn phòng ban",
  "请选择性别": "Chọn giới tính",
  "请选择岗位": "Chọn chức vụ",
  "请选择角色": "Chọn vai trò",
  "请再次输入新密码": "Vui lòng nhập lại mật khẩu mới",
  "请输入旧密码": "Vui lòng nhập mật khẩu cũ",
  "请输入新密码": "Vui lòng nhập mật khẩu mới",
  "请输入内容": "Vui lòng nhập nội dung",

  // Nút bấm & Thao tác chung
  "搜索": "Tìm kiếm",
  "重置": "Đặt lại",
  "新增": "Thêm mới",
  "修改": "Sửa",
  "删除": "Xóa",
  "导出": "Xuất file",
  "导入": "Nhập file",
  "确定": "Xác nhận",
  "取消": "Hủy",
  "确 定": "Xác nhận",
  "取 消": "Hủy",
  "状态": "Trạng thái",
  "创建时间": "Ngày tạo",
  "备注": "Ghi chú",
  "操作": "Thao tác",
  "更多": "Thêm",
  "详情": "Chi tiết",
  "提示": "Gợi ý",
  "成功": "Thành công",
  "失败": "Thất bại",
  "警告": "Cảnh báo",
  "启用": "Kích hoạt",
  "停用": "Hủy kích hoạt",
  "正常": "Bình thường",
  "显示": "Hiển thị",
  "隐藏": "Ẩn",
  "是": "Có",
  "否": "Không",
  "男": "Nam",
  "女": "Nữ",
  "未知": "Chưa xác định",
  "保存": "Lưu",
  "关闭": "Đóng",
  "返回": "Quay lại",
  "回首页": "Quay lại Trang chủ",

  // Bộ lọc ngày tháng
  "开始日期": "Từ ngày",
  "结束日期": "Đến ngày",
  "选择日期": "Chọn ngày",
  "请选择": "Vui lòng chọn",
  "请输入": "Vui lòng nhập",

  // Cây thư mục (Tree Actions)
  "展开/折叠": "Mở rộng/Thu gọn",
  "全部展开": "Mở rộng tất cả",
  "全部折叠": "Thu gọn tất cả",
  "展开": "Mở rộng",
  "折叠": "Thu gọn",

  // Quản lý vai trò (Role)
  "角色名称": "Tên vai trò",
  "权限字符": "Key quyền hạn",
  "角色状态": "Trạng thái vai trò",
  "角色编号": "Mã vai trò",
  "显示顺序": "Thứ tự hiển thị",
  "分配用户": "Gán người dùng",
  "数据权限": "Quyền dữ liệu",
  "添加角色": "Thêm vai trò",
  "修改角色": "Sửa vai trò",
  "分配角色": "Gán vai trò",
  "角色顺序": "Thứ tự vai trò",
  "数据范围": "Phạm vi dữ liệu",
  "菜单权限": "Quyền menu",
  "部门权限": "Quyền phòng ban",

  // Quản lý người dùng (User)
  "用户名称": "Tên đăng nhập",
  "用户昵称": "Tên hiển thị",
  "手机号码": "Số điện thoại",
  "用户状态": "Trạng thái người dùng",
  "用户编号": "Mã người dùng",
  "添加用户": "Thêm người dùng",
  "修改用户": "Sửa người dùng",
  "分配角色": "Gán vai trò",
  "用户导入": "Nhập dữ liệu người dùng",
  "下载模板": "Tải file mẫu",
  "是否更新已经存在的用户数据": "Cập nhật dữ liệu người dùng đã tồn tại",
  "仅允许导入xls、xlsx格式文件。": "Chỉ chấp nhận file định dạng xls, xlsx.",
  "将文件拖到此处，或": "Kéo thả file vào đây, hoặc",
  "点击上传": "click để tải lên",
  "重置密码": "Đổi mật khẩu",
  "用户性别": "Giới tính",
  "所属部门": "Bộ phận",
  "所属角色": "Vai trò",
  "登录账号": "Tài khoản đăng nhập",

  // Quản lý phòng ban (Dept)
  "部门名称": "Tên phòng ban",
  "负责人": "Người phụ trách",
  "联系电话": "Số điện thoại",
  "邮箱": "Email",
  "部门编号": "Mã phòng ban",
  "添加部门": "Thêm phòng ban",
  "修改部门": "Sửa phòng ban",
  "上级部门": "Phòng ban cấp trên",
  "部门状态": "Trạng thái phòng ban",

  // Quản lý menu (Menu)
  "菜单名称": "Tên menu",
  "菜单编号": "Mã menu",
  "添加菜单": "Thêm menu",
  "修改菜单": "Sửa menu",
  "上级菜单": "Menu cấp trên",
  "菜单类型": "Loại menu",
  "目录": "Thư mục",
  "菜单": "Menu",
  "按钮": "Nút bấm",
  "菜单图标": "Icon menu",
  "路由地址": "Đường dẫn route",
  "组件路径": "Đường dẫn component",
  "路由参数": "Tham số route",
  "是否外链": "Là link ngoài",
  "是否缓存": "Có cache",
  "显示状态": "Trạng thái hiển thị",
  "权限标识": "Key quyền hạn",

  // Quản lý chức vụ (Post)
  "岗位编码": "Mã chức vụ",
  "岗位名称": "Tên chức vụ",
  "岗位顺序": "Thứ tự chức vụ",
  "岗位编号": "Mã chức vụ",
  "添加岗位": "Thêm chức vụ",
  "修改岗位": "Sửa chức vụ",

  // Quản lý từ điển (Dict)
  "字典名称": "Tên từ điển",
  "字典类型": "Loại từ điển",
  "字典编号": "Mã từ điển",
  "添加字典": "Thêm từ điển",
  "修改字典": "Sửa từ điển",
  "字典数据": "Dữ liệu từ điển",
  "字典键值": "Giá trị từ điển",
  "字典标签": "Nhãn từ điển",
  "数据标签": "Nhãn dữ liệu",
  "数据键值": "Giá trị dữ liệu",
  "样式属性": "Thuộc tính CSS",
  "回显样式": "Class hiển thị",
  "是否默认": "Mặc định",
  "数据顺序": "Thứ tự dữ liệu",

  // Quản lý cấu hình (Config)
  "参数名称": "Tên tham số",
  "参数键名": "Key tham số",
  "参数键值": "Giá trị tham số",
  "系统内置": "Hệ thống tích hợp",
  "参数编号": "Mã tham số",
  "添加参数": "Thêm tham số",
  "修改参数": "Sửa tham số",

  // Quản lý thông báo (Notice)
  "公告标题": "Tiêu đề thông báo",
  "公告类型": "Loại thông báo",
  "公告状态": "Trạng thái thông báo",
  "公告编号": "Mã thông báo",
  "添加公告": "Thêm thông báo",
  "修改公告": "Sửa thông báo",
  "公告内容": "Nội dung thông báo",
  "发布": "Đăng tải",
  "类型": "Loại",

  // Profile cá nhân
  "个人信息": "Thông tin cá nhân",
  "基本资料": "Thông tin cơ bản",
  "修改密码": "Đổi mật khẩu",
  "旧密码": "Mật khẩu cũ",
  "新密码": "Mật khẩu mới",
  "确认密码": "Xác nhận mật khẩu",
  "个人中心": "Trang cá nhân",

  // Giám sát & Nhật ký (Monitor & Logs)
  "刷新缓存": "Làm mới bộ nhớ đệm",
  "Thao tác人员": "Người thực hiện",
  "操作人员": "Người thực hiện",
  "操作时间": "Thời gian thực hiện",
  "消耗时间": "Thời gian tiêu hao",
  "日志主键": "ID nhật ký",
  "模块标题": "Tiêu đề module",
  "业务类型": "Loại nghiệp vụ",
  "方法名称": "Tên phương thức",
  "请求方式": "Phương thức yêu cầu",
  "操作类别": "Loại thao tác",
  "主机地址": "Địa chỉ IP",
  "操作地点": "Địa điểm thao tác",
  "请求参数": "Tham số yêu cầu",
  "返回参数": "Tham số phản hồi",
  "错误消息": "Thông báo lỗi",
  "操作状态": "Trạng thái hoạt động",
  "内容": "Nội dung",
  "æ˜¯": "Có",
};

// Sắp xếp các key trong dict theo chiều dài giảm dần
const sortedKeys = Object.keys(dict).sort((a, b) => b.length - a.length);

const targetDirs = [
  path.join(__dirname, 'ruoyi-ui', 'src', 'views', 'system'),
  path.join(__dirname, 'ruoyi-ui', 'src', 'views', 'monitor'),
  path.join(__dirname, 'ruoyi-ui', 'src', 'views', 'tool'),
  path.join(__dirname, 'ruoyi-ui', 'src', 'layout'),
  path.join(__dirname, 'ruoyi-ui', 'src', 'components')
];

function walkDir(dir) {
  if (!fs.existsSync(dir)) return;
  const files = fs.readdirSync(dir);
  for (const file of files) {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) {
      walkDir(filePath);
    } else if (filePath.endsWith('.vue')) {
      translateFile(filePath);
    }
  }
}

function translateFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  let changed = false;

  // Thực hiện dịch hàng loạt dựa trên từ điển đã sắp xếp
  for (const key of sortedKeys) {
    const val = dict[key];
    // Thay thế toàn bộ các chuỗi trùng khớp chính xác trong code
    // Dùng regex để thay thế toàn cầu các cụm từ này
    if (content.includes(key)) {
      const regex = new RegExp(key, 'g');
      content = content.replace(regex, val);
      changed = true;
    }
  }

  if (changed) {
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Translated: ${path.relative(__dirname, filePath)}`);
  }
}

console.log('Bắt đầu dịch các giao diện hệ thống...');
for (const dir of targetDirs) {
  walkDir(dir);
}
console.log('Dịch hoàn tất!');
