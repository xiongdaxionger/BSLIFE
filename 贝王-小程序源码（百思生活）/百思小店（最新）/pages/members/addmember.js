var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    referralsurl:''
  },
  onLoad:function(){
    var that = this;
    var userinfos = wx.getStorageSync('userinfo');
    var params = {
      method: 'b2c.member.index',
      wx_pro_mid: userinfos.memberId,
    };
    app.request(params, function (data) {
      that.setData({
        uname: data.member.uname,
        referralsurl: data.referrals_url
      })

    }, function (msg, data) {

    }, true, false, true);
  },
  onShow:function(){
    this.onLoad();
  },
  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
  
  },
  // 二维码邀请
  codetoinvite:function(){
    wx.navigateTo({
      url: './codetoinvite',
    })
  },
  // 添加会员
  addmember:function(){
    wx.navigateTo({
      url: './add',
    })
  },
  // 直接邀请
  actioncnt:function(){
    var that = this;
    wx.showActionSheet({
      itemList: ['复制链接'],
      success: function (res) {
        var referralsurl = that.data.referralsurl;
        wx.setClipboardData({
          data: referralsurl,
          success: function (res) {
            wx.getClipboardData({
              success: function (res) {
                wx.showToast({
                  title: '复制成功',
                  icon: 'success',
                  duration: 2000
                })  
              }
            })
          }
        })
        
      },
      fail: function (res) {
        
      }
    })
  }
})