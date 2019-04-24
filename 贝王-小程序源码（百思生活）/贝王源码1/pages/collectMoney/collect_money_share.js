// pages/collectMoney/collect_money_share.js

var app = getApp();
Page({
  data: {
    name: '', //收款名称
    amount: '', //收款金额
    shareURL: '', //收钱链接
    qrCodeURL: '', //收钱二维码链接

    fail: false, //是否加载失败
    loading: true, //是否在加载
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    this.setData({
      name: options.name,
      amount: options.amount
    })

    this.loadInfo();
  },

  // 加载收钱信息
  loadInfo: function () {

    const that = this;
    var params = {
      method: 'b2c.wallet.collect',
      money: this.data.amount,
      collect_desc: this.data.name,
    };

    app.request(params, function (data) {

      that.setData({
        loading: false,
        qrCodeURL: data.qrcode,
        shareURL: data.link
      })
    }, function (msg, data) {
      that.setData({
        fail: true
      })
    }, true, false, true);
  },

  // 重新加载
  reloadData: function () {
    this.setData({
      fail: false,
    })
    this.loadInfo();
  }
})