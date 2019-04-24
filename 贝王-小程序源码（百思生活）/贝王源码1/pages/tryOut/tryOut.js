// pages/user/bind_phone.js

var app = getApp()
Page({
  data: {
    article_data: {},
    type_index:0
  },
  onLoad: function (options) {
    this.get_article_data()
  },
  //获取页面数据-社区的数据
  get_article_data: function () {
    var that = this;
    app.request({
      method: 'content.article.story_index',
    }, function (data) {
      
      that.setData({
        article_data: data
      })
    }, function (data) { }, true, true, true)
  },
  toggle_type:function(event){
    this.setData({
      type_index: event.currentTarget.dataset.type
    })
  },
  jump_detail:function(){//跳转至详情页
    wx.navigateTo({
      url: '/pages/tryOut/tryOutPro/tryOutPro?productID=133',
    })
  }
})