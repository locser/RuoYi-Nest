<template>
  <el-form ref="form" :model="form" :rules="rules" label-width="80px">
    <el-form-item label="Tên hiển thị" prop="nickName">
      <el-input v-model="form.nickName" maxlength="30" />
    </el-form-item> 
    <el-form-item label="Số điện thoại" prop="phonenumber">
      <el-input v-model="form.phonenumber" maxlength="11" />
    </el-form-item>
    <el-form-item label="Email" prop="email">
      <el-input v-model="form.email" maxlength="50" />
    </el-form-item>
    <el-form-item label="giới tính">
      <el-radio-group v-model="form.sex">
        <el-radio label="0">Nam</el-radio>
        <el-radio label="1">Nữ</el-radio>
      </el-radio-group>
    </el-form-item>
    <el-form-item>
      <el-button type="primary" size="mini" @click="submit">Lưu</el-button>
      <el-button type="danger" size="mini" @click="close">Đóng</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import { updateUserProfile } from "@/api/system/user";

export default {
  props: {
    user: {
      type: Object
    }
  },
  data() {
    return {
      form: {},
      // xác nhận mẫu
      rules: {
        nickName: [
          { required: true, message: "Tên hiển thịkhông thể trống", trigger: "blur" }
        ],
        email: [
          { required: true, message: "EmailĐịa chỉ không thể trống", trigger: "blur" },
          {
            type: "email",
            message: "Vui lòng nhậpChính xácEmailĐịa chỉ",
            trigger: ["blur", "change"]
          }
        ],
        phonenumber: [
          { required: true, message: "Số điện thoạikhông thể trống", trigger: "blur" },
          {
            pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/,
            message: "Vui lòng nhậpChính xácSố điện thoại",
            trigger: "blur"
          }
        ]
      }
    };
  },
  watch: {
    user: {
      handler(user) {
        if (user) {
          this.form = { nickName: user.nickName, phonenumber: user.phonenumber, email: user.email, sex: user.sex };
        }
      },
      immediate: true
    }
  },
  methods: {
    submit() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          updateUserProfile(this.form).then(response => {
            this.$modal.msgSuccess("Chỉnh sửa thành công");
            this.user.phonenumber = this.form.phonenumber;
            this.user.email = this.form.email;
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
