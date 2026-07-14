<template>
  <div class="top-right-btn" :style="style">
    <el-row>
      <el-tooltip class="item" effect="dark" :content="showSearch ? 'ẨnTìm kiếm' : 'Hiển thịTìm kiếm'" placement="top" v-if="search">
        <el-button size="mini" circle icon="el-icon-search" @click="toggleSearch()" />
      </el-tooltip>
      <el-tooltip class="item" effect="dark" content="làm cho khỏe lại" placement="top">
        <el-button size="mini" circle icon="el-icon-refresh" @click="refresh()" />
      </el-tooltip>
      <el-tooltip class="item" effect="dark" content="Hiển thị và ẩn cột" placement="top" v-if="columns">
        <el-button size="mini" circle icon="el-icon-menu" @click="showColumn()" v-if="showColumnsType == 'transfer'"/>
        <el-dropdown trigger="click" :hide-on-click="false" style="padding-left: 12px" v-if="showColumnsType == 'checkbox'">
          <el-button size="mini" circle icon="el-icon-menu" />
          <el-dropdown-menu slot="dropdown">
            <template v-for="item in columns">
              <el-dropdown-item :key="item.key">
                <el-checkbox :checked="item.visible" @change="checkboxChange($event, item.label)" :label="item.label" />
              </el-dropdown-item>
            </template>
          </el-dropdown-menu>
        </el-dropdown>
      </el-tooltip>
    </el-row>
    <el-dialog :title="title" :visible.sync="open" append-to-body>
      <el-transfer
        :titles="['Hiển thị', 'Ẩn']"
        v-model="value"
        :data="columns"
        @change="dataChange"
      ></el-transfer>
    </el-dialog>
  </div>
</template>
<script>
export default {
  name: "RightToolbar",
  data() {
    return {
      // Dữ liệu rõ ràng
      value: [],
      // Tiêu đề lớp bật lên
      title: "Hiển thị/Ẩn",
      // CóKhôngHiển thịlớp bật lên
      open: false,
    };
  },
  props: {
    /* CóKhôngHiển thịĐiều kiện tìm kiếm */
    showSearch: {
      type: Boolean,
      default: true,
    },
    /* Hiển thị và ẩn thông tin cột */
    columns: {
      type: Array,
    },
    /* CóKhôngHiển thịBiểu tượng tìm kiếm */
    search: {
      type: Boolean,
      default: true,
    },
    /* Hiển thị và ẩn cộtLoại（transferhộp đưa đón、checkboxhộp kiểm） */
    showColumnsType: {
      type: String,
      default: "checkbox",
    },
    /* lề phải */
    gutter: {
      type: Number,
      default: 10,
    },
  },
  computed: {
    style() {
      const ret = {};
      if (this.gutter) {
        ret.marginRight = `${this.gutter / 2}px`;
      }
      return ret;
    }
  },
  created() {
    if (this.showColumnsType == 'transfer') {
      // Mặc định ban đầu cho các cột hiển thị và ẩnẨnDanh sách
      for (let item in this.columns) {
        if (this.columns[item].visible === false) {
          this.value.push(parseInt(item));
        }
      }
    }
  },
  methods: {
    // Tìm kiếm
    toggleSearch() {
      this.$emit("update:showSearch", !this.showSearch);
    },
    // làm cho khỏe lại
    refresh() {
      this.$emit("queryTable");
    },
    // Những thay đổi trong các thành phần danh sách ở bên phải
    dataChange(data) {
      for (let item in this.columns) {
        const key = this.columns[item].key;
        this.columns[item].visible = !data.includes(key);
      }
    },
    // Mở cột hiển thịdialog
    showColumn() {
      this.open = true;
    },
    // Kiểm tra
    checkboxChange(event, label) {
      this.columns.filter(item => item.label == label)[0].visible = event;
    }
  },
};
</script>
<style lang="scss" scoped>
:deep(.el-transfer__button) { 
  border-radius: 50%;
  padding: 12px;
  display: block;
  margin-left: 0px;
}
:deep(.el-transfer__button:first-child) {
  margin-bottom: 10px;
}
</style>
