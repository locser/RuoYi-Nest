<template>
  <!-- người dùng được ủy quyền -->
  <el-dialog title="Chọn người dùng" :visible.sync="visible" width="800px" top="5vh" append-to-body>
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true">
      <el-form-item label="Tên đăng nhập" prop="userName">
        <el-input
          v-model="queryParams.userName"
          placeholder="Vui lòng nhập tên đăng nhập"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Số điện thoại" prop="phonenumber">
        <el-input
          v-model="queryParams.phonenumber"
          placeholder="Vui lòng nhập số điện thoại"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">Tìm kiếm</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">Đặt lại</el-button>
      </el-form-item>
    </el-form>
    <el-row>
      <el-table @row-click="clickRow" ref="table" :data="userList" @selection-change="handleSelectionChange" height="260px">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column label="Tên đăng nhập" prop="userName" :show-overflow-tooltip="true" />
        <el-table-column label="Tên hiển thị" prop="nickName" :show-overflow-tooltip="true" />
        <el-table-column label="Email" prop="email" :show-overflow-tooltip="true" />
        <el-table-column label="điện thoại di động" prop="phonenumber" :show-overflow-tooltip="true" />
        <el-table-column label="Trạng thái" align="center" prop="status">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
          </template>
        </el-table-column>
        <el-table-column label="Ngày tạo" align="center" prop="createTime" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.createTime) }}</span>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-row>
    <div slot="footer" class="dialog-footer">
      <el-button type="primary" @click="handleSelectUser">Xác nhận</el-button>
      <el-button @click="visible = false">Hủy</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { unallocatedUserList, authUserSelectAll } from "@/api/system/role";
export default {
  dicts: ['sys_normal_disable'],
  props: {
    // Mã vai trò
    roleId: {
      type: [Number, String]
    }
  },
  data() {
    return {
      // lớp mặt nạ
      visible: false,
      // Chọn giá trị mảng
      userIds: [],
      // Tổng số mặt hàng
      total: 0,
      // Dữ liệu người dùng trái phép
      userList: [],
      // tham số truy vấn
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        roleId: undefined,
        userName: undefined,
        phonenumber: undefined
      }
    };
  },
  methods: {
    // Hiển thịHộp bật lên
    show() {
      this.queryParams.roleId = this.roleId;
      this.getList();
      this.visible = true;
    },
    clickRow(row) {
      this.$refs.table.toggleRowSelection(row);
    },
    // Dữ liệu đã chọn trong hộp chọn nhiều lần
    handleSelectionChange(selection) {
      this.userIds = selection.map(item => item.userId);
    },
    // Dữ liệu bảng truy vấn
    getList() {
      unallocatedUserList(this.queryParams).then(res => {
        this.userList = res.rows;
        this.total = res.total;
      });
    },
    /** Tìm kiếmNút bấmThao tác */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** Đặt lạiNút bấmThao tác */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** Chọn người dùng được ủy quyềnThao tác */
    handleSelectUser() {
      const roleId = this.queryParams.roleId;
      const userIds = this.userIds.join(",");
      if (userIds == "") {
        this.$modal.msgError("Vui lòng chọnNgười dùng gán");
        return;
      }
      authUserSelectAll({ roleId: roleId, userIds: userIds }).then(res => {
        this.$modal.msgSuccess(res.msg);
        this.visible = false;
        this.$emit("ok");
      }); 
    }
  }
};
</script>
