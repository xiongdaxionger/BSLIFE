// 充值确认
var app = getApp();

Page({
  data: {
    imgURL: app.getImgURL(),
    payInfos: null, //支付方式
    amount_symbol: '', //金钱符号
    activity: null, //选中的充值活动
    cur_input_amount: '', //当前输入的金额
    cur_selected_payInfo: 0, //当前选中的支付方式
    join_activity: false, //是否参加充值有礼
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    const payInfos = JSON.parse(options.payInfos);
    this.setData({
      payInfos: payInfos,
      amount_symbol: options.amount_symbol,
    })

    if (options.amount != null) {
      this.setData({
        cur_input_amount: options.amount,
        activity: JSON.parse(options.activity),
        join_activity: true
      })
    }
    console.log(this.data);
  },

  onReady: function () {
    if (this.data.join_activity) {
      wx.setNavigationBarTitle({
        title: '充值确认'
      })
    }
  },

  // 支付
  pay: function () {
    
    const amount = this.data.cur_input_amount;
    if (amount == null || amount.length == 0 || parseFloat(amount) <= 0) {
      wx.showModal({
        title: "请输入有效充值金额",
        content: "",
        showCancel: false
      });
      return;
    }
    let object = this.data.payInfos[this.data.cur_selected_payInfo]
    let appID = object.app_id;
    const that = this;

    wx.login({
      success: function(res){
        app.request({
          method:'b2c.member.dopayment_recharge',
          "payment[money]":amount,
          "payment[pay_app_id]":appID,
          "code":res.code
        },function(data){
            wx.requestPayment({
                'timeStamp': data.timestamp.toString(),
                'nonceStr': data.noncestr,
                'package': data.return.package,
                'signType': 'MD5',
                'paySign': data.return.sign,
                'success':function(res){
                    that.topupFinfish()
                },
                'fail':function(res){
                  wx.showModal({
                    title: "充值失败,请重试",
                    content: "",
                    showCancel: false
                  });
                }
            })
        },function(data){

        },true,true,true)
      },
      fail: function() {
      },
      complete: function() {
      }
    })
  },

  // 充值完成
  topupFinfish: function () {
    var delta = 1;
    if (this.data.join_activity) {
      delta = 2;
    }

    
    wx.setStorage({
      key: 'topupResult',
      data: true
    })
    wx.navigateBack({
      delta: delta, // 回退前 delta(默认为1) 页面
    })
  },

  // 选中支付方式
  tapSelected: function (event) {
    const index = event.currentTarget.dataset.index;
    const cur_selected_payInfo = this.data.cur_selected_payInfo;
    if (index == cur_selected_payInfo)
      return;
    this.setData({
      cur_selected_payInfo: index
    })
  },

  // 充值金额输入内容改变
  inputDidChange: function (event) {
    this.setData({
      cur_input_amount : event.detail.value
    })
  }
})