var app = getApp();
var stringUtil = require("../../utils/string.js");
Page({

  /**
   * 页面的初始数据
   */
  data: {
    count_down: false, //是否在倒计时
    second: 120, //当前倒计时秒数
    timer: null, //倒计时
    phone: '',
    vcode: '',
    confirm: false,
    partner: [],
    stepFirst:true,
    stepTow:false,
    stepThree: false,
    price:'0.00',
    partnerId:'',
    finishPid:'',
    stepThrees: false,
    stepTows:false,
    btns:'',
    mlvId:'',
    //是否显示图片验证码
    showImageCode:false,
    //图片验证码链接
    imageCodeURL:'',
    ///输入的图片验证码内容
    inputCode:'',
    ///验证码前置链接
    codeURL:''
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function () {
    this.getNeedImageCodeInfo()
  },
  ///是否需要图片验证码
  getNeedImageCodeInfo:function(){
    var that = this;
    app.request({
      method: 'b2c.passport.sendPSW'
    }, function (data) {
      that.setData({
        showImageCode: data.site_sms_valide == 'true',
        codeURL:data.code_url,
        imageCodeURL: data.code_url + "?" + new Date().getTime(),
      })
    },function(){},true,true,true);
  },
  ///切换验证码
  tapImageCode: function () {
    this.setData({
      imageCodeURL: this.data.codeURL + "?" + new Date().getTime(),
    });
  },
  // 获取验证码
  getCode: function () {
    if (!this.data.count_down) {
      var that = this;
      const data = this.data;
      const phoneNumber = data.phone;
      if (!stringUtil.isMobileNumber(phoneNumber)) {
        wx.showModal({
          title: '请输入有效手机号',
          content: "",
          showCancel: false
        });
        return;
      }
      if (this.data.showImageCode && this.data.inputCode == '') {
        wx.showModal({
          title: '请输入图形验证码',
          content: "",
          showCancel: false
        });
        return
      }

      var params = {
        method: 'b2c.passport.send_vcode_sms',
        uname: that.data.phone,
        type: 'partner'
      };
      if (this.data.showImageCode) {
        params.sms_vcode = this.data.inputCode
      }
      app.request(params, function (data) {
        wx.showModal({
          title: '验证码已发送，请注意查收',
          content: "",
          showCancel: false
        });

        that.setData({
          count_down: true,
          second: 120
        });
        that.startTimer();
      }, function (msg, data) {
        that.tapImageCode()
      }, true, false, true);
    }

  },
  // 启动倒计时
  startTimer: function () {

    const that = this;

    var timer = setInterval(function () {
      var second = that.data.second;
      second--;
      if (second <= 0) {
        that.stopTimer();
      } else {
        that.setData({
          second: second
        })
      }
    }, 1000);
    this.data.timer = timer;
  },
  // 停止倒计时
  stopTimer: function () {
    var timer = this.data.timer;
    if (timer != null) {
      clearInterval(timer);
      this.tapImageCode()
      this.setData({
        timer: null,
        count_down: false
      })
    }
  },
  // 确认按钮是否可以点击
  showconfirm: function () {
    var data = this.data;
    if (data.phone != '' && data.vcode != '' && data.phone.length == 11) {
      this.setData({
        confirm: true
      })
    } else {
      this.setData({
        confirm: false
      })
    }
  },
  // 输入验证码
  setVcode: function (e) {
    this.setData({
      vcode: e.detail.value
    })
    this.showconfirm();
  },
  // 输入手机号码
  setPhone:function(e){
    this.setData({
      phone: e.detail.value
    })
    this.showconfirm();
  },
  // 下一步
  confirm:function(){
    var data = this.data;
    if (!data.confirm){
      return false;
    }
    var that = this;
    var param = {
      method: 'pos.store.verify_phone',
      phone: data.phone,
      vcode: data.vcode
    }
    app.request(param, function (data) {
      if (data.member_lv_id){
        that.getCash(data.member_lv_id);
      }else{
        that.getCash(data.member_lv.member_group_id);
      }
      
    }, function (data) {

    }, true, true, true)
  },
  // 获取小店权益金
  getCash: function (lvId){
    var that = this;
    var param = {
      method: 'pos.cashier.get_cash',
      member_lv_id: lvId
    }
    app.request(param, function (data) {
      if (data.length > 0){
        that.setData({
          partner: data,
          price: data['0'].price,
          partnerId: data['0'].partner_id,
          stepFirst: false,
          stepTow: true,
          stepTows: true,
        })
      }else{
        wx.showModal({
          title: '提示',
          content: '暂时没有适合该号码的套餐',
        })
      }
    }, function (data) {

    }, true, true, true)
  },
  // 微信支付
  wxpay: function (e) {
    if (this.data.phone == '') {
      return;
    }
    var money = e.currentTarget.dataset.price;
    var phone = this.data.phone;
    var that = this;
    wx.login({
      success: function (res) {
        app.request({
          method: 'pos.cashier.become_partner',
          "payment[money]": money,
          "payment[pay_app_id]": 'wxpayjsapi',
          "payment[partner_id]": that.data.partnerId,
          "code": res.code,
          phone: phone,
          is_store: "true"
        }, function (data) {
          wx.requestPayment({
            'timeStamp': data.timestamp.toString(),
            'nonceStr': data.noncestr,
            'package': data.return.package,
            'signType': 'MD5',
            'paySign': data.return.sign,
            'success': function (res) {
              that.setData({
                finishPid:that.data.partnerId,
                stepTow:false,
                stepFirst: false,
                stepThree:true,
                stepThrees: true
              })
              that.getPartnerDetail(that.data.partnerId);
            },
            'fail': function (res) {
              wx.showModal({
                title: "支付失败,请重试",
                content: "",
                showCancel: false
              });
            }
          })
        }, function (data) {

        }, true, true, true)
      },
      fail: function () {
      },
      complete: function () {
      }
    })
  },
  // 选择套餐
  choosePartner:function(e){
    this.setData({
      price: e.currentTarget.dataset.price,
      partnerId: e.currentTarget.dataset.id,
    })
  },
  // 返回登录页
  reLogin:function(){
    this.setData({
      partner: []
    })
    wx.navigateBack({})
  },
  // 获取套餐详情
  getPartnerDetail: function (partner_id){
    var that = this;
    var param = {
      method: 'pos.store.partner_detail',
      partner_id: partner_id
    }
    app.request(param, function (data) {
      var mlvId = '';
      if(data.data == '1'){
        mlvId = data.list.up_level
      }
      that.setData({
        btns: data.data,
        mlvId: mlvId
      })
    }, function (data) {

    }, true, true, true)
  },
  // 继续选择套餐
  reBack:function(){
    var that = this;
    that.getCash(that.data.mlvId);
    that.setData({
      stepThrees:false,
      stepThree:false
    })
  },
  // 验证是否合伙人
  verifyMobile:function(){
    var that = this;
    if (this.data.count_down){
      return
    }
    if (this.data.phone == '') {
      wx.showModal({
        title: "请输入手机号码",
        content: "",
        showCancel: false
      });
      return
    }
    var param = {
      method: 'pos.store.verify_mobile',
      phone: that.data.phone
    }
    app.request(param, function (data) {
      if(data){
        that.getCode();
      }
    }, function (data) {

    }, true, true, true)
  },
  ///图形验证码输入
  imageCodeChange:function(event){
    this.data.inputCode = event.detail.value
  }
})