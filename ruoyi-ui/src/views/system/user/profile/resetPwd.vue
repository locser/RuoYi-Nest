<template>
  <el-form ref="form" :model="user" :rules="rules" label-width="80px">
    <el-form-item label="Mật khẩu cũ" prop="oldPassword">
      <el-input v-model="user.oldPassword" placeholder="Vui lòng nhập mật khẩu cũ" type="password" show-password/>
    </el-form-item>
    <el-form-item label="Mật khẩu mới" prop="newPassword">
      <el-input v-model="user.newPassword" placeholder="Vui lòng nhập mật khẩu mới" type="password" show-password/>
    </el-form-item>
    <el-form-item label="Xác nhận mật khẩu" prop="confirmPassword">
      <el-input v-model="user.confirmPassword" placeholder="请确认Mật khẩu mới" type="password" show-password/>
    </el-form-item>
    <el-form-item>
      <el-button type="primary" size="mini" @click="submit">Lưu</el-button>
      <el-button type="danger" size="mini" @click="close">Đóng</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import { updateUserPwd } from "@/api/system/user";

export default {
  data() {
    const equalToPassword = (rule, value, callback) => {
      if (this.user.newPassword !== value) {
        callback(new Error("两次输入的密码不一致"));
      } else {
        callback();
      }
    };
    return {
      user: {
        oldPassword: undefined,
        newPassword: undefined,
        confirmPassword: undefined
      },
      // 表单校验
      rules: {
        oldPassword: [
          { required: true, message: "Mật khẩu cũ不能为空", trigger: "blur" }
        ],
        newPassword: [
          { required: true, message: "Mật khẩu mới不能为空", trigger: "blur" },
          { min: 6, max: 20, message: "长度在 6 到 20 个字符", trigger: "blur" },
          { pattern: /^[^<>"'|\\]+$/, message: "Không được chứa ký tự đặc biệt：< > \" ' \\\ |", trigger: "blur" }
        ],
        confirmPassword: [
          { required: true, message: "Xác nhận mật khẩu不能为空", trigger: "blur" },
          { required: true, validator: equalToPassword, trigger: "blur" }
        ]
      }
    };
  },
  methods: {
    submit() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          updateUserPwd(this.user.oldPassword, this.user.newPassword).then(response => {
            this.$modal.msgSuccess("Chỉnh sửa thành công");
          });
        }
      });
    },
    close() {
      this.$tab.closePage();
    }
  }
};
</script>
