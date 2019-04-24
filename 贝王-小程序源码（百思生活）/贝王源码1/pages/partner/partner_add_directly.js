// 添加会员
var app = null;
var stringUtil = null;

Page({
  data: {
    count_down: false, //是否在倒计时
    second: 120, //当前倒计时秒数
    timer: null, //倒计时

    // 用户输入的信息
    phoneNumber: null, //手机号
    code: null, //验证码
    password: null, //密码
    name: null, //姓名

    confirmEnable: false, //是否确定
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    app = getApp();
    stringUtil = require("../../utils/string.js");
  },
  onUnload: function () {
    // 页面关闭
    app = null;
    stringUtil = null;
    this.stopTimer();
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
    const name = data.name;

    var confirmEnable = phoneNumber != null && phoneNumber.length > 0
      && code != null && code.length > 0
      && password != null && password.length > 0
      && name != null && name.length > 0;
    this.setData({
      confirmEnable: confirmEnable
    });
  },

  // 确定
  confirm: function () {
    const data = this.data;
    if (!data.confirmEnable)
      return;
    const phoneNumber = data.phoneNumber;
    const password = data.password;
    const code = data.code;
    const name = data.name;

    if (password.length < 6 || password.length > 20) {
      wx.showModal({
        title: '请输入6到20位的密码',
        content: "",
        showCancel: false
      });
      return;
    }

    var userInfo = app.globalData.userInfo;
    const that = this;
    var params = {
      method: 'distribution.fxmem.create',
      'pam_account[login_name]': phoneNumber,
      'contact[name]': name,
      'pam_account[login_password]': password,
      'pam_account[psw_confirm]': password,
      'license': true,
      'source': 'weixin',
      vcode: code,
      member_id: userInfo.userId,
    };
    app.request(params, function (data) {
      wx.setStorageSync('addPartnerResult', true);
      wx.showModal({
        title: '添加会员成功',
        content: "",
        showCancel: false,
        confirmText: '确定',
        success: function (res) {
          if (res.confirm) {
            wx.navigateBack({
              delta: 1, // 回退前 delta(默认为1) 页面
            })
          }
        }
      });
    }, function () {

    }, true, true, true);
  },

  // 获取验证码
  getCode: function () {
    if (!this.data.count_down) {
      const data = this.data;
      const phoneNumber = data.phoneNumber;
      if (!stringUtil.isMobileNumber(phoneNumber)) {
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
        'type': 'invite'
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
})