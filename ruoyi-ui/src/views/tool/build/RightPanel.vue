<template>
  <div class="right-board">
    <el-tabs v-model="currentTab" class="center-tabs">
      <el-tab-pane label="Thuộc tính thành phần" name="field" />
      <el-tab-pane label="thuộc tính biểu mẫu" name="form" />
    </el-tabs>
    <div class="field-box">
      <a class="document-link" target="_blank" :href="documentLink" title="Xem tài liệu thành phần">
        <i class="el-icon-link" />
      </a>
      <el-scrollbar class="right-scrollbar">
        <!-- Thuộc tính thành phần -->
        <el-form v-show="currentTab==='field' && showField" size="small" label-width="90px">
          <el-form-item v-if="activeData.changeTag" label="thành phầnLoại">
            <el-select
              v-model="activeData.tagIcon"
              placeholder="Vui lòng chọnthành phầnLoại"
              :style="{width: '100%'}"
              @change="tagChange"
            >
              <el-option-group v-for="group in tagList" :key="group.label" :label="group.label">
                <el-option
                  v-for="item in group.options"
                  :key="item.label"
                  :label="item.label"
                  :value="item.tagIcon"
                >
                  <svg-icon class="node-icon" :icon-class="item.tagIcon" />
                  <span> {{ item.label }}</span>
                </el-option>
              </el-option-group>
            </el-select>
          </el-form-item>
          <el-form-item v-if="activeData.vModel!==undefined" label="Tên trường">
            <el-input v-model="activeData.vModel" placeholder="Vui lòng nhậpTên trường（v-model）" />
          </el-form-item>
          <el-form-item v-if="activeData.componentName!==undefined" label="Tên thành phần">
            {{ activeData.componentName }}
          </el-form-item>
          <el-form-item v-if="activeData.label!==undefined" label="tiêu đề">
            <el-input v-model="activeData.label" placeholder="Vui lòng nhậptiêu đề" />
          </el-form-item>
          <el-form-item v-if="activeData.placeholder!==undefined" label="Trình giữ chỗGợi ý">
            <el-input v-model="activeData.placeholder" placeholder="Vui lòng nhậpTrình giữ chỗGợi ý" />
          </el-form-item>
          <el-form-item v-if="activeData['start-placeholder']!==undefined" label="Bắt đầu chiếm không gian">
            <el-input v-model="activeData['start-placeholder']" placeholder="Vui lòng nhậpTrình giữ chỗGợi ý" />
          </el-form-item>
          <el-form-item v-if="activeData['end-placeholder']!==undefined" label="Kết thúc phần giữ chỗ">
            <el-input v-model="activeData['end-placeholder']" placeholder="Vui lòng nhậpTrình giữ chỗGợi ý" />
          </el-form-item>
          <el-form-item v-if="activeData.span!==undefined" label="lưới mẫu">
            <el-slider v-model="activeData.span" :max="24" :min="1" :marks="{12:''}" @change="spanChange" />
          </el-form-item>
          <el-form-item v-if="activeData.layout==='rowFormItem'" label="Khoảng cách lưới">
            <el-input-number v-model="activeData.gutter" :min="0" placeholder="Khoảng cách lưới" />
          </el-form-item>
          <el-form-item v-if="activeData.layout==='rowFormItem'" label="chế độ bố trí">
            <el-radio-group v-model="activeData.type">
              <el-radio-button label="default" />
              <el-radio-button label="flex" />
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="activeData.justify!==undefined&&activeData.type==='flex'" label="Sắp xếp theo chiều ngang">
            <el-select v-model="activeData.justify" placeholder="Vui lòng chọnSắp xếp theo chiều ngang" :style="{width: '100%'}">
              <el-option
                v-for="(item, index) in justifyOptions"
                :key="index"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
          <el-form-item v-if="activeData.align!==undefined&&activeData.type==='flex'" label="sắp xếp theo chiều dọc">
            <el-radio-group v-model="activeData.align">
              <el-radio-button label="top" />
              <el-radio-button label="middle" />
              <el-radio-button label="bottom" />
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="activeData.labelWidth!==undefined" label="chiều rộng nhãn">
            <el-input v-model.number="activeData.labelWidth" type="number" placeholder="Vui lòng nhậpchiều rộng nhãn" />
          </el-form-item>
          <el-form-item v-if="activeData.style&&activeData.style.width!==undefined" label="Chiều rộng thành phần">
            <el-input v-model="activeData.style.width" placeholder="Vui lòng nhậpChiều rộng thành phần" clearable />
          </el-form-item>
          <el-form-item v-if="activeData.vModel!==undefined" label="giá trị mặc định">
            <el-input
              :value="setDefaultValue(activeData.defaultValue)"
              placeholder="Vui lòng nhậpgiá trị mặc định"
              @input="onDefaultValueInput"
            />
          </el-form-item>
          <el-form-item v-if="activeData.tag==='el-checkbox-group'" label="Ít nhất nên được chọn">
            <el-input-number
              :value="activeData.min"
              :min="0"
              placeholder="Ít nhất nên được chọn"
              @input="$set(activeData, 'min', $event?$event:undefined)"
            />
          </el-form-item>
          <el-form-item v-if="activeData.tag==='el-checkbox-group'" label="Tùy chọn nhiều nhất">
            <el-input-number
              :value="activeData.max"
              :min="0"
              placeholder="Tùy chọn nhiều nhất"
              @input="$set(activeData, 'max', $event?$event:undefined)"
            />
          </el-form-item>
          <el-form-item v-if="activeData.prepend!==undefined" label="tiền tố">
            <el-input v-model="activeData.prepend" placeholder="Vui lòng nhậptiền tố" />
          </el-form-item>
          <el-form-item v-if="activeData.append!==undefined" label="hậu tố">
            <el-input v-model="activeData.append" placeholder="Vui lòng nhậphậu tố" />
          </el-form-item>
          <el-form-item v-if="activeData['prefix-icon']!==undefined" label="biểu tượng phía trước">
            <el-input v-model="activeData['prefix-icon']" placeholder="Vui lòng nhậpTên biểu tượng trước đó">
              <el-button slot="append" icon="el-icon-thumb" @click="openIconsDialog('prefix-icon')">
                chọn
              </el-button>
            </el-input>
          </el-form-item>
          <el-form-item v-if="activeData['suffix-icon'] !== undefined" label="biểu tượng quay lại">
            <el-input v-model="activeData['suffix-icon']" placeholder="Vui lòng nhậpTên biểu tượng quay lại">
              <el-button slot="append" icon="el-icon-thumb" @click="openIconsDialog('suffix-icon')">
                chọn
              </el-button>
            </el-input>
          </el-form-item>
          <el-form-item v-if="activeData.tag === 'el-cascader'" label="dấu phân cách tùy chọn">
            <el-input v-model="activeData.separator" placeholder="Vui lòng nhậpdấu phân cách tùy chọn" />
          </el-form-item>
          <el-form-item v-if="activeData.autosize !== undefined" label="Số hàng tối thiểu">
            <el-input-number v-model="activeData.autosize.minRows" :min="1" placeholder="Số hàng tối thiểu" />
          </el-form-item>
          <el-form-item v-if="activeData.autosize !== undefined" label="Số hàng tối đa">
            <el-input-number v-model="activeData.autosize.maxRows" :min="1" placeholder="Số hàng tối đa" />
          </el-form-item>
          <el-form-item v-if="activeData.min !== undefined" label="giá trị tối thiểu">
            <el-input-number v-model="activeData.min" placeholder="giá trị tối thiểu" />
          </el-form-item>
          <el-form-item v-if="activeData.max !== undefined" label="giá trị tối đa">
            <el-input-number v-model="activeData.max" placeholder="giá trị tối đa" />
          </el-form-item>
          <el-form-item v-if="activeData.step !== undefined" label="độ dài bước">
            <el-input-number v-model="activeData.step" placeholder="số bước" />
          </el-form-item>
          <el-form-item v-if="activeData.tag === 'el-input-number'" label="Sự chính xác">
            <el-input-number v-model="activeData.precision" :min="0" placeholder="Sự chính xác" />
          </el-form-item>
          <el-form-item v-if="activeData.tag === 'el-input-number'" label="Nút bấmVị trí">
            <el-radio-group v-model="activeData['controls-position']">
              <el-radio-button label="">
                mặc định
              </el-radio-button>
              <el-radio-button label="right">
                bên phải
              </el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="activeData.maxlength !== undefined" label="Đầu vào tối đa">
            <el-input v-model="activeData.maxlength" placeholder="Vui lòng nhậpđộ dài ký tự">
              <template slot="append">
                nhân vật
              </template>
            </el-input>
          </el-form-item>
          <el-form-item v-if="activeData['active-text'] !== undefined" label="bật lênGợi ý">
            <el-input v-model="activeData['active-text']" placeholder="Vui lòng nhậpbật lênGợi ý" />
          </el-form-item>
          <el-form-item v-if="activeData['inactive-text'] !== undefined" label="ĐóngGợi ý">
            <el-input v-model="activeData['inactive-text']" placeholder="Vui lòng nhậpĐóngGợi ý" />
          </el-form-item>
          <el-form-item v-if="activeData['active-value'] !== undefined" label="giá trị mở">
            <el-input
              :value="setDefaultValue(activeData['active-value'])"
              placeholder="Vui lòng nhậpgiá trị mở"
              @input="onSwitchValueInput($event, 'active-value')"
            />
          </el-form-item>
          <el-form-item v-if="activeData['inactive-value'] !== undefined" label="Đónggiá trị">
            <el-input
              :value="setDefaultValue(activeData['inactive-value'])"
              placeholder="Vui lòng nhậpĐónggiá trị"
              @input="onSwitchValueInput($event, 'inactive-value')"
            />
          </el-form-item>
          <el-form-item
            v-if="activeData.type !== undefined && 'el-date-picker' === activeData.tag"
            label="thời gianLoại"
          >
            <el-select
              v-model="activeData.type"
              placeholder="Vui lòng chọnthời gianLoại"
              :style="{ width: '100%' }"
              @change="dateTypeChange"
            >
              <el-option
                v-for="(item, index) in dateOptions"
                :key="index"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
          <el-form-item v-if="activeData.name !== undefined" label="Tên trường tệp">
            <el-input v-model="activeData.name" placeholder="Vui lòng nhậpTên trường tệp tải lên" />
          </el-form-item>
          <el-form-item v-if="activeData.accept !== undefined" label="tài liệuLoại">
            <el-select
              v-model="activeData.accept"
              placeholder="Vui lòng chọntài liệuLoại"
              :style="{ width: '100%' }"
              clearable
            >
              <el-option label="hình ảnh" value="image/*" />
              <el-option label="băng hình" value="video/*" />
              <el-option label="Âm thanh" value="audio/*" />
              <el-option label="excel" value=".xls,.xlsx" />
              <el-option label="word" value=".doc,.docx" />
              <el-option label="pdf" value=".pdf" />
              <el-option label="txt" value=".txt" />
            </el-select>
          </el-form-item>
          <el-form-item v-if="activeData.fileSize !== undefined" label="kích thước tập tin">
            <el-input v-model.number="activeData.fileSize" placeholder="Vui lòng nhậpkích thước tập tin">
              <el-select slot="append" v-model="activeData.sizeUnit" :style="{ width: '66px' }">
                <el-option label="KB" value="KB" />
                <el-option label="MB" value="MB" />
                <el-option label="GB" value="GB" />
              </el-select>
            </el-input>
          </el-form-item>
          <el-form-item v-if="activeData.action !== undefined" label="Tải lên địa chỉ">
            <el-input v-model="activeData.action" placeholder="Vui lòng nhậpTải lên địa chỉ" clearable />
          </el-form-item>
          <el-form-item v-if="activeData['list-type'] !== undefined" label="danh sáchLoại">
            <el-radio-group v-model="activeData['list-type']" size="small">
              <el-radio-button label="text">
                text
              </el-radio-button>
              <el-radio-button label="picture">
                picture
              </el-radio-button>
              <el-radio-button label="picture-card">
                picture-card
              </el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item
            v-if="activeData.buttonText !== undefined"
            v-show="'picture-card' !== activeData['list-type']"
            label="Nút bấmTừ"
          >
            <el-input v-model="activeData.buttonText" placeholder="Vui lòng nhậpNút bấmTừ" />
          </el-form-item>
          <el-form-item v-if="activeData['range-separator'] !== undefined" label="dấu phân cách">
            <el-input v-model="activeData['range-separator']" placeholder="Vui lòng nhậpdấu phân cách" />
          </el-form-item>
          <el-form-item v-if="activeData['picker-options'] !== undefined" label="khoảng thời gian">
            <el-input
              v-model="activeData['picker-options'].selectableRange"
              placeholder="Vui lòng nhậpkhoảng thời gian"
            />
          </el-form-item>
          <el-form-item v-if="activeData.format !== undefined" label="định dạng thời gian">
            <el-input
              :value="activeData.format"
              placeholder="Vui lòng nhậpđịnh dạng thời gian"
              @input="setTimeValue($event)"
            />
          </el-form-item>
          <template v-if="['el-checkbox-group', 'el-radio-group', 'el-select'].indexOf(activeData.tag) > -1">
            <el-divider>Tùy chọn</el-divider>
            <draggable
              :list="activeData.options"
              :animation="340"
              group="selectItem"
              handle=".option-drag"
            >
              <div v-for="(item, index) in activeData.options" :key="index" class="select-item">
                <div class="select-line-icon option-drag">
                  <i class="el-icon-s-operation" />
                </div>
                <el-input v-model="item.label" placeholder="tên tùy chọn" size="small" />
                <el-input
                  placeholder="giá trị tùy chọn"
                  size="small"
                  :value="item.value"
                  @input="setOptionValue(item, $event)"
                />
                <div class="close-btn select-line-icon" @click="activeData.options.splice(index, 1)">
                  <i class="el-icon-remove-outline" />
                </div>
              </div>
            </draggable>
            <div style="margin-left: 20px;">
              <el-button
                style="padding-bottom: 0"
                icon="el-icon-circle-plus-outline"
                type="text"
                @click="addSelectItem"
              >
                Thêm tùy chọn
              </el-button>
            </div>
            <el-divider />
          </template>

          <template v-if="['el-cascader'].indexOf(activeData.tag) > -1">
            <el-divider>Tùy chọn</el-divider>
            <el-form-item label="dữ liệuLoại">
              <el-radio-group v-model="activeData.dataType" size="small">
                <el-radio-button label="dynamic">
                  dữ liệu động
                </el-radio-button>
                <el-radio-button label="static">
                  dữ liệu tĩnh
                </el-radio-button>
              </el-radio-group>
            </el-form-item>

            <template v-if="activeData.dataType === 'dynamic'">
              <el-form-item label="Gắn thẻ tên khóa">
                <el-input v-model="activeData.labelKey" placeholder="Vui lòng nhậpGắn thẻ tên khóa" />
              </el-form-item>
              <el-form-item label="tên khóa giá trị">
                <el-input v-model="activeData.valueKey" placeholder="Vui lòng nhậptên khóa giá trị" />
              </el-form-item>
              <el-form-item label="Tên khóa con">
                <el-input v-model="activeData.childrenKey" placeholder="Vui lòng nhậpTên khóa con" />
              </el-form-item>
            </template>

            <el-tree
              v-if="activeData.dataType === 'static'"
              draggable
              :data="activeData.options"
              node-key="id"
              :expand-on-click-node="false"
              :render-content="renderContent"
            />
            <div v-if="activeData.dataType === 'static'" style="margin-left: 20px">
              <el-button
                style="padding-bottom: 0"
                icon="el-icon-circle-plus-outline"
                type="text"
                @click="addTreeItem"
              >
                Thêm cha mẹ
              </el-button>
            </div>
            <el-divider />
          </template>

          <el-form-item v-if="activeData.optionType !== undefined" label="phong cách tùy chọn">
            <el-radio-group v-model="activeData.optionType">
              <el-radio-button label="default">
                mặc định
              </el-radio-button>
              <el-radio-button label="button">
                Nút bấm
              </el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="activeData['active-color'] !== undefined" label="Bật màu">
            <el-color-picker v-model="activeData['active-color']" />
          </el-form-item>
          <el-form-item v-if="activeData['inactive-color'] !== undefined" label="Đóngmàu sắc">
            <el-color-picker v-model="activeData['inactive-color']" />
          </el-form-item>

          <el-form-item v-if="activeData['allow-half'] !== undefined" label="Cho phép lựa chọn một nửa">
            <el-switch v-model="activeData['allow-half']" />
          </el-form-item>
          <el-form-item v-if="activeData['show-text'] !== undefined" label="văn bản phụ trợ">
            <el-switch v-model="activeData['show-text']" @change="rateTextChange" />
          </el-form-item>
          <el-form-item v-if="activeData['show-score'] !== undefined" label="Hiển thịPhân số">
            <el-switch v-model="activeData['show-score']" @change="rateScoreChange" />
          </el-form-item>
          <el-form-item v-if="activeData['show-stops'] !== undefined" label="Hiển thịsự gián đoạn">
            <el-switch v-model="activeData['show-stops']" />
          </el-form-item>
          <el-form-item v-if="activeData.range !== undefined" label="Lựa chọn phạm vi">
            <el-switch v-model="activeData.range" @change="rangeChange" />
          </el-form-item>
          <el-form-item
            v-if="activeData.border !== undefined && activeData.optionType === 'default'"
            label="CóKhôngcó đường viền"
          >
            <el-switch v-model="activeData.border" />
          </el-form-item>
          <el-form-item v-if="activeData.tag === 'el-color-picker'" label="định dạng màu">
            <el-select
              v-model="activeData['color-format']"
              placeholder="Vui lòng chọnđịnh dạng màu"
              :style="{ width: '100%' }"
              @change="colorFormatChange"
            >
              <el-option
                v-for="(item, index) in colorFormatOptions"
                :key="index"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
          <el-form-item
            v-if="activeData.size !== undefined &&
              (activeData.optionType === 'button' ||
                activeData.border ||
                activeData.tag === 'el-color-picker')"
            label="Kích thước tùy chọn"
          >
            <el-radio-group v-model="activeData.size">
              <el-radio-button label="medium">
                trung bình
              </el-radio-button>
              <el-radio-button label="small">
                nhỏ hơn
              </el-radio-button>
              <el-radio-button label="mini">
                nhỏ
              </el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="activeData['show-word-limit'] !== undefined" label="Nhập số liệu thống kê">
            <el-switch v-model="activeData['show-word-limit']" />
          </el-form-item>
          <el-form-item v-if="activeData.tag === 'el-input-number'" label="Số bước nghiêm ngặt">
            <el-switch v-model="activeData['step-strictly']" />
          </el-form-item>
          <el-form-item v-if="activeData.tag === 'el-cascader'" label="CóKhôngNhiều lựa chọn">
            <el-switch v-model="activeData.props.props.multiple" />
          </el-form-item>
          <el-form-item v-if="activeData.tag === 'el-cascader'" label="Hiển thị đường dẫn đầy đủ">
            <el-switch v-model="activeData['show-all-levels']" />
          </el-form-item>
          <el-form-item v-if="activeData.tag === 'el-cascader'" label="Có thểKhônglọc">
            <el-switch v-model="activeData.filterable" />
          </el-form-item>
          <el-form-item v-if="activeData.clearable !== undefined" label="có thểKhôngXóa sạch">
            <el-switch v-model="activeData.clearable" />
          </el-form-item>
          <el-form-item v-if="activeData.showTip !== undefined" label="Hiển thịGợi ý">
            <el-switch v-model="activeData.showTip" />
          </el-form-item>
          <el-form-item v-if="activeData.multiple !== undefined" label="Nhiều lựa chọn tập tin">
            <el-switch v-model="activeData.multiple" />
          </el-form-item>
          <el-form-item v-if="activeData['auto-upload'] !== undefined" label="Tự động tải lên">
            <el-switch v-model="activeData['auto-upload']" />
          </el-form-item>
          <el-form-item v-if="activeData.readonly !== undefined" label="CóKhôngchỉ đọc">
            <el-switch v-model="activeData.readonly" />
          </el-form-item>
          <el-form-item v-if="activeData.disabled !== undefined" label="CóKhôngVô hiệu hóa">
            <el-switch v-model="activeData.disabled" />
          </el-form-item>
          <el-form-item v-if="activeData.tag === 'el-select'" label="CóKhôngCó thểTìm kiếm">
            <el-switch v-model="activeData.filterable" />
          </el-form-item>
          <el-form-item v-if="activeData.tag === 'el-select'" label="CóKhôngNhiều lựa chọn">
            <el-switch v-model="activeData.multiple" @change="multipleChange" />
          </el-form-item>
          <el-form-item v-if="activeData.required !== undefined" label="CóKhôngYêu cầu">
            <el-switch v-model="activeData.required" />
          </el-form-item>

          <template v-if="activeData.layoutTree">
            <el-divider>Cây bố cục</el-divider>
            <el-tree
              :data="[activeData]"
              :props="layoutTreeProps"
              node-key="renderKey"
              default-expand-all
              draggable
            >
              <span slot-scope="{ node, data }">
                <span class="node-label">
                  <svg-icon class="node-icon" :icon-class="data.tagIcon" />
                  {{ node.label }}
                </span>
              </span>
            </el-tree>
          </template>

          <template v-if="activeData.layout === 'colFormItem' && activeData.tag !== 'el-button'">
            <el-divider>Kiểm tra thường xuyên</el-divider>
            <div
              v-for="(item, index) in activeData.regList"
              :key="index"
              class="reg-item"
            >
              <span class="close-btn" @click="activeData.regList.splice(index, 1)">
                <i class="el-icon-close" />
              </span>
              <el-form-item label="sự biểu lộ">
                <el-input v-model="item.pattern" placeholder="Vui lòng nhậpthường xuyên" />
              </el-form-item>
              <el-form-item label="sai lầmGợi ý" style="margin-bottom:0">
                <el-input v-model="item.message" placeholder="Vui lòng nhậpsai lầmGợi ý" />
              </el-form-item>
            </div>
            <div style="margin-left: 20px">
              <el-button icon="el-icon-circle-plus-outline" type="text" @click="addReg">
                Thêm quy tắc
              </el-button>
            </div>
          </template>
        </el-form>
        <!-- thuộc tính biểu mẫu -->
        <el-form v-show="currentTab === 'form'" size="small" label-width="90px">
          <el-form-item label="tên mẫu">
            <el-input v-model="formConf.formRef" placeholder="Vui lòng nhậptên mẫu（ref）" />
          </el-form-item>
          <el-form-item label="mẫu đơn">
            <el-input v-model="formConf.formModel" placeholder="Vui lòng nhậpmô hình dữ liệu" />
          </el-form-item>
          <el-form-item label="Xác minh mô hình">
            <el-input v-model="formConf.formRules" placeholder="Vui lòng nhậpXác minh mô hình" />
          </el-form-item>
          <el-form-item label="kích thước mẫu">
            <el-radio-group v-model="formConf.size">
              <el-radio-button label="medium">
                trung bình
              </el-radio-button>
              <el-radio-button label="small">
                nhỏ hơn
              </el-radio-button>
              <el-radio-button label="mini">
                nhỏ
              </el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="căn chỉnh nhãn">
            <el-radio-group v-model="formConf.labelPosition">
              <el-radio-button label="left">
                căn trái
              </el-radio-button>
              <el-radio-button label="right">
                Căn phải
              </el-radio-button>
              <el-radio-button label="top">
                căn chỉnh trên cùng
              </el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="chiều rộng nhãn">
            <el-input-number v-model="formConf.labelWidth" placeholder="chiều rộng nhãn" />
          </el-form-item>
          <el-form-item label="Khoảng cách lưới">
            <el-input-number v-model="formConf.gutter" :min="0" placeholder="Khoảng cách lưới" />
          </el-form-item>
          <el-form-item label="Vô hiệu hóa biểu mẫu">
            <el-switch v-model="formConf.disabled" />
          </el-form-item>
          <el-form-item label="hình thứcNút bấm">
            <el-switch v-model="formConf.formBtns" />
          </el-form-item>
          <el-form-item label="Hiển thịĐường viền thành phần không được chọn">
            <el-switch v-model="formConf.unFocusedComponentBorder" />
          </el-form-item>
        </el-form>
      </el-scrollbar>
    </div>

    <treeNode-dialog :visible.sync="dialogVisible" title="Thêm tùy chọn" @commit="addNode" />
    <icons-dialog :visible.sync="iconsVisible" :current="activeData[currentIconModel]" @select="setIcon" />
  </div>
