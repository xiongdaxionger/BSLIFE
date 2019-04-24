var app = getApp()
Page({
    data:{
        //是否为预售订单
        isPrepareOrder:false,
        //订单号
        orderID:"",
        //是否从订单列表或者订单详情进入支付
        isOrderPay:false,
        //是否为组合支付
        isCombinationPay:false,
        //能否再次输入支付密码
        canInputPassWordAgain:true,
        //支付信息数据
        payMessageInfo:{},
        /**是否显示加载失败的视图**/
        showFailNetWork:false,
        /**按钮的提示文本**/
        buttonTitle:"支付",
        /**按钮能否点击**/
        canButtonClick:true,
        /**组合支付的支付方式ID**/
        combinationPayID:"",
        /**预存款支付密码**/
        payPassWord:"",
        /**密码框动画**/
        payPassWordTranslateAnimation: null, 
        /**背景动画**/
        backgroundOpacityAnimation: null, 
        /**是否显示支付密码输入**/
        isShowPayPassWord:false,
        /**支付密码显示用的无效内容**/
        payPassWordInput:[0,1,2,3,4,5],
        /**支付密码实际输入的内容**/
        payPassWordRealInput:[],
        /**密码输入的长度**/
        payPassWordInputLength:0,
        //是否跳转至设置支付密码
        isNavigateSetPay:false,
        imgURL: app.getImgURL(), //图片前面域名
        //是否代客下单
        isOpenMember:false,
    },
    //页面加载
    onLoad:function(options){
        this.data.isPrepareOrder = options.isPrepare == "true"
        this.data.orderID = options.orderID
        this.data.isOrderPay = options.isOrderPay == "true"
        this.data.isCombinationPay = options.isCombinationPay == "true"
        this.data.isOpenMember = options.isOpenMember == "true"
        
        if(this.data.isCombinationPay){
            let model = JSON.parse(options.model)
            this.data.payMessageInfo = model
            this.data.buttonTitle = "确认组合支付"
            let firstPayment = this.data.payMessageInfo.paymentsArr[0]
            firstPayment.isSelect = true
            this.data.combinationPayID = firstPayment.infoID
            this.changeCombinationPayRequest(this.data.combinationPayID)
        }
        else{
      this.getPayMessageInfoRequest()
    }
  },
  //页面显示
  onShow: function () {
    if (this.data.isNavigateSetPay) {
      this.data.isNavigateSetPay = false
      let model = wx.getStorageSync('paypassword')
      if (typeof model == "string" || model == null) {
        return
      }
      wx.setStorageSync('paypassword', "");
      this.data.payPassWord = model.paypassword
      this.doPaymentCall()
    }
  },
  //获取支付方式
  getPayMessageInfoRequest: function () {
    var that = this
    app.request({
      "method": "b2c.paycenter.index",
      "is_wx_pro": "true",
      "order_id": that.data.orderID
    }, function (data) {
      let paymessageInfo = that.getPayMessageInfo(data)
      that.data.payMessageInfo = paymessageInfo
      that.getButtonTitleStatus()
      that.setData({
        showFailNetWork: false,
        payMessageInfo: paymessageInfo,
        orderID: that.orderID,
        buttonTitle: that.data.buttonTitle,
        canButtonClick: that.data.canButtonClick,
      })
    }, function (data) {
      
      if (typeof data == "boolean") {
        //订单直接就已经支付了，处理
        that.paySuccessAction()
      }
      else {
        that.setData({
          showFailNetWork: true
        })
      }
    }, true, true, true)
  },
  //解析支付信息数据
  getPayMessageInfo: function (data) {
    var that = this
    let orderDict = data.order
    let settingDict = data.setting
    let memberDict = data.memberInfo
    let combinationPayArr = data.combination_pay_payments
    let model = {
      //格式化的需要支付的总金额
      formatTotalMoney: orderDict.current_amount_text,
      //需要支付的总金额
      totalMoney: orderDict.cur_money,
      //是否为预售订单
      isPrepare: orderDict.promotion_type == "prepare",
      //是否开启组合支付
      canCombinationPay: settingDict.combination_pay == "true",
      //选中的支付方式的按钮提示，为null时不能使用该支付
      payButtonTitle: settingDict.pay_btn == null ? "" : settingDict.pay_btn,
      //该支付方式能否支付
      canPay: settingDict.pay_btn != null,
      //不能支付的原因
      payRejectReason: settingDict.no_btn_message,
      //支付货币
      currency: orderDict.currency,
      //订单ID
      orderID: orderDict.order_id,
      //选中的支付方式ID
      selectPayID: orderDict.payinfo.pay_app_id,
      //用户的预存款信息--是否设置了支付密码
      isSetPayPassWord: memberDict.has_pay_password,
      //预存款金额
      depositMoney: memberDict.deposit_money,
      //格式化预存款金额
      formatDepositMoeny: memberDict.deposit_money_format,
      //剩余的支付金额
      combinationMoney: memberDict.cur_money,
      //初始剩余支付金额
      initCombinationMoeny: memberDict.cur_money,
      //格式化的剩余支付金额
      formatCombinationMoney: memberDict.cur_money_format,
      //支付方式数据
      paymentsArr: that.getPaymentsArr(data.payments),
      //组合支付方式数据
      combinationPaymentsArr: combinationPayArr == null ? [] : that.getPaymentsArr(combinationPayArr)
    }
    return model
  },
  //解析支付方式数据
  getPaymentsArr: function (array) {
    let infoArr = []
    for (var i = 0; i < array.length; i++) {
      let object = array[i]
      let model = {
        //支付方式描述
        infoDesc: object.app_pay_brief,
        //支付图标
        infoIcon: object.icon_src,
        //支付ID
        infoID: object.app_id,
        //支付方式名称
        infoName: object.app_name == null ? object.app_display_name : object.app_name,
        //支付JSON字符串
        value: object.value,
        //是否选中支付方式
        isSelect: object.checked == "true"
      }
      infoArr.push(model)
    }
    return infoArr
  },
  //解析按钮标题和能否点击
  getButtonTitleStatus: function () {
    let titleString = this.data.payMessageInfo.payButtonTitle
    let canCombinationPay = this.data.payMessageInfo.canCombinationPay
    let canClick = true
    if (titleString.length == 0) {
      if (canCombinationPay) {
        titleString = "组合支付"
        canClick = true
      }
      else {
        titleString = "无法支付"
        canClick = false
      }
    }
    else {
      canClick = true
    }
    this.data.buttonTitle = titleString
    this.data.canButtonClick = canClick
  },
  //切换支付方式
  changeSelectPay: function (event) {
    let infoID = event.target.dataset.infoId
    if (this.data.isCombinationPay) {
      //组合支付切换支付方式
      this.changeCombinationPayRequest(infoID)
    }
    else {
      //普通支付切换支付方式
      this.changeNormalPayRequest(infoID)
    }
  },
  //切换普通支付方式请求
  changeNormalPayRequest: function (infoID) {
    var that = this
    let param = {
      "method": "b2c.order.payment_change",
      "payment[currency]": this.data.payMessageInfo.currency,
      "order_id": this.data.payMessageInfo.orderID,
      "payment[pay_app_id]": infoID,
      "is_wx_pro": "true"
    }
    app.request(param,
      function (data) {
        let paymessageInfo = that.getPayMessageInfo(data)
        that.data.payMessageInfo = paymessageInfo
        that.getButtonTitleStatus()
        that.setData({
          payMessageInfo: paymessageInfo,
          buttonTitle: that.data.buttonTitle,
          canButtonClick: that.data.canButtonClick
        })
      }, function (data) {
      }, true, true, true)
  },
  //切换组合支付方式请求
  changeCombinationPayRequest: function (infoID) {
    var that = this
    app.request({
      "method": "b2c.paycenter.get_payment_money",
      "payment[pay_app_id]": infoID,
      "payment[cur_money]": that.data.payMessageInfo.initCombinationMoeny,
      "payment[deposit_pay_money]": that.data.payMessageInfo.depositMoney,
      "is_wx_pro": "true"
    }, function (data) {
      that.data.combinationPayID = infoID
      for (var i = 0; i < that.data.payMessageInfo.paymentsArr.length; i++) {
        let payObject = that.data.payMessageInfo.paymentsArr[i]
        if (payObject.infoID == infoID) {
          payObject.isSelect = true

        }
        else {
          payObject.isSelect = false
        }
      }
      that.data.payMessageInfo.formatCombinationMoney = data.cur_money
      that.data.payMessageInfo.combinationMoney = data.cur_money_val
      that.data.payMessageInfo.formatDepositMoeny = data.deposit_money
      that.data.payMessageInfo.depositMoney = data.deposit_money_value
      that.setData({
        showFailNetWork: false,
        payMessageInfo: that.data.payMessageInfo,
        buttonTitle: that.data.buttonTitle
      })
    }, function () {
      that.setData({
        showFailNetWork: true
      })
    }, true, true, true)
  },
  //确认支付
  payButtonCommit: function (event) {
    var that = this
    if (!this.data.canButtonClick) {
      return
    }
    if (this.data.payMessageInfo.selectPayID == "deposit") {
      if (this.data.payMessageInfo.canCombinationPay) {
        wx.showModal({
          title: "启用组合支付",
          content: "当前预存款不足，是否使用第三方支付方式支付剩余扣除预存款后的剩余金额(确定后不能回到当前页)？",
          showCancel: true,
          cancelText: "取消",
          confirmText: "确定",
          success: function (res) {
            if (res.confirm) {
              let newModel = {
                isSetPayPassWord: that.data.payMessageInfo.isSetPayPassWord,
                depositMoney: that.data.payMessageInfo.depositMoney,
                formatDepositMoeny: that.data.payMessageInfo.formatDepositMoeny,
                combinationMoney: that.data.payMessageInfo.combinationMoney,
                initCombinationMoeny: that.data.payMessageInfo.initCombinationMoeny,
                formatCombinationMoney: that.data.payMessageInfo.formatCombinationMoney,
                orderID: that.data.payMessageInfo.orderID,
                totalMoney: that.data.payMessageInfo.totalMoney,
                currency: that.data.payMessageInfo.currency,
                selectPayID: that.data.payMessageInfo.selectPayID,
                paymentsArr: that.data.payMessageInfo.combinationPaymentsArr
              }
              let modelString = JSON.stringify(newModel)
              wx.redirectTo({
                url: '../payinfolist/payinfolist?' + 'orderID=' + newModel.orderID + '&isPrepare=' + this.isPrepareOrder + '&isOrderPay=' + this.isOrderPay + '&isCombinationPay=' + true + '&model=' + modelString,
              })
            }
          }
        });

        return
      }

      if (this.data.payMessageInfo.isSetPayPassWord) {
        if (this.data.canInputPassWordAgain) {
          this.showPayPassWord()
        }
        else {
          wx.showModal({
            title: "您输入支付密码的错误次数超过限制次数，请重设支付密码",
            content: "",
            showCancel: true,
            cancelText: "取消",
            confirmText: "忘记密码",
            success: function (res) {
              if (res.confirm) {
                //跳转重设密码
                that.navigateToForgetPayPassWord()
              }
            }
          });
        }
      }
      else {

        this.data.isNavigateSetPay = true
        if (app.isWeixinLogin()){
          //微信登录先绑定手机号
          const that = this;
          app.getAccountSecurityInfo(function () {

            if (app.shouldBindPhoneNumber()) {
              app.bindPhoneNumber('../paypassword/paypassword?' + 'isSetPayPass=' + "true");
            } else {
              that.setPayPassword();
            }
          });
        }else{
          this.setPayPassword();
        }
      }
    }
    else {
      this.doPaymentCall()
    }
  },

  //设置支付密码
  setPayPassword:function(){
    //调整至设置支付密码
    wx.navigateTo({
      url: '../paypassword/paypassword?' + 'isSetPayPass=' + "true",
    })
  },

  //调用支付
  doPaymentCall: function () {
    let param = {}
    var that = this
    param["method"] = "b2c.paycenter.dopayment"
    param["order_id"] = this.data.payMessageInfo.orderID
    param["pay_app_id"] = this.data.payMessageInfo.selectPayID
    if (this.data.isCombinationPay) {
      param["combination_pay"] = "true"
      param["other_online_cur_money"] = this.data.payMessageInfo.combinationMoney
      param["other_online_pay_app_id"] = this.data.combinationPayID
      param["cur_money"] = this.data.payMessageInfo.totalMoney
    }
    else {
      param["cur_money"] = this.data.payMessageInfo.totalMoney
    }
    if (this.data.payMessageInfo.selectPayID == "deposit") {
      param["pay_password"] = this.data.payPassWord
    }
    if (that.data.payMessageInfo.selectPayID == "wxpayjsapi" || that.data.combinationPayID == "wxpayjsapi") {
      wx.login({
        success: function (res) {
          param["code"] = res.code
          
          that.callPayment(param)
        },
        fail: function () {
        },
        complete: function () {
        }
      })
    }
    else {
      this.callPayment(param)
    }

  },
  //实际调用支付
  callPayment: function (requestParam) {
    var that = this
    app.request(requestParam,
      function (data) {
        if (that.data.payMessageInfo.selectPayID == "wxpayjsapi" || that.data.combinationPayID == "wxpayjsapi") {
         
          wx.requestPayment({
            'timeStamp': data.timestamp.toString(),
            'nonceStr': data.noncestr,
            'package': data.return.package,
            'signType': 'MD5',
            'paySign': data.return.sign,
            'success': function (res) {
              that.paySuccessAction()
            },
            'fail': function (res) {
              that.payFailAction()
            }
          })
        }
        else if (that.data.payMessageInfo.selectPayID == "deposit") {
          
          that.paySuccessAction()
        }
      }, function (data) {
        wx.hideToast();
        let msg = data.msg
        let code = data.code
        if (code == "pay_password_error") {
          let limit = data.data.limit
          if (limit != 0) {
            that.data.canInputPassWordAgain = true
            wx.showModal({
              title: msg,
              content: "",
              showCancel: true,
              confirmText: "再次输入",
              cancelText: "忘记密码",
              success: function (res) {
                if (res.confirm) {
                  that.showPayPassWord()
                }
                else {
                  //忘记密码跳转
                  that.navigateToForgetPayPassWord()
                }
              }
            })
          }
          else {
            that.data.canInputPassWordAgain = false
            wx.showModal({
              title: msg,
              content: "",
              showCancel: true,
              confirmText: "忘记密码",
              cancelText: "取消",
              success: function (res) {
                if (res.confirm) {
                  //忘记密码跳转
                  that.navigateToForgetPayPassWord()
                }
              }
            })
          }
        }
        else{
            if(this.data.isPrepareOrder){
                wx.redirectTo({
                    url: '../orderlist/orderlist?' + 'index=' + 5 + '&showBar=' + false + '&typeIndex=' + 0 + '&isPrepare' + true,
                })
            }   
            else{
                let index = this.data.isOpenMember ? 1 : 0
                wx.redirectTo({
                    url: '../orderlist/orderlist?' + 'index=' + 2 + '&showBar=' + true + '&typeIndex=' + index + '&isPrepare=' + false,
                })
            }
        }
      },
      true, true, false)
  },
  //跳转至忘记支付密码
  navigateToForgetPayPassWord: function () {
    wx.navigateTo({
      url: '../paypassword/paypassword?' + 'isSetPayPass=' + "false",
    })
  },
  //支付成功的跳转
  paySuccessAction: function () {
    if (this.data.isOrderPay) {
      wx.navigateBack({
        delta: 1
      })
    }
    else {
      if (this.data.isPrepareOrder) {
        wx.redirectTo({
          url: '../orderlist/orderlist?' + 'index=' + 5 + '&showBar=' + false,
        })
      }
      else {
        wx.redirectTo({
          url: '../orderlist/orderlist?' + 'index=' + 2 + '&showBar=' + true,
        })
      }
    }
  },
  //支付失败回调--统一跳转待支付订单列表
  payFailAction: function () {
    if (this.data.isOrderPay) {
      wx.navigateBack({
        delta: 1
      })
    }
    else {
      wx.redirectTo({
        url: '../orderlist/orderlist?' + 'index=' + 1 + '&showBar=' + true + '&typeIndex=' + 0 + '&isPrepare=' + false,
        })
    }
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
      this.doPaymentCall()
      return ""
    }
  },
  //网络重载
  reloadData: function () {
    if (this.data.isCombinationPay) {
      this.changeCombinationPayRequest(this.data.combinationPayID)
    }
    else {
      this.getPayMessageInfoRequest()
    }
  },
})