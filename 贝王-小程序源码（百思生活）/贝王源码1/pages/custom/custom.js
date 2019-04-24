var app = getApp()
Page({
    data:{
      id:''
    },
    onLoad: function (options) {
      var urlid = decodeURIComponent(options.custom_id);
      this.setData({
        id: urlid
      })
    }
})