//app.js

var httpRequest = require('/utils/httpRequest.js');

App({
  onLaunch: function () {
    // 获取用户信息 判断用户是否已登录
    const updateManager = wx.getUpdateManager();
    updateManager.onCheckForUpdate(function (res) {
      // 请求完新版本信息的回调
      if (res.hasUpdate) {
        wx.showModal({
          title: '提示',
          content: '新的版本已经可以应用了喔~',
          showCancel: false,
          confirmText: '强制重启',
          success: function (res) {
            if (res.confirm) {
              updateManager.onUpdateReady(function () {
                updateManager.applyUpdate()
              })
            }
          }
        })

      }
    })
    const data = wx.getStorageSync('userInfo');
    this.initializeGlobalData();

    var globalData = this.globalData;
    if (data != null && parseInt(data.userId) > 0) {
      globalData.userInfo = data;
      globalData.isLogin = true;
      globalData.isWeixinLogin = data.isWeixinLogin;
      this.loadUserInfo();
    }
    // 获取系统信息
    const systemInfo = wx.getSystemInfoSync();
    globalData.systemInfo = systemInfo;
  },

  // 获取安全信息，查看是否已绑定手机号
  getAccountSecurityInfo: function (callback) {
    if (!this.globalData.isLogin)
      return;

    const phoneNumber = this.globalData.userInfo.phoneNumber;
    if (phoneNumber != null && phoneNumber.length > 0){
      typeof callback == "function" && callback();
      return;
    }

    this.globalData.isLoadAccountSecurityInfo = false;

    const that = this;
    this.request({
      method: 'b2c.member.security'
    }, function (data) {
      if (that.globalData.isLogin) {
        that.globalData.isLoadAccountSecurityInfo = true;
        data = data.data;
        if (data != null) {
          that.globalData.userInfo.phoneNumber = data.mobile;
        }
        typeof callback == "function" && callback();
      }
    });

    
  },

  //绑定手机号成功后跳到的界面
  bindPhoneNumber:function(redirectTo){
    var url = '/pages/user/bind_phone';

    if (redirectTo != null && redirectTo.length > 0){
      url += '?redirectTo=' + encodeURIComponent(redirectTo);
    }
    wx.navigateTo({
      url: url
    })
  },

  //是否需要绑定手机号
  shouldBindPhoneNumber:function(){
    const globalData = this.globalData;
    const phoneNumber = globalData.userInfo.phoneNumber;
    return phoneNumber == null || phoneNumber.length == 0;
  },

  // 是否可以绑定手机号
  isBindPhoneNumberEnable:function() {
    const globalData = this.globalData;
    const phoneNumber = globalData.userInfo.phoneNumber;
    return globalData.isLoadAccountSecurityInfo && (phoneNumber == null || phoneNumber.length == 0);
  },

  //是否是微信登录
  isWeixinLogin:function(){
    const globalData = this.globalData;
    return globalData.isWeixinLogin;
  },

  // 清除用户信息
  clearUserInfo: function () {
    wx.clearStorage({
      key: 'userInfo'
    })
  },
 
   // 用户分享转发
   onShareApp: function (res) { //{title:xxx,sucFun:fun,failFun:fun}
    if(typeof res !='object' && Object.prototype.toString.call(res) == "[object Array]"){return}
    var path=getCurrentPages()[getCurrentPages().length-1];
    if(JSON.stringify(path.options)!="{}"){
      var arr=[];
      for(var key in path.options){
        arr.push(key+"="+path.options[key])
      }
     path=path.__route__+'?'+arr.join("&");
    }else{ path=path.__route__}
    var obg={
      title: res.title,
      path: path,
      success: function(res) {
        res.sucFun;
      },
      fail: function(res) {
        res.FailFun
      }
    }
    return obg
  },
  //倒计时
  timeOut:function(date){// 2017/12/30 18:00
    var _date=new Date,
        interval='',
        arr = [];
        _date=_date.getTime();
    arr=date.split(' ');
    date = new Date(arr[0]);
    date.setHours(arr[1].split(":")[0], arr[1].split(":")[1])
    date=date.getTime();
    var interval=date - _date;
    if (interval<=0){return 0}
    arr=[];
    //计算出相差天数
    var days = Math.floor(interval / (24 * 3600 * 1000))+'';
    days.length == 1 && (days="0"+days)
    arr.push(days)
    //计算出小时数
    var leave1 = interval % (24 * 3600 * 1000)    //计算天数后剩余的毫秒数
    var hours = Math.floor(leave1 / (3600 * 1000))+'';
    hours.length == 1 && (hours = "0" + hours)
    arr.push(hours)
    //计算相差分钟数
    var leave2 = leave1 % (3600 * 1000)        //计算小时数后剩余的毫秒数
    var minutes = Math.floor(leave2 / (60 * 1000))+'';
    minutes.length == 1 && (minutes = "0" + minutes)
    arr.push(minutes)
    //计算相差秒数
    var leave3 = leave2 % (60 * 1000)      //计算分钟数后剩余的毫秒数
    var seconds = Math.round(leave3 / 1000)+'';
    seconds.length == 1 && (seconds = "0" + seconds)
    arr.push(seconds);  
    return arr //[天,时,分,秒]
  },
  // 获取客服电话
  getServicePhoneNumber: function (callback) {
    var globalData = this.globalData;
    var servicePhoneNumber = globalData.servicePhoneNumber;

    if (servicePhoneNumber != null && servicePhoneNumber.length > 0) {
      typeof callback == "function" && callback(servicePhoneNumber);
    } else {
      this.request({
        method: 'b2c.activity.cs'
      }, function (data) {

         servicePhoneNumber = data.mobile;
        globalData.servicePhoneNumber = servicePhoneNumber;
        typeof callback == "function" && callback(servicePhoneNumber);
      }, function () {

      }, true);
    }
  },

  // 获取上线电话
  getUplineMobile: function(callback){
      var globalData = this.globalData;
    var uplineMobile = globalData.uplineMobile;

    if (uplineMobile != null) {
      if(uplineMobile.length == 0){
        uplineMobile = globalData.servicePhoneNumber;
      }
      typeof callback == "function" && callback(uplineMobile);
    } else {
      this.request({
        method: 'b2c.activity.cs'
      }, function (data) {
        uplineMobile = data.higher;
        if(uplineMobile == null){
          uplineMobile = '';
        }
        globalData.uplineMobile = uplineMobile;
        globalData.servicePhoneNumber = data.mobile;

        if(uplineMobile.length == 0){
          uplineMobile = data.mobile;
        }
        typeof callback == "function" && callback(uplineMobile);
      }, function () {

      }, true);
    }
  },

  // 保存用户信息
  saveUserInfo: function (data) {
    var member = data.member;
    var globalData = this.globalData;
    var memberIdent = globalData.userInfo.memberIdent
    if(memberIdent == null || memberIdent.length == 0){
        memberIdent = data.member_ident
    }
    else{
        memberIdent = globalData.userInfo.memberIdent
    }
    
    globalData.qrCodeURL = data.code_image_id;
    globalData.shopcartCount = member.cart_number;
    const phoneNumber = globalData.userInfo.phoneNumber;
    globalData.userInfo = {
      userId: member.member_id,
      name: member.name,
      namePrefix : data.shopname,
      avatar: member.avatar,
      account: member.uname,
      has_pay_password: member.has_pay_password,
      access_num: member.access_num,
      goodCollectCount: member.favorite_num,
      couponCount: member.coupon_num,
      unreadMessageCount: data.un_readMsg,
      integral: member.usage_point,
      balance:member.advance,
      openPresell: data.prepare_status == 'true',
      openFenxiao: data.distribution_status == 'true',
      memberIdent:memberIdent,

      level: member.levelname,

      phoneNumber: phoneNumber,
      isWeixinLogin: globalData.isWeixinLogin,
    };
    globalData.orderInfo = {
      waitePayCount: member.un_pay_orders,
      waiteDeliveryCount: member.un_ship_orders,
      waiteGoodsCount: member.un_received_orders,
      waiteCommentCount: member.un_discuss_orders,
      refundCount: member.aftersales_orders
    };

    var that = this;
    wx.setStorageSync('userInfo', that.globalData.userInfo);
  },

  // 加载用户信息
  loadUserInfo: function (callback, showLoading) {
    if (this.globalData.isLogin && !this.globalData.isLoadUserInfo) {

      this.globalData.isLoadUserInfo = true;
      var that = this;
      this.request({
        method: 'b2c.member.index'
      }, function (data) {
        // 加载成功
        if (that.globalData.isLogin) {
          that.saveUserInfo(data);
          that.globalData.isLoadUserInfo = false;
          typeof callback == "function" && callback(that.globalData.userInfo);
        }
      }, function (res,msg) {
        
        // 加载失败
        that.globalData.isLoadUserInfo = false;
        typeof callback == "function" && callback();

      }, showLoading);
    }
  },

  // 设置用户id
  setUserId: function (userId, isWeixinLogin) {
    this.globalData.userInfo.userId = userId;
    this.globalData.isLogin = true;
    this.globalData.uplineMobile = null;
    this.globalData.isWeixinLogin = isWeixinLogin;
  },

  // 设置手机号
  setPhoneNumber: function (phoneNumber) {
    this.globalData.userInfo.phoneNumber = phoneNumber;
    this.globalData.isLoadAccountSecurityInfo = true;
  },

  // 初始化全局信息
  initializeGlobalData: function () {
    this.globalData.userInfo = {
      avatar: this.getImgURL() + '/images/me/default_avatar.png', //头像
      name: '', //昵称
      namePrefix : '', //昵称前缀
      userId: '', //用户id
      phoneNumber: null, //手机号
      account: null, //账号
      has_pay_password: false, //是否已设置支付密码

      goodCollectCount: 0, //商品收藏数量
      couponCount: 0, //优惠券数量
      unreadMessageCount: 0, //未读消息数量
      integral: 0, //积分
      balance: 0, //余额
      openPresell: false, //是否开启预售
      openFenxiao: false, //是否开启分销

      level: null, //等级名称
    };
    this.globalData.orderInfo = {
      waitePayCount: 0, //订待付款数量
      waiteDeliveryCount: 0, //待发货数量
      waiteGoodsCount: 0, //待收货数量
      waiteCommentCount: 0, //待评价数量
      refundCount: 0, //退款售后数量
    };
  },

  // 全局信息
  globalData: {

    // 系统信息
    systemInfo: null,

    // 是否已登录
    isLogin: false,

    // 是否是微信登录
    isWeixinLogin: false,

    // 是否正在加载用户信息
    isLoadUserInfo: false,

    // 是否已加载完账号安全信息
    isLoadAccountSecurityInfo: false,

    // 购物车数量
    shopcartCount: 0,

    // 用户信息
    userInfo: null,

    // 订单信息
    orderInfo: null,

    // 客服电话
    servicePhoneNumber: null,

    //上线电话
    uplineMobile:null,

    qrCodeURL:'',// 邀请注册二维码链接

    //倒计时定时器id
    timeOutId:null
  },

  // 弹出登录
  showLogin: function () {
    wx.navigateTo({
      url: '/pages/login/login',
      success: function (res) {
        // success
      },
      fail: function () {
        // fail
        wx.redirectTo({
          url: '/pages/login/login',
          success: function (res) {
            // success
          },
          fail: function () {
            // fail
          },
          complete: function () {
            // complete
          }
        })
      },
      complete: function () {
        // complete
      }
    })
  },

  // 退出登录
  logout: function () {
   
    wx.removeStorageSync('userInfo');
    var globalData = this.globalData;
    this.initializeGlobalData();
    globalData.shopcartCount = 0;
    globalData.isLogin = false;
    globalData.isLoadAccountSecurityInfo = false;
    globalData.uplineMobile = null;
  },

  // 获取图片头部域名
  getImgURL:function(){
    return httpRequest.getImgURL();
  },

  // 获取app名称
  getAppName(){
    return "M+Store";
  },

  // 网络请求
  /**
   * 调用http请求
   * @param params 请求参数
   * @param success 成功回调方法 data 成功后的数据
   * @param fail 失败回调方法 errMsg 错误提示信息
   * @param showLoading 是否显示加载指示器
   * @param showLogin 如果需要登录，是否弹出登录窗口
   * @param showErrMsg 是否显示错误信息
   * @param filePath 文件路径
   * @param fileKey 文件key
   */
  request: function (params, success, fail, showLoading, showLogin, showErrMsg, filePath, fileKey) {
    var that = this;
    if (this.globalData.isLogin) {
      params.wx_pro_mid = this.globalData.userInfo.userId;
      if(params.method != "b2c.member.index"){
          params.sess_id = this.globalData.userInfo.memberIdent;
      }
    }
    params.is_wx_pro = true;

    // 是否上传文件
    const uploadFile = filePath != null && filePath.length > 0;
    var data = httpRequest.buildData(params, uploadFile);
    if (showLoading) {
      httpRequest.startLoading();
    }

    if (!uploadFile) {
      wx.request({
        url: httpRequest.getRequestURL(),
        data: data,
        method: 'POST', // OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, CONNECT
        header: { 'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8' }, // 设置请求的 header
        success: function (res) {
          // succes
          that.dealwithResult(res.data, success, fail, showLogin, showErrMsg);
        },
        fail: function () {
          // fail
          httpRequest.stopLoading();
          if (showErrMsg) {
            wx.showModal({
              title: "网络状态不佳",
              content: "",
              showCancel: false
            });
          }
          typeof fail == "function" && fail(null);
        },
      });
    } else {
      // 上传图片
      wx.uploadFile({
        url: httpRequest.getRequestURL(),
        filePath: filePath,
        name: fileKey,
        formData: data, // HTTP 请求中其他额外的 form data
        success: function (res) {
          that.dealwithResult(JSON.parse(res.data), success, fail, showLogin, showErrMsg);
        },
        fail: function () {
          // fail
          httpRequest.stopLoading();
          if (showErrMsg) {
            wx.showModal({
              title: "网络状态不佳",
              content: "",
              showCancel: false
            });
          }
          typeof fail == "function" && fail(null);
        }
      });
    }
  },

  // 处理请求结果
  dealwithResult: function (data, success, fail, showLogin, showErrMsg) {
    httpRequest.stopLoading();
    if (data == null) {
      typeof fail == "function" && fail();
      return;
    }
    // 判断状态吗
    const code = data.code;
    if (code != "") {
      if (code == "need_login") {
        ///需要登录
        if (showLogin) {
          this.showLogin();
        }
        typeof fail == "function" && fail(null);
      }
      else if (code == "cart_empty") {
        typeof fail == "function" && fail(true)
        return;
      }
      else {
        const errMsg = data.msg;
        if (!showErrMsg) {
          typeof fail == "function" && fail(errMsg,data)
          return;
        }
        
        if (showErrMsg && errMsg != null) {
          wx.showModal({
            title: errMsg,
            content: "",
            showCancel: false
          });
        }
        if (typeof data.data == "object") {
          data = data.data;
        }

        typeof fail == "function" && fail(errMsg, data);
      }
      return;
    }
    

    const org = data;
    if (typeof data.data == "object") {
      data = data.data;
    }

    typeof success == "function" && success(data, org);
  },

  /**
   * 打开某个广告页
   * @param type 广告类型
   * @param id 广告关联的id
   */
  openAdPage: function (type, id) {
    if (type == "article") {
      // 文章
      
      var mid = httpRequest.getDomain()+'/wap2/article-' + id +'.html';
      wx.navigateTo({
        url: '/pages/custom/custom?custom_id=' + mid
      })
    }
    else if (type == "gallery") {
      // 商品列表 普通分类
      wx.navigateTo({
        url: '/pages/goods/good_list?cat_id=' + id
      })
    }
    else if (type == "virtual_cat") {
      // 商品列表 虚拟分类
      wx.navigateTo({
        url: '/pages/goods/good_list?cat_id=' + id + '&is_virtual_cat=' + true
      })
    }
    else if (type == "goods_cat") {
      //打开分类
    }
    else if (type == "brand") {
      // 品牌
      wx.navigateTo({
        url: '/pages/goods/good_list?brand_id=' + id
      })
    }
    else if (type == "yiy") {
      // 摇一摇
      // wx.navigateTo({
      //   url: '/pages/tryOut/tryOut'
      // })
    }
    else if (type == "my_activity") {
      //  活动
      wx.navigateTo({
        url: '/pages/activitylist/activitylist'
      })
    }
    else if (type == "product") {
      // 商品详情
       wx.navigateTo({
      url: '/pages/gooddetail/gooddetail?productID=' + id,
    })
    }
    else if (type == "signin") {
      //签到
      var memberinfo = wx.getStorageSync('userInfo');
      if (memberinfo == '') {
        wx.navigateTo({
          url: '/pages/login/login'
        })
      } else {
        wx.navigateTo({
          url: '/pages/integral/integral_sign_in?integral=false'
        })
      }
    }
    else if (type == "starbuy") {
      // 秒杀
      if (this.globalData.userInfo.userId == '') {
        wx.navigateTo({
          url: '/pages/login/login',
        })
      }else{
        wx.navigateTo({
          url: '/pages/secondKill/second_kill',
        })
      }
      
    }
    else if (type == "community") {
      // 社区
      wx.navigateTo({
        url: '/pages/articleStory/articleStory',
      })
    }
    else if (type == "custom") {
      // 自定义链接
      var urlid = decodeURI(id);
      var name, value;
      var num = urlid.indexOf("?");
      var str = urlid.substr(num + 1);
      var arr = str.split("&");
      for (var i = 0; i < arr.length; i++) {
        num = arr[i].indexOf("=");
        if (num > 0) {
          name = arr[i].substring(0, num);
          value = arr[i].substr(num + 1);
          this[name] = value;
          if (name == 'keyword') {
            wx.navigateTo({
              url: '/pages/goods/good_list?keyword=' + value,
            })
            return;
          }
          if (name == 'gvc_id'){
            wx.navigateTo({
              url: '/pages/goods/good_list?cat_id=' + value + '&is_virtual_cat=true'
            })
            return;
          }
        }
      } 
      var url = encodeURIComponent(id);
      wx.navigateTo({
        url: '/pages/custom/custom?custom_id=' + url
      })
    }
    else if (type == "recharge") {
      // 充值
        this.request({
          method: 'b2c.member.deposit'
          }, function (data) {
            var actEnable = false;
            const activityObj = data.active.recharge;
            if (activityObj.status == 1) {
                actEnable = activityObj.filter != null && activityObj.filter.length > 0;
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
          }, function (msg,res) {
            
      }, true, true, true);
    }
    else if (type == "preparesell") {
      // 预售商品列表
      wx.navigateTo({
        url: '/pages/goods/good_list?only_presell=' + true
      })
    }
    else if (type == "get_coupons") {
      // 领券中心
      wx.navigateTo({
        url: '/pages/couponlist/couponlist'
      })
    }

  }
})