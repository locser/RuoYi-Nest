<template>
  <!-- Tạo bảng -->
  <el-dialog title="Tạo bảng" :visible.sync="visible" width="800px" top="5vh" append-to-body>
    <span>Tạo câu lệnh bảng(Hỗ trợ nhiều câu lệnh tạo bảng)：</span>
    <el-input type="textarea" :rows="10" placeholder="Vui lòng nhậpchữ" v-model="content"></el-input>
    <div slot="footer" class="dialog-footer">
      <el-button type="primary" @click="handleCreateTable">Xác nhận</el-button>
      <el-button @click="visible = false">Hủy</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { createTable } from "@/api/tool/gen";
export default {
  data() {
    return {
      // lớp mặt nạ
      visible: false,
      // chữNội dung
      content: ""
    };
  },
  methods: {
    // Hiển thịHộp bật lên
    show() {
      this.visible = true;
    },
    /** tạo nênNút bấmThao tác */
    handleCreateTable() {
      if (this.content === "") {
        this.$modal.msgError("Vui lòng nhậpTạo câu lệnh bảng");
        return;
      }
      createTable({ sql: this.content }).then(res => {
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
