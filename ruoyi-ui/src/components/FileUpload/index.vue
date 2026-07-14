<template>
  <div class="upload-file">
    <el-upload
      multiple
      :action="uploadFileUrl"
      :before-upload="handleBeforeUpload"
      :file-list="fileList"
      :limit="limit"
      :on-error="handleUploadError"
      :on-exceed="handleExceed"
      :on-success="handleUploadSuccess"
      :show-file-list="false"
      :headers="headers"
      class="upload-file-uploader"
      ref="fileUpload"
    >
      <!-- tải lênNút bấm -->
      <el-button size="mini" type="primary">Chọn tập tin</el-button>
      <!-- tải lênGợi ý -->
      <div class="el-upload__tip" slot="tip" v-if="showTip">
        Vui lòng tải lên
        <template v-if="fileSize"> Kích thước không vượt quá <b style="color: #f56c6c">{{ fileSize }}MB</b> </template>
        <template v-if="fileType"> Định dạng là <b style="color: #f56c6c">{{ fileType.join("/") }}</b> </template>
        tập tin
      </div>
    </el-upload>

    <!-- danh sách tập tin -->
    <transition-group class="upload-file-list el-upload-list el-upload-list--text" name="el-fade-in-linear" tag="ul">
      <li :key="file.url" class="el-upload-list__item ele-upload-list__item-content" v-for="(file, index) in fileList">
        <el-link :href="`${baseUrl}${file.url}`" :underline="false" target="_blank">
          <span class="el-icon-document"> {{ getFileName(file.name) }} </span>
        </el-link>
        <div class="ele-upload-list__item-content-action">
          <el-link :underline="false" @click="handleDelete(index)" type="danger">Xóa</el-link>
        </div>
      </li>
    </transition-group>
  </div>
</template>

<script>
import { getToken } from "@/utils/auth";

export default {
  name: "FileUpload",
  props: {
    // giá trị
    value: [String, Object, Array],
    // Giới hạn số lượng
    limit: {
      type: Number,
      default: 5,
    },
    // giới hạn kích thước(MB)
    fileSize: {
      type: Number,
      default: 5,
    },
    // tài liệuLoại, Ví dụ['png', 'jpg', 'jpeg']
    fileType: {
      type: Array,
      default: () => ["doc", "xls", "ppt", "txt", "pdf"],
    },
    // CóKhôngHiển thịGợi ý
    isShowTip: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      number: 0,
      uploadList: [],
      baseUrl: import.meta.env.VITE_APP_BASE_API,
      uploadFileUrl: import.meta.env.VITE_APP_BASE_API + "/common/upload", // Tải lên địa chỉ máy chủ tập tin
      headers: {
        Authorization: "Bearer " + getToken(),
      },
      fileList: [],
    };
  },
  watch: {
    value: {
      handler(val) {
        if (val) {
          let temp = 1;
          // Đầu tiên chuyển đổi giá trị thành một mảng
          const list = Array.isArray(val) ? val : this.value.split(',');
          // Sau đó chuyển đổi mảng thành một mảng đối tượng
          this.fileList = list.map(item => {
            if (typeof item === "string") {
              item = { name: item, url: item };
            }
            item.uid = item.uid || new Date().getTime() + temp++;
            return item;
          });
        } else {
          this.fileList = [];
          return [];
        }
      },
      deep: true,
      immediate: true
    }
  },
  computed: {
    // CóKhôngHiển thịGợi ý
    showTip() {
      return this.isShowTip && (this.fileType || this.fileSize);
    },
  },
  methods: {
    // Kiểm tra định dạng và kích thước trước khi tải lên
    handleBeforeUpload(file) {
      // Hiệu đính tài liệuLoại
      if (this.fileType) {
        const fileName = file.name.split('.');
        const fileExt = fileName[fileName.length - 1];
        const isTypeOk = this.fileType.indexOf(fileExt) >= 0;
        if (!isTypeOk) {
          this.$modal.msgError(`Định dạng tệp không chính xác，Vui lòng tải lên${this.fileType.join("/")}tập tin định dạng!`);
          return false;
        }
      }
      // Tên file chứng minhCóKhôngChứa ký tự đặc biệt
      if (file.name.includes(',')) {
        this.$modal.msgError('Tên tệp không chính xác，Không thể chứa dấu phẩy tiếng Anh!');
        return false;
      }
      // Kích thước tập tin bằng chứng
      if (this.fileSize) {
        const isLt = file.size / 1024 / 1024 < this.fileSize;
        if (!isLt) {
          this.$modal.msgError(`Kích thước tệp tải lên không thể vượt quá ${this.fileSize} MB!`);
          return false;
        }
      }
      this.$modal.loading("Đang tải tập tin lên，Vui lòng chờ...");
      this.number++;
      return true;
    },
    // Số lượng tập tin vượt quá
    handleExceed() {
      this.$modal.msgError(`Số lượng tập tin tải lên không thể vượt quá ${this.limit} cá nhân!`);
    },
    // tải lênThất bại
    handleUploadError(err) {
      this.$modal.msgError("Tải tập tin lênThất bại，Vui lòng thử lại");
      this.$modal.closeLoading();
    },
    // tải lênThành cônggọi lại
    handleUploadSuccess(res, file) {
      if (res.code === 200) {
        this.uploadList.push({ name: res.fileName, url: res.fileName });
        this.uploadedSuccessfully();
      } else {
        this.number--;
        this.$modal.closeLoading();
        this.$modal.msgError(res.msg);
        this.$refs.fileUpload.handleRemove(file);
        this.uploadedSuccessfully();
      }
    },
    // Xóatài liệu
    handleDelete(index) {
      this.fileList.splice(index, 1);
      this.$emit("input", this.listToString(this.fileList));
    },
    // Tải lên quá trình xử lý cuối cùng
    uploadedSuccessfully() {
      if (this.number > 0 && this.uploadList.length === this.number) {
        this.fileList = this.fileList.concat(this.uploadList);
        this.uploadList = [];
        this.number = 0;
        this.$emit("input", this.listToString(this.fileList));
        this.$modal.closeLoading();
      }
    },
    // Lấy tên tập tin
    getFileName(name) {
      // nếu nhưCóurlSau đó lấy họ nếu khôngCótrực tiếpQuay lại
      if (name.lastIndexOf("/") > -1) {
        return name.slice(name.lastIndexOf("/") + 1);
      } else {
        return name;
      }
    },
    // Chuyển đổi đối tượng thành chuỗi đã chỉ định được phân cách
    listToString(list, separator) {
      let strs = "";
      separator = separator || ",";
      for (let i in list) {
        strs += list[i].url + separator;
      }
      return strs != '' ? strs.substr(0, strs.length - 1) : '';
    }
  }
};
</script>

<style scoped lang="scss">
.upload-file-uploader {
  margin-bottom: 5px;
}
.upload-file-list .el-upload-list__item {
  border: 1px solid #e4e7ed;
  line-height: 2;
  margin-bottom: 10px;
  position: relative;
}
.upload-file-list .ele-upload-list__item-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: inherit;
}
.ele-upload-list__item-content-action .el-link {
  margin-right: 10px;
}
</style>
