<template>
  <!-- 创建表 -->
  <el-dialog title="创建表" :visible.sync="visible" width="800px" top="5vh" append-to-body>
    <span>创建表语句(支持多个建表语句)：</span>
    <el-input type="textarea" :rows="10" placeholder="Vui lòng nhập文本" v-model="content"></el-input>
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
      // 遮罩层
      visible: false,
      // 文本Nội dung
      content: ""
    };
  },
  methods: {
    // Hiển thị弹框
    show() {
      this.visible = true;
    },
    /** 创建Nút bấmThao tác */
    handleCreateTable() {
      if (this.content === "") {
        this.$modal.msgError("Vui lòng nhập建表语句");
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
