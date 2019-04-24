
// 登录
// app实例
var app = getApp();

Page({
    data: {
        imgURL: app.getImgURL(),
        canLogin: false, ///是否可以登录
        account: '', ///账号
        password: null, ///密码
        passwordOpen: false, ///是否显示密码

        weixinAnimation: {}, ///微信登录按钮动画
        canWeixin: false, ///能否使用微信登录
        canwx:true
    },

    onLoad: function (options) {
        const account = wx.getStorageSync('loginAccount');
        if(account != null && account.length > 0){
            this.setData({
                account : account
            })
        }

        this.loadPageInfo();
    },

    // 输入改变
    inputDidChange: function (event) {

        const key = event.target.id;
        const value = event.detail.value;
        this.data[key] = value;

        const account = this.data.account;
        const password = this.data.password;

        var canLogin = account != null && account.length > 0
            && password != null && password.length > 0;
        this.setData({
            canLogin: canLogin
        });
    },

    // 点击眼睛
    openPassword: function () {
        var passwordOpen = this.data.passwordOpen;
        this.setData({
            passwordOpen: !passwordOpen
        })
    },

    // 普通登录
    login: function (event) {
        if (!this.data.canLogin)
            return;
        var that = this;
        const account = this.data.account;
        var params = {
            method: 'b2c.passport.post_login',
            uname: account,
            password: this.data.password,
            is_xcx:true
        };

        app.request(params, function (data) {
          app.globalData.userInfo.memberIdent = data.sess_id;
            wx.setStorageSync('loginAccount', account);
            that.loginSucess(data.member_id, false);
        }, function (msg, data) {

        }, true, false, true);
    },

    // 登陆成功
    loginSucess: function (userId, isWeixinLogin){
      app.setUserId(userId, isWeixinLogin);
            // 登录成功
            app.loadUserInfo(function () {
                wx.navigateBack({
                    delta: 1, // 回退前 delta(默认为1) 页面
                })
            }, true);
    },

    // 微信登录
    weixinLogin: function () {
        
        const that = this;
        if (that.data.canwx == false){
          return;
        }
        that.data.canwx = false;
        var code = null;
        wx.login({
            success: function (res) {
                // success
                code = res.code;
                
                wx.getUserInfo({
                  success: function(res){
                      var userInfo = res.userInfo;

                         app.request({
                          method: 'b2c.passport.trust_login',
                          provider_code : 'weixin',
                          encryptedData : res.encryptedData,
                          code:code,
                          iv : res.iv
                      },function(data){
                          const userId = data.member_id;
                         that.data.canwx = true;
                          if(userId == null || userId.length == 0){
                            // 绑定手机号
                            // that.loginFail();
                            wx.navigateTo({
                              url: '/pages/user/bind_phone?weixin_login=true'
                            })
                          }else{
                            //   登陆成功
                            that.loginSucess(userId, true);
                          }
                      },function(){
                          that.loginFail();
                      },true, false, true)
                    
                  },
                  fail: function() {
                    // fail
                    that.loginFail();
                  }
                })
            },
            fail: function (res) {
                // fail
                
                that.data.canwx = true;
                 that.loginFail();
            }
        })
    },

    // 登录失败
    loginFail:function(){
      that.data.canwx = true;
wx.showModal({
              title: "网络状态不佳",
              content: "",
              showCancel: false
            });
    },
    // 注册
    register: function () {
        wx.navigateTo({
            url: '/pages/login/phone_number_input'
        })
    },

    // 找回密码
    resetPassword:function(){
        
        const account = this.data.account;
        wx.navigateTo({
          url: '/pages/user/reset_password?phoneNumber=' + account
        })
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

})