</template>

<script lang="jsx">
import { isArray } from 'util'
import draggable from 'vuedraggable'
import TreeNodeDialog from './TreeNodeDialog'
import { isNumberStr } from '@/utils/index'
import IconsDialog from './IconsDialog'
import {
  inputComponents,
  selectComponents,
  layoutComponents
} from '@/utils/generator/config'

const dateTimeFormat = {
  date: 'yyyy-MM-dd',
  week: 'yyyy KHÔNG. WW tuần',
  month: 'yyyy-MM',
  year: 'yyyy',
  datetime: 'yyyy-MM-dd HH:mm:ss',
  daterange: 'yyyy-MM-dd',
  monthrange: 'yyyy-MM',
  datetimerange: 'yyyy-MM-dd HH:mm:ss'
}

export default {
  components: {
    draggable,
    TreeNodeDialog,
    IconsDialog
  },
  props: ['showField', 'activeData', 'formConf'],
  data() {
    return {
      currentTab: 'field',
      currentNode: null,
      dialogVisible: false,
      iconsVisible: false,
      currentIconModel: null,
      dateTypeOptions: [
        {
          label: 'ngày(date)',
          value: 'date'
        },
        {
          label: 'tuần(week)',
          value: 'week'
        },
        {
          label: 'mặt trăng(month)',
          value: 'month'
        },
        {
          label: 'Năm(year)',
          value: 'year'
        },
        {
          label: 'ngày giờ(datetime)',
          value: 'datetime'
        }
      ],
      dateRangeTypeOptions: [
        {
          label: 'phạm vi ngày(daterange)',
          value: 'daterange'
        },
        {
          label: 'phạm vi tháng(monthrange)',
          value: 'monthrange'
        },
        {
          label: 'phạm vi ngày giờ(datetimerange)',
          value: 'datetimerange'
        }
      ],
      colorFormatOptions: [
        {
          label: 'hex',
          value: 'hex'
        },
        {
          label: 'rgb',
          value: 'rgb'
        },
        {
          label: 'rgba',
          value: 'rgba'
        },
        {
          label: 'hsv',
          value: 'hsv'
        },
        {
          label: 'hsl',
          value: 'hsl'
        }
      ],
      justifyOptions: [
        {
          label: 'start',
          value: 'start'
        },
        {
          label: 'end',
          value: 'end'
        },
        {
          label: 'center',
          value: 'center'
        },
        {
          label: 'space-around',
          value: 'space-around'
        },
        {
          label: 'space-between',
          value: 'space-between'
        }
      ],
      layoutTreeProps: {
        label(data, node) {
          return data.componentName || `${data.label}: ${data.vModel}`
        }
      }
    }
  },
  computed: {
    documentLink() {
      return (
        this.activeData.document
        || 'https://element.eleme.cn/#/zh-CN/component/installation'
      )
    },
    dateOptions() {
      if (
        this.activeData.type !== undefined
        && this.activeData.tag === 'el-date-picker'
      ) {
        if (this.activeData['start-placeholder'] === undefined) {
          return this.dateTypeOptions
        }
        return this.dateRangeTypeOptions
      }
      return []
    },
    tagList() {
      return [
        {
          label: 'thành phần đầu vào',
          options: inputComponents
        },
        {
          label: 'Thành phần chọn lọc',
          options: selectComponents
        }
      ]
    }
  },
  methods: {
    addReg() {
      this.activeData.regList.push({
        pattern: '',
        message: ''
      })
    },
    addSelectItem() {
      this.activeData.options.push({
        label: '',
        value: ''
      })
    },
    addTreeItem() {
      ++this.idGlobal
      this.dialogVisible = true
      this.currentNode = this.activeData.options
    },
    renderContent(h, { node, data, store }) {
      return (
        <div class="custom-tree-node">
          <span>{node.label}</span>
          <span class="node-operation">
            <i on-click={() => this.append(data)}
              class="el-icon-plus"
              title="Thêm vào"
            ></i>
            <i on-click={() => this.remove(node, data)}
              class="el-icon-delete"
              title="Xóa"
            ></i>
          </span>
        </div>
      )
    },
    append(data) {
      if (!data.children) {
        this.$set(data, 'children', [])
      }
      this.dialogVisible = true
      this.currentNode = data.children
    },
    remove(node, data) {
      const { parent } = node
      const children = parent.data.children || parent.data
      const index = children.findIndex(d => d.id === data.id)
      children.splice(index, 1)
    },
    addNode(data) {
      this.currentNode.push(data)
    },
    setOptionValue(item, val) {
      item.value = isNumberStr(val) ? +val : val
    },
    setDefaultValue(val) {
      if (Array.isArray(val)) {
        return val.join(',')
      }
      if (['string', 'number'].indexOf(val) > -1) {
        return val
      }
      if (typeof val === 'boolean') {
        return `${val}`
      }
      return val
    },
    onDefaultValueInput(str) {
      if (isArray(this.activeData.defaultValue)) {
        // mảng
        this.$set(
          this.activeData,
          'defaultValue',
          str.split(',').map(val => (isNumberStr(val) ? +val : val))
        )
      } else if (['true', 'false'].indexOf(str) > -1) {
        // Boolean
        this.$set(this.activeData, 'defaultValue', JSON.parse(str))
      } else {
        // chuỗi và số
        this.$set(
          this.activeData,
          'defaultValue',
          isNumberStr(str) ? +str : str
        )
      }
    },
    onSwitchValueInput(val, name) {
      if (['true', 'false'].indexOf(val) > -1) {
        this.$set(this.activeData, name, JSON.parse(val))
      } else {
        this.$set(this.activeData, name, isNumberStr(val) ? +val : val)
      }
    },
    setTimeValue(val, type) {
      const valueFormat = type === 'week' ? dateTimeFormat.date : val
      this.$set(this.activeData, 'defaultValue', null)
      this.$set(this.activeData, 'value-format', valueFormat)
      this.$set(this.activeData, 'format', val)
    },
    spanChange(val) {
      this.formConf.span = val
    },
    multipleChange(val) {
      this.$set(this.activeData, 'defaultValue', val ? [] : '')
    },
    dateTypeChange(val) {
      this.setTimeValue(dateTimeFormat[val], val)
    },
    rangeChange(val) {
      this.$set(
        this.activeData,
        'defaultValue',
        val ? [this.activeData.min, this.activeData.max] : this.activeData.min
      )
    },
    rateTextChange(val) {
      if (val) this.activeData['show-score'] = false
    },
    rateScoreChange(val) {
      if (val) this.activeData['show-text'] = false
    },
    colorFormatChange(val) {
      this.activeData.defaultValue = null
      this.activeData['show-alpha'] = val.indexOf('a') > -1
      this.activeData.renderKey = +new Date() // gia hạnrenderKey,Kết xuất lại thành phần
    },
    openIconsDialog(model) {
      this.iconsVisible = true
      this.currentIconModel = model
    },
    setIcon(val) {
      this.activeData[this.currentIconModel] = val
    },
    tagChange(tagIcon) {
      let target = inputComponents.find(item => item.tagIcon === tagIcon)
      if (!target) target = selectComponents.find(item => item.tagIcon === tagIcon)
      this.$emit('tag-change', target)
    }
  }
}
</script>

