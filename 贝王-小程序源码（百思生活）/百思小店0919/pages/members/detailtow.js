var app = getApp();
var util = require('../../utils/util.js');
Page({

  /**
   * 页面的初始数据
   */
  data: {
    income: '0.00',
    memberId: '',
    orderNum: '',
    phone: '',
    area: '',
    navType: 1,
    memberList: [],
    orderList: []
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var regtime = util.formatTimesamp(options.regtime, 2);
    var that = this;
    var area = '';
    if (options.area == 'null') {
      area = '';
    } else {
      area = options.area;
    }
    that.setData({
      income: options.price,
      memberId: options.id,
      orderNum: options.order,
      phone: options.phone,
      regtime: regtime,
      area: area
    })
  },
  // 导航栏选择
  chooseType: function (e) {
    var that = this;
    // 团队
    if (e.currentTarget.dataset.type == '2') {
      var params = {
        method: 'pos.store.all_members',
        member_id: that.data.memberId,
        page: 1
      };
      app.request(params, function (data) {
        that.setData({
          memberList: data.List
        })
      }, function (msg, data) {

      }, true, false, true);
    }
    if (e.currentTarget.dataset.type == '3') {
      var postData = {
        method: 'b2c.member.orders',
        member_id: that.data.memberId,
        is_fx: false,
        is_wx_pro: true,
        order_status: 'all',
        page: 1,
        sess_id: app.globalData.sessId,
        wx_pro_mid: that.data.memberId,
      }
      app.request(postData, function (data) {
        if (data.orders){
          data.orders.forEach(function (item) {
            item.createtime = util.formatTimesamp(item.createtime, 1);
          })
          that.setData({
            orderList: data.orders
          })
        }
      }, function (msg, data) {

      }, true, false, true);
    }
    that.setData({
      navType: e.currentTarget.dataset.type
    })
  }
})