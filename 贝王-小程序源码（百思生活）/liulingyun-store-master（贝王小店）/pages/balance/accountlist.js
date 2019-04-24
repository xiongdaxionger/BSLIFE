//提现账号页面
var app = getApp()
Page({
  data: {
    //账户数据
    accountListsArr: [],
    //是否加载成功
    showFailNetWork: false,
    //是否需要重新加载
    isRefreshInfo: false,
  },
  //页面显示
  onShow: function () {
    if (this.data.isRefreshInfo) {
      this.data.isRefreshInfo = false
      this.accountListsArr = []
      this.loadAccountInfo(true)
    }
  },
  //页面加载
  onLoad: function (options) {
    this.loadAccountInfo(true)
  },
  //加载数据
  loadAccountInfo: function (showLoading) {
    var that = this
    app.request({
      "method": "b2c.wallet.get_banklists"
    }, function (data) {
      let accountList = data.banklists
      let accountTmpList = []
      for (var i = 0; i < accountList.length; i++) {
        let object = accountList[i]
        let num = object.bank_num
        let accountType = object.bank_type
        let accountNum = ""
        let lastNum = ""
        if (accountType == "1") {
          let numArr = num.split(" ")
          lastNum = numArr.pop()
          for (var j = 0; j < numArr.length; j++) {
            accountNum = accountNum + "**** "
          }
          accountNum = accountNum + lastNum
        }
        else {
          accountNum = num
        }
        let model = {
          //账户ID
          accountID: object.member_bank_id,
          //图片Logo
          icon: object.bank_img,
          //类型名称--(支付宝/银行名称)
          typeName: object.bank_name,
          //账户真实名称
          realName: object.real_name,
          //账户信息
          num: accountNum,
          //尾号
          lastNum: lastNum,
          //类型
          accountType: accountType
        }
        accountTmpList.push(model)
      }
      that.setData({
        showFailNetWork: false,
        accountListsArr: accountTmpList
      })
    }, function (data) {
      that.setData({
        showFailNetWork: true
      })
    }, showLoading, true, true)
  },
  //选中账户
  selectAccount: function (event) {
    let object = this.data.accountListsArr[event.target.dataset.index]
    let model = {
      name: object.typeName,
      info: object.accountType == "1" ? '尾号' + object.lastNum : '账号' + object.num,
      ID: object.accountID
    }
    wx.setStorageSync('accountInfo', model);
    wx.navigateBack({
      delta: 1
    })
  },
  //添加账号
  addAccount: function () {

    this.data.isRefreshInfo = true
    //微信登录先绑定手机号
    const that = this;
    app.getAccountSecurityInfo(function () {

      if (app.shouldBindPhoneNumber()) {
        app.bindPhoneNumber('/pages/balance/addaccount');
      } else {
        wx.navigateTo({
          url: '/pages/balance/addaccount'
        })
      }
    });
  },
  //删除账号
  deleteAccount: function (event) {
    let index = event.target.dataset.index
    let object = this.data.accountListsArr[index]
    var that = this
    app.request({
      "method": "b2c.wallet.delete_bankcard",
      "member_bank_id": object.accountID
    }, function (data) {
      wx.showModal({
        title: "删除成功",
        content: "",
        showCancel: false,
      })
      let result = {
        "model": object,
        "isDelete": true
      }
      wx.setStorageSync('deleteAccount', result);
      let tmpArr = that.data.accountListsArr
      tmpArr.splice(index, 1)
      that.setData({
        accountListsArr: tmpArr
      })
    }, function (data) {
      wx.showModal({
        title: "",
        content: "删除失败，请重试",
        showCancel: false,
      })
    }, true, true, true)
  },
  //重载
  reloadData: function () {

  }
})