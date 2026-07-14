<template>
  <div>
    <div class="user-info-head" @click="editCropper()"><img v-bind:src="options.img" title="click để tải lênhình đại diện" class="img-circle img-lg" /></div>
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body @opened="modalOpened"  @close="closeDialog">
      <el-row>
        <el-col :xs="24" :md="12" :style="{height: '350px'}">
          <vue-cropper
            ref="cropper"
            :img="options.img"
            :info="true"
            :autoCrop="options.autoCrop"
            :autoCropWidth="options.autoCropWidth"
            :autoCropHeight="options.autoCropHeight"
            :fixedBox="options.fixedBox"
            :outputType="options.outputType"
            @realTime="realTime"
            v-if="visible"
          />
        </el-col>
        <el-col :xs="24" :md="12" :style="{height: '350px'}">
          <div class="avatar-upload-preview">
            <img :src="previews.url" :style="previews.img" />
          </div>
        </el-col>
      </el-row>
      <br />
      <el-row>
        <el-col :lg="2" :sm="3" :xs="3">
          <el-upload action="#" :http-request="requestUpload" :show-file-list="false" :before-upload="beforeUpload">
            <el-button size="small">
              chọn
              <i class="el-icon-upload el-icon--right"></i>
            </el-button>
          </el-upload>
        </el-col>
        <el-col :lg="{span: 1, offset: 2}" :sm="2" :xs="2">
          <el-button icon="el-icon-plus" size="small" @click="changeScale(1)"></el-button>
        </el-col>
        <el-col :lg="{span: 1, offset: 1}" :sm="2" :xs="2">
          <el-button icon="el-icon-minus" size="small" @click="changeScale(-1)"></el-button>
        </el-col>
        <el-col :lg="{span: 1, offset: 1}" :sm="2" :xs="2">
          <el-button icon="el-icon-refresh-left" size="small" @click="rotateLeft()"></el-button>
        </el-col>
        <el-col :lg="{span: 1, offset: 1}" :sm="2" :xs="2">
          <el-button icon="el-icon-refresh-right" size="small" @click="rotateRight()"></el-button>
        </el-col>
        <el-col :lg="{span: 2, offset: 6}" :sm="2" :xs="2">
          <el-button type="primary" size="small" @click="uploadImg()">mang chi trả</el-button>
        </el-col>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
import store from "@/store";
import { VueCropper } from "vue-cropper";
import { uploadAvatar } from "@/api/system/user";
import { debounce } from '@/utils'

export default {
  components: { VueCropper },
  data() {
    return {
      // CóKhôngHiển thịlớp bật lên
      open: false,
      // CóKhôngHiển thịcropper
      visible: false,
      // Tiêu đề lớp bật lên
      title: "Sửahình đại diện",
      options: {
        img: store.getters.avatar,  //Địa chỉ của hình ảnh đã cắt
        autoCrop: true,             // Mặc địnhTạo hộp ảnh chụp màn hình
        autoCropWidth: 200,         // Chiều rộng khung ảnh chụp màn hình được tạo mặc định
        autoCropHeight: 200,        // Chiều cao khung ảnh chụp màn hình được tạo mặc định
        fixedBox: true,             // Đã sửa kích thước khung ảnh chụp màn hình không được phép thay đổi
        outputType:"png",           // Ảnh chụp màn hình mặc định được tạo làPNGĐịnh dạng
        filename: 'avatar'          // Tên tập tin
      },
      previews: {},
      resizeHandler: null
    };
  },
  methods: {
    // Chỉnh sửa hình đại diện
    editCropper() {
      this.open = true;
    },
    // Gọi lại khi mở lớp bật lên kết thúc
    modalOpened() {
      this.visible = true;
      if (!this.resizeHandler) {
        this.resizeHandler = debounce(() => {
          this.refresh()
        }, 100)
      }
      window.addEventListener("resize", this.resizeHandler)
    },
    // làm mới thành phần
    refresh() {
      this.$refs.cropper.refresh();
    },
    // Ghi đè hành vi tải lên mặc định
    requestUpload() {
    },
    // Xoay trái
    rotateLeft() {
      this.$refs.cropper.rotateLeft();
    },
    // Xoay phải
    rotateRight() {
      this.$refs.cropper.rotateRight();
    },
    // Thu phóng hình ảnh
    changeScale(num) {
      num = num || 1;
      this.$refs.cropper.changeScale(num);
    },
    // Xử lý trước tải lên
    beforeUpload(file) {
      if (file.type.indexOf("image/") == -1) {
        this.$modal.msgError("Lỗi định dạng tệp，Vui lòng tải ảnh lênLoại,giống：JPG，PNGtập tin hậu tố。");
      } else {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => {
          this.options.img = reader.result;
          this.options.filename = file.name;
        };
      }
    },
    // Tải ảnh lên
    uploadImg() {
      this.$refs.cropper.getCropBlob(data => {
        let formData = new FormData();
        formData.append("avatarfile", data, this.options.filename);
        uploadAvatar(formData).then(response => {
          this.open = false;
          this.options.img = import.meta.env.VITE_APP_BASE_API + response.imgUrl;
          store.commit('SET_AVATAR', this.options.img);
          this.$modal.msgSuccess("Chỉnh sửa thành công");
          this.visible = false;
        });
      });
    },
    // Xem trước trực tiếp
    realTime(data) {
      this.previews = data;
    },
    // Đóngcửa sổ
    closeDialog() {
      this.options.img = store.getters.avatar
      this.visible = false;
      window.removeEventListener("resize", this.resizeHandler)
    }
  }
};
</script>
<style scoped lang="scss">
.user-info-head {
  position: relative;
  display: inline-block;
  height: 120px;
}

.user-info-head:hover:after {
  content: '+';
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  color: #eee;
  background: rgba(0, 0, 0, 0.5);
  font-size: 24px;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  cursor: pointer;
  line-height: 110px;
  border-radius: 50%;
}
</style>
