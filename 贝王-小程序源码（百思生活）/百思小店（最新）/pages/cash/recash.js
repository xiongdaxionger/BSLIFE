var app = getApp();
var util = require('../../utils/util.js');
Page({

  /**
   * 页面的初始数据
   */
  data: {
    //是否跳转选择账号
    isNavigateSelect:false,
    //提现账号ID
    accountID:'',
    //提现账号
    accountName:'',
    price:'0.00',
    pId:'',
    cashType:'0',
    recashTime:'',
    confirm: false,
    remake:'',
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var that = this;
   // app.globalData.mobile = options.mobile;
    var param = {
      method: 'pos.store.get_partner',
      member_id: app.globalData.userInfo.userId
    }
    app.request(param, function (data) {
      data.recash_time = util.formatTimesamp(data.recash_time, 0);
      that.setData({
        price: data.price,
        pId: data.id,
        cashType: data.cash_type,
        recashTime: data.recash_time,
        remake: data.remark
      })
    }, function (data) {

    }, true, true, true)
    
  },
  onShow:function(){
    if (this.data.isNavigateSelect) {
      this.data.isNavigateSelect = false
      let model = wx.getStorageSync('accountInfo')
      if (typeof model == "string" || model == null) {
        return
      }
      wx.setStorageSync('accountInfo', "")
      this.data.accountID = model.ID
      if (this.data.accountID){
        this.setData({
          confirm: true
        })
      }
      var num = model.info;
      if (num != null && num.length > 4) {
        num = num.substring(num.length - 4);
      }
      this.setData({
        accountName: model.name + ' ' + '尾号' + num
      })
    }
  },
  /**
   * 添加账号
   */
  accountlist:function(){
    this.data.isNavigateSelect = true;
    wx.navigateTo({
      url: '/pages/balance/accountlist'
    })
  },
  // 退款
  recash:function(){
    var that = this;
    if (that.data.accountID == ''){
      return false;
    }
    var params = {
      method: 'pos.cashier.re_cash',
      member_bank_id: that.data.accountID,
      price: that.data.price,
      id: that.data.pId
    };
    app.request(params, function (data) {
      wx.showToast({
        title: '申请成功',
        icon:'success'
      })
      that.onLoad();
    }, function (msg, data) {

    }, true, false, true);
  }
})