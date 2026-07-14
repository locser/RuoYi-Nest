<template>
  <el-form ref="basicInfoForm" :model="info" :rules="rules" label-width="150px">
    <el-row>
      <el-col :span="12">
        <el-form-item label="tên bảng" prop="tableName">
          <el-input placeholder="Vui lòng nhậpTên kho" v-model="info.tableName" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="Mô tả bảng" prop="tableComment">
          <el-input placeholder="Vui lòng nhập" v-model="info.tableComment" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="Tên lớp thực thể" prop="className">
          <el-input placeholder="Vui lòng nhập" v-model="info.className" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="tác giả" prop="functionAuthor">
          <el-input placeholder="Vui lòng nhập" v-model="info.functionAuthor" />
        </el-form-item>
      </el-col>
      <el-col :span="24">
        <el-form-item label="Ghi chú" prop="remark">
          <el-input type="textarea" :rows="3" v-model="info.remark"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
export default {
  props: {
    info: {
      type: Object,
      default: null
    }
  },
  data() {
    return {
      rules: {
        tableName: [
          { required: true, message: "Vui lòng nhậptên bảng", trigger: "blur" }
        ],
        tableComment: [
          { required: true, message: "Vui lòng nhậpMô tả bảng", trigger: "blur" }
        ],
        className: [
          { required: true, message: "Vui lòng nhậpTên lớp thực thể", trigger: "blur" }
        ],
        functionAuthor: [
          { required: true, message: "Vui lòng nhậptác giả", trigger: "blur" }
        ]
      }
    };
  }
};
</script>
