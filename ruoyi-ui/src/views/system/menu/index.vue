<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
      <el-form-item label="Tên menu" prop="menuName">
        <el-input
          v-model="queryParams.menuName"
          placeholder="Vui lòng nhậpTên menu"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="Trạng thái" prop="status">
        <el-select v-model="queryParams.status" placeholder="MenuTrạng thái" clearable>
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
          v-hasPermi="['system:menu:add']"
        >Thêm mới</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-sort"
          size="mini"
          @click="toggleExpandAll"
        >Mở rộng/Thu gọn</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table
      v-if="refreshTable"
      v-loading="loading"
      :data="menuList"
      row-key="menuId"
      :default-expand-all="isExpandAll"
      :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
    >
      <el-table-column prop="menuName" label="Tên menu" :show-overflow-tooltip="true" width="160"></el-table-column>
      <el-table-column prop="icon" label="biểu tượng" align="center" width="100">
        <template slot-scope="scope">
          <svg-icon :icon-class="scope.row.icon" />
        </template>
      </el-table-column>
      <el-table-column prop="orderNum" label="Sắp xếp" width="60"></el-table-column>
      <el-table-column prop="perms" label="Key quyền hạn" :show-overflow-tooltip="true"></el-table-column>
      <el-table-column prop="component" label="Đường dẫn component" :show-overflow-tooltip="true"></el-table-column>
      <el-table-column prop="status" label="Trạng thái" width="80">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="Ngày tạo" align="center" prop="createTime">
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
            v-hasPermi="['system:menu:edit']"
          >Sửa</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-plus"
            @click="handleAdd(scope.row)"
            v-hasPermi="['system:menu:add']"
          >Thêm mới</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:menu:remove']"
          >Xóa</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- thêm hoặcSửa menuhộp thoại -->
    <el-dialog :title="title" :visible.sync="open" width="680px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="Menu cấp trên" prop="parentId">
              <treeselect
                v-model="form.parentId"
                :options="menuOptions"
                :normalizer="normalizer"
                :show-count="true"
                placeholder="chọnMenu cấp trên"
              />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="Loại menu" prop="menuType">
              <el-radio-group v-model="form.menuType">
                <el-radio label="M">Thư mục</el-radio>
                <el-radio label="C">Menu</el-radio>
                <el-radio label="F">Nút bấm</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24" v-if="form.menuType != 'F'">
            <el-form-item label="Icon menu" prop="icon">
              <el-popover
                placement="bottom-start"
                width="460"
                trigger="click"
                @show="$refs['iconSelect'].reset()"
              >
                <IconSelect ref="iconSelect" @selected="selected" :active-icon="form.icon" />
                <el-input slot="reference" v-model="form.icon" placeholder="Bấm vào biểu tượng chọn" readonly>
                  <svg-icon
                    v-if="form.icon"
                    slot="prefix"
                    :icon-class="form.icon"
                    style="width: 25px;"
                  />
                  <i v-else slot="prefix" class="el-icon-search el-input__icon" />
                </el-input>
              </el-popover>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Tên menu" prop="menuName">
              <el-input v-model="form.menuName" placeholder="Vui lòng nhậpTên menu" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="Thứ tự hiển thị" prop="orderNum">
              <el-input-number v-model="form.orderNum" controls-position="right" :min="0" />
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType != 'F'">
            <el-form-item prop="isFrame">
              <span slot="label">
                <el-tooltip content="chọnCóQuy tắc liên kết bên ngoàiĐường dẫn routecần phải`http(s)://`sự khởi đầu" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Là link ngoài
              </span>
              <el-radio-group v-model="form.isFrame">
                <el-radio label="0">Có</el-radio>
                <el-radio label="1">Không</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType != 'F'">
            <el-form-item prop="path">
              <span slot="label">
                <el-tooltip content="đã đến thămĐường dẫn route，giống：`user`，Nếu địa chỉ mạng bên ngoài yêu cầu truy cập liên kết nội bộ, hãy sử dụng`http(s)://`sự khởi đầu" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Đường dẫn route
              </span>
              <el-input v-model="form.path" placeholder="Vui lòng nhập đường dẫn route" />
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType == 'C'">
            <el-form-item prop="component">
              <span slot="label">
                <el-tooltip content="đã đến thămĐường dẫn component，giống：`system/user/index`，Mặc định trong`views`Thư mụcXuống" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Đường dẫn component
              </span>
              <el-input v-model="form.component" placeholder="Vui lòng nhập đường dẫn component" />
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType != 'M'">
            <el-form-item prop="perms">
              <el-input v-model="form.perms" placeholder="Vui lòng nhậpKey quyền hạn" maxlength="100" />
              <span slot="label">
                <el-tooltip content="được xác định trong bộ điều khiểnKey quyền hạn，giống：@PreAuthorize(`@ss.hasPermi('system:user:list')`)" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Key quyền hạn
              </span>
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType == 'C'">
            <el-form-item prop="query">
              <el-input v-model="form.query" placeholder="Vui lòng nhập tham số route" maxlength="255" />
              <span slot="label">
                <el-tooltip content='Các tham số truyền mặc định cho các tuyến truy cập，giống：`{"id": 1, "name": "ry"}`' placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Tham số route
              </span>
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType == 'C'">
            <el-form-item prop="isCache">
              <span slot="label">
                <el-tooltip content="chọnCósẽ được`keep-alive`bộ nhớ đệm，Yêu cầu các thành phần phù hợp`name`Hãy nhất quán với địa chỉ" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Có cache
              </span>
              <el-radio-group v-model="form.isCache">
                <el-radio label="0">bộ nhớ đệm</el-radio>
                <el-radio label="1">Không lưu vào bộ nhớ đệm</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType != 'F'">
            <el-form-item prop="visible">
              <span slot="label">
                <el-tooltip content="chọnẨnthì tuyến đường sẽ không xuất hiện trong thanh bên，nhưng vẫn có thể truy cập được" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                Trạng thái hiển thị
              </span>
              <el-radio-group v-model="form.visible">
                <el-radio
                  v-for="dict in dict.type.sys_show_hide"
                  :key="dict.value"
                  :label="dict.value"
                >{{dict.label}}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item prop="status">
              <span slot="label">
                <el-tooltip content="chọnHủy kích hoạtthì tuyến đường sẽ không xuất hiện trong thanh bên，nó cũng không thể truy cập được" placement="top">
                <i class="el-icon-question"></i>
                </el-tooltip>
                MenuTrạng thái
              </span>
              <el-radio-group v-model="form.status">
                <el-radio
                  v-for="dict in dict.type.sys_normal_disable"
                  :key="dict.value"
                  :label="dict.value"
                >{{dict.label}}</el-radio>
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
  </div>
