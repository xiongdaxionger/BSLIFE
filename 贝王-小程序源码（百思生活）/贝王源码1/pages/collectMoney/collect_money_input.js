// 收钱输入
var app = getApp();
Page({
  data: {
    canNext: false, //是否可以下一步
    name: '', //收款名称
    amount: '', //收款金额

    fail: false, //是否加载失败
    loading: true, //是否在加载

    appName: '', //app名称
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    const userInfo = app.globalData.userInfo;
    var name = userInfo.name;
    if (name == null || name.length == 0) {
      name = userInfo.account;
    }
    this.setData({
      name: name + '直接收款',
      appName: app.getAppName()
    })
  },

  // 输入改变
  textDidChange: function (event) {

    const key = event.target.id;
    const value = event.detail.value;
    this.data[key] = value;

    const name = this.data.name;
    const amount = this.data.amount;

    var canNext = name != null && name.length > 0
      && amount != null && amount.length > 0;

    
    this.setData({
      canNext: canNext
    });
  },

  // 下一步
  next: function (event) {
    if (!this.data.canNext)
      return;
    var that = this;
    const amount = this.data.amount;
    if (parseFloat(amount) <= 0) {
      wx.showModal({
        title: "请输入有效收款金额",
        content: "",
        showCancel: false
      });
      return;
    }

    const name = this.data.name;
    wx.redirectTo({
      url: '/pages/collectMoney/collect_money_share?amount=' + amount + '&name=' + name
    })
  },


})