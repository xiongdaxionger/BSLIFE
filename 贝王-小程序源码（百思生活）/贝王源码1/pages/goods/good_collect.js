// pages/goods/good_collect.js
var operation = null;
var app = getApp();

Page({
  data: {
    imgURL: app.getImgURL(),
    fail: false, //是否加载失败
    good_infos: null, //收藏的商品信息

    load_more: false, //是否在加载更多
    good_total_size: 0, //商品列表总数
    page: 0, //当前页码

    showScrollToTop: false, //是否显示回到顶部按钮
    scroll_top: 0, //回到顶部
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    operation = require('../../utils/goodDetailOperation.js');
    this.loadGoodInfo();
  },
  onUnload: function () {
    // 页面关闭
    operation = null;
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

  //加入购物车
  addShopCarAction: function (event) {

    var info = this.data.good_infos[event.currentTarget.dataset.index];
    let param = operation.getAddShopCarParam(null, info.good_id, info.product_id, 1, 0, null, 0, "goods")
    app.request(param,
      function (data) {
        wx.showModal({
          title: '加入购物车成功',
          content: '',
          showCancel: false
        })
      }, function (data) {
      }
      , true, true, true)
  },

  // 到货通知
  tapNotice: function (event) {
    var info = this.data.good_infos[event.currentTarget.dataset.index];

    wx.navigateTo({
      url: '../gooddetail/goodnotify?' + 'goodid=' + info.good_id + '&productid=' + info.product_id,
    })
  },

  // 点击商品
  tapGood: function (event) {
    var info = this.data.good_infos[event.currentTarget.dataset.index];
     wx.navigateTo({
      url: '/pages/gooddetail/gooddetail?productID=' + info.product_id,
    })
  },

  // 删除
  deleteGood: function (event) {

    const index = event.currentTarget.dataset.index;
    var good_infos = this.data.good_infos;
    var info = good_infos[index];
    const that = this;

    app.request({
      method: 'b2c.member.ajax_del_fav',
      gid: info.good_id
    }, function (data) {
      wx.showToast({
        title: '删除成功',
        icon: 'success'
      });
      good_infos.splice(index, 1);
      that.setData({
        good_infos: good_infos
      })
    }, function () {

    }, true, true, true);
  },

  // 加载商品信息
  loadGoodInfo: function () {

    const that = this;
    const data = this.data;
    const page = data.page;
    var params = {
      method: 'b2c.member.favorite',
      page: page + 1
    }

    app.request(params, function (data) {

      // 加载成功
      that.parseGoodInfos(data);
    }, function () {

      const fail = data.load_more;
      that.setData({
        fail: !fail,
        load_more: false
      })
    }, page == 0)
  },

  // 解析商品信息
  parseGoodInfos: function (data) {
    var items = data.favorite;
    var good_infos = this.data.good_infos;

    // 商品信息
    if (items != null) {
      var infos = new Array();
      for (var i = 0; i < items.length; i++) {
        const obj = items[i];
        infos.push(this.goodInfoFromObj(obj));
      }
      if (good_infos == null) {
        good_infos = infos;
      } else {
        Array.prototype.push.apply(good_infos, infos);
      }
    }

    this.setData({
      good_infos: good_infos,
      load_more: false,
      fail: false,
      page : this.data.page + 1
    })

    // 商品总数
    this.data.good_total_size = data.pager.dataCount;
  },

  // 创建商品信息对象
  goodInfoFromObj: function (obj) {
    var info = new Object();
    info.good_id = obj.goods_id;
    info.product_id = obj.product_id;
    info.name = obj.name;
    info.img = obj.image_default_id;
    info.price = obj.price;
    info.isMarket = obj.marketable == 'true';
    info.inventory = obj.store;

    return info;
  },

  // 加载更多
  loadMore: function () {
    const infos = this.data.good_infos;
    if (infos.length < this.data.good_total_size && !this.data.load_more) {
      this.setData({
        load_more: true
      })
      //可以加载
      this.loadGoodInfo();
    }
  },

  // 重新加载
  reloadData: function () {
    this.setData({
      good_infos: null,
      page: 0
    })
    this.loadGoodInfo();
  }
})