</template>

<script>
import { listMenu, getMenu, delMenu, addMenu, updateMenu } from "@/api/system/menu";
import Treeselect from "@riophae/vue-treeselect";
import "@riophae/vue-treeselect/dist/vue-treeselect.css";
import IconSelect from "@/components/IconSelect";

export default {
  name: "Menu",
  dicts: ['sys_show_hide', 'sys_normal_disable'],
  components: { Treeselect, IconSelect },
  data() {
    return {
      // lớp mặt nạ
      loading: true,
      // Hiển thịTìm kiếmtình trạng
      showSearch: true,
      // Menudữ liệu cây bảng
      menuList: [],
      // Menutùy chọn cây
      menuOptions: [],
      // Tiêu đề lớp bật lên
      title: "",
      // CóKhôngHiển thịlớp bật lên
      open: false,
      // CóKhôngMở rộng，mặc địnhThu gọn tất cả
      isExpandAll: false,
      // Kết xuất lại bảngTrạng thái
      refreshTable: true,
      // tham số truy vấn
      queryParams: {
        menuName: undefined,
        visible: undefined
      },
      // thông số biểu mẫu
      form: {},
      // xác nhận mẫu
      rules: {
        menuName: [
          { required: true, message: "Tên menukhông thể trống", trigger: "blur" }
        ],
        orderNum: [
          { required: true, message: "MenuĐơn hàng không thể trống", trigger: "blur" }
        ],
        path: [
          { required: true, message: "Đường dẫn routekhông thể trống", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    // Chọn biểu tượng
    selected(name) {
      this.form.icon = name;
    },
    /** Truy vấnMenudanh sách */
    getList() {
      this.loading = true;
      listMenu(this.queryParams).then(response => {
        this.menuList = this.handleTree(response.data, "menuId");
        this.loading = false;
      });
    },
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
    /** Truy vấnMenuCấu trúc cây thả xuống */
    getTreeselect() {
      listMenu().then(response => {
        this.menuOptions = [];
        const menu = { menuId: 0, menuName: 'danh mục chính', children: [] };
        menu.children = this.handleTree(response.data, "menuId");
        this.menuOptions.push(menu);
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
        menuId: undefined,
        parentId: 0,
        menuName: undefined,
        icon: undefined,
        menuType: "M",
        orderNum: undefined,
        isFrame: "1",
        isCache: "0",
        visible: "0",
        status: "0"
      };
      this.resetForm("form");
    },
    /** Tìm kiếmNút bấmThao tác */
    handleQuery() {
      this.getList();
    },
    /** Đặt lạiNút bấmThao tác */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** Thêm mớiNút bấmThao tác */
    handleAdd(row) {
      this.reset();
      this.getTreeselect();
      if (row != null && row.menuId) {
        this.form.parentId = row.menuId;
      } else {
        this.form.parentId = 0;
      }
      this.open = true;
      this.title = "Thêm menu";
    },
    /** Mở rộng/Thu gọnThao tác */
    toggleExpandAll() {
      this.refreshTable = false;
      this.isExpandAll = !this.isExpandAll;
      this.$nextTick(() => {
        this.refreshTable = true;
      });
    },
    /** SửaNút bấmThao tác */
    handleUpdate(row) {
      this.reset();
      this.getTreeselect();
      getMenu(row.menuId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "Sửa menu";
      });
    },
    /** nộpNút bấm */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.menuId != undefined) {
            updateMenu(this.form).then(response => {
              this.$modal.msgSuccess("Chỉnh sửa thành công");
              this.open = false;
              this.getList();
            });
          } else {
            addMenu(this.form).then(response => {
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
      this.$modal.confirm('Bạn có chắc chắn muốn xóaTên là"' + row.menuName + '" không?').then(function() {
        return delMenu(row.menuId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("Xóa thành công");
      }).catch(() => {});
    }
  }
};
</script>
