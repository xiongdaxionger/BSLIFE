// pages/login/register.js
var app = getApp();

Page({
  data: {
    imgURL:app.getImgURL(),
    tick: true, //密码可见是否打钩

    phoneNumber: null, //手机号
    code: null, //短信验证码
    password: null, //密码

    finisnEnable: false, //是否可以完成
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    this.setData({
      phoneNumber: options.phoneNumber,
      code: options.code
    })
  },

  // 联系客服
  tapService: function () {
    app.getServicePhoneNumber(function (phone) {
      wx.makePhoneCall({
        phoneNumber: phone
      })
    })
  },

  // 点击打钩
  tapTick: function () {
    var tick = this.data.tick;
    this.setData({
      tick: !tick
    })
  },

  // 完成
  finsh: function () {
    const data = this.data;
    if (!data.finisnEnable)
      return;
    const password = data.password;
    const phoneNumber = data.phoneNumber;

    if (password.length < 6 || password.length > 20) {
      wx.showModal({
        title: '请输入6-20位的密码',
        content: "",
        showCancel: false
      });
    }

    // 注册
    var params = {
      method: 'b2c.passport.create',
      license: 'on',
      source: 'weixin',
      'pam_account[login_name]': phoneNumber,
      'pam_account[psw_confirm]': password,
      'pam_account[login_password]': password,
      vcode: data.code
    };
    const that = this;
    app.request(params, function (data) {
      const userId = data.member_id;
      if (userId != null && parseInt(userId) > 0) {

        // 设置用户信息
        const app = getApp();
        app.setUserId(userId);
        app.setPhoneNumber(phoneNumber);

        wx.showToast({
          title: '注册成功',
          icon: 'success'
        });

        wx.navigateBack({
          delta: 2, // 回退前 delta(默认为1) 页面
        })
      }
    }, function () {

    }, true, true, true);
  },

  // 输入改变
  textDidChange: function (event) {
    const value = event.detail.value;
    const data = this.data;
    data.password = value;

    this.setData({
      finisnEnable: value != null && value.length > 0
    });
  },
})