<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="Tên nhiệm vụ" prop="jobName">
        <el-input
          v-model="queryParams.jobName"
          placeholder="Vui lòng nhậpTên nhiệm vụ"
          clearable
          style="width: 240px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Tên nhóm nhiệm vụ" prop="jobGroup">
        <el-select
          v-model="queryParams.jobGroup"
          placeholder="Vui lòng chọnTên nhóm nhiệm vụ"
          clearable
          style="width: 240px"
        >
          <el-option
            v-for="dict in dict.type.sys_job_group"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="thực hiệnTrạng thái" prop="status">
        <el-select
          v-model="queryParams.status"
          placeholder="Vui lòng chọnthực hiệnTrạng thái"
          clearable
          style="width: 240px"
        >
          <el-option
            v-for="dict in dict.type.sys_common_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="Thời gian thực hiện">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="Từ ngày"
          end-placeholder="Đến ngày"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">Tìm kiếm</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">Đặt lại</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['monitor:job:remove']"
        >Xóa</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          @click="handleClean"
          v-hasPermi="['monitor:job:remove']"
        >Xóa sạch</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['monitor:job:export']"
        >Xuất file</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-close"
          size="mini"
          @click="handleClose"
        >Đóng</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="jobLogList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="Số nhật ký" width="80" align="center" prop="jobLogId" />
      <el-table-column label="Tên nhiệm vụ" align="center" prop="jobName" :show-overflow-tooltip="true" />
      <el-table-column label="Tên nhóm nhiệm vụ" align="center" prop="jobGroup" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_job_group" :value="scope.row.jobGroup"/>
        </template>
      </el-table-column>
      <el-table-column label="gọi chuỗi mục tiêu" align="center" prop="invokeTarget" :show-overflow-tooltip="true" />
      <el-table-column label="Thông tin nhật ký" align="center" prop="jobMessage" :show-overflow-tooltip="true" />
      <el-table-column label="thực hiệnTrạng thái" align="center" prop="status">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_common_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="Thời gian thực hiện" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="Thao tác" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView(scope.row)"
            v-hasPermi="['monitor:job:query']"
          >chi tiết</el-button>
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

    <!-- Chi tiết nhật ký lịch trình -->
    <el-dialog title="Chi tiết nhật ký lịch trình" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" label-width="100px" size="mini">
        <el-row>
          <el-col :span="12">
            <el-form-item label="Số sê-ri nhật ký：">{{ form.jobLogId }}</el-form-item>
            <el-form-item label="Tên nhiệm vụ：">{{ form.jobName }}</el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Nhóm nhiệm vụ：">{{ form.jobGroup }}</el-form-item>
            <el-form-item label="Thời gian thực hiện：">{{ form.createTime }}</el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="phương thức gọi：">{{ form.invokeTarget }}</el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Thông tin nhật ký：">{{ form.jobMessage }}</el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="thực hiệnTrạng thái：">
              <div v-if="form.status == 0">Bình thường</div>
              <div v-else-if="form.status == 1">Thất bại</div>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Thông tin ngoại lệ：" v-if="form.status == 1">{{ form.exceptionInfo }}</el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="open = false">đóng đóng</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getJob} from "@/api/monitor/job";
import { listJobLog, delJobLog, cleanJobLog } from "@/api/monitor/jobLog";

export default {
  name: "JobLog",
  dicts: ['sys_common_status', 'sys_job_group'],
  data() {
    return {
      // lớp mặt nạ
      loading: true,
      // Chọn mảng
      ids: [],
      // Không bị vô hiệu hóa nhiều
      multiple: true,
      // Hiển thịTìm kiếmtình trạng
      showSearch: true,
      // Tổng số mặt hàng
      total: 0,
      // Lập kế hoạch dữ liệu bảng nhật ký
      jobLogList: [],
      // CóKhôngHiển thịlớp bật lên
      open: false,
      // phạm vi ngày
      dateRange: [],
      // thông số biểu mẫu
      form: {},
      // tham số truy vấn
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        jobName: undefined,
        jobGroup: undefined,
        status: undefined
      }
    };
  },
  created() {
    const jobId = this.$route.params && this.$route.params.jobId;
    if (jobId !== undefined && jobId != 0) {
      getJob(jobId).then(response => {
        this.queryParams.jobName = response.data.jobName;
        this.queryParams.jobGroup = response.data.jobGroup;
        this.getList();
      });
    } else {
      this.getList();
    }
  },
  methods: {
    /** Danh sách nhật ký lập lịch truy vấn */
    getList() {
      this.loading = true;
      listJobLog(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.jobLogList = response.rows;
          this.total = response.total;
          this.loading = false;
        }
      );
    },
    // Quay lạiNút bấm
    handleClose() {
      const obj = { path: "/monitor/job" };
      this.$tab.closeOpenPage(obj);
    },
    /** Tìm kiếmNút bấmThao tác */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** Đặt lạiNút bấmThao tác */
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // Dữ liệu đã chọn trong hộp chọn nhiều lần
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.jobLogId);
      this.multiple = !selection.length;
    },
    /** chi tiếtNút bấmThao tác */
    handleView(row) {
      this.open = true;
      this.form = row;
    },
    /** XóaNút bấmThao tác */
    handleDelete(row) {
      const jobLogIds = this.ids;
      this.$modal.confirm('Bạn có chắc chắn muốn xóaSố nhật ký lập kế hoạch là"' + jobLogIds + '" không?').then(function() {
        return delJobLog(jobLogIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("Xóa thành công");
      }).catch(() => {});
    },
    /** Xóa sạchNút bấmThao tác */
    handleClean() {
      this.$modal.confirm('CóKhôngxác nhậnXóa sạchTất cả các mục dữ liệu nhật ký lập kế hoạch？').then(function() {
        return cleanJobLog();
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("Xóa sạch thành công");
      }).catch(() => {});
    },
    /** Xuất fileNút bấmThao tác */
    handleExport() {
      this.download('/monitor/jobLog/export', {
        ...this.queryParams
      }, `log_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
