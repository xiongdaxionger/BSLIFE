//余额首页 钱包

var app = getApp();

Page({
  data: {
    imgURL: app.getImgURL(),
    fail: false, //是否加载失败
    loading: true, //是否在加载

    money_symbol: '元', //钱符号
    balance: '0.00', //余额
    commission: '0.00', //佣金
    show_commission: false, //是否显示佣金
    withdraw_enable: false, //是否可以提现
    infos: [], //佣金和提现信息
  },
  onLoad: function (options) {
    // 移除充值结果
    wx.removeStorageSync('topupResult');
    // 页面初始化 options为页面跳转所带来的参数
    this.loadBalanceInfo(true);
  },

  onShow: function () {
    
    //  刷新界面
    const result = wx.getStorageSync('topupResult');
    if (result) {
      
      this.loadBalanceInfo(false);
    }
  },

  // 点击账单
  tapBill: function () {
    wx.navigateTo({
      url: '/pages/balance/billlist'
    })
  },

  // 点击问号
  tapMask: function (event) {
    const index = event.currentTarget.dataset.index;
    const info = this.data.infos[index];
    wx.showModal({
      title: info.msg,
      content: "",
      showCancel: false
    });
  },

  // 点击提现
  tapWidthdraw: function () {
    app.getAccountSecurityInfo(function(){

      if (app.shouldBindPhoneNumber()){
        app.bindPhoneNumber('/pages/balance/withdraw');
      }else{
        wx.navigateTo({
          url: '/pages/balance/withdraw'
        })
      }
    });
    
  },

  // 点击充值
  tapTopup: function () {
    app.request({
      method: 'b2c.member.deposit'
    }, function (data) {
      var actEnable = false;
      if (data.active != null) {
        var activityObj = data.active.recharge;
        if (activityObj != null) {
          if (activityObj.status == 1) {
            actEnable = activityObj.filter != null && activityObj.filter.length > 0;
          }
        }
      }
      const json = JSON.stringify(data);
      if (actEnable) {
        // 有充值活动
        wx.navigateTo({
          url: '/pages/balance/topup_activity?data=' + json,
        })
      } else {
        // 没充值活动
        const payInfos = data.payments;
        const amount_symbol = data.def_cur_sign;

        var url = '/pages/balance/topup_confirm?payInfos=' + JSON.stringify(payInfos) + '&amount_symbol=' + amount_symbol;
        wx.navigateTo({
          url: url
        })
      }
    }, function () {

    }, true, true, true);
  },

  // 加载钱包信息
  loadBalanceInfo: function (flag) {
    this.setData({
      loading: flag
    })

    const that = this;
    app.request({
      method: 'b2c.wallet.index'
    }, function (data) {
      const result = wx.getStorageSync('topupResult');
      if (result){
        wx.showToast({
          title: '充值成功',
          icon: 'success',
        })
      }
      const advance = data.advance;
      if (advance != null) {
        that.setData({
          balance: advance.total,
          money_symbol: data.cur,
          withdraw_enable: data.withdrawal_status == "true",
          show_commission: data.commision_status
        })
      }

      const commission = data.commision;
      if (commission != null) {
        that.setData({
          commission: commission.total
        })
      }

      var infos = new Array();

      // 佣金信息
      if (that.data.show_commission) {
        var obj = new Object();
        obj.name = "累计佣金";
        obj.amount = commission.sum;
        obj.msg = "累计佣金";
        infos.push(obj);

        obj = new Object();
        obj.name = "冻结佣金";
        obj.amount = commission.freeze;
        obj.msg = "冻结佣金";
        infos.push(obj);
      }

      // 提现信息
      if (that.data.withdraw_enable) {
        var obj = new Object();
        obj.name = "正在提现";
        obj.amount = data.txing;
        obj.msg = data.txing_notice;
        infos.push(obj);

        obj = new Object();
        obj.name = "累计提现";
        obj.amount = data.tixian;
        obj.msg = data.tixian_notice;
        infos.push(obj);
      }
      if (infos.length > 0) {
        that.setData({
          infos: infos
        })
      }
      that.setData({
        loading: false
      })
    }, function () {
      if (flag) {
        that.setData({
          fail: true
        })
      }
    }, flag, flag, flag);
  },

  // 重新加载
  reloadData: function () {
    this.setData({
      fail: false,
    })
    this.loadBalanceInfo(true);
  }

})