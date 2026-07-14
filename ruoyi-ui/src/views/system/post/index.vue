<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="Mã chức vụ" prop="postCode">
        <el-input
          v-model="queryParams.postCode"
          placeholder="Vui lòng nhập mã chức vụ"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Tên chức vụ" prop="postName">
        <el-input
          v-model="queryParams.postName"
          placeholder="Vui lòng nhập tên chức vụ"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Trạng thái" prop="status">
        <el-select v-model="queryParams.status" placeholder="bưu kiệnTrạng thái" clearable>
          <el-option
            v-for="dict in dict.type.sys_normal_disable"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">Tìm kiếm</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">Đặt lại</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:post:add']"
        >Thêm mới</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:post:edit']"
        >Sửa</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:post:remove']"
        >Xóa</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:post:export']"
        >Xuất file</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="postList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="Mã chức vụ" align="center" prop="postId" />
      <el-table-column label="Mã chức vụ" align="center" prop="postCode" />
      <el-table-column label="Tên chức vụ" align="center" prop="postName" />
      <el-table-column label="Thứ tự chức vụ" align="center" prop="postSort" />
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
      <el-table-column label="Thao tác" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:post:edit']"
          >Sửa</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:post:remove']"
          >Xóa</el-button>
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

    <!-- thêm hoặcSửa chức vụhộp thoại -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="Tên chức vụ" prop="postName">
          <el-input v-model="form.postName" placeholder="Vui lòng nhập tên chức vụ" />
        </el-form-item>
        <el-form-item label="Mã chức vụ" prop="postCode">
          <el-input v-model="form.postCode" placeholder="Vui lòng nhậptên mã hóa" />
        </el-form-item>
        <el-form-item label="Thứ tự chức vụ" prop="postSort">
          <el-input-number v-model="form.postSort" controls-position="right" :min="0" />
        </el-form-item>
        <el-form-item label="bưu kiệnTrạng thái" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio
              v-for="dict in dict.type.sys_normal_disable"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="Ghi chú" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="Vui lòng nhập nội dung" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">Xác nhận</el-button>
        <el-button @click="cancel">Hủy</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPost, getPost, delPost, addPost, updatePost } from "@/api/system/post";

export default {
  name: "Post",
  dicts: ['sys_normal_disable'],
  data() {
    return {
      // lớp mặt nạ
      loading: true,
      // Chọn mảng
      ids: [],
      // Không bị vô hiệu hóa riêng lẻ
      single: true,
      // Không bị vô hiệu hóa nhiều
      multiple: true,
      // Hiển thịTìm kiếmtình trạng
      showSearch: true,
      // Tổng số mặt hàng
      total: 0,
      // Dữ liệu mẫu công việc
      postList: [],
      // Tiêu đề lớp bật lên
      title: "",
      // CóKhôngHiển thịlớp bật lên
      open: false,
      // tham số truy vấn
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        postCode: undefined,
        postName: undefined,
        status: undefined
      },
      // thông số biểu mẫu
      form: {},
      // xác nhận mẫu
      rules: {
        postName: [
          { required: true, message: "Tên chức vụkhông thể trống", trigger: "blur" }
        ],
        postCode: [
          { required: true, message: "Mã chức vụkhông thể trống", trigger: "blur" }
        ],
        postSort: [
          { required: true, message: "Thứ tự chức vụkhông thể trống", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** Truy vấn danh sách công việc */
    getList() {
      this.loading = true;
      listPost(this.queryParams).then(response => {
        this.postList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // HủyNút bấm
    cancel() {
      this.open = false;
      this.reset();
    },
    // hình thứcĐặt lại
    reset() {
      this.form = {
        postId: undefined,
        postCode: undefined,
        postName: undefined,
        postSort: 0,
        status: "0",
        remark: undefined
      };
      this.resetForm("form");
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
    // Dữ liệu đã chọn trong hộp chọn nhiều lần
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.postId)
      this.single = selection.length!=1
      this.multiple = !selection.length
    },
    /** Thêm mớiNút bấmThao tác */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "Thêm chức vụ";
    },
    /** SửaNút bấmThao tác */
    handleUpdate(row) {
      this.reset();
      const postId = row.postId || this.ids
      getPost(postId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "Sửa chức vụ";
      });
    },
    /** nộpNút bấm */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.postId != undefined) {
            updatePost(this.form).then(response => {
              this.$modal.msgSuccess("Chỉnh sửa thành công");
              this.open = false;
              this.getList();
            });
          } else {
            addPost(this.form).then(response => {
              this.$modal.msgSuccess("Thêm mới thành công");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** XóaNút bấmThao tác */
    handleDelete(row) {
      const postIds = row.postId || this.ids;
      this.$modal.confirm('Bạn có chắc chắn muốn xóaMã chức vụvì"' + postIds + '" không?').then(function() {
        return delPost(postIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("Xóa thành công");
      }).catch(() => {});
    },
    /** Xuất fileNút bấmThao tác */
    handleExport() {
      this.download('system/post/export', {
        ...this.queryParams
      }, `post_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
