// pages/phone_number_input.js

var app = null;
var stringUtil = null;

Page({
  data:{
    phoneNumber:null, //手机号

    nextEnable:false, //是否可以下一步
  },
  onLoad:function(options){
    // 页面初始化 options为页面跳转所带来的参数
    app = getApp();
    stringUtil = require("../../utils/string.js");
  },
  onUnload:function(){
    // 页面关闭
    app = null;
    stringUtil = null;
  },

  // 联系客服
  tapService:function(){
    app.getServicePhoneNumber(function(phone){
      wx.makePhoneCall({
        phoneNumber: phone
      })
    })
  },

  // 下一步
  next:function(){
     const data = this.data;
     if(!data.nextEnable)
     return;
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
        'type': 'signup'
      };
      const that = this;
      app.request(params, function (data) {
        wx.redirectTo({
          url: '/pages/login/sms_code_fetch?phoneNumber=' + phoneNumber
        })
      }, function () {
        
      }, true, true, true);
  },

  // 输入改变
  textDidChange:function(event){
    const value = event.detail.value;
    const data = this.data;
    data.phoneNumber = value;

    this.setData({
      nextEnable: value != null && value.length > 0
    });
  }
})