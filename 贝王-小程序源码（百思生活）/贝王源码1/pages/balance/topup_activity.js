// 充值活动

Page({
  data:{
    payInfos:null, //支付方式
    amount_symbol: '', //金钱符号
    activities: [], //充值活动
    cur_input_amount: '', //当前输入的金额
  },
  onLoad:function(options){
    // 页面初始化 options为页面跳转所带来的参数
    const data = JSON.parse(options.data);
    const payments = data.payments;
    const filter = data.active.recharge.filter;
    var activities = new Array();
    const amount_symbol = data.def_cur_sign;

    for(var i = 0;i < filter.length;i ++){
      const obj = filter[i];
      var info = new Object();
      info.desc = obj.brief;
      info.amount = obj.price_min;
      info.giving = obj.song;
      info.name = '充值' + amount_symbol + info.amount + '赠';
      activities.push(info);
    }

    this.setData({
      amount_symbol : amount_symbol,
      payInfos : data.payments,
      activities : activities
    })
  },

  //点击立即充值
  tapTopupInput:function(){
    const amount = this.data.cur_input_amount;
    if(amount == null || amount.length == 0 || parseFloat(amount) <= 0){
      wx.showModal({
      title: "请输入有效充值金额",
      content: "",
      showCancel: false
    });
    return;
    }

    // 获取对应赠品
    const activities = this.data.activities;
    
    var selectedInfo = null;
    for(var i = 0;i < activities.length;i ++){
      const info = activities[i];
      var value = parseFloat(info.amount);
      if(value <= amount){
        if(selectedInfo != null){
          if(value > parseFloat(selectedInfo.amount)){
            selectedInfo = info;
          }
        }else{
          selectedInfo = info;
        }
      }
    }
    this.topupConfirm(selectedInfo, amount);
  },

  // 充值确认
  topupConfirm:function(info, amount){

    const payInfos = this.data.payInfos;
    const amount_symbol = this.data.amount_symbol;

    var url = '/pages/balance/topup_confirm?amount=' + amount + "&payInfos=" + JSON.stringify(payInfos) + '&amount_symbol=' + amount_symbol;
    if(info != null){
      url += '&activity=' + JSON.stringify(info);
    }
    wx.navigateTo({
      url: url
    })
  },

  // 点击我要充值
  tapTopupActivity:function(event){
    const index = event.currentTarget.dataset.index;
    const info = this.data.activities[index];
    this.topupConfirm(info, info.amount);
  },

  // 充值金额输入内容改变
  inputDidChange:function(event){
    this.data.cur_input_amount = event.detail.value;
  }
})