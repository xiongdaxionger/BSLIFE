var app = getApp()
var operation
Page({
  data: {
    /**是否显示加载失败的视图**/
    showFailNetWork: false,
    /**购物车数据**/
    shopCartInfo: {},
    /**是否处于编辑状态**/
    isEditStatus: false,
    /**购物车是否为空**/
    isShopCarEmpty: false,
    /**网络状态下是否全选**/
    netWorkStatusIsSelectAll: true,
    /**编辑状态下是否全选**/
    editStatusIsSelectAll: false,
    /**网络状态下选中商品的数量**/
    selectQuantity: 0,
    imgURL: app.getImgURL(), //图片前面域名
    //选中图片
    selectImage: "",
    //未选中图片
    unselectImage: "",
  },
  /**页面展示**/
  onShow: function (options) {
    this.loadShopCartInfo(true)
  },
  //页面卸载
  onUnload: function () {
    operation = null
  },
  //页面加载
  onLoad: function (options) {
    operation = require('../../utils/shopCartOperation.js')
    this.data.selectImage = this.data.imgURL + "/images/shopcart/shop_Car_Select.png"
    this.data.unselectImage = this.data.imgURL + "/images/shopcart/shop_Car_UnSelect.png"
  },
  /**加载数据**/
  loadShopCartInfo: function (showLoading) {
    var that = this;
    app.request({
      method: 'b2c.cart.index'
    }, function (data) {
      let model = operation.getShopCartInfo(data);
      that.setData({
        showFailNetWork: false,
        shopCartInfo: model,
        isShopCarEmpty: false,
        netWorkStatusIsSelectAll: operation.netWorkStatusIsSelectAll(model),
        editStatusIsSelectAll: operation.editStatusIsSelectAll(model),
        selectQuantity: operation.getSelectShopCarGoodQuantity(model),
        selectImage: that.data.selectImage,
        unselectImage: that.data.unselectImage
      })
      app.globalData.shopcartCount = data.aCart._cookie.CART_NUMBER;
    }, function (data) {
      app.globalData.shopcartCount = '';
      if (typeof data == "boolean") {
        that.setData({
          showFailNetWork: false,
          isShopCarEmpty: true
        })
      }
      else {
        that.setData({
          showFailNetWork: true
        })
      }
    }, showLoading, true, true)
  },
  /**重载数据**/
  reloadData: function () {
    this.loadShopCartInfo(true)
  },
  //编辑按钮点击
  editStatusChange: function (event) {
    this.setData({
      isEditStatus: !this.data.isEditStatus,
      netWorkStatusIsSelectAll: operation.netWorkStatusIsSelectAll(this.data.shopCartInfo),
      editStatusIsSelectAll: operation.editStatusIsSelectAll(this.data.shopCartInfo)
    })
  },
  /**选中所有商品**/
  selectAllGood: function (event) {
    if (this.data.isEditStatus) {
      this.data.editStatusIsSelectAll = !this.data.editStatusIsSelectAll
    }
    else {
      this.data.netWorkStatusIsSelectAll = !this.data.netWorkStatusIsSelectAll
    }
    for (var i = 0; i < this.data.shopCartInfo.groupGoodInfoArr.length; i++) {
      let groupInfo = this.data.shopCartInfo.groupGoodInfoArr[i];
      if (groupInfo.groupType == 0) {
        let normalGoodInfo = groupInfo.groupGoodInfosArr[0];
        if (normalGoodInfo.goodStore == "0") {
          normalGoodInfo.goodIsSelect = false;
          normalGoodInfo.goodEditIsSelect = false;
        }
        else {
          if (this.data.isEditStatus) {
            normalGoodInfo.goodEditIsSelect = this.data.editStatusIsSelectAll;
          }
          else {
            normalGoodInfo.goodIsSelect = this.data.netWorkStatusIsSelectAll;
          }
        }
      }
    }
    if (!this.data.isEditStatus) {
      //请求网络,重新loadInfo
      this.selectGoodRequest();
    }
    else {
      this.setData({
        shopCartInfo: this.data.shopCartInfo,
        editStatusIsSelectAll: this.data.editStatusIsSelectAll,
        netWorkStatusIsSelectAll: this.data.netWorkStatusIsSelectAll
      })
    }
  },
  //选中单个商品
  selectGood: function (event) {
    let objIdent = event.target.dataset.objIdent;
    let editSelect = event.target.dataset.editSelect == true;
    let networkSelect = event.target.dataset.networkSelect == true;
    for (var i = 0; i < this.data.shopCartInfo.groupGoodInfoArr.length; i++) {
      let groupInfo = this.data.shopCartInfo.groupGoodInfoArr[i];
      if (groupInfo.groupType == 0) {
        let normalGoodInfo = groupInfo.groupGoodInfosArr[0];
        if (normalGoodInfo.objIdent == objIdent) {
          if (this.data.isEditStatus) {
            normalGoodInfo.goodEditIsSelect = !editSelect;
          }
          else {
            normalGoodInfo.goodIsSelect = !networkSelect;
          }
        }
      }
    }
    if (!this.data.isEditStatus) {
      //请求网络,重新loadInfo
      this.selectGoodRequest();
    }
    else {
      this.data.editStatusIsSelectAll = operation.editStatusIsSelectAll(this.data.shopCartInfo);
      this.data.netWorkStatusIsSelectAll = operation.netWorkStatusIsSelectAll(this.data.shopCartInfo);
      this.setData({
        shopCartInfo: this.data.shopCartInfo,
        editStatusIsSelectAll: this.data.editStatusIsSelectAll,
        netWorkStatusIsSelectAll: this.data.netWorkStatusIsSelectAll
      })
    }
  },
  //选中商品的请求
  selectGoodRequest: function () {
    var that = this;
    let selectGoodInfoArr = operation.getCurrentSelectGoodObjIdent(this.data.shopCartInfo, this.data.isEditStatus);
    let param = {};
    for (var i = 0; i < selectGoodInfoArr.length; i++) {
      let key = "obj_ident" + "[" + i + "]";
      param[key] = selectGoodInfoArr[i];
    }
    param["method"] = "b2c.cart.select_cart_item";
    app.request(param,
      function (data) {
        that.loadShopCartInfo(true);
      }, function (data) {
        that.loadShopCartInfo(true);
      }, true, true, true)
  },
  //删除选中商品
  deleteGoodAction: function (event) {
    var that = this;
    let selectGoodArr = operation.getCurrentSelectGoodObjIdent(this.data.shopCartInfo, this.data.isEditStatus)
    if (selectGoodArr.length == 0) {
      wx.showModal({
        title: "请选择需要删除的商品",
        content: "",
        showCancel: false
      });
    } else {
      wx.showModal({
        title: "确定要删除选中商品么？",
        content: "",
        showCancel: true,
        success: function (res) {
          if (res.confirm) {
            let param = operation.batchDeleteGoodInfo(that.data.shopCartInfo)
            app.request(param,
              function (data) {
                that.loadShopCartInfo(true);
              }, function (data) {
                that.loadShopCartInfo(true);
              }, true, true, true)
          }
        }
      });
    }
  },
  //减少商品数量
  minusGoodAction: function (event) {
    var that = this;
    let quantity = event.target.dataset.quantity;
    if (quantity == "1") {
    }
    else {
      this.changeGoodQuantity(event, true)
    }
  },
  //增加商品数量
  addGoodAction: function (event) {
    let quantity = event.target.dataset.quantity;
    let maxBuyCount = event.target.dataset.maxBuyCount;
    if (parseInt(quantity) + 1 > parseInt(maxBuyCount)) {
      wx.showModal({
        title: "超出商品最大购买量",
        content: "",
        showCancel: false
      });
    }
    else {
      this.changeGoodQuantity(event, false)
    }
  },
  //更改商品数量
  changeGoodQuantity: function (event, isMinus) {
    var that = this;
    let goodType = event.target.dataset.goodType;
    let quantity = event.target.dataset.quantity;
    let normalGoodID = event.target.dataset.normalGoodId;
    let normalProductID = event.target.dataset.normalProductId;
    let productID = event.target.dataset.productId;
    let newQuantity = isMinus ? parseInt(quantity) - 1 : parseInt(quantity) + 1;
    let objIdent = event.target.dataset.objIdent;
    for (var i = 0; i < this.data.shopCartInfo.groupGoodInfoArr.length; i++) {
      let groupInfo = this.data.shopCartInfo.groupGoodInfoArr[i];
      if (groupInfo.groupType == 0) {
        let normalGoodInfo = groupInfo.groupGoodInfosArr[0];
        if (normalGoodInfo.objIdent == objIdent) {
          normalGoodInfo.goodIsSelect = true;
        }
      }
    }
    let selectObjIdentArr = operation.getCurrentSelectGoodObjIdent(this.data.shopCartInfo, false);
    let goodIdent = "goods_" + normalGoodID + "_" + normalProductID;
    let param = {};
    param["method"] = "b2c.cart.update";
    param["obj_type"] = "goods";
    if (goodType == "0") {
      param["goods_id"] = normalGoodID;
      param["goods_ident"] = goodIdent;
      let quantityKey = "modify_quantity" + "[" + goodIdent + "]" + "[quantity]";
      param[quantityKey] = newQuantity;
    }
    else {
      let groupID = event.target.dataset.groupId;
      let quantityKey = "modify_quantity" + "[" + goodIdent + "]" + "[adjunct]" + "[" + groupID + "]" + "[" + productID + "]" + "[quantity]";
      param[quantityKey] = newQuantity;
    }
    app.request(param,
      function (data) {
        that.loadShopCartInfo(true);
      }, function (data) {
        that.loadShopCartInfo(true);
      }, true, true, true)
  },
  //结算按钮事件
  payButtonAction: function (event) {
    let selectGoodArr = operation.getCurrentSelectGoodObjIdent(this.data.shopCartInfo, this.data.isEditStatus);
    if (selectGoodArr.length == 0) {
      wx.showModal({
        title: "请选择需要结算的商品",
        content: "",
        showCancel: false
      });
    }
    else {
      let param = {};
      for (var i = 0; i < selectGoodArr.length; i++) {
        let key = "obj_ident" + "[" + i + "]";
        param[key] = selectGoodArr[i];
      }
      param["method"] = "b2c.cart.checkout";
      var paramString = JSON.stringify(param);
      wx.navigateTo({
        url: '../confirmorder/confirmorder?' + 'model=' + paramString + '&isFastBuy=' + false + "&pointOrder=" + false,
      })
    }
  }
})