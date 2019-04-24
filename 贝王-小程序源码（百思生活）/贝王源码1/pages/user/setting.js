var app = getApp();
Page({
  data: {
    imgURL: app.getImgURL(),
    //显示的数据
    infosArr: [],
    iswxtrust:false
  },
  //显示页面
  onLoad: function (options) {
    
  },
  
  onShow:function(){
    this.data.infosArr = app.globalData.userInfo.has_pay_password ? ["修改登录密码", "修改支付密码", "忘记支付密码"] : ["修改登录密码", "设置支付密码"]
    this.setData({
      infosArr: this.data.infosArr
    })
    var that = this;
    var params = {
      method: 'pos.cashier.iswx_trustinfo',
      member_id: app.globalData.userInfo.userId
    };
    app.request(params, function (data) {
      that.setData({
        iswxtrust: data.data
      })
    }, function (msg, data) {

    }, true, false, true);
  },

  //退出登录
  logoutAction: function () {
    wx.showModal({
      title: "退出登录",
      content: "确定要退出登录吗？",
      showCancel: true,
      success: function (res) {
        app.logout()
        wx.navigateBack()
      }
    })
  },
  //点击条目事件
  settingAction: function (event) {
    let index = event.target.dataset.index
    switch (index) {
      case 0: {
        if (app.isWeixinLogin()) {
          //微信登录先绑定手机号
          const that = this;
          app.getAccountSecurityInfo(function () {

            if (app.shouldBindPhoneNumber()) {
              app.bindPhoneNumber();
            } else {
              that.modifyLoginPassword();
            }
          });
        } else {
          this.modifyLoginPassword();
        }

        break;
      }
      case 1:
      case 2: {
        let isSet = 'false';
        if (index == 1) {
          isSet = app.globalData.userInfo.has_pay_password ? "false" : "true";
        }
        if (app.isWeixinLogin()) {
          //微信登录先绑定手机号
          const that = this;
          app.getAccountSecurityInfo(function () {

            if (app.shouldBindPhoneNumber()) {
              app.bindPhoneNumber('../paypassword/paypassword?' + 'isSetPayPass=' + isSet);
            } else {
              that.modifyPayPassword(isSet);
            }
          });
        } else {
          this.modifyPayPassword(isSet);
        }
        break;
      }
    }
  },

  //修改登录密码
  modifyLoginPassword: function () {
    wx.navigateTo({
      url: '../user/changelogin',
    })
  },

  //修改支付密码
  modifyPayPassword: function (isSet) {

    wx.navigateTo({
      url: '../paypassword/paypassword?' + 'isSetPayPass=' + isSet,
    })
  },
  // 微信免登解绑
  settingTrust:function(){
    var that = this;
    var params = {
      method: 'pos.cashier.del_trustinfo',
      member_id: app.globalData.userInfo.userId
    };
    app.request(params, function (data) {
      wx.showToast({
        title: '解绑成功',
        icon:'success'
      })
      that.onShow();
    }, function (msg, data) {

    }, true, false, true);
  }
})