<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="Tên nhiệm vụ" prop="jobName">
        <el-input
          v-model="queryParams.jobName"
          placeholder="Vui lòng nhậpTên nhiệm vụ"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Tên nhóm nhiệm vụ" prop="jobGroup">
        <el-select v-model="queryParams.jobGroup" placeholder="Vui lòng chọnTên nhóm nhiệm vụ" clearable>
          <el-option
            v-for="dict in dict.type.sys_job_group"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="Nhiệm vụTrạng thái" prop="status">
        <el-select v-model="queryParams.status" placeholder="Vui lòng chọnNhiệm vụTrạng thái" clearable>
          <el-option
            v-for="dict in dict.type.sys_job_status"
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
          v-hasPermi="['monitor:job:add']"
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
          v-hasPermi="['monitor:job:edit']"
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
          v-hasPermi="['monitor:job:remove']"
        >Xóa</el-button>
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
          type="info"
          plain
          icon="el-icon-s-operation"
          size="mini"
          @click="handleJobLog"
          v-hasPermi="['monitor:job:query']"
        >nhật ký</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="jobList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="Số nhiệm vụ" width="100" align="center" prop="jobId" />
      <el-table-column label="Tên nhiệm vụ" align="center" prop="jobName" :show-overflow-tooltip="true" />
      <el-table-column label="Tên nhóm nhiệm vụ" align="center" prop="jobGroup">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_job_group" :value="scope.row.jobGroup"/>
        </template>
      </el-table-column>
      <el-table-column label="gọi chuỗi mục tiêu" align="center" prop="invokeTarget" :show-overflow-tooltip="true" />
      <el-table-column label="cronthực hiện biểu thức" align="center" prop="cronExpression" :show-overflow-tooltip="true" />
      <el-table-column label="Trạng thái" align="center">
        <template slot-scope="scope">
          <el-switch
            v-model="scope.row.status"
            active-value="0"
            inactive-value="1"
            @change="handleStatusChange(scope.row)"
          ></el-switch>
        </template>
      </el-table-column>
      <el-table-column label="Thao tác" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['monitor:job:edit']"
          >Sửa</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['monitor:job:remove']"
          >Xóa</el-button>
          <el-dropdown size="mini" @command="(command) => handleCommand(command, scope.row)" v-hasPermi="['monitor:job:changeStatus', 'monitor:job:query']">
            <el-button size="mini" type="text" icon="el-icon-d-arrow-right">Thêm</el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="handleRun" icon="el-icon-caret-right"
                v-hasPermi="['monitor:job:changeStatus']">Thực hiện một lần</el-dropdown-item>
              <el-dropdown-item command="handleView" icon="el-icon-view"
                v-hasPermi="['monitor:job:query']">Chi tiết nhiệm vụ</el-dropdown-item>
              <el-dropdown-item command="handleJobLog" icon="el-icon-s-operation"
                v-hasPermi="['monitor:job:query']">Nhật ký lịch trình</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
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

    <!-- thêm hoặcSửaHộp thoại tác vụ theo lịch trình -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="Tên nhiệm vụ" prop="jobName">
              <el-input v-model="form.jobName" placeholder="Vui lòng nhậpTên nhiệm vụ" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Nhóm nhiệm vụ" prop="jobGroup">
              <el-select v-model="form.jobGroup" placeholder="Vui lòng chọnNhóm nhiệm vụ">
                <el-option
                  v-for="dict in dict.type.sys_job_group"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item prop="invokeTarget">
              <span slot="label">
                phương thức gọi
                <el-tooltip placement="top">
                  <div slot="content">
                    BeanVí dụ cuộc gọi：ryTask.ryParams('ry')
                    <br />ClassVí dụ về cuộc gọi lớp：com.ruoyi.quartz.task.RyTask.ryParams('ry')
                    <br />Mô tả thông số：Chuỗi hỗ trợ，BooleanLoại，số nguyên dài，dấu phẩy động，số nguyên
                  </div>
                  <i class="el-icon-question"></i>
                </el-tooltip>
              </span>
              <el-input v-model="form.invokeTarget" placeholder="Vui lòng nhậpgọi chuỗi mục tiêu" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="cronsự biểu lộ" prop="cronExpression">
              <el-input v-model="form.cronExpression" placeholder="Vui lòng nhậpcronthực hiện biểu thức">
                <template slot="append">
                  <el-button type="primary" @click="handleShowCron">
                    Tạo biểu thức
                    <i class="el-icon-time el-icon--right"></i>
                  </el-button>
                </template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="24" v-if="form.jobId !== undefined">
            <el-form-item label="Trạng thái">
              <el-radio-group v-model="form.status">
                <el-radio
                  v-for="dict in dict.type.sys_job_status"
                  :key="dict.value"
                  :label="dict.value"
                >{{dict.label}}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="chiến lược thực hiện" prop="misfirePolicy">
              <el-radio-group v-model="form.misfirePolicy" size="small">
                <el-radio-button label="1">Thực hiện ngay lập tức</el-radio-button>
                <el-radio-button label="2">Thực hiện một lần</el-radio-button>
                <el-radio-button label="3">Từ bỏ việc thực hiện</el-radio-button>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="CóKhôngđồng thời" prop="concurrent">
              <el-radio-group v-model="form.concurrent" size="small">
                <el-radio-button label="0">cho phép</el-radio-button>
                <el-radio-button label="1">cấm</el-radio-button>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">Xác nhận</el-button>
        <el-button @click="cancel">Hủy</el-button>
      </div>
    </el-dialog>

    <el-dialog title="Crontrình tạo biểu thức" :visible.sync="openCron" append-to-body destroy-on-close class="scrollbar">
      <crontab @hide="openCron=false" @fill="crontabFill" :expression="expression"></crontab>
    </el-dialog>

    <!-- Chi tiết nhật ký tác vụ -->
    <el-dialog title="Chi tiết nhiệm vụ" :visible.sync="openView" width="700px" append-to-body>
      <el-form ref="form" :model="form" label-width="120px" size="mini">
        <el-row>
          <el-col :span="12">
            <el-form-item label="Số nhiệm vụ：">{{ form.jobId }}</el-form-item>
            <el-form-item label="Tên nhiệm vụ：">{{ form.jobName }}</el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Nhóm nhiệm vụ：">{{ jobGroupFormat(form) }}</el-form-item>
            <el-form-item label="Ngày tạo：">{{ form.createTime }}</el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="cronsự biểu lộ：">{{ form.cronExpression }}</el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Lần thực hiện tiếp theo：">{{ parseTime(form.nextValidTime) }}</el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Gọi phương thức mục tiêu：">{{ form.invokeTarget }}</el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Nhiệm vụTrạng thái：">
              <div v-if="form.status == 0">Bình thường</div>
              <div v-else-if="form.status == 1">tạm dừng</div>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="CóKhôngđồng thời：">
              <div v-if="form.concurrent == 0">cho phép</div>
              <div v-else-if="form.concurrent == 1">cấm</div>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="chiến lược thực hiện：">
              <div v-if="form.misfirePolicy == 0">Chính sách mặc định</div>
              <div v-else-if="form.misfirePolicy == 1">Thực hiện ngay lập tức</div>
              <div v-else-if="form.misfirePolicy == 2">Thực hiện một lần</div>
              <div v-else-if="form.misfirePolicy == 3">Từ bỏ việc thực hiện</div>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="openView = false">đóng đóng</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listJob, getJob, delJob, addJob, updateJob, runJob, changeJobStatus } from "@/api/monitor/job";
