// pages/user/reset_password.js
var stringJs = null;
var app = null;
Page({
  data: {
    count_down: false, //是否在倒计时
    second: 120, //当前倒计时秒数
    timer: null, //倒计时

    // 用户输入的信息
    phoneNumber: null, //手机号
    code: null, //验证码
    password: null, //密码
    confirm_password: null, //确认密码

    confirmEnable: false, //是否确定

    // 客服电话
    servicePhoneNumber: null,
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    stringJs = require("../../utils/string.js");
    app = getApp();
    const phoneNumber = options.phoneNumber;
    
    if (stringJs.isMobileNumber(phoneNumber)) {
      this.setData({
        phoneNumber: phoneNumber
      })
    }
    this.loadPageInfo();
  },
  onUnload: function () {
    // 页面关闭
    stringJs = null;
    app = null;
  },

  // 文字输入改变
  textDidChange: function (event) {
    const key = event.target.id;
    const value = event.detail.value;
    const data = this.data;
    data[key] = value;

    const phoneNumber = data.phoneNumber;
    const password = data.password;
    const code = data.code;
    const confirm_password = data.confirm_password;

    var confirmEnable = phoneNumber != null && phoneNumber.length > 0
      && code != null && code.length > 0
      && password != null && password.length > 0
      && confirm_password != null && confirm_password.length > 0;
    this.setData({
      confirmEnable: confirmEnable
    });
  },

  // 拨打客服电话
  tapService:function(){
    const servicePhoneNumber = this.data.servicePhoneNumber;
    wx.makePhoneCall({
      phoneNumber: servicePhoneNumber
    })
  },

  // 确定
  confirm: function () {
    const data = this.data;
    if (!data.confirmEnable)
      return;
    const confirm_password = data.confirm_password;
    const password = data.password;
    if (confirm_password != password) {
      wx.showModal({
        title: '两次密码输入不一致',
        content: "",
        showCancel: false
      });
      return;
    }
    const phoneNumber = data.phoneNumber;
    const code = data.code;

    const that = this;
    // 重置密码
    var params = {
      method: 'b2c.passport.resetpassword',
      account: phoneNumber,
      key: code,
      psw_confirm: password,
      login_password: password
    };
    app.request(params, function (data) {
      wx.showToast({
        title: '重置密码成功',
        icon: 'success'
      });
      wx.navigateBack({
        delta: 1, // 回退前 delta(默认为1) 页面
      })
    }, function () {

    }, true, true, true);
  },

  // 获取验证码
  getCode: function () {
    if (!this.data.count_down) {
      const data = this.data;
      const phoneNumber = data.phoneNumber;
      if (!stringJs.isMobileNumber(phoneNumber)) {
        wx.showModal({
          title: '请输入有效手机号',
          content: "",
          showCancel: false
        });
        return;
      }

      var params = {
        method: 'b2c.passport.send_vcode_sms',
        uname: phoneNumber,
        'type': 'forgot'
      };
      const that = this;
      app.request(params, function (data) {
        wx.showModal({
          title: '验证码已发送，请注意查收',
          content: "",
          showCancel: false
        });

        that.setData({
          count_down: true,
          second: 120
        });
        that.startTimer();
      }, function () {

      }, true, true, true);
    }
  },

  // 启动倒计时
  startTimer: function () {

    const that = this;

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

  // 加载页面信息
  loadPageInfo: function () {
    const that = this;
    app.request({
      method: 'b2c.passport.sendPSW'
    }, function (data) {
      const tel = data.tel;
      if (tel != null && tel.length > 0) {
        that.setData({
          servicePhoneNumber: tel
        })
      }
    });
  }
})