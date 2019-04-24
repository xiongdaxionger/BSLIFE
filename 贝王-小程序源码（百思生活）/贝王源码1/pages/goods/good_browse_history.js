// pages/goods/good_browse_history.js
var app = getApp();
Page({
  data:{
    good_infos: null, //收藏的商品信息

    showScrollToTop: false, //是否显示回到顶部按钮
    scroll_top: 0, //回到顶部
  },
  onLoad:function(options){
    // 页面初始化 options为页面跳转所带来的参数
    const that = this;
     wx.getStorage({
      key: 'good_browse_history',
      success: function(res){
        // success
        var good_infos = res.data;
        if(good_infos == null || !(good_infos instanceof Array)){
          good_infos = [];
        }
         that.setData({
          good_infos:good_infos
        })
      },
      fail: function() {
        // fail
        that.setData({
          good_infos:[]
        })
      },
      complete: function() {
        // complete
      }
    })
  },

    // 容器滑动
  containerScroll: function (event) {
    const y = event.detail.scrollTop;
    // 屏幕高度
    const height = app.globalData.systemInfo.windowHeight;
    this.setData({
      showScrollToTop: y >= height * 2
    })
  },

  // 回到顶部
  scrollToTop: function () {
    this.setData({
      scroll_top: 1
    })
    // 必须要有改变才会刷新Ui的
    this.setData({
      scroll_top: 0
    })
  },

    // 点击商品
  tapGood: function (event) {
    var info = this.data.good_infos[event.currentTarget.dataset.index];
    wx.navigateTo({
      url: '/pages/gooddetail/gooddetail?productID=' + info.product_id,
    })
  },

  // 删除浏览历史
  deleteHistory:function(event){
    const index = event.currentTarget.dataset.index;
    var good_infos = this.data.good_infos;
    good_infos.splice(index, 1);
    this.setData({
      good_infos: good_infos
    })

    wx.setStorage({
      key: 'good_browse_history',
      data: good_infos,
    })

     wx.setStorage({
    key: 'good_browse_history_count',
    data: good_infos.length
  })
  },

  // 清空浏览历史
  clearHistory:function(){
    wx.removeStorage({
      key: 'good_browse_history',
    })
    this.setData({
      good_infos:[],
      showScrollToTop:false
    })
  }
})


// 添加商品浏览记录
function insertHistory(info){
  var img = '';
  if(info.images.length > 0){
    img = info.images[0];
  }
  var history = {
    good_id: info.goodID,
    product_id : info.productID,
    price: info.showPrice,
    market_price: info.marketPrice,
    name: info.name,
    img : img
  }
  
   wx.getStorage({
    key: 'good_browse_history',
    success: function(res){
      // success
      dealWithRes(res.data, history);
    },
    fail: function() {
      // fail
      dealWithRes(null, history);
    }
  })
}

// 处理获取浏览记录结果
function dealWithRes(data, history){
  if(data == null || !(data instanceof Array)){
    data = new Array();
  }

  //清除相同的商品
  for(let i = 0;i < data.length;i ++){
    const obj = data[i];
    if(obj.product_id == history.product_id){
      data.splice(i, 1);
      break;
    }
  }

  // 保存
  data.splice(0, 0, history);
  if(data.length > 20){
    data.splice(20, data.length - 20);
  }
  wx.setStorage({
    key: 'good_browse_history',
    data: data
  })

  wx.setStorage({
    key: 'good_browse_history_count',
    data: data.length
  })
}

module.exports = {
  insertHistory : insertHistory
}