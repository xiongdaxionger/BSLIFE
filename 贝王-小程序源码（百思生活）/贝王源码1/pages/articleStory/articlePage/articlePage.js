// pages/user/bind_phone.js

var app = getApp()
Page({
  data: {
    article_id:''
  },
  onLoad: function (options) {
    this.setData({
      article_id: options.id
    })
    
  },

})