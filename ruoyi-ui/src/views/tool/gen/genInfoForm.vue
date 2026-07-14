<template>
  <el-form ref="genInfoForm" :model="info" :rules="rules" label-width="150px">
    <el-row>
      <el-col :span="12">
        <el-form-item prop="tplCategory">
          <span slot="label">Tạo mẫu</span>
          <el-select v-model="info.tplCategory" @change="tplSelectChange">
            <el-option label="Bàn đơn（Thêm, xóa, sửa đổi và kiểm tra）" value="crud" />
            <el-option label="bàn cây（Thêm, xóa, sửa đổi và kiểm tra）" value="tree" />
            <el-option label="Bàn chính và bàn con（Thêm, xóa, sửa đổi và kiểm tra）" value="sub" />
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item prop="tplWebType">
          <span slot="label">giao diện người dùngLoại</span>
          <el-select v-model="info.tplWebType">
            <el-option label="Vue2 Element UI giấy nến" value="element-ui" />
            <el-option label="Vue3 Element Plus giấy nến" value="element-plus" />
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item prop="packageName">
          <span slot="label">
            Tạo đường dẫn gói
            <el-tooltip content="Nó được tạo theo mô-đun gốc nào?，Ví dụ ruoyi-system" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-input v-model="info.packageName" />
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <el-form-item prop="moduleName">
          <span slot="label">
            Tạo tên mô-đun
            <el-tooltip content="Có thể hiểu là tên hệ thống con，Ví dụ system" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-input v-model="info.moduleName" />
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <el-form-item prop="businessName">
          <span slot="label">
            Tạo tên doanh nghiệp
            <el-tooltip content="Có thể hiểu là tên tiếng Anh của hàm，Ví dụ user" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-input v-model="info.businessName" />
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <el-form-item prop="functionName">
          <span slot="label">
            sinhThành côngCó thể đặt tên
            <el-tooltip content="được sử dụng làm mô tả lớp，Ví dụ người dùng" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-input v-model="info.functionName" />
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <el-form-item prop="genType">
          <span slot="label">
            Cách tạo mã
            <el-tooltip content="Mặc định làzipTải xuống gói nén，Bạn cũng có thể tùy chỉnh đường dẫn thế hệ" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-radio v-model="info.genType" label="0">zipGói nén</el-radio>
          <el-radio v-model="info.genType" label="1">đường dẫn tùy chỉnh</el-radio>
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            Menu cấp trên
            <el-tooltip content="Được giao cho chỉ địnhMenuXuống，Ví dụ Quản lý hệ thống" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <treeselect
            :append-to-body="true"
            v-model="info.parentMenuId"
            :options="menus"
            :normalizer="normalizer"
            :show-count="true"
            placeholder="Vui lòng chọnhệ thốngMenu"
          />
        </el-form-item>
      </el-col>

      <el-col :span="24" v-if="info.genType == '1'">
        <el-form-item prop="genPath">
          <span slot="label">
            đường dẫn tùy chỉnh
            <el-tooltip content="Điền đường dẫn tuyệt đối vào đĩa，Nếu không điền vào，sau đó tạo ra hiện tạiWebthuộc dự án" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-input v-model="info.genPath">
            <el-dropdown slot="append">
              <el-button type="primary">
                Lựa chọn nhanh các tuyến đường gần đây
                <i class="el-icon-arrow-down el-icon--right"></i>
              </el-button>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item @click.native="info.genPath = '/'">Khôi phục đường dẫn cơ sở xây dựng mặc định</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <el-row v-show="info.tplCategory == 'tree'">
      <h4 class="form-header">Thông tin khác</h4>
      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            trường mã hóa cây
            <el-tooltip content="CâyHiển thịtên trường được mã hóa， giống：dept_id" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-select v-model="info.treeCode" placeholder="Vui lòng chọn">
            <el-option
              v-for="(column, index) in info.columns"
              :key="index"
              :label="column.columnName + '：' + column.columnComment"
              :value="column.columnName"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            trường mã hóa cây gốc
            <el-tooltip content="CâyHiển thịtên trường được mã hóa gốc， giống：parent_Id" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-select v-model="info.treeParentCode" placeholder="Vui lòng chọn">
            <el-option
              v-for="(column, index) in info.columns"
              :key="index"
              :label="column.columnName + '：' + column.columnComment"
              :value="column.columnName"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            trường tên cây
            <el-tooltip content="nút câyHiển thịTên trường tên， giống：dept_name" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-select v-model="info.treeName" placeholder="Vui lòng chọn">
            <el-option
              v-for="(column, index) in info.columns"
              :key="index"
              :label="column.columnName + '：' + column.columnComment"
              :value="column.columnName"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row v-show="info.tplCategory == 'sub'">
      <h4 class="form-header">Thông tin liên quan</h4>
      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            Tên bảng của bảng phụ liên quan
            <el-tooltip content="Tên bảng của bảng phụ liên quan， giống：sys_user" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-select v-model="info.subTableName" placeholder="Vui lòng chọn" @change="subSelectChange">
            <el-option
              v-for="(table, index) in tables"
              :key="index"
              :label="table.tableName + '：' + table.tableComment"
              :value="table.tableName"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item>
          <span slot="label">
            Tên khóa ngoại được liên kết với bảng phụ
            <el-tooltip content="Tên khóa ngoại được liên kết với bảng phụ， giống：user_id" placement="top">
              <i class="el-icon-question"></i>
            </el-tooltip>
          </span>
          <el-select v-model="info.subTableFkName" placeholder="Vui lòng chọn">
            <el-option
              v-for="(column, index) in subColumns"
              :key="index"
              :label="column.columnName + '：' + column.columnComment"
              :value="column.columnName"
            ></el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
