var app = getApp();
var httpRequest = require('../../utils/httpRequest.js');
var logo = httpRequest.getDomain() +'public/xcxfiles/002.png';
Page({

  /**
   * 页面的初始数据
   */
  data: {
    uname:'',
    password:'',
    logo: logo
  },
  onLoad:function(){
    var uname = wx.getStorageSync('uname');
    var isLogin = wx.getStorageSync('isLogin');
    if (uname != ""){
      this.setData({
        uname: uname
      })
    }
    if (isLogin == 'yes'){
      wx.switchTab({
        url: '../home/home',
      })
    }
  },
  // 登录
  memberLogin:function(){
    var that = this;
    var params = {
      method: 'b2c.passport.post_login',
      uname: that.data.uname,
      password: that.data.password,
      site_autologin:'on',
      verifycode:'',
      is_remember:'on',
      is_stroe:'true',
      is_xcx: 'true',
    };
    app.request(params, function (data) {
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
  // 输入手机号
  setUname:function(e){
    this.setData({
      uname: e.detail.value
    })
  },
  // 输入密码
  setPass:function(e){
    this.setData({
      password: e.detail.value
    })
  },
  // 跳转到成为合伙人页面
  paycash:function(){
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