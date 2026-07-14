<template>
  <!-- Nhập filebề mặt -->
  <el-dialog title="Nhập filebề mặt" :visible.sync="visible" width="800px" top="5vh" append-to-body>
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true">
      <el-form-item label="tên bảng" prop="tableName">
        <el-input
          v-model="queryParams.tableName"
          placeholder="Vui lòng nhậptên bảng"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Mô tả bảng" prop="tableComment">
        <el-input
          v-model="queryParams.tableComment"
          placeholder="Vui lòng nhậpMô tả bảng"
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
      <el-table @row-click="clickRow" ref="table" :data="dbTableList" @selection-change="handleSelectionChange" height="260px">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="tableName" label="tên bảng" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="tableComment" label="Mô tả bảng" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="createTime" label="Ngày tạo"></el-table-column>
        <el-table-column prop="updateTime" label="Thời gian cập nhật"></el-table-column>
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
      <el-button type="primary" @click="handleImportTable">Xác nhận</el-button>
      <el-button @click="visible = false">Hủy</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { listDbTable, importTable } from "@/api/tool/gen";
export default {
  data() {
    return {
      // lớp mặt nạ
      visible: false,
      // Chọn giá trị mảng
      tables: [],
      // Tổng số mặt hàng
      total: 0,
      // dữ liệu bảng
      dbTableList: [],
      // tham số truy vấn
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        tableName: undefined,
        tableComment: undefined
      }
    };
  },
  methods: {
    // Hiển thịHộp bật lên
    show() {
      this.getList();
      this.visible = true;
    },
    clickRow(row) {
      this.$refs.table.toggleRowSelection(row);
    },
    // Dữ liệu đã chọn trong hộp chọn nhiều lần
    handleSelectionChange(selection) {
      this.tables = selection.map(item => item.tableName);
    },
    // Dữ liệu bảng truy vấn
    getList() {
      listDbTable(this.queryParams).then(res => {
        if (res.code === 200) {
          this.dbTableList = res.rows;
          this.total = res.total;
        }
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
    /** Nhập fileNút bấmThao tác */
    handleImportTable() {
      const tableNames = this.tables.join(",");
      if (tableNames == "") {
        this.$modal.msgError("Vui lòng chọnmuốnNhập filebàn");
        return;
      }
      importTable({ tables: tableNames }).then(res => {
        this.$modal.msgSuccess(res.msg);
        if (res.code === 200) {
          this.visible = false;
          this.$emit("ok");
        }
      });
    }
  }
};
</script>
