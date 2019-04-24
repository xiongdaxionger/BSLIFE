var app = getApp();
var httpRequest = require('../../utils/httpRequest.js');
var logo = httpRequest.getDomain() + 'public/xcxfiles/logo.png';
Page({

  /**
   * 页面的初始数据
   */
  data: {
    imgURL: app.getImgURL(),
    uname: '',
    password: '',
    logo: logo
  },
  onLoad: function () {
    console.log("555", this.data.imgURL)
    var uname = wx.getStorageSync('uname');
    var isLogin = wx.getStorageSync('isLogin');
    if (uname != "") {
      this.setData({
        uname: uname
      })
    }
    if (isLogin == 'yes') {
      wx.switchTab({
        url: '../home/home',
      })
    }
    //this.loadPageInfo();
  },

  // 加载会员信息

  // 获取登录页面信息
  loadPageInfo: function () {

    var that = this;
    app.request({
      method: 'b2c.passport.login'
    }, function (data) {

      var canWeixin = false;
      var array = data.login_image_url;
      if (array != null) {
        for (var i = 0; i < array.length; i++) {
          var object = array[i];

          if (object.name == "weixin") {
            canWeixin = true;
            break;
          }
        }
      }
      that.setData({
        canWeixin: canWeixin
      });

    }, function () {

    })
  },

  // 登录
  memberLogin: function () {
    var that = this;
    console.log("哈哈-memberLogin");
    var params = {
      method: 'b2c.passport.post_login',
      uname: that.data.uname,
      password: that.data.password,
      site_autologin: 'on',
      verifycode: '',
      is_remember: 'on',
      is_stroe: 'true',
      is_xcx: 'true',
    };
    app.request(params, function (data) {
      console.log("哈哈农夫",data);
      app.globalData.memberId = data.member_id;
      app.globalData.isLogin = true;
      app.globalData.userInfo.userId = data.member_id;
      app.globalData.sessId = data.sess_id;
      wx.setStorageSync('uname', that.data.uname);
      wx.setStorageSync('isLogin', 'yes');
      wx.setStorageSync('userinfo', app.globalData);
      wx.switchTab({
        url: '../home/home',
      })
    }, function (msg, data) {

    }, true, false, true);
  },

  //获取用户授权
  getPhoneNumber: function (e) {
    console.log("getPhoneNumber", e)
    console.log("getPhoneNumber1", e.detail.errMsg)
    console.log("getPhoneNumber2", e.detail.iv)
    console.log("getPhoneNumber3", e.detail.encryptedData)
    if (e.detail.errMsg == 'getPhoneNumber:fail user deny') {
      wx.showModal({
        title: '提示',
        showCancel: false,
        content: '未授权',
        success: function (res) {
          console.log("getPhoneNumberError", res)
        }
      })
    } else {
      wx.showModal({
        title: '提示',
        showCancel: false,
        content: '同意授权',
        success: function (res) {
          console.log("getPhoneNumberSuccess", res)
        }
      })
    }
  },

  // 微信登录
  weixinLogin: function () {
    console.log("触发微信登录")
    const that = this;
    if (that.data.canwx == false) {
      return;
    }
    that.data.canwx = false;
    var code = null;
    wx.login({
      success: function (res) {
        // success
        code = res.code;
        console.log(res);
        console.log("login获取的code", res.code);
        wx.getUserInfo({
          success: function (res) {
            console.log("微信getUserInfo", res);
            var userInfo = res.userInfo;
            app.request({
              method: 'b2c.passport.trust_login',
              provider_code: 'weixin',
              encryptedData: res.encryptedData,
              code: code,
              iv: res.iv
            }, function (data) {
              console.log("b2c.passport.trust_login测试返回data ", data)
              const userId = data.member_id;
              that.loginSucess(userId, true);
            }, function () {
              that.loginFail();
            }, true, false, true)

          },
          fail: function () {
            console.log("wx.getUserInfo fail", res);
            that.loginFail();
          }
        })
      },
      fail: function (res) {
        // fail

        that.data.canwx = true;
        console.log("wx.login fail", res);
        that.loginFail();
      }
    })
  },

  bindGetUserInfo: function (e) {
    console.log(e.detail.userInfo)
  },
  // 登陆成功
  loginSucess: function (userId, isWeixinLogin) {
    console.log("微信快捷登陆成功", userId)
    app.setUserId(userId, isWeixinLogin);
    // 登录成功
    console.log("登陆成功");
    // app.loadUserInfo(function () {
    //   wx.navigateBack({
    //     delta: 1, // 回退前 delta(默认为1) 页面
    //   })
    // }, true);
    wx.switchTab({
      url: '../home/home',
    })
  },

  // 登录失败
  loginFail: function () {
    var that = this;
    that.data.canwx = true;
    wx.showModal({
      title: "网络状态不佳",
      content: "",
      showCancel: false
    });
  },

  // 输入手机号
  setUname: function (e) {
    this.setData({
      uname: e.detail.value
    })
  },
  // 输入密码
  setPass: function (e) {
    this.setData({
      password: e.detail.value
    })
  },
  // 跳转到成为合伙人页面
  paycash: function () {
    wx.navigateTo({
      url: '../cash/verifyphone',
    })
  },
  // 忘记密码
  resetPassword: function () {

    const account = this.data.uname;
    wx.navigateTo({
      url: '/pages/user/reset_password?phoneNumber=' + account
    })
  },
})