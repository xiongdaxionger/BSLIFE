//提现首页

var app = getApp();

Page({
  data: {
    //输入的提现金额
    withDrawMoney: 0.0,
    //金额
    money: "",
    //最大提现金额
    maxMoney: "",
    //最小提现金额
    minMoney: "",
    //可提现金额
    canWithDrawMoeny: 0.0,
    //提现费率数组
    feesArr: [],
    //税率数组
    taxsArr: [],
    //显示提示语数组
    infosArr: [],
    //是否加载成功
    showFailNetWork: false,
    //提现账号
    accountName: "",
    //提现账号ID
    accountID: "",
    //图片前面域名
    imgURL: app.getImgURL(),
    //是否跳转选择账号
    isNavigateSelect: false,
    /**预存款支付密码**/
    payPassWord: "",
    /**密码框动画**/
    payPassWordTranslateAnimation: null,
    /**背景动画**/
    backgroundOpacityAnimation: null,
    /**是否显示支付密码输入**/
    isShowPayPassWord: false,
    /**支付密码显示用的无效内容**/
    payPassWordInput: [0, 1, 2, 3, 4, 5],
    /**支付密码实际输入的内容**/
    payPassWordRealInput: [],
    /**密码输入的长度**/
    payPassWordInputLength: 0,
    //是否跳转至设置支付密码
    isNavigateSetPay: false,
  },
  //页面显示
  onShow: function () {
    let result = wx.getStorageSync('deleteAccount')
    let isDelete = result.isDelete
    if (isDelete) {
      wx.setStorageSync('deleteAccount', { "isDelete": false })
      let model = result.model
      let accountID = model.accountID
      if (accountID == this.data.accountID) {
        this.data.accountID = ""
        this.setData({
          accountName: ""
        })
      }
    }

    if (this.data.isNavigateSelect) {
      this.data.isNavigateSelect = false
      let model = wx.getStorageSync('accountInfo')
      if (typeof model == "string" || model == null) {
        return
      }
      wx.setStorageSync('accountInfo', "")
      this.data.accountID = model.ID
      var num = model.info;
      if(num != null && num.length > 4){
        num = num.substring(num.length - 4);
      }
      this.setData({
        accountName: model.name + ' ' + '尾号' + num
      })
    }

    if (this.data.isNavigateSetPay) {
      this.data.isNavigateSetPay = false
      let model = wx.getStorageSync('paypassword')
      if (typeof model == "string" || model == null) {
        return
      }
      wx.setStorageSync('paypassword', "");
      this.data.payPassWord = model.paypassword
      //调用提现
      this.data.withDrawConfirm()
    }
  },
  //页面加载完成
  onLoad: function (options) {
    this.loadDataInfo(true)
  },
  //获取数据
  loadDataInfo: function (showLoading) {
    var that = this
    app.request({
      "method": "b2c.wallet.withdrawalNotice"
    }, function (data) {
      for (var i = 0; i < data.length; i++) {
        let object = data[i]
        let objectType = object.type
        if (objectType == "money") {
          //提现金额相关
          that.data.maxMoney = object.max
          that.data.minMoney = object.min
          that.data.canWithDrawMoeny = parseFloat(object.commision)
        }
        else if (objectType == "fee") {
          //提现费率
          let model = {
            //说明
            notice: object.notice,
            //比率
            val: parseFloat(object.val)
          }
          that.data.feesArr.push(model)
        }
        else if (objectType == "tax") {
          //提现税率
          let model = {
            //说明
            notice: object.notice,
            //比率
            val: parseFloat(object.val)
          }
          that.data.feesArr.push(model)
        }
        else {
          //说明
          that.data.infosArr.push(object)
        }
      }
      that.setData({
        maxMoney: that.data.maxMoney,
        showFailNetWork: false,
        canWithDrawMoeny: that.data.canWithDrawMoeny,
        feesArr: that.data.feesArr,
        taxsArr: that.data.taxsArr,
        infosArr: that.data.infosArr
      })
    }, function (data) {
      that.setData({
        showFailNetWork: true
      })
    }, showLoading, true, true)
  },
  //选择账号
  selectAccount: function () {
    this.data.isNavigateSelect = true
    wx.navigateTo({
      url: '/pages/balance/accountlist'
    })
  },
  //输入
  inputChange: function (event) {
    const key = event.target.id
    const value = event.detail.value
    if (value.length == 0) {
      this.data.money = "0.0"
      this.setData({
        withDrawMoney: parseFloat(this.data.money)
      })
    }
    else {
      this.data[key] = value
      this.setData({
        withDrawMoney: parseFloat(this.data.money)
      })
    }
  },
  //提交提现
  submitWithDraw: function () {
    if (this.data.withDrawMoney == 0.0) {
      this.showMessage('请输入提现金额')
      return
    }
    else {

      if (this.data.withDrawMoney < parseFloat(this.data.minMoney)) {
        this.showMessage('请输入最低提现金额' + this.data.minMoney)
        return
      }

      if (this.data.withDrawMoney > parseFloat(this.data.maxMoney)) {
        this.showMessage('超出最大提现额度，请更改')
        return
      }

      if (this.data.withDrawMoney > this.data.canWithDrawMoeny) {
        this.showMessage('超出您的可提现金额，请更改')
        return
      }
    }

    if (this.data.accountID.length == 0) {
      this.showMessage('请选择提现账号')
      return
    }

    if (app.globalData.userInfo.has_pay_password) {
      this.showPayPassWord()
    }
    else {
      this.showPayPassWord()
      //this.data.isNavigateSetPay = true
      // if (app.isWeixinLogin()) {
      //   //微信登录先绑定手机号
      //   const that = this;
      //   app.getAccountSecurityInfo(function () {

      //     if (app.shouldBindPhoneNumber()) {
      //       app.bindPhoneNumber('../paypassword/paypassword?' + 'isSetPayPass=' + "true");
      //     } else {
      //       that.setPayPassword();
      //     }
      //   });
      // } else {
      //   this.setPayPassword();
      // }
    }
  },

  //设置支付密码
  setPayPassword: function () {
    wx.navigateTo({
      url: '../paypassword/paypassword?' + 'isSetPayPass=' + "true",
    })
  },

  //最终提交提现
  withDrawConfirm: function () {
    var that = this
    app.request({
      "method": 'b2c.wallet.withdrawal',
      "money": that.data.withDrawMoney,
      "member_bank_id": that.data.accountID,
      "pay_password": that.data.payPassWord,
    }, function (data) {
      wx.showModal({
        title: "提现成功!",
        content: "",
        showCancel: false,
      })
      wx.setStorage({
        key: 'topupResult',
        data: true
      })
      that.setData({
        canWithDrawMoeny: that.data.canWithDrawMoeny - that.data.withDrawMoney
      })
    }, function (data) {
      wx.showModal({
        title: "",
        content: "提交失败，请重试",
        showCancel: false,
      })
    }, true, true, true)
  },
  //点击支付密码输入框
  showPayPassWord: function () {
    this.setData({
      isShowPayPassWord: true,
    })
    this.payPassWordAnimation(true)
  },
  //关闭支付密码输入框
  closeShippingMethod: function () {
    this.payPassWordAnimation(false)
    var that = this
    var timer = setTimeout(function () {
      that.setData({
        isShowPayPassWord: false,
        payPassWordInputLength: 0,
        payPassWordRealInput: []
      })
      clearTimeout(timer);
    }, 400)
  },
  //密码输入框动画
  payPassWordAnimation: function (show) {
    var that = this;
    //屏幕高度
    const height = app.globalData.systemInfo.windowHeight;
    var animation = wx.createAnimation({
      duration: 400,
    });
    //修改透明度,偏移
    this.setData({
      backgroundOpacityAnimation: animation.opacity(show ? 1 : 0).step().export(),
      payPassWordTranslateAnimation: animation.translateY(show ? (height / 2 - 80) : (80 - height / 2)).step().export()
    })
  },
  //密码框输入事件
  passwordInput: function (event) {
    let value = event.detail.value
    let inputArr = value.split("")
    this.data.payPassWordRealInput = inputArr
    this.data.payPassWordInputLength = inputArr.length
    this.setData({
      payPassWordRealInput: this.data.payPassWordRealInput,
      payPassWordInputLength: this.data.payPassWordInputLength
    })
    if (value.length == 6) {
      this.data.payPassWord = value
      this.closeShippingMethod()
      this.withDrawConfirm()
      return ""
    }
  },
  //显示信息
  showMessage: function (message) {
    wx.showModal({
      title: message,
      content: "",
      showCancel: false
    })
  },
  //重载
  reloadData: function () {
    this.loadDataInfo(true)
  },
})