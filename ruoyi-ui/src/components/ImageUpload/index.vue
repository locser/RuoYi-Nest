<template>
  <div class="component-upload-image">
    <el-upload
      multiple
      :action="uploadImgUrl"
      list-type="picture-card"
      :on-success="handleUploadSuccess"
      :before-upload="handleBeforeUpload"
      :limit="limit"
      :on-error="handleUploadError"
      :on-exceed="handleExceed"
      ref="imageUpload"
      :on-remove="handleDelete"
      :show-file-list="true"
      :headers="headers"
      :file-list="fileList"
      :on-preview="handlePictureCardPreview"
      :class="{hide: this.fileList.length >= this.limit}"
    >
      <i class="el-icon-plus"></i>
    </el-upload>

    <!-- tải lênGợi ý -->
    <div class="el-upload__tip" slot="tip" v-if="showTip">
      Vui lòng tải lên
      <template v-if="fileSize"> Kích thước không vượt quá <b style="color: #f56c6c">{{ fileSize }}MB</b> </template>
      <template v-if="fileType"> Định dạng là <b style="color: #f56c6c">{{ fileType.join("/") }}</b> </template>
      tập tin
    </div>

    <el-dialog
      :visible.sync="dialogVisible"
      title="Xem trước"
      width="800"
      append-to-body
    >
      <img
        :src="dialogImageUrl"
        style="display: block; max-width: 100%; margin: 0 auto"
      />
    </el-dialog>
  </div>
</template>

<script>
import { getToken } from "@/utils/auth";
import { isExternal } from "@/utils/validate";

export default {
  props: {
    value: [String, Object, Array],
    // Giới hạn số lượng hình ảnh
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
      default: () => ["png", "jpg", "jpeg"],
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
      dialogImageUrl: "",
      dialogVisible: false,
      hideUpload: false,
      baseUrl: import.meta.env.VITE_APP_BASE_API,
      uploadImgUrl: import.meta.env.VITE_APP_BASE_API + "/common/upload", // Địa chỉ máy chủ hình ảnh đã tải lên
      headers: {
        Authorization: "Bearer " + getToken(),
      },
      fileList: []
    };
  },
  watch: {
    value: {
      handler(val) {
        if (val) {
          // Đầu tiên chuyển đổi giá trị thành một mảng
          const list = Array.isArray(val) ? val : this.value.split(',');
          // Sau đó chuyển đổi mảng thành một mảng đối tượng
          this.fileList = list.map(item => {
            if (typeof item === "string") {
              if (item.indexOf(this.baseUrl) === -1 && !isExternal(item)) {
                  item = { name: this.baseUrl + item, url: this.baseUrl + item };
              } else {
                  item = { name: item, url: item };
              }
            }
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
    // Trước khi tải lênloadingtrọng tải
    handleBeforeUpload(file) {
      let isImg = false;
      if (this.fileType.length) {
        let fileExtension = "";
        if (file.name.lastIndexOf(".") > -1) {
          fileExtension = file.name.slice(file.name.lastIndexOf(".") + 1);
        }
        isImg = this.fileType.some(type => {
          if (file.type.indexOf(type) > -1) return true;
          if (fileExtension && fileExtension.indexOf(type) > -1) return true;
          return false;
        });
      } else {
        isImg = file.type.indexOf("image") > -1;
      }

      if (!isImg) {
        this.$modal.msgError(`Định dạng tệp không chính xác，Vui lòng tải lên${this.fileType.join("/")}Tệp định dạng hình ảnh!`);
        return false;
      }
      if (file.name.includes(',')) {
        this.$modal.msgError('Tên tệp không chính xác，Không thể chứa dấu phẩy tiếng Anh!');
        return false;
      }
      if (this.fileSize) {
        const isLt = file.size / 1024 / 1024 < this.fileSize;
        if (!isLt) {
          this.$modal.msgError(`Kích thước ảnh avatar tải lên không được vượt quá ${this.fileSize} MB!`);
          return false;
        }
      }
      this.$modal.loading("Đang tải ảnh lên，Vui lòng chờ...");
      this.number++;
    },
    // Số lượng tập tin vượt quá
    handleExceed() {
      this.$modal.msgError(`Số lượng tập tin tải lên không thể vượt quá ${this.limit} cá nhân!`);
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
        this.$refs.imageUpload.handleRemove(file);
        this.uploadedSuccessfully();
      }
    },
    // Xóahình ảnh
    handleDelete(file) {
      const findex = this.fileList.map(f => f.name).indexOf(file.name);
      if (findex > -1) {
        this.fileList.splice(findex, 1);
        this.$emit("input", this.listToString(this.fileList));
      }
    },
    // tải lênThất bại
    handleUploadError() {
      this.$modal.msgError("Tải ảnh lênThất bại，Vui lòng thử lại");
      this.$modal.closeLoading();
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
    // Xem trước
    handlePictureCardPreview(file) {
      this.dialogImageUrl = file.url;
      this.dialogVisible = true;
    },
    // Chuyển đổi đối tượng thành chuỗi đã chỉ định được phân cách
    listToString(list, separator) {
      let strs = "";
      separator = separator || ",";
      for (let i in list) {
        if (list[i].url) {
          strs += list[i].url.replace(this.baseUrl, "") + separator;
        }
      }
      return strs != '' ? strs.substr(0, strs.length - 1) : '';
    }
  }
};
</script>
<style scoped lang="scss">
// .el-upload--picture-card Kiểm soát phần cộng
:deep(.hide .el-upload--picture-card) {  
    display: none;
}
// Loại bỏ hiệu ứng hoạt hình
:deep(.el-list-enter-active),
:deep(.el-list-leave-active) {
    transition: all 0s;
}

:deep(.el-list-enter), :deep(.el-list-leave-active) {
  opacity: 0;
  transform: translateY(0);
}
</style>

