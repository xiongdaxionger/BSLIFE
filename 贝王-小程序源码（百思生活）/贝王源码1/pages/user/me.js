
// 我的js

//获取应用实例
var app = getApp();

Page({
  data: {
    imgURL: app.getImgURL(), //图片前面域名
    //订单按钮信息
    orderItems: [
      {
        name: '待付款',
        icon: '/images/me/order_waite_pay.png',
        num: 0,
      },
      {
        name: '待发货',
        icon: '/images/me/order_waite_delivery.png',
        num: 0,
      },
      {
        name: '待收货',
        icon: '/images/me/order_waite_goods.png',
        num: 0,
      },
      {
        name: '待评价',
        icon: '/images/me/order_waite_comment.png',
        num: 0,
      },
      {
        name: '我的订单',
        icon: '/images/me/me_order.png',
      }
    ],

    //功能按钮信息
    funcItems: [
    ],

    // 是否已登录
    isLogin: false,

    //用户信息
    userInfo: {},
    displayName: '', //显示的昵称

    isBindPhoneNumberEnable: false, //是否可以绑定手机号

    good_browser_history_count: 0, //商品浏览记录数量
  },

  onShow: function () {
    this.refreshUserInfo();
    // 加载用户信息
    var that = this;
    if (app.globalData.isLogin) {
      app.loadUserInfo(function () {
        that.refreshUserInfo();
      }, false);

      // 加载安全信息
      app.getAccountSecurityInfo(function () {
        that.setData({
          isBindPhoneNumberEnable: app.isBindPhoneNumberEnable()
        });
      });
    }
    else {
      that.setData({
        isBindPhoneNumberEnable: false
      });
    }
    // 获取浏览记录数量
    wx.getStorage({
      key: 'good_browse_history_count',
      success: function (res) {
        var data = res.data;
        that.setData({
          good_browser_history_count: data
        })
      },
      fail: function () {
        that.setData({
          good_browser_history_count: 0
        })
      }
    })
  },

  // 刷新用户信息
  refreshUserInfo: function () {
    // app全局信息
    const globalData = app.globalData;

    const orderInfo = globalData.orderInfo;
    if (orderInfo != null) {
      var orderItems = this.data.orderItems;
      orderItems[0].num = orderInfo.waitePayCount;
      orderItems[1].num = orderInfo.waiteDeliveryCount;
      orderItems[2].num = orderInfo.waiteGoodsCount;
      orderItems[3].num = orderInfo.waiteCommentCount;
      this.setData({
        orderItems: orderItems
      });
    }

    var userInfo = globalData.userInfo;
    var displayName = userInfo.account;
    if (userInfo.openFenxiao && userInfo.name != null && userInfo.length > 0 && userInfo.namePrefix != null && userInfo.namePrefix.length > 0) {
      displayName = userInfo.namePrefix + userInfo.name;
    }
    var funcItems = this.loadFuncItems();
    // 页面显示
    this.setData({
      funcItems : funcItems,
      isLogin: globalData.isLogin,
      userInfo: userInfo,
      displayName: displayName
    });
  },

  // 获取按钮信息
  loadFuncItems:function(){
    // app全局信息
    const globalData = app.globalData;
    var array = [
      {
        name: '商品收藏',
        type: 0
      },
      {
        name: '我的足迹',
        type: 1
      },
      {
        name: '售后服务',
        icon: '/images/me/me_refund_service.png',
        type: 3
      },
      {
        name: '领券中心',
        icon: '/images/me/me_draw_coupons.png',
        type: 4
      },
      {
        name: '我的活动',
        icon: '/images/me/me_activity.png',
        type: 5
      },
      {
        name: '收货地址',
        icon: '/images/me/me_shipping_address.png',
        type: 6
      },
      {
        name: '客户服务',
        icon: '/images/me/me_service.png',
        type: 7
      },
      {
        name: '存取记录',
        type: 13,
        access: globalData.userInfo.access_num ? globalData.userInfo.access_num : 0
      },
      {
        name: '合伙人中心',
        icon: '/images/me/bwstore.png',
        type: 14
      },
      // ,
      // {
      //   name: '拼团',
      //   icon: '/images/me/icon_pin.jpg',
      //   type: 8
      // }
    ];

// 预售订单
    if(globalData.userInfo.openPresell){
       array.splice(2, 0 , {
        name: '预售订单',
        icon: '/images/me/me_presell.png',
        type: 2
      })
    }

    // if (app.globalData.userInfo.openFenxiao) {
    //   array.splice(8, 0, {
    //     name: '分销中心',
    //     icon: '/images/me/me_partner.png',
    //     type: 9
    //   })
    // }

    var is_show_join = false;

    if (this.data.isLogin){

        is_show_join = true;
    }
    else{

      if (!app.globalData.userInfo.openFenxiao){

        is_show_join = true;
      }
    }

    if (is_show_join){
      array.splice(8, 0, {
        name: '合伙人加盟',
        icon: '/images/partner/partner_join.png',
        type: 12
      })
    }

    return array;
  },

  // 登录
  login: function () {
    app.showLogin()
  },

  //头像加载失败
  headImageDidFail : function(){
    var userInfo = this.data.userInfo;
    userInfo.avatar = '/images/me/default_avatar.png';
    this.setData({
      userInfo : userInfo
    })
  },

  //查看我的优惠券
  myCouponAction: function () {
    if (this.data.isLogin) {
      wx.navigateTo({
        url: '../usecouponlist/usecouponlist?' + 'isFastBuy=' + false + '&wanSelect=' + false
      })
    }
    else {
      this.login();
    }
  },

  // 点击余额
  tapBalance: function () {
    if (this.data.isLogin) {
      wx.navigateTo({
        url: '/pages/balance/balance_home'
      })
    }
    else {
      this.login();
    }
  },

  // 点击积分
  tapIntegral: function () {
    if (this.data.isLogin) {
      wx.navigateTo({
        url: '/pages/integral/integral'
      })
    }
    else {
      this.login();
    }
  },

  // 点击功能图标
  tapFuncItem: function (event) {
    const index = parseInt(event.currentTarget.dataset.index);
    switch (index) {
      case 0:
      case 2:
      case 3:
      case 5:
      case 6: {//开发时先忽略case 8
        //需要登录 
        if (!this.data.isLogin) {
          this.login();
        }
      }
    }
    switch (index) {
      case 0: {
        wx.navigateTo({
          url: '/pages/goods/good_collect',
        })
        break;
      }
      case 12:{
        wx.navigateTo({
          url: '/pages/partner/partner_join'
        })
        break;
      }
      case 1: {
        wx.navigateTo({
          url: '/pages/goods/good_browse_history',
        })
        break;
      }
      case 2: {
        wx.navigateTo({
          url: '../orderlist/orderlist?' + 'index=' + 5 + '&showBar=' + false + '&typeIndex=' + 0 + '&isPrepare=' + true,
        })
        break;
      }
      case 3: {
        wx.navigateTo({
          url: '../refund/refund',
        })
        break;
      }
      case 4: {
        wx.navigateTo({
          url: '../couponlist/couponlist',
        })
        break;
      }
      case 5: {
        wx.navigateTo({
          url: '../activitylist/activitylist',
        })
        break;
      }
      case 6: {
        wx.navigateTo({
          url: '../addresslist/addresslist?' + 'canSelect=' + false + '&memberID=' + app.globalData.userInfo.userId,
        })
        break;
      }
      case 7: {
        wx.navigateTo({
          url: '../customerservice/customerservice',
        })
        break;
      }
      case 8: {
        wx.navigateTo({
          url: '../groupBooking/myGroupBooking/myGroupBooking',
        })
        break;
      }
      case 9: {

        if(app.globalData.userInfo.openFenxiao){
          wx.navigateTo({
            url: '/pages/user/distribution_center'
          })
        }
        else{
            wx.showModal({
                title: "您的账号暂不具备分销功能！",
                content: "",
                showCancel: false,
            });
        }
        break;
      }
      case 10: {
        wx.navigateTo({
          url: '/pages/collectMoney/collect_money_input'
        })
        break;
      }
      case 11: {
        wx.navigateTo({
          url: '/pages/statistical/statistical'
        })
        break;
      }
      case 13: {
        if (app.globalData.userInfo.userId){
          wx.navigateTo({
            url: '/pages/cargo/cargo'
          })
        }else{
          wx.navigateTo({
            url: '/pages/login/login'
          })
        }
        break;
      }
      case 14: {
        // 跳转到贝王小店
        wx.navigateToMiniProgram({
          appId: 'wxb016683b7102327e',
          path: 'pages/login/login',
          extraData: {
            foo: 'bar'
          },
          envVersion: 'release',
          success(res) {
            
            // 打开成功
          }
        })
        break;
      }
    }
  },

  // 账户管理
  tapAccount: function () {
    if (this.data.isLogin) {
      wx.navigateTo({
        url: '/pages/user/userInfo',
      })
    }
  },

  // 绑定手机号
  bindPhoneNumber: function () {
    wx.navigateTo({
      url: '/pages/user/bind_phone'
    })
  },

  //订单事件
  orderAction: function (event) {
    let index = parseInt(event.target.dataset.index);
    if (index == 4) {
      index = 0;
    }
    else {
      index = index + 1;
    }
    if (!this.data.isLogin) {
      this.login();
    }
    else {
      wx.navigateTo({
        url: '../orderlist/orderlist?' + 'index=' + index + '&showBar=' + true + '&typeIndex=' + 0 + '&isPrepare=' + false,
      })
    }
  },
  //跳转设置
  settingAction: function (event) {
    if (!this.data.isLogin) {
      this.login();
    }
    else {
      wx.navigateTo({
        url: '../user/setting',
      })
    }
  }
})