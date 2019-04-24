var app = getApp();
var util = require('../../utils/util.js');
Page({

  /**
   * 页面的初始数据
   */
  data: {
    memberData:[],
    commision:'0.00',
    teamTotal:'0',
    regtime:'',
    isShowPartner:false
  },
  onLoad:function(){
    
  },
  // 是否显示退小店权益金
  getPartner: function () {
    var that = this;
    var param = {
      method: 'pos.store.get_partner',
      member_id: app.globalData.userInfo.userId
    }
    app.request(param, function (data) {
      if(data){
        if (data.price) {
          that.setData({
            isShowPartner: true
          })
        }
      }
      
    }, function (data) {

    }, true, true, true)

  },
  onShow:function(){
    var userinfo = wx.getStorageSync('userinfo');
    var params = {
      method: 'b2c.member.index',
      wx_pro_mid: userinfo.memberId,
      is_wx_pro: true,
    };
    var that = this;
    app.request(params, function (data) {
      app.globalData.phoneNumber = data.member.login_name_arr.mobile;
      if (data.member.member_type == '1') {
        that.loginOut();
      }
      var regtime = util.formatTimesamp(data.member.regtime, 1);
      that.setData({
        memberData: data,
        regtime: regtime
      })
    }, function (msg, data) {

    }, true, false, true);
    that.commission(userinfo);
    that.getPartner();
  },
  // 我的奖励
  commission:function(data){
    var params = {
      method: 'b2c.wallet.index',
      wx_pro_mid: data.memberId,
      is_wx_pro: true,
      sess_id: data.sessId
    };
    var that = this;
    app.request(params, function (e) {
      that.setData({
        commision: e.commision.total
      })
    }, function (msg, e) {

    }, true, false, true);
    var param = {
      method: 'pos.store.all_members',
      member_id: data.memberId,
      page: 1
    };
    app.request(param, function (data) {
      that.setData({
        teamTotal: data.pager.total
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  // 跳转到我的团队
  myTeam:function(){
    wx.switchTab({
      url: './list',
    })
  },
  // 退出
  loginOut:function(){
    wx.removeStorageSync('isLogin');
    wx.removeStorageSync('userinfo');
    wx.redirectTo({
      url: '../login/login',
    })
  },
  // 跳转到我的奖励
  myCommision:function(){
    wx.navigateTo({
      url: '/pages/balance/balance_home'
    })
  },
  // 退小店权益金
  recash:function(){
    var mobile = this.data.memberData.member.login_name_arr.mobile;
    wx.navigateTo({
      url: '../cash/recash?mobile=' + mobile,
    })
  },
  ranking:function(){
    wx.navigateTo({
      url: '/pages/ranking/ranking'
    })
  }
})