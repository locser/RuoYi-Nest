<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="Thao tác地址" prop="operIp">
        <el-input
          v-model="queryParams.operIp"
          placeholder="Vui lòng nhậpThao tác地址"
          clearable
          style="width: 240px;"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="系统模块" prop="title">
        <el-input
          v-model="queryParams.title"
          placeholder="Vui lòng nhập系统模块"
          clearable
          style="width: 240px;"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Người thực hiện" prop="operName">
        <el-input
          v-model="queryParams.operName"
          placeholder="Vui lòng nhậpNgười thực hiện"
          clearable
          style="width: 240px;"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Loại" prop="businessType">
        <el-select
          v-model="queryParams.businessType"
          placeholder="Thao tácLoại"
          clearable
          style="width: 240px"
        >
          <el-option
            v-for="dict in dict.type.sys_oper_type"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="Trạng thái" prop="status">
        <el-select
          v-model="queryParams.status"
          placeholder="Trạng thái hoạt động"
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
          value-format="yyyy-MM-dd HH:mm:ss"
          type="daterange"
          range-separator="-"
          start-placeholder="Từ ngày"
          end-placeholder="Đến ngày"
          :default-time="['00:00:00', '23:59:59']"
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
          v-hasPermi="['monitor:operlog:remove']"
        >Xóa</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          @click="handleClean"
          v-hasPermi="['monitor:operlog:remove']"
        >Xóa sạch</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['monitor:operlog:export']"
        >Xuất file</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table ref="tables" v-loading="loading" :data="list" @selection-change="handleSelectionChange" :default-sort="defaultSort" @sort-change="handleSortChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="日志编号" align="center" prop="operId" />
      <el-table-column label="系统模块" align="center" prop="title" :show-overflow-tooltip="true" />
      <el-table-column label="Thao tácLoại" align="center" prop="businessType">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_oper_type" :value="scope.row.businessType"/>
        </template>
      </el-table-column>
      <el-table-column label="Người thực hiện" align="center" prop="operName" width="110" :show-overflow-tooltip="true" sortable="custom" :sort-orders="['descending', 'ascending']" />
      <el-table-column label="Thao tác地址" align="center" prop="operIp" width="130" :show-overflow-tooltip="true" />
      <el-table-column label="Địa điểm thao tác" align="center" prop="operLocation" :show-overflow-tooltip="true" />
      <el-table-column label="Trạng thái hoạt động" align="center" prop="status">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_common_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="Thao tác日期" align="center" prop="operTime" width="160" sortable="custom" :sort-orders="['descending', 'ascending']">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.operTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="Thời gian tiêu hao" align="center" prop="costTime" width="110" :show-overflow-tooltip="true" sortable="custom" :sort-orders="['descending', 'ascending']">
        <template slot-scope="scope">
          <span>{{ scope.row.costTime }}毫秒</span>
        </template>
      </el-table-column>
      <el-table-column label="Thao tác" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView(scope.row,scope.index)"
            v-hasPermi="['monitor:operlog:query']"
          >详细</el-button>
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

    <!-- Thao tác日志详细 -->
    <el-dialog title="Thao tác日志详细" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" label-width="100px" size="mini">
        <el-row>
          <el-col :span="12">
            <el-form-item label="Thao tác模块：">{{ form.title }} / {{ typeFormat(form) }}</el-form-item>
            <el-form-item
              label="登录信息："
            >{{ form.operName }} / {{ form.operIp }} / {{ form.operLocation }}</el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="请求地址：">{{ form.operUrl }}</el-form-item>
            <el-form-item label="Phương thức yêu cầu：">{{ form.requestMethod }}</el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Thao tác方法：">{{ form.method }}</el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Tham số yêu cầu：">{{ form.operParam }}</el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Tham số phản hồi：">{{ form.jsonResult }}</el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Trạng thái hoạt động：">
              <div v-if="form.status === 0">Bình thường</div>
              <div v-else-if="form.status === 1">Thất bại</div>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Thời gian tiêu hao：">{{ form.costTime }}毫秒</el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Thời gian thực hiện：">{{ parseTime(form.operTime) }}</el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="异常信息：" v-if="form.status === 1">{{ form.errorMsg }}</el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="open = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { list, delOperlog, cleanOperlog } from "@/api/monitor/operlog";

export default {
  name: "Operlog",
  dicts: ['sys_oper_type', 'sys_common_status'],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非多个禁用
      multiple: true,
      // Hiển thịTìm kiếm条件
      showSearch: true,
      // 总条数
      total: 0,
      // 表格数据
      list: [],
      // CóKhôngHiển thị弹出层
      open: false,
      // 日期范围
      dateRange: [],
      // 默认Sắp xếp
      defaultSort: {prop: 'operTime', order: 'descending'},
      // 表单参数
      form: {},
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        operIp: undefined,
        title: undefined,
        operName: undefined,
        businessType: undefined,
        status: undefined
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询登录日志 */
    getList() {
      this.loading = true;
      list(this.addDateRange(this.queryParams, this.dateRange)).then( response => {
          this.list = response.rows;
          this.total = response.total;
          this.loading = false;
        }
      );
    },
    // Thao tác日志Loại字典翻译
    typeFormat(row, column) {
      return this.selectDictLabel(this.dict.type.sys_oper_type, row.businessType);
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
      this.queryParams.pageNum = 1;
      this.$refs.tables.sort(this.defaultSort.prop, this.defaultSort.order)
    },
    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.operId)
      this.multiple = !selection.length
    },
    /** Sắp xếp触发事件 */
    handleSortChange(column, prop, order) {
      this.queryParams.orderByColumn = column.prop;
      this.queryParams.isAsc = column.order;
      this.getList();
    },
    /** 详细Nút bấmThao tác */
    handleView(row) {
      this.open = true;
      this.form = row;
    },
    /** XóaNút bấmThao tác */
    handleDelete(row) {
      const operIds = row.operId || this.ids;
      this.$modal.confirm('Bạn có chắc chắn muốn xóa日志编号为"' + operIds + '" không?').then(function() {
        return delOperlog(operIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("Xóa thành công");
      }).catch(() => {});
    },
    /** Xóa sạchNút bấmThao tác */
    handleClean() {
      this.$modal.confirm('CóKhông确认Xóa sạch所有Thao tác日志数据项？').then(function() {
        return cleanOperlog();
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("Xóa sạch thành công");
      }).catch(() => {});
    },
    /** Xuất fileNút bấmThao tác */
    handleExport() {
      this.download('monitor/operlog/export', {
        ...this.queryParams
      }, `operlog_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

