var app = getApp();
var stringUtil = require("../../utils/string.js");
Page({

  /**
   * 页面的初始数据
   */
  data: {
    phone:'',
    vcode:'',
    uname:'',
    password:'',
    confirm:false,
    count_down: false, //是否在倒计时
    second: 120, //当前倒计时秒数
    timer: null, //倒计时
    //是否显示图片验证码
    showImageCode: false,
    //图片验证码链接
    imageCodeURL: '',
    ///输入的图片验证码内容
    inputCode: '',
    ///验证码前置链接
    codeURL: ''
  },
  // 输入手机号码
  setPhone:function(e){
    this.setData({
      phone: e.detail.value
    })
    this.showconfirm();
  },
  // 输入验证码
  setVcode:function(e){
    this.setData({
      vcode: e.detail.value
    })
    this.showconfirm();
  },
  // 输入昵称
  setUname:function(e){
    this.setData({
      uname: e.detail.value
    })
    this.showconfirm();
  },
  // 输入密码
  setPass:function(e){
    this.setData({
      password: e.detail.value
    })
    this.showconfirm();
  },
  /**
 * 生命周期函数--监听页面加载
 */
  onLoad: function () {
    this.getNeedImageCodeInfo()
  },
  ///是否需要图片验证码
  getNeedImageCodeInfo: function () {
    var that = this;
    app.request({
      method: 'b2c.passport.sendPSW'
    }, function (data) {
      that.setData({
        showImageCode: data.site_sms_valide == 'true',
        codeURL: data.code_url,
        imageCodeURL: data.code_url + "?" + new Date().getTime(),
      })
    }, function () { }, true, true, true);
  },
  ///切换验证码
  tapImageCode: function () {
    this.setData({
      imageCodeURL: this.data.codeURL + "?" + new Date().getTime(),
    });
  },
  // 确认添加
  confirm:function(){
    var confirm = this.data.confirm;
    if (!confirm){
      return;
    }
    var userinfos = wx.getStorageSync('userinfo');
    var that = this;
    var params = {
      method: 'distribution.fxmem.create',
      'pam_account[login_name]': that.data.phone,
      'pam_account[login_password]': that.data.password,
      'pam_account[psw_confirm]': that.data.password,
      vcode: that.data.vcode,
      source:'bwstore',
      license:'on',
      'contact[name]': that.data.uname,
      wx_pro_mid: userinfos.memberId,
    };
    app.request(params, function (data) {
      that.setData({
        phone: '',
        vcode: '',
        uname: '',
        password: '',
        confirm: false,
        count_down: false,
        second: 120,
        timer: null,
      })
      wx.showModal({
        title: '注册成功',
        content: "",
        showCancel: false,
        success: function (res) {
          if (res.confirm) {
            wx.navigateBack({})
          }
        }  
      });
      
    }, function (msg, data) {

    }, true, false, true);
  },
  // 确认按钮是否可以点击
  showconfirm:function(){
    var data = this.data;
    if (data.phone != '' && data.vcode != '' && data.uname != '' && data.password != '' && data.phone.length == 11){
      this.setData({
        confirm: true
      })
    }else{
      this.setData({
        confirm: false
      })
    }
  },
  // 获取验证码
  getCode:function(){
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
        type: 'invite'
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
  ///图形验证码输入
  imageCodeChange: function (event) {
    this.data.inputCode = event.detail.value
  }
})