<style lang="scss" scoped>
.right-board {
  width: 350px;
  position: absolute;
  right: 0;
  top: 0;
  padding-top: 3px;
  .field-box {
    position: relative;
    height: calc(100vh - 42px);
    box-sizing: border-box;
    overflow: hidden;
  }
  .el-scrollbar {
    height: 100%;
  }
}
.select-item {
  display: flex;
  border: 1px dashed #fff;
  box-sizing: border-box;
  & .close-btn {
    cursor: pointer;
    color: #f56c6c;
  }
  & .el-input + .el-input {
    margin-left: 4px;
  }
}
.select-item + .select-item {
  margin-top: 4px;
}
.select-item.sortable-chosen {
  border: 1px dashed #409eff;
}
.select-line-icon {
  line-height: 32px;
  font-size: 22px;
  padding: 0 4px;
  color: #777;
}
.option-drag {
  cursor: move;
}
.time-range {
  .el-date-editor {
    width: 227px;
  }
  :deep(.el-icon-time) {  
    display: none;
  }
}
.document-link {
  position: absolute;
  display: block;
  width: 26px;
  height: 26px;
  top: 0;
  left: 0;
  cursor: pointer;
  background: #409eff;
  z-index: 1;
  border-radius: 0 0 6px 0;
  text-align: center;
  line-height: 26px;
  color: #fff;
  font-size: 18px;
}
.node-label{
  font-size: 14px;
}
.node-icon{
  color: #bebfc3;
}
</style>
