// pages/user/bind_phone.js

var app = getApp()
Page({
  data: {
    article_data:{}
  },
  onLoad: function (options) {
    this.get_article_data()
  },
  //获取页面数据
  get_article_data:function(){
    var that=this;
    app.request({
      method: 'content.article.story_index',
    }, function (data) {
      that.setData({
        article_data:data
      })
    }, function (data) {}, true, true, true)
  },
  doLike:function(event){
    var _this=this
    app.request({
      method: 'content.article.addPraise',
      ifpraise: true,
      article_id: event.target.dataset.id
    }, function (data) {
      _this.get_article_data();
    },function(data){},true,true)
  },
  to_article:function(event){
    wx.navigateTo({
      url: '/pages/articleStory/articlePage/articlePage?id=' + event.currentTarget.dataset.id,
    })
  }
})