import Crontab from '@/components/Crontab'

export default {
  components: { Crontab },
  name: "Job",
  dicts: ['sys_job_group', 'sys_job_status'],
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
      // Dữ liệu bảng nhiệm vụ theo lịch trình
      jobList: [],
      // Tiêu đề lớp bật lên
      title: "",
      // CóKhôngHiển thịlớp bật lên
      open: false,
      // CóKhôngHiển thịLớp bật lên chi tiết
      openView: false,
      // CóKhôngHiển thịCronLớp bật lên biểu thức
      openCron: false,
      // biểu thức được truyền vào
      expression: "",
      // tham số truy vấn
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        jobName: undefined,
        jobGroup: undefined,
        status: undefined
      },
      // thông số biểu mẫu
      form: {},
      // xác nhận mẫu
      rules: {
        jobName: [
          { required: true, message: "Tên nhiệm vụ không được để trống", trigger: "blur" }
        ],
        invokeTarget: [
          { required: true, message: "Chuỗi mục tiêu đang gọi không được để trống", trigger: "blur" }
        ],
        cronExpression: [
          { required: true, message: "cronBiểu thức thực thi không được để trống", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** Truy vấn danh sách nhiệm vụ theo lịch trình */
    getList() {
      this.loading = true;
      listJob(this.queryParams).then(response => {
        this.jobList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // Dịch từ điển tên nhóm nhiệm vụ
    jobGroupFormat(row, column) {
      return this.selectDictLabel(this.dict.type.sys_job_group, row.jobGroup);
    },
    // HủyNút bấm
    cancel() {
      this.open = false;
      this.reset();
    },
    // hình thứcĐặt lại
    reset() {
      this.form = {
        jobId: undefined,
        jobName: undefined,
        jobGroup: undefined,
        invokeTarget: undefined,
        cronExpression: undefined,
        misfirePolicy: 1,
        concurrent: 1,
        status: "0"
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
      this.ids = selection.map(item => item.jobId);
      this.single = selection.length != 1;
      this.multiple = !selection.length;
    },
    // ThêmThao táccò súng
    handleCommand(command, row) {
      switch (command) {
        case "handleRun":
          this.handleRun(row);
          break;
        case "handleView":
          this.handleView(row);
          break;
        case "handleJobLog":
          this.handleJobLog(row);
          break;
        default:
          break;
      }
    },
    // Nhiệm vụTrạng tháiSửa
    handleStatusChange(row) {
      let text = row.status === "0" ? "Kích hoạt" : "Hủy kích hoạt";
      this.$modal.confirm('Bạn có chắc chắn muốn"' + text + '""' + row.jobName + '"Nhiệm vụ?？').then(function() {
        return changeJobStatus(row.jobId, row.status);
      }).then(() => {
        this.$modal.msgSuccess(text + "Thành công");
      }).catch(function() {
        row.status = row.status === "0" ? "1" : "0";
      });
    },
    /* Thực hiện ngay lập tức một lần */
    handleRun(row) {
      this.$modal.confirm('Bạn có chắc chắn muốnThực hiện ngay lập tức một lần"' + row.jobName + '"Nhiệm vụ?？').then(function() {
        return runJob(row.jobId, row.jobGroup);
      }).then(() => {
        this.$modal.msgSuccess("thực hiệnThành công");
      }).catch(() => {});
    },
    /** Chi tiết nhiệm vụ */
    handleView(row) {
      getJob(row.jobId).then(response => {
        this.form = response.data;
        this.openView = true;
      });
    },
    /** cronsự biểu lộNút bấmThao tác */
    handleShowCron() {
      this.expression = this.form.cronExpression;
      this.openCron = true;
    },
    /** Xác nhậnGiá trị trả về sau */
    crontabFill(value) {
      this.form.cronExpression = value;
    },
    /** Truy vấn danh sách nhật ký tác vụ */
    handleJobLog(row) {
      const jobId = row.jobId || 0;
      this.$router.push('/monitor/job-log/index/' + jobId)
    },
    /** Thêm mớiNút bấmThao tác */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "Thêm nhiệm vụ";
    },
    /** SửaNút bấmThao tác */
    handleUpdate(row) {
      this.reset();
      const jobId = row.jobId || this.ids;
      getJob(jobId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "SửaNhiệm vụ";
      });
    },
    /** nộpNút bấm */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.jobId != undefined) {
            updateJob(this.form).then(response => {
              this.$modal.msgSuccess("Chỉnh sửa thành công");
              this.open = false;
              this.getList();
            });
          } else {
            addJob(this.form).then(response => {
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
      const jobIds = row.jobId || this.ids;
      this.$modal.confirm('Bạn có chắc chắn muốn xóaSố nhiệm vụ theo lịch trình là"' + jobIds + '" không?').then(function() {
        return delJob(jobIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("Xóa thành công");
      }).catch(() => {});
    },
    /** Xuất fileNút bấmThao tác */
    handleExport() {
      this.download('monitor/job/export', {
        ...this.queryParams
      }, `job_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
