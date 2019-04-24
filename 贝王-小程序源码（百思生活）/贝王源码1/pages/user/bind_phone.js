// pages/user/bind_phone.js

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

    account: null, //不问空时表示当前账号已判断，第三方登陆绑定手机号用到
    msg: null, //绑定的提示信息
    is_exist: false, //手机号是否已注册或已绑定
    shouldBindAfterDetectAccount: false, //检测完后是否直接绑定

    confirmEnable: false, //是否确定


    // 是否是第三方登录绑定手机号
    is_social_login: false,

    //绑定完成后跳转
    redirectTo: null,
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    
    app = getApp();
    stringUtil = require("../../utils/string.js");

    // 微信登录
    var weixin_login = options.weixin_login;
    if (weixin_login == 'true') {
      this.setData({
        is_social_login: true
      })
    } else {
      // app全局信息
      const globalData = app.globalData;
      this.setData({
        is_social_login: globalData.isWeixinLogin
      })
    }

    if (options.redirectTo != null && options.redirectTo.length > 0){
      this.setData({
        redirectTo: decodeURIComponent(options.redirectTo)
      })
    }
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

    if (key == 'phoneNumber' && value != null && stringUtil.isMobileNumber(value)) {
      this.detectAccount(value);
    }

    var confirmEnable = phoneNumber != null && phoneNumber.length > 0
      && code != null && code.length > 0
      && (!data.is_social_login || (password != null && password.length > 0));
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

    const that = this;
    if (!this.data.is_social_login) {
      // 绑定手机号
      var params = {
        method: 'b2c.member.verify_vcode2',
        uname: phoneNumber,
        vcode: code,
        send_type: 'reset'
      };
      app.request(params, function (data) {
        app.globalData.userInfo.phoneNumber = phoneNumber;
        that.bindSuccess(1);
      }, function () {

      }, true, true, true);
    } else {
      //已检测完毕
      if (that.data.account != null) {
        that.socialBindPhone();
      } else {
        that.data.shouldBindAfterDetectAccount = true;
        that.detectAccount();
      }
    }
  },

  // 第三方登陆绑定手机号
  socialBindPhone: function () {
    const data = this.data;
    if (data.is_exist) {
      const msg = data.msg;
      // if (msg == null || msg.length == 0) {
      //   wx.showModal({
      //     title: "手机号已注册",
      //     content: "",
      //     showCancel: false
      //   });
      // } else {
      //   wx.showModal({
      //     title: msg,
      //     content: "",
      //     showCancel: false
      //   });
      // }
      // return;
    }
    data.shouldBindAfterDetectAccount = false;
    const phoneNumber = data.phoneNumber;
    const password = data.password;
    const code = data.code;
    var that = this;

    wx.login({
      success: function (res) {
        const wx_code = res.code;
        wx.getUserInfo({
          success: function (res) {
            // success
            var params = {
              vcode: code,
              'data[trust_source]': 'trustlogin_plugin_weixin',
              encryptedData: res.encryptedData,
              code: wx_code,
              iv: res.iv
            }
            if (data.is_exist) {
              params.uname = phoneNumber;
              params.password = password;
              params.method = 'trustlogin.trustlogin.check_login';
            } else {
              params.method = 'trustlogin.trustlogin.set_login';
              params["pam_account[psw_confirm]"] = password;
              params["pam_account[login_password]"] = password;
              params["pam_account[login_name]"] = phoneNumber;
            }

            app.request(params, function (data) {
              
              app.globalData.userInfo.phoneNumber = phoneNumber;
              app.globalData.isLogin = true;
              app.globalData.userInfo.userId = data.member_id;
              // 登录成功
              app.loadUserInfo(function () {
                that.bindSuccess(2);
              }, true);
            }, function (msg,data) {
              
            }, true, false, true);
          },
          fail: function () {
            // fail
          }
        })
      },
      fail: function () {
        // fail
      }
    })
  },

  // 绑定手机号成功
  bindSuccess: function (delta) {
    
    wx.showToast({
      title: '绑定手机号成功',
      icon: 'success',
      mask: true,
      duration: 2000
    });

    const that = this;
    setTimeout(function(){
      if (that.data.redirectTo != null) {
        wx.redirectTo({
          url: that.data.redirectTo,
        })
      } else {
        wx.navigateBack({
          delta: delta, // 回退前 delta(默认为1) 页面
        })
      }
    }, 1500);
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
        'type': data.is_social_login ? 'trustlogin' : 'reset'
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

  //检测账号是否存在
  detectAccount: function (account) {
    if (account == this.data.account)
      return;
    this.data.account = null;

    const that = this;
    app.request({
      method: 'b2c.passport.signup_ajax_check_name',
      'type': 'trustlogin',
      'pam_account[login_name]': account
    }, function (data) {
      that.setData({
        msg: null,
        account: account,
        is_exist: false
      })
      if (that.data.shouldBindAfterDetectAccount) {
        that.socialBindPhone();
      }
    }, function (msg) {
      that.setData({
        msg: msg,
        is_exist: true,
        account: account
      })
      if (that.data.shouldBindAfterDetectAccount) {
        that.socialBindPhone();
      }
    }, that.data.shouldBindAfterDetectAccount);
  },
})