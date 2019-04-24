var app = getApp();
var util = require('../../utils/util.js');
Page({

  /**
   * 页面的初始数据
   */
  data: {
    articleList:[],
    articleType:[],
    nodeId:''
  },
  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function () {
    var that = this;
    that.getArticleType();
  },
  // 跳转到文章内页
  jumpCustom:function(e){
    var id = e.currentTarget.dataset.id;
    wx.navigateTo({
      url: '../custom/custom?id=' + id,
    })
  },
  // 获取文章栏目
  getArticleType:function(){
    var that = this;
    var params = {
      method: 'pos.store.get_article_type',
      node_type: "xcxactive",
    };
    app.request(params, function (data) {
      that.setData({
        articleType:data.data,
        nodeId: data.data['0'].node_id
      })
      that.getArticleList(data.data['0'].node_id)
    }, function (msg, data) {

    }, true, false, true);
  },
  getArticleList: function (node_id){
    var that = this;
    var params = {
      method: 'content.article.l',
      node_type: "xcxactive",
      page: '1',
      node_id: node_id
    };
    app.request(params, function (data) {
      if (data.articles){
        data.articles.forEach(function (item) {
          item.pubtime = util.formatTimesamp(item.pubtime, 2);
        })
        that.setData({
          articleList: data.articles
        })
      }
      
    }, function (msg, data) {

    }, true, false, true);
  },
  // 选择文章类型
  chooseNodeId:function(e){
    var id = e.currentTarget.dataset.id;
    this.setData({
      nodeId:id
    })
    this.getArticleList(id);
  }
})