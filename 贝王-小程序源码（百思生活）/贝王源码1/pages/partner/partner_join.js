var app = getApp();
var stringJs = null;

Page({
  data: {
    mobile: null, //手机号
    name: null, //姓名
    city: null, //城市
    top_image_url:null,//图片

    fail: false, //加载失败

    confirmEnable: false, //是否可以保存
  },

  onLoad: function (options) {
    stringJs = require("../../utils/string.js");

      this.reloadData();
  },
  onReady: function () {
    // 页面渲染完成
    wx.setNavigationBarTitle({
      title: '合伙人加盟'
    })
  },
  onShow: function () {
    // 页面显示
  },
  onUnload: function () {
    // 页面关闭
    app = null;
    stringJs = null;
  },

  // 文字输入改变
  textDidChange: function (event) {
    const key = event.target.id;
    const value = event.detail.value;
    const data = this.data;
    data[key] = value;
    this.detectSave();
  },

  // 是否可以保存
  detectSave: function () {
    const data = this.data;

    const mobile = data.mobile;
    const city = data.city;
    const name = data.name;

    var confirmEnable = name != null && name.length > 0
      && mobile != null && mobile.length > 0
      && city != null && city.length > 0;
    this.setData({
      confirmEnable: confirmEnable
    });
  },

  // 确定保存
  confirm: function () {
    const data = this.data;
    if (!data.confirmEnable)
      return;
    const mobile = data.mobile;
    if (!stringJs.isMobileNumber(mobile)) {
      wx.showModal({
        title: '请输入有效手机号',
        content: "",
        showCancel: false
      });
      return;
    }

    const name = data.name;
    const city = data.city;
    var member_id = "0";
    if (app.globalData.isLogin){
      member_id = app.globalData.userInfo.userId;
    }
    const that = this;
    // 绑定手机号
    var params = {
      method: 'distribution.apply.add',
      phone: mobile,
      contact: name,
      company : city,
      member_id : member_id
    };

    app.request(params, function (data) {

      // 提交成功
      wx.showToast({
        title: '提交成功，请等待审核',
        icon: 'success'
      });
      wx.navigateBack({
        delta: 1, // 回退前 delta(默认为1) 页面
      })
    }, function () {

    }, true, true, true);
  },

  // 重新加载
  reloadData: function () {
    const that = this;
    that.setData({
      fail: false
    })

    var params = {
      method: 'distribution.apply.index',
    };
    app.request(params, function (data) {
      
      that.setData({
        top_image_url: data[0].params.ad_pic,
        fail:false
      })
    }, function () {
      that.setData({
        fail: true
      })
    }, true, true, true);
  }
})