var httpRequest = require('/utils/httpRequest.js');
App({
  onLaunch: function () {
    const updateManager = wx.getUpdateManager();
    updateManager.onCheckForUpdate(function (res) {
      // 请求完新版本信息的回调
      if (res.hasUpdate){
        wx.showModal({
          title: '提示',
          content: '新的版本已经可以应用了喔~',
          showCancel:false,
          confirmText:'强制重启',
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
    var globalData = this.globalData;
    // 获取系统信息
    const systemInfo = wx.getSystemInfoSync();
    globalData.systemInfo = systemInfo;
    // 登录
    wx.login({
      success: res => {
        // 发送 res.code 到后台换取 openId, sessionKey, unionId
      }
    });
    var that = this;
    var userinfos = wx.getStorageSync('userinfo');
    if (userinfos){
      that.globalData.userInfo.userId = userinfos.memberId;
      that.globalData.isLogin = userinfos.isLogin;
      this.request({
        method: 'b2c.member.security',
        wx_pro_mid: userinfos.memberId,
        is_wx_pro: true,
        sess_id: userinfos.sessId
      }, function (data) {
        that.globalData.isLoadAccountSecurityInfo = true;
        data = data.data;
        if (data != null) {
          that.globalData.userInfo.phoneNumber = data.mobile;
        }

      });
    }
    
    // 获取用户信息
    wx.getSetting({
      success: res => {
        if (res.authSetting['scope.userInfo']) {
          // 已经授权，可以直接调用 getUserInfo 获取头像昵称，不会弹框
          wx.getUserInfo({
            success: res => {
              // 可以将 res 发送给后台解码出 unionId
              this.globalData.userInfo = res.userInfo

              // 由于 getUserInfo 是网络请求，可能会在 Page.onLoad 之后才返回
              // 所以此处加入 callback 以防止这种情况
              if (this.userInfoReadyCallback) {
                this.userInfoReadyCallback(res)
              }
            }
          })
        }
      }
    })
  },
  globalData: {
    userInfo: [],
    memberId:'',
    sessId:'',
    isLogin:false,
     // 是否已加载完账号安全信息
    isLoadAccountSecurityInfo: false,
    // 系统信息
    systemInfo: null,

  },
  request: function (params, success, fail, showLoading, showLogin, showErrMsg, filePath, fileKey) {
    var that = this;
    
    if (this.globalData.isLogin) {
      params.wx_pro_mid = this.globalData.userInfo.userId;
      if (params.method != "b2c.member.index") {
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
          // success
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
          // success
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
          typeof fail == "function" && fail(errMsg, data)
          return
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
  isLogin: function () {
    var that = this;
    if (that.globalData.memberId == '') {
      wx.redirectTo({
        url: '/pages/login/login',
      })
    }
  },
  // 获取图片头部域名
  getImgURL: function () {
    return httpRequest.getImgURL();
  },
  // 获取安全信息，查看是否已绑定手机号
  getAccountSecurityInfo: function (callback) {
    if (!this.globalData.isLogin)
      return;

    const phoneNumber = this.globalData.userInfo.phoneNumber;
    if (phoneNumber != null && phoneNumber.length > 0) {
      typeof callback == "function" && callback();
      return;
    }

    this.globalData.isLoadAccountSecurityInfo = false;
    var userinfos = wx.getStorageSync('userinfo');
    const that = this;
    var member = '';
    member = that.globalData.memberId;
    console.log(member);
    this.request({
      method: 'b2c.member.security',
      wx_pro_mid: member,
      is_wx_pro: true,
      sess_id: that.globalData.sessId
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
  bindPhoneNumber: function (redirectTo) {
    var url = '/pages/user/bind_phone';

    if (redirectTo != null && redirectTo.length > 0) {
      url += '?redirectTo=' + encodeURIComponent(redirectTo);
    }
    wx.navigateTo({
      url: url
    })
  },

  //是否需要绑定手机号
  shouldBindPhoneNumber: function () {
    const globalData = this.globalData;
    const phoneNumber = globalData.userInfo.phoneNumber;
    return phoneNumber == null || phoneNumber.length == 0;
  },

  // 是否可以绑定手机号
  isBindPhoneNumberEnable: function () {
    const globalData = this.globalData;
    const phoneNumber = globalData.userInfo.phoneNumber;
    return globalData.isLoadAccountSecurityInfo && (phoneNumber == null || phoneNumber.length == 0);
  },

  //是否是微信登录
  isWeixinLogin: function () {
    const globalData = this.globalData;
    return globalData.isWeixinLogin;
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
  // 设置手机号
  setPhoneNumber: function (phoneNumber) {
    this.globalData.userInfo.phoneNumber = phoneNumber;
    this.globalData.isLoadAccountSecurityInfo = true;
  },
  // 用户分享转发
  onShareApp: function (res) { //{title:xxx,sucFun:fun,failFun:fun}
    if (typeof res != 'object' && Object.prototype.toString.call(res) == "[object Array]") { return }
    var path = getCurrentPages()[getCurrentPages().length - 1];
    if (JSON.stringify(path.options) != "{}") {
      var arr = [];
      for (var key in path.options) {
        arr.push(key + "=" + path.options[key])
      }
      path = path.__route__ + '?' + arr.join("&");
    } else { path = path.__route__ }
    var obg = {
      title: res.title,
      path: path,
      success: function (res) {
        res.sucFun;
      },
      fail: function (res) {
        res.FailFun
      }
    }
    return obg
  },
  // onShow:function(){
  //   var userinfos = wx.getStorageSync('userinfo');
  //   if (!userinfos) {
  //     wx.redirectTo({
  //       url: '/pages/login/login',
  //     })
  //   }
  // }
})