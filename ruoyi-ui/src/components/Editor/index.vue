<template>
  <div>
    <el-upload
      :action="uploadUrl"
      :before-upload="handleBeforeUpload"
      :on-success="handleUploadSuccess"
      :on-error="handleUploadError"
      name="file"
      :show-file-list="false"
      :headers="headers"
      style="display: none"
      ref="upload"
      v-if="this.type == 'url'"
    >
    </el-upload>
    <div class="editor" ref="editor" :style="styles"></div>
  </div>
</template>

<script>
import Quill from "quill";
import "quill/dist/quill.core.css";
import "quill/dist/quill.snow.css";
import "quill/dist/quill.bubble.css";
import { getToken } from "@/utils/auth";

export default {
  name: "Editor",
  props: {
    /* biên tập viênNội dung */
    value: {
      type: String,
      default: "",
    },
    /* cao */
    height: {
      type: Number,
      default: null,
    },
    /* chiều cao tối thiểu */
    minHeight: {
      type: Number,
      default: null,
    },
    /* chỉ đọc */
    readOnly: {
      type: Boolean,
      default: false,
    },
    /* Giới hạn kích thước tệp tải lên(MB) */
    fileSize: {
      type: Number,
      default: 5,
    },
    /* Loại（base64Định dạng、urlĐịnh dạng） */
    type: {
      type: String,
      default: "url",
    }
  },
  data() {
    return {
      uploadUrl: import.meta.env.VITE_APP_BASE_API + "/common/upload", // Địa chỉ máy chủ hình ảnh đã tải lên
      headers: {
        Authorization: "Bearer " + getToken()
      },
      Quill: null,
      currentValue: "",
      options: {
        theme: "snow",
        bounds: document.body,
        debug: "warn",
        modules: {
          // Cấu hình thanh công cụ
          toolbar: [
            ["bold", "italic", "underline", "strike"],       // In đậm chữ nghiêng gạch chân XóaDây điện
            ["blockquote", "code-block"],                    // Trích dẫn  khối mã
            [{ list: "ordered" }, { list: "bullet" }],       // có trật tự、danh sách không có thứ tự
            [{ indent: "-1" }, { indent: "+1" }],            // vết lõm
            [{ size: ["small", false, "large", "huge"] }],   // cỡ chữ
            [{ header: [1, 2, 3, 4, 5, 6, false] }],         // tiêu đề
            [{ color: [] }, { background: [] }],             // Màu chữ、Màu nền phông chữ
            [{ align: [] }],                                 // Căn chỉnh
            ["clean"],                                       // định dạng văn bản rõ ràng
            ["link", "image", "video"]                       // liên kết、hình ảnh、băng hình
          ],
        },
        placeholder: "Vui lòng nhập nội dung",
        readOnly: this.readOnly,
      },
    };
  },
  computed: {
    styles() {
      let style = {};
      if (this.minHeight) {
        style.minHeight = `${this.minHeight}px`;
      }
      if (this.height) {
        style.height = `${this.height}px`;
      }
      return style;
    },
  },
  watch: {
    value: {
      handler(val) {
        if (val !== this.currentValue) {
          this.currentValue = val === null ? "" : val;
          if (this.Quill) {
            this.Quill.clipboard.dangerouslyPasteHTML(this.currentValue);
          }
        }
      },
      immediate: true,
    },
  },
  mounted() {
    this.init();
  },
  beforeDestroy() {
    this.Quill = null;
  },
  methods: {
    init() {
      const editor = this.$refs.editor;
      this.Quill = new Quill(editor, this.options);
      // Nếu địa chỉ tải lên được đặt, hãy tùy chỉnh sự kiện tải lên hình ảnh
      if (this.type == 'url') {
        let toolbar = this.Quill.getModule("toolbar");
        toolbar.addHandler("image", (value) => {
          if (value) {
            this.$refs.upload.$children[0].$refs.input.click();
          } else {
            this.quill.format("image", false);
          }
        });
      }
      this.Quill.clipboard.dangerouslyPasteHTML(this.currentValue);
      this.Quill.on("text-change", (delta, oldDelta, source) => {
        const html = this.$refs.editor.children[0].innerHTML;
        const text = this.Quill.getText();
        const quill = this.Quill;
        this.currentValue = html;
        this.$emit("input", html);
        this.$emit("on-change", { html, text, quill });
      });
      this.Quill.on("text-change", (delta, oldDelta, source) => {
        this.$emit("on-text-change", delta, oldDelta, source);
      });
      this.Quill.on("selection-change", (range, oldRange, source) => {
        this.$emit("on-selection-change", range, oldRange, source);
      });
      this.Quill.on("editor-change", (eventName, ...args) => {
        this.$emit("on-editor-change", eventName, ...args);
      });
    },
    // Kiểm tra định dạng và kích thước trước khi tải lên
    handleBeforeUpload(file) {
      const type = ["image/jpeg", "image/jpg", "image/png", "image/svg"];
      const isJPG = type.includes(file.type);
      // Kiểm tra định dạng tập tin
      if (!isJPG) {
        this.$message.error(`Lỗi định dạng hình ảnh!`);
        return false;
      }
      // Kích thước tập tin bằng chứng
      if (this.fileSize) {
        const isLt = file.size / 1024 / 1024 < this.fileSize;
        if (!isLt) {
          this.$message.error(`Kích thước tệp tải lên không thể vượt quá ${this.fileSize} MB!`);
          return false;
        }
      }
      return true;
    },
    handleUploadSuccess(res, file) {
      // Nếu tải lênThành công
      if (res.code == 200) {
        // Nhận phiên bản thành phần văn bản đa dạng thức
        let quill = this.Quill;
        // Lấy vị trí con trỏ
        let length = quill.getSelection().index;
        // Chèn ảnh  res.urlcho máy chủQuay lạiđịa chỉ hình ảnh
        quill.insertEmbed(length, "image", import.meta.env.VITE_APP_BASE_API + res.fileName);
        // Điều chỉnh con trỏ đến cuối
        quill.setSelection(length + 1);
      } else {
        this.$message.error("chèn ảnhThất bại");
      }
    },
    handleUploadError() {
      this.$message.error("chèn ảnhThất bại");
    },
  },
};
</script>

