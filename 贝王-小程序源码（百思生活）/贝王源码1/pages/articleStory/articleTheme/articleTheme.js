// pages/user/bind_phone.js

var app = getApp()
Page({
  data: {
    article_data: 13
  },
  onLoad: function (options) {
    this.setData({ node_id: options.node_id})
    this.get_article_data();
  },
  //获取页面数据
  get_article_data: function () {
    var node_id=this.data.node_id;
    var that = this;
    var data = {
      method: 'content.article.story_index'
    };
    if(node_id){
      data={
        method: 'content.article.l',
        node_id: node_id,
        page: 1,
        node_type:''
      }
    }
    app.request(data, function (data) {
       data.articles.forEach(function(item){
         item.uptime*=1000;
         var date = new Date(item.uptime);
         item.uptime=date.toLocaleDateString().replace(/\//g,'-')
       })
       that.setData({
         article_data: data
       });
    })
  },
  //点赞
  doLike: function (event) {
    var _this = this
    app.request({
      method: 'content.article.addPraise',
      ifpraise: true,
      article_id: event.target.dataset.id
    }, function (data) {
      _this.get_article_data();
    }, function (data) { }, true, true)
  },
  to_article: function (event) {
    wx.navigateTo({
      url: '/pages/articleStory/articlePage/articlePage?id=' + event.currentTarget.dataset.id,
    })
  }
})