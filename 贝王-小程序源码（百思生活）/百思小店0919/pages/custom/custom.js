var app = getApp()
var httpRequest = require('../../utils/httpRequest.js');
Page({

  /**
   * 页面的初始数据
   */
  data: {
    id: ''
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var url = httpRequest.getDomain();
    url = url + 'index.php/wap2/article-' + options.id +'.html?is_wx=1&is_xcxbwxd=1';
    this.setData({
      id: url
    })
  },

 
})