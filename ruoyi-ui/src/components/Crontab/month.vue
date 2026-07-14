<template>
	<el-form size='small'>
		<el-form-item>
			<el-radio v-model='radioValue' :label="1">
				mặt trăng，Ký tự đại diện được phép[, - * /]
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="2">
				chu kỳ từ
				<el-input-number v-model='cycle01' :min="1" :max="11" /> -
				<el-input-number v-model='cycle02' :min="cycle01 ? cycle01 + 1 : 2" :max="12" /> mặt trăng
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="3">
				từ
				<el-input-number v-model='average01' :min="1" :max="11" /> tháng bắt đầu，Mọi
				<el-input-number v-model='average02' :min="1" :max="12 - average01 || 0" /> Thực hiện mỗi tháng một lần
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="4">
				Chỉ định
				<el-select clearable v-model="checkboxList" placeholder="Có thể có nhiều lựa chọn" multiple style="width:100%">
					<el-option v-for="item in 12" :key="item" :value="item">{{item}}</el-option>
				</el-select>
			</el-radio>
		</el-form-item>
	</el-form>
</template>

<script>
export default {
	data() {
		return {
			radioValue: 1,
			cycle01: 1,
			cycle02: 2,
			average01: 1,
			average02: 1,
			checkboxList: [],
			checkNum: this.check
		}
	},
	name: 'crontab-month',
	props: ['check', 'cron'],
	methods: {
		// Lựa chọn duy nhấtNút bấmKhi giá trị thay đổi
		radioChange() {
			switch (this.radioValue) {
				case 1:
					this.$emit('update', 'month', '*');
					break;
				case 2:
					this.$emit('update', 'month', this.cycleTotal);
					break;
				case 3:
					this.$emit('update', 'month', this.averageTotal);
					break;
				case 4:
					this.$emit('update', 'month', this.checkboxString);
					break;
			}
		},
		// Khi hai giá trị của khoảng thời gian thay đổi
		cycleChange() {
			if (this.radioValue == '2') {
				this.$emit('update', 'month', this.cycleTotal);
			}
		},
		// Khi giá trị trung bình của hai giá trị thay đổi
		averageChange() {
			if (this.radioValue == '3') {
				this.$emit('update', 'month', this.averageTotal);
			}
		},
		// checkboxKhi giá trị thay đổi
		checkboxChange() {
			if (this.radioValue == '4') {
				this.$emit('update', 'month', this.checkboxString);
			}
		}
	},
	watch: {
		'radioValue': 'radioChange',
		'cycleTotal': 'cycleChange',
		'averageTotal': 'averageChange',
		'checkboxString': 'checkboxChange'
	},
	computed: {
		// Tính hai giá trị thời kỳ
		cycleTotal: function () {
			const cycle01 = this.checkNum(this.cycle01, 1, 11)
			const cycle02 = this.checkNum(this.cycle02, cycle01 ? cycle01 + 1 : 2, 12)
			return cycle01 + '-' + cycle02;
		},
		// Tính giá trị trung bình đã sử dụng
		averageTotal: function () {
			const average01 = this.checkNum(this.average01, 1, 11)
			const average02 = this.checkNum(this.average02, 1, 12 - average01 || 0)
			return average01 + '/' + average02;
		},
		// Đã kiểm tra số lượngcheckboxbộ sưu tập giá trị
		checkboxString: function () {
			let str = this.checkboxList.join();
			return str == '' ? '*' : str;
		}
	}
}
</script>
