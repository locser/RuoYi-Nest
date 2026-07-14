<template>
	<div class="popup-result">
		<p class="title">gần đây5thời gian chạy</p>
		<ul class="popup-result-scroll">
			<template v-if='isShow'>
				<li v-for='item in resultList' :key="item">{{item}}</li>
			</template>
			<li v-else>Kết quả tính toán...</li>
		</ul>
	</div>
</template>

<script>
export default {
	data() {
		return {
			dayRule: '',
			dayRuleSup: '',
			dateArr: [],
			resultList: [],
			isShow: false
		}
	},
	name: 'crontab-result',
	methods: {
		// Khi giá trị biểu thức thay đổi，Bắt đầu tính kết quả
		expressionChange() {

			// Bắt đầu tính toán-Ẩnkết quả
			this.isShow = false;
			// Lấy mảng quy tắc[0Thứ hai、1điểm、2giờ、3ngày、4mặt trăng、5Tuần、6Năm]
			let ruleArr = this.$options.propsData.ex.split(' ');
			// Dùng để ghi lại số lần vòng lặp được nhập
			let nums = 0;
			// Mảng dùng để lưu trữ tạm thời các kết quả quy tắc thời gian mang tính biểu tượng
			let resultArr = [];
			// Nhận thời gian hiện tại chính xác để[Năm、mặt trăng、ngày、giờ、điểm、Thứ hai]
			let nTime = new Date();
			let nYear = nTime.getFullYear();
			let nMonth = nTime.getMonth() + 1;
			let nDay = nTime.getDate();
			let nHour = nTime.getHours();
			let nMin = nTime.getMinutes();
			let nSecond = nTime.getSeconds();
			// Theo quy định, hãy đến gần nhất100mảng năm của các năm có thể、mảng tháng, v.v.
			this.getSecondArr(ruleArr[0]);
			this.getMinArr(ruleArr[1]);
			this.getHourArr(ruleArr[2]);
			this.getDayArr(ruleArr[3]);
			this.getMonthArr(ruleArr[4]);
			this.getWeekArr(ruleArr[5]);
			this.getYearArr(ruleArr[6], nYear);
			// Gán mảng thu được-Dễ dàng sử dụng
			let sDate = this.dateArr[0];
			let mDate = this.dateArr[1];
			let hDate = this.dateArr[2];
			let DDate = this.dateArr[3];
			let MDate = this.dateArr[4];
			let YDate = this.dateArr[5];
			// Lấy chỉ mục của thời gian hiện tại trong mảng
			let sIdx = this.getIndex(sDate, nSecond);
			let mIdx = this.getIndex(mDate, nMin);
			let hIdx = this.getIndex(hDate, nHour);
			let DIdx = this.getIndex(DDate, nDay);
			let MIdx = this.getIndex(MDate, nMonth);
			let YIdx = this.getIndex(YDate, nYear);
			// Đặt lạiChức năng tháng, ngày, giờ, phút và giây(Sau này sử dụng nhiều hơn)
			const resetSecond = function () {
				sIdx = 0;
				nSecond = sDate[sIdx]
			}
			const resetMin = function () {
				mIdx = 0;
				nMin = mDate[mIdx]
				resetSecond();
			}
			const resetHour = function () {
				hIdx = 0;
				nHour = hDate[hIdx]
				resetMin();
			}
			const resetDay = function () {
				DIdx = 0;
				nDay = DDate[DIdx]
				resetHour();
			}
			const resetMonth = function () {
				MIdx = 0;
				nMonth = MDate[MIdx]
				resetDay();
			}
			// Nếu năm hiện tại không phải là giá trị hiện tại trong mảng
			if (nYear !== YDate[YIdx]) {
				resetMonth();
			}
			// Nếu tháng hiện tại không phải là giá trị hiện tại trong mảng
			if (nMonth !== MDate[MIdx]) {
				resetDay();
			}
			// Nếu hiện tại“ngày”Không phải giá trị hiện tại trong mảng
			if (nDay !== DDate[DIdx]) {
				resetHour();
			}
			// Nếu hiện tại“giờ”Không phải giá trị hiện tại trong mảng
			if (nHour !== hDate[hIdx]) {
				resetMin();
			}
			// Nếu hiện tại“điểm”Không phải giá trị hiện tại trong mảng
			if (nMin !== mDate[mIdx]) {
				resetSecond();
			}

			// Lặp lại mảng năm
			goYear: for (let Yi = YIdx; Yi < YDate.length; Yi++) {
				let YY = YDate[Yi];
				// Nếu đạt giá trị cực đại
				if (nMonth > MDate[MDate.length - 1]) {
					resetMonth();
					continue;
				}
				// Lặp qua mảng tháng
				goMonth: for (let Mi = MIdx; Mi < MDate.length; Mi++) {
					// Phân công、Thuận tiện cho việc tính toán sau này
					let MM = MDate[Mi];
					MM = MM < 10 ? '0' + MM : MM;
					// Nếu đạt giá trị cực đại
					if (nDay > DDate[DDate.length - 1]) {
						resetDay();
						if (Mi == MDate.length - 1) {
							resetMonth();
							continue goYear;
						}
						continue;
					}
					// Lặp qua mảng ngày
					goDay: for (let Di = DIdx; Di < DDate.length; Di++) {
						// Phân công、Thuận tiện cho việc tính toán sau này
						let DD = DDate[Di];
						let thisDD = DD < 10 ? '0' + DD : DD;

						// Nếu đạt giá trị cực đại
						if (nHour > hDate[hDate.length - 1]) {
							resetHour();
							if (Di == DDate.length - 1) {
								resetDay();
								if (Mi == MDate.length - 1) {
									resetMonth();
									continue goYear;
								}
								continue goMonth;
							}
							continue;
						}

						// Xác định tính hợp pháp của một ngày，Ngay cả khi nó là bất hợp phápCóThoát khỏi vòng lặp hiện tại
						if (this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true && this.dayRule !== 'workDay' && this.dayRule !== 'lastWeek' && this.dayRule !== 'lastDay') {
							resetDay();
							continue goMonth;
						}
						// Nếu có một giá trị trong quy tắc ngày
						if (this.dayRule == 'lastDay') {
							// nếu khôngCóĐối với ngày pháp lý, bạn cần điều chỉnh ngày thành ngày pháp lý là ngày cuối cùng của tháng.

							if (this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
								while (DD > 0 && this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
									DD--;

									thisDD = DD < 10 ? '0' + DD : DD;
								}
							}
						} else if (this.dayRule == 'workDay') {
							// Xác minh và điều chỉnh nếuCó2mặt trăng30Khi một ngày như thế này được thông qua, nó cần được điều chỉnh thànhBình thườngcuối tháng
							if (this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
								while (DD > 0 && this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
									DD--;
									thisDD = DD < 10 ? '0' + DD : DD;
								}
							}
							// Lấy ngày khi điều kiện được đáp ứngCóTuầnX
							let thisWeek = this.formatDate(new Date(YY + '-' + MM + '-' + thisDD + ' 00:00:00'), 'week');
							// khi chủ nhật
							if (thisWeek == 1) {
								// Tìm ngày tiếp theo trước，và phán xétCóKhôngcho cuối tháng
								DD++;
								thisDD = DD < 10 ? '0' + DD : DD;
								// Phán quyết rằng ngày hôm sau sẽ không còn nữaCóngày pháp lý
								if (this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
									DD -= 3;
								}
							} else if (thisWeek == 7) {
								// tuần đó6Khi bạn chỉ cần đánh giá liệuCó1Bạn có thể tiếp tục với sốThao tác
								if (this.dayRuleSup !== 1) {
									DD--;
								} else {
									DD += 2;
								}
							}
						} else if (this.dayRule == 'weekDay') {
							// Nếu được chỉ địnhCóngày trong tuần
							// Nhận ngày hiện tạiCóNgày trong tuần
							let thisWeek = this.formatDate(new Date(YY + '-' + MM + '-' + DD + ' 00:00:00'), 'week');
							// Kiểm tra tuần hiện tạiCóKhôngỞ Chu Trì（dayRuleSup）ở giữa
							if (this.dayRuleSup.indexOf(thisWeek) < 0) {
								// Nếu đạt giá trị cực đại
								if (Di == DDate.length - 1) {
									resetDay();
									if (Mi == MDate.length - 1) {
										resetMonth();
										continue goYear;
									}
									continue goMonth;
								}
								continue;
							}
						} else if (this.dayRule == 'assWeek') {
							// Nếu được chỉ địnhCóNgày trong tuần
							// Nhận hàng tháng1Con sốCóNgày trong tuần
							let thisWeek = this.formatDate(new Date(YY + '-' + MM + '-' + DD + ' 00:00:00'), 'week');
							if (this.dayRuleSup[1] >= thisWeek) {
								DD = (this.dayRuleSup[0] - 1) * 7 + this.dayRuleSup[1] - thisWeek + 1;
							} else {
								DD = this.dayRuleSup[0] * 7 + this.dayRuleSup[1] - thisWeek + 1;
							}
						} else if (this.dayRule == 'lastWeek') {
							// Nếu ngày cuối cùng của tháng được chỉ định
							// Xác minh và điều chỉnh nếuCó2mặt trăng30Khi một ngày như thế này được thông qua, nó cần được điều chỉnh thànhBình thườngcuối tháng
							if (this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
								while (DD > 0 && this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
									DD--;
									thisDD = DD < 10 ? '0' + DD : DD;
								}
							}
							// Lấy ngày cuối cùng của thángCóngày trong tuần
							let thisWeek = this.formatDate(new Date(YY + '-' + MM + '-' + thisDD + ' 00:00:00'), 'week');
							// Tìm ngày gần nhất trong tuần trong yêu cầu
							if (this.dayRuleSup < thisWeek) {
								DD -= thisWeek - this.dayRuleSup;
							} else if (this.dayRuleSup > thisWeek) {
								DD -= 7 - (this.dayRuleSup - thisWeek)
							}
						}
						// Xác định giá trị thời gianCóKhôngít hơn10Thay thế bằng“05”định dạng này
						DD = DD < 10 ? '0' + DD : DD;

						// xe đạp“giờ”mảng
						goHour: for (let hi = hIdx; hi < hDate.length; hi++) {
							let hh = hDate[hi] < 10 ? '0' + hDate[hi] : hDate[hi]

							// Nếu đạt giá trị cực đại
							if (nMin > mDate[mDate.length - 1]) {
								resetMin();
								if (hi == hDate.length - 1) {
									resetHour();
									if (Di == DDate.length - 1) {
										resetDay();
										if (Mi == MDate.length - 1) {
											resetMonth();
											continue goYear;
										}
										continue goMonth;
									}
									continue goDay;
								}
								continue;
							}
							// xe đạp"điểm"mảng
							goMin: for (let mi = mIdx; mi < mDate.length; mi++) {
								let mm = mDate[mi] < 10 ? '0' + mDate[mi] : mDate[mi];

								// Nếu đạt giá trị cực đại
								if (nSecond > sDate[sDate.length - 1]) {
									resetSecond();
									if (mi == mDate.length - 1) {
										resetMin();
										if (hi == hDate.length - 1) {
											resetHour();
											if (Di == DDate.length - 1) {
												resetDay();
												if (Mi == MDate.length - 1) {
													resetMonth();
													continue goYear;
												}
												continue goMonth;
											}
											continue goDay;
										}
										continue goHour;
									}
									continue;
								}
								// xe đạp"Thứ hai"mảng
								goSecond: for (let si = sIdx; si <= sDate.length - 1; si++) {
									let ss = sDate[si] < 10 ? '0' + sDate[si] : sDate[si];
									// Thêm thời gian hiện tại（Tính hợp pháp của thời gian đã được đánh giá trong chu kỳ ngày）
									if (MM !== '00' && DD !== '00') {
										resultArr.push(YY + '-' + MM + '-' + DD + ' ' + hh + ':' + mm + ':' + ss)
										nums++;
									}
									// Nếu số lượng mục đã đầy thì thoát khỏi vòng lặp
									if (nums == 5) break goYear;
									// Nếu đạt giá trị cực đại
									if (si == sDate.length - 1) {
										resetSecond();
										if (mi == mDate.length - 1) {
											resetMin();
											if (hi == hDate.length - 1) {
												resetHour();
												if (Di == DDate.length - 1) {
													resetDay();
													if (Mi == MDate.length - 1) {
														resetMonth();
														continue goYear;
													}
													continue goMonth;
												}
												continue goDay;
											}
											continue goHour;
										}
										continue goMin;
									}
								} //goSecond
							} //goMin
						}//goHour
					}//goDay
				}//goMonth
			}
			// phán xét100Số kết quả trong năm
			if (resultArr.length == 0) {
				this.resultList = ['Kết quả không đáp ứng điều kiện！'];
			} else {
				this.resultList = resultArr;
				if (resultArr.length !== 5) {
					this.resultList.push('gần đây100Chỉ những điều trên trong năm' + resultArr.length + 'kết quả！')
				}
			}
			// Tính toán hoàn thành-Hiển thịkết quả
			this.isShow = true;


		},
		// Dùng để tính chỉ số của một số trong mảng
		getIndex(arr, value) {
			if (value <= arr[0] || value > arr[arr.length - 1]) {
				return 0;
			} else {
				for (let i = 0; i < arr.length - 1; i++) {
					if (value > arr[i] && value <= arr[i + 1]) {
						return i + 1;
					}
				}
			}
		},
		// lấy"Năm"mảng
		getYearArr(rule, year) {
			this.dateArr[5] = this.getOrderArr(year, year + 100);
			if (rule !== undefined) {
				if (rule.indexOf('-') >= 0) {
					this.dateArr[5] = this.getCycleArr(rule, year + 100, false)
				} else if (rule.indexOf('/') >= 0) {
					this.dateArr[5] = this.getAverageArr(rule, year + 100)
				} else if (rule !== '*') {
					this.dateArr[5] = this.getAssignArr(rule)
				}
			}
		},
		// lấy"mặt trăng"mảng
		getMonthArr(rule) {
			this.dateArr[4] = this.getOrderArr(1, 12);
			if (rule.indexOf('-') >= 0) {
				this.dateArr[4] = this.getCycleArr(rule, 12, false)
			} else if (rule.indexOf('/') >= 0) {
				this.dateArr[4] = this.getAverageArr(rule, 12)
			} else if (rule !== '*') {
				this.dateArr[4] = this.getAssignArr(rule)
			}
		},
		// lấy"ngày"mảng-Chủ yếu là quy tắc ngày
		getWeekArr(rule) {
			// Chỉ khi cả hai giá trị của quy tắc ngày đều“”ngày biểu hiện thời gianCóVới các tùy chọn
			if (this.dayRule == '' && this.dayRuleSup == '') {
				if (rule.indexOf('-') >= 0) {
					this.dayRule = 'weekDay';
					this.dayRuleSup = this.getCycleArr(rule, 7, false)
				} else if (rule.indexOf('#') >= 0) {
					this.dayRule = 'assWeek';
					let matchRule = rule.match(/[0-9]{1}/g);
					this.dayRuleSup = [Number(matchRule[1]), Number(matchRule[0])];
					this.dateArr[3] = [1];
					if (this.dayRuleSup[1] == 7) {
						this.dayRuleSup[1] = 0;
					}
				} else if (rule.indexOf('L') >= 0) {
					this.dayRule = 'lastWeek';
					this.dayRuleSup = Number(rule.match(/[0-9]{1,2}/g)[0]);
					this.dateArr[3] = [31];
					if (this.dayRuleSup == 7) {
						this.dayRuleSup = 0;
					}
				} else if (rule !== '*' && rule !== '?') {
					this.dayRule = 'weekDay';
					this.dayRuleSup = this.getAssignArr(rule)
				}
			}
		},
		// lấy"ngày"mảng-Một số ít quy tắc ngày tháng
		getDayArr(rule) {
			this.dateArr[3] = this.getOrderArr(1, 31);
			this.dayRule = '';
			this.dayRuleSup = '';
			if (rule.indexOf('-') >= 0) {
				this.dateArr[3] = this.getCycleArr(rule, 31, false)
				this.dayRuleSup = 'null';
			} else if (rule.indexOf('/') >= 0) {
				this.dateArr[3] = this.getAverageArr(rule, 31)
				this.dayRuleSup = 'null';
			} else if (rule.indexOf('W') >= 0) {
				this.dayRule = 'workDay';
				this.dayRuleSup = Number(rule.match(/[0-9]{1,2}/g)[0]);
				this.dateArr[3] = [this.dayRuleSup];
			} else if (rule.indexOf('L') >= 0) {
				this.dayRule = 'lastDay';
				this.dayRuleSup = 'null';
				this.dateArr[3] = [31];
			} else if (rule !== '*' && rule !== '?') {
				this.dateArr[3] = this.getAssignArr(rule)
				this.dayRuleSup = 'null';
			} else if (rule == '*') {
				this.dayRuleSup = 'null';
			}
		},
		// lấy"giờ"mảng
		getHourArr(rule) {
			this.dateArr[2] = this.getOrderArr(0, 23);
			if (rule.indexOf('-') >= 0) {
				this.dateArr[2] = this.getCycleArr(rule, 24, true)
			} else if (rule.indexOf('/') >= 0) {
				this.dateArr[2] = this.getAverageArr(rule, 23)
			} else if (rule !== '*') {
				this.dateArr[2] = this.getAssignArr(rule)
			}
		},
		// lấy"điểm"mảng
		getMinArr(rule) {
			this.dateArr[1] = this.getOrderArr(0, 59);
			if (rule.indexOf('-') >= 0) {
				this.dateArr[1] = this.getCycleArr(rule, 60, true)
			} else if (rule.indexOf('/') >= 0) {
				this.dateArr[1] = this.getAverageArr(rule, 59)
			} else if (rule !== '*') {
				this.dateArr[1] = this.getAssignArr(rule)
			}
		},
		// lấy"Thứ hai"mảng
		getSecondArr(rule) {
			this.dateArr[0] = this.getOrderArr(0, 59);
			if (rule.indexOf('-') >= 0) {
				this.dateArr[0] = this.getCycleArr(rule, 60, true)
			} else if (rule.indexOf('/') >= 0) {
				this.dateArr[0] = this.getAverageArr(rule, 59)
			} else if (rule !== '*') {
				this.dateArr[0] = this.getAssignArr(rule)
			}
		},
		// Theo thông tin đếnmin-maxQuay lạimột mảng tuần tự
		getOrderArr(min, max) {
			let arr = [];
			for (let i = min; i <= max; i++) {
				arr.push(i);
			}
			return arr;
		},
		// Dựa trên các giá trị phân tán được chỉ định trong quy tắcQuay lạimột mảng
		getAssignArr(rule) {
			let arr = [];
			let assiginArr = rule.split(',');
			for (let i = 0; i < assiginArr.length; i++) {
				arr[i] = Number(assiginArr[i])
			}
			arr.sort(this.compare)
			return arr;
		},
		// Tính toán theo các quy tắc số học nhất địnhQuay lạimột mảng
		getAverageArr(rule, limit) {
			let arr = [];
			let agArr = rule.split('/');
			let min = Number(agArr[0]);
			let step = Number(agArr[1]);
			while (min <= limit) {
				arr.push(min);
				min += step;
			}
			return arr;
		},
		// theo quy địnhQuay lạimột mảng định kỳ
		getCycleArr(rule, limit, status) {
			// status--thể hiệnCóKhôngtừ0bắt đầu（Sau đó từ1bắt đầu）
			let arr = [];
			let cycleArr = rule.split('-');
			let min = Number(cycleArr[0]);
			let max = Number(cycleArr[1]);
			if (min > max) {
				max += limit;
			}
			for (let i = min; i <= max; i++) {
				let add = 0;
				if (status == false && i % limit == 0) {
					add = limit;
				}
				arr.push(Math.round(i % limit + add))
			}
			arr.sort(this.compare)
			return arr;
		},
		// So sánh số（dùng choArray.sort）
		compare(value1, value2) {
			if (value2 - value1 > 0) {
				return -1;
			} else {
				return 1;
			}
		},
		// Định dạng định dạng ngày như：2017-9-19 18:04:33
		formatDate(value, type) {
			// Tính toán các giá trị liên quan đến ngày
			let time = typeof value == 'number' ? new Date(value) : value;
			let Y = time.getFullYear();
			let M = time.getMonth() + 1;
			let D = time.getDate();
			let h = time.getHours();
			let m = time.getMinutes();
			let s = time.getSeconds();
			let week = time.getDay();
			// nếu được thông quatypetừ
			if (type == undefined) {
				return Y + '-' + (M < 10 ? '0' + M : M) + '-' + (D < 10 ? '0' + D : D) + ' ' + (h < 10 ? '0' + h : h) + ':' + (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s);
			} else if (type == 'week') {
				// hiện hữuquartzở giữa 1cho ngày chủ nhật
				return week + 1;
			}
		},
		// Ngày kiểm traCóKhônghiện hữu
		checkDate(value) {
			let time = new Date(value);
			let format = this.formatDate(time)
			return value === format;
		}
	},
	watch: {
		'ex': 'expressionChange'
	},
	props: ['ex'],
	mounted: function () {
		// khởi tạo Nhận kết quả một lần
		this.expressionChange();
	}
}

</script>
