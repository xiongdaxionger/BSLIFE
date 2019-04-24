// pages/sms_code_fetch.js

var app = null;
Page({
  data: {
    phoneNumber: null, //手机号
    code: null, //短信验证码

    nextEnable: false, //是否可以下一步

    count_down: false, //是否在倒计时
    second: 120, //当前倒计时秒数
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    this.setData({
      phoneNumber : options.phoneNumber
    });
    app = getApp();
    this.startTimer();
  },
  onUnload: function () {
    // 页面关闭
    this.stopTimer();
    app = null;
  },

  // 联系客服
  tapService: function () {
app.getServicePhoneNumber(function(phone){
      wx.makePhoneCall({
        phoneNumber: phone
      })
    })
  },

  // 下一步
  next: function () {
    const data = this.data;
    if (!data.nextEnable)
      return;
    const phoneNumber = data.phoneNumber;
    const code = data.code;

    // 验证输入的短信验证码
    var params = {
      method: 'b2c.passport.get_vcode',
      uname: phoneNumber,
      'type': 'signup'
    };
    const that = this;
    app.request(params, function (data) {
      const vCode = data.vcode;
      if (vCode == code) {
        wx.redirectTo({
          url: '/pages/login/register?phoneNumber=' + phoneNumber + '&code=' + code
        })
      } else {
        wx.showModal({
          title: '输入的验证码有误',
          content: "",
          showCancel: false
        });
      }
    }, function () {

    }, true, true, true);
  },

  // 输入改变
  textDidChange: function (event) {
    const value = event.detail.value;
    const data = this.data;
    data.code = value;

    this.setData({
      nextEnable: value != null && value.length > 0
    });
  },

  // 获取验证码
  getCode: function () {
    if (!this.data.count_down) {
      const data = this.data;
      const phoneNumber = data.phoneNumber;

      var params = {
        method: 'b2c.passport.send_vcode_sms',
        uname: phoneNumber,
        'type': 'signup'
      };
      const that = this;
      app.request(params, function (data) {
        wx.showModal({
          title: '验证码已发送，请注意查收',
          content: "",
          showCancel: false
        });

        that.startTimer();
      }, function () {

      }, true, true, true);
    }
  },

  // 启动倒计时
  startTimer: function () {

    const that = this;
    that.setData({
      count_down: true,
      second: 120
    });

    var timer = setInterval(function () {
      var second = that.data.second;
      second--;
      if (second <= 0) {
        that.stopTimer();
      } else {
        that.setData({
          second: second
        })
      }
    }, 1000);
    this.data.timer = timer;
  },

  // 停止倒计时
  stopTimer: function () {
    var timer = this.data.timer;
    if (timer != null) {
      clearInterval(timer);
      this.setData({
        timer: null,
        count_down: false
      })
    }
  },
})