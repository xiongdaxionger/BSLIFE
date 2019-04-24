
const app = getApp();
const search = require('../../pages/goods/good_search.js');

Page({
  data: {
    time:[]
  },
  onLoad: function (options) {
     this.startTimeOut("2017/12/30 18:00")
  },
  startTimeOut(str){//启动倒计时
    var _this = this;
    app.globalData.timeOutId = setInterval(function () {
      _this.setData({ time: app.timeOut(str) });
    }, 1000)
  }

})