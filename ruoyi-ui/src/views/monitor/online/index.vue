<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
      <el-form-item label="Địa chỉ đăng nhập" prop="ipaddr">
        <el-input
          v-model="queryParams.ipaddr"
          placeholder="Vui lòng nhậpĐịa chỉ đăng nhập"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Tên đăng nhập" prop="userName">
        <el-input
          v-model="queryParams.userName"
          placeholder="Vui lòng nhập tên đăng nhập"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">Tìm kiếm</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">Đặt lại</el-button>
      </el-form-item>

    </el-form>
    <el-table
      v-loading="loading"
      :data="list.slice((pageNum-1)*pageSize,pageNum*pageSize)"
      style="width: 100%;"
    >
      <el-table-column label="số seri" type="index" align="center">
        <template slot-scope="scope">
          <span>{{(pageNum - 1) * pageSize + scope.$index + 1}}</span>
        </template>
      </el-table-column>
      <el-table-column label="số phiên" align="center" prop="tokenId" :show-overflow-tooltip="true" />
      <el-table-column label="Tên đăng nhập" align="center" prop="userName" :show-overflow-tooltip="true" />
      <el-table-column label="Tên phòng ban" align="center" prop="deptName" />
      <el-table-column label="Chủ nhà" align="center" prop="ipaddr" :show-overflow-tooltip="true" />
      <el-table-column label="Vị trí đăng nhập" align="center" prop="loginLocation" :show-overflow-tooltip="true" />
      <el-table-column label="Trình duyệt" align="center" prop="browser" />
      <el-table-column label="Thao táchệ thống" align="center" prop="os" />
      <el-table-column label="Thời gian đăng nhập" align="center" prop="loginTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.loginTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="Thao tác" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleForceLogout(scope.row)"
            v-hasPermi="['monitor:online:forceLogout']"
          >Buộc rút lui</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="pageNum" :limit.sync="pageSize" />
  </div>
</template>

<script>
import { list, forceLogout } from "@/api/monitor/online";

export default {
  name: "Online",
  data() {
    return {
      // lớp mặt nạ
      loading: true,
      // Tổng số mặt hàng
      total: 0,
      // dữ liệu dạng bảng
      list: [],
      pageNum: 1,
      pageSize: 10,
      // tham số truy vấn
      queryParams: {
        ipaddr: undefined,
        userName: undefined
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** Truy vấn danh sách nhật ký đăng nhập */
    getList() {
      this.loading = true;
      list(this.queryParams).then(response => {
        this.list = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** Tìm kiếmNút bấmThao tác */
    handleQuery() {
      this.pageNum = 1;
      this.getList();
    },
    /** Đặt lạiNút bấmThao tác */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** Buộc rút luiNút bấmThao tác */
    handleForceLogout(row) {
      this.$modal.confirm('CóKhôngXác nhận rằng tên rút tiền bắt buộc là"' + row.userName + '"của người dùng？').then(function() {
        return forceLogout(row.tokenId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("Buộc rút luiThành công");
      }).catch(() => {});
    }
  }
};
</script>