import Treeselect from "@riophae/vue-treeselect";
import "@riophae/vue-treeselect/dist/vue-treeselect.css";

export default {
  components: { Treeselect },
  props: {
    info: {
      type: Object,
      default: null
    },
    tables: {
      type: Array,
      default: null
    },
    menus: {
      type: Array,
      default: []
    },
  },
  data() {
    return {
      subColumns: [],
      rules: {
        tplCategory: [
          { required: true, message: "Vui lòng chọnTạo mẫu", trigger: "blur" }
        ],
        packageName: [
          { required: true, message: "Vui lòng nhậpTạo đường dẫn gói", trigger: "blur" }
        ],
        moduleName: [
          { required: true, message: "Vui lòng nhậpTạo tên mô-đun", trigger: "blur" }
        ],
        businessName: [
          { required: true, message: "Vui lòng nhậpTạo tên doanh nghiệp", trigger: "blur" }
        ],
        functionName: [
          { required: true, message: "Vui lòng nhậpsinhThành côngCó thể đặt tên", trigger: "blur" }
        ],
      }
    };
  },
  watch: {
    'info.subTableName': function(val) {
      this.setSubTableColumns(val);
    },
    'info.tplWebType': function(val) {
      if (val === '') {
        this.info.tplWebType = "element-ui";
      }
    }
  },
  methods: {
    /** Chuyển thànhMenucấu trúc dữ liệu */
    normalizer(node) {
      if (node.children && !node.children.length) {
        delete node.children;
      }
      return {
        id: node.menuId,
        label: node.menuName,
        children: node.children
      };
    },
    /** Chọn tên bảng phụ để kích hoạt */
    subSelectChange(value) {
      this.info.subTableFkName = '';
    },
    /** Chọn Tạo trình kích hoạt mẫu */
    tplSelectChange(value) {
      if(value !== 'sub') {
        this.info.subTableName = '';
        this.info.subTableFkName = '';
      }
    },
    /** Đặt khóa ngoại liên quan */
    setSubTableColumns(value) {
      for (var item in this.tables) {
        const name = this.tables[item].tableName;
        if (value === name) {
          this.subColumns = this.tables[item].columns;
          break;
        }
      }
    }
  }
};
</script>
