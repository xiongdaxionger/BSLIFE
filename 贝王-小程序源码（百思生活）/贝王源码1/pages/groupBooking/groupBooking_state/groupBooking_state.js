
const app = getApp();
const search = require('../../../pages/goods/good_search.js');

Page({
  data: {
    time:[],
  },
  onLoad: function (options) {
    this.startTimeOut("2017/12/30 18:00")
  },
  startTimeOut(str) {//倒计时
    var _this = this;
    app.globalData.timeOutId = setInterval(function () {
      var arr = app.timeOut(str);
      arr[0] = arr[1] * 1 + arr.shift() * 24;
      _this.setData({ time: arr })
    }, 1000)
  },
})