<style>
.editor, .ql-toolbar {
  white-space: pre-wrap !important;
  line-height: normal !important;
}
.quill-img {
  display: none;
}
.ql-snow .ql-tooltip[data-mode="link"]::before {
  content: "Vui lòng nhậpĐịa chỉ liên kết:";
}
.ql-snow .ql-tooltip.ql-editing a.ql-action::after {
  border-right: 0px;
  content: "Lưu";
  padding-right: 0px;
}
.ql-snow .ql-tooltip[data-mode="video"]::before {
  content: "Vui lòng nhậpĐịa chỉ video:";
}
.ql-snow .ql-picker.ql-size .ql-picker-label::before,
.ql-snow .ql-picker.ql-size .ql-picker-item::before {
  content: "14px";
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="small"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="small"]::before {
  content: "10px";
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="large"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="large"]::before {
  content: "18px";
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="huge"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="huge"]::before {
  content: "32px";
}
.ql-snow .ql-picker.ql-header .ql-picker-label::before,
.ql-snow .ql-picker.ql-header .ql-picker-item::before {
  content: "chữ";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="1"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="1"]::before {
  content: "tiêu đề1";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="2"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="2"]::before {
  content: "tiêu đề2";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="3"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="3"]::before {
  content: "tiêu đề3";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="4"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="4"]::before {
  content: "tiêu đề4";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="5"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="5"]::before {
  content: "tiêu đề5";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="6"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="6"]::before {
  content: "tiêu đề6";
}
.ql-snow .ql-picker.ql-font .ql-picker-label::before,
.ql-snow .ql-picker.ql-font .ql-picker-item::before {
  content: "Phông chữ chuẩn";
}
.ql-snow .ql-picker.ql-font .ql-picker-label[data-value="serif"]::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value="serif"]::before {
  content: "phông chữ serif";
}
.ql-snow .ql-picker.ql-font .ql-picker-label[data-value="monospace"]::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value="monospace"]::before {
  content: "phông chữ đơn cách";
}
</style>
