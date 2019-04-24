// 二维码邀请

var app = getApp();
Page({
  data:{
    name : '', //用户昵称
    qrCodeURL : '' //二维码链接
  },
  onLoad:function(options){
    // 页面初始化 options为页面跳转所带来的参数
    var userInfo = app.globalData.userInfo;
    var name = userInfo.name;
    if(name == null || name.length == 0){
      name = userInfo.account;
    }

    this.setData({
      name : name,
      qrCodeURL : app.globalData.qrCodeURL
    })
  }
})