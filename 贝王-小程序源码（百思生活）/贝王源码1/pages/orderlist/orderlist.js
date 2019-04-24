var app = getApp()
var operation = require('../../utils/orderOperation.js')
Page({
    data:{  
    /**选中的状态下标**/
    selectIndex:0,
    /**是否显示状态栏**/
    showStatusBar:false,
    /**订单数据**/
    orderListInfo:[],
    /**页码**/
    pageNumber:1,
    /**是否正在请求数据**/
    isLoadInfo:false,
    /**是否显示加载失败的视图**/
    showFailNetWork:false,
    /**空视图显示的提示语**/
    emptyTipString:"",
    /**订单状态数组**/
    orderStatusInfo:['全部','待付款','待发货','待收货','待评价'],
    /**代购订单数组**/
    fenXiaoStatusInfo:['全部','待付款','待发货','待收货'],
    //总数量
    total:0,
    imgURL: app.getImgURL(), //图片前面域名
    load_more: false, //是否在加载更多
    showScrollToTop: false, //是否显示回到顶部按钮
    scroll_top: 0, //回到顶部
    //是否为代购订单
    isFenXiaoOrder:false,
    //订单类型(分销订单/普通订单下标)
    typeSelectIndex:0,
    },
    /**页面展示**/
    onShow:function(options){
      if(!this.data.isLoadInfo){
        this.data.pageNumber = 1
        this.data.orderListInfo = []
        this.loadOrderListInfo(true)
      }
    },
    /**页面加载完成**/
    onLoad:function(options){
      this.data.selectIndex = parseInt(options.index)
      this.data.typeSelectIndex = parseInt(options.typeIndex)
      this.data.showStatusBar = options.showBar == "true"
      let isPrepare = options.isPrepare == "true"
      this.data.isFenXiaoOrder = isPrepare ? false : app.globalData.userInfo.openFenxiao
      this.data.isLoadInfo = true
      this.loadOrderListInfo(true)
    },
    /**重载信息**/
    reloadData:function(){
      this.loadOrderListInfo(true)
    },
        // 容器滑动
    containerScroll: function (event) {
      const y = event.detail.scrollTop;
      // 屏幕高度
      const height = app.globalData.systemInfo.windowHeight;
      this.setData({
        showScrollToTop: y >= height * 2
      })
    },
    // 回到顶部
    scrollToTop: function () {
      this.setData({
        scroll_top: 1
      })
      // 必须要有改变才会刷新Ui的
      this.setData({
        scroll_top: 0
      })
    },
    //切换类型
    selectType:function(event){
        let index = event.target.dataset.index
        if(index == 1 && this.data.selectIndex == 4){
          this.data.selectIndex = 3
        }
        this.data.typeSelectIndex = index
        this.data.pageNumber = 1;
        this.loadOrderListInfo(true)
    },
    //空提示语
    getEmptyTip:function(){
      switch(this.data.selectIndex){
        case 0:{
          this.data.emptyTipString = "暂无订单"
          break;
        }
        case 1:{
          this.data.emptyTipString = "暂无待付款订单"
          break
        }
        case 2:{
          this.data.emptyTipString = "暂无待发货订单"
          break
        }
        case 3:{
          this.data.emptyTipString = "暂无待收货订单"
          break
        }
        case 4:{
          this.data.emptyTipString = "暂无待评价"
          break
        }
        case 5:{
          this.data.emptyTipString = "暂无预售订单"
          break
        }
      }
    },
    /**获取订单数据**/
    loadOrderListInfo:function(showLoading){
        this.getEmptyTip()
        var that = this;
        app.request({
          "method":'b2c.member.orders',
          "page":that.data.pageNumber, 
          "member_id":app.globalData.userInfo.userId,
          "order_status":operation.requestOrderStatus(that.data.selectIndex),
          "is_fx":that.data.typeSelectIndex == 1 ? "true" : "false"
        },function(data){
          let total = data.pager.dataCount
          let orderInfoArr = getOrderInfoArr(data)
          let tmpOrderInfoArr = that.data.orderListInfo
          if(that.data.pageNumber == 1){
            tmpOrderInfoArr = orderInfoArr
          }
          else{
            Array.prototype.push.apply(tmpOrderInfoArr, orderInfoArr)
          }
          that.setData({
            selectIndex:that.data.selectIndex,
            showStatusBar:that.data.showStatusBar,
            emptyTipString:that.data.emptyTipString,
            orderListInfo:tmpOrderInfoArr,
            showFailNetWork:false,
            total:total,
            load_more:false,
            isFenXiaoOrder:that.data.isFenXiaoOrder,
            typeSelectIndex:that.data.typeSelectIndex
          })
        },function(data){
            that.setData({
              showFailNetWork:true
            })
        },showLoading,true,true)
    },
    /**状态栏动作**/
    changeOrderStatus:function(event){
      this.setData(
        {
        selectIndex : parseInt(event.target.dataset.orderStatus),
        },
      )
      this.data.pageNumber = 1;
      this.loadOrderListInfo(true)
    },
    /**下拉刷新**/
    onPullDownRefresh: function() {
      this.data.pageNumber = 1;
      this.loadOrderListInfo(true);
    },
    /**上拉加载**/
    onReachBottom: function() {
      this.data.pageNumber = this.data.pageNumber + 1;
      this.loadOrderListInfo(true);
    },
    /**删除订单**/
    deleteOrderAction:function(event){
      let orderID = event.target.dataset.orderId;
      var that = this;
      wx.showModal({
          title: "确定要删除该订单吗?",
          content: "",
          showCancel: true,
          success:function(res){
            if(res.confirm){
              app.request({
                method:'b2c.order.dodelete',
                order_id:orderID
              },function(){
                wx.showToast({
                  title: '订单删除成功',
                  icon: 'success',
                  duration:5000
                })
                that.data.pageNumber = 1;
                that.loadOrderListInfo(true);
              },function(){
              },true,true,true)
            }
          }
        });
    },

    //评价晒单
    tapComment:function(event){
      this.data.isLoadInfo = false
      const index = parseInt(event.currentTarget.dataset.index);
      const goodIndex = parseInt(event.currentTarget.dataset.goodindex);
      const info = this.data.orderListInfo[index];
      const goodInfo = info.orderGoodInfoArr[goodIndex];
      wx.navigateTo({
        url: '/pages/goodcomment/comment_add?orderId=' + info.orderID + '&goodId=' + goodInfo.orderGoodID + '&productId=' + goodInfo.orderProductID + 
        '&imageURL=' + goodInfo.orderGoodImage,
      })
    },
    // 加载更多
    loadMore: function () {
        let length = this.data.orderListInfo.length
        if (length < this.data.total && !this.data.load_more) {
            this.setData({
                load_more: true
            })
            this.data.pageNumber = this.data.pageNumber + 1
            //可以加载
            this.loadOrderListInfo(true);
        }
    },
    /**再次购买**/
    buyAgainAction:function(event){
      let orderID = event.target.dataset.orderId;
      var that = this;
      app.request({
        method:'b2c.member.reAddCart',
        order_id:orderID
      },function(){
        wx.showToast({
          title: '商品再次加入购物车成功',
          icon: 'success',
          duration:5000
        })
      },function(){
      },true,true,true)
    },
    /**取消订单*/
    cancelOrderAction:function(event){
      let orderID = event.target.dataset.orderId;
      wx.showModal({
          title: "确定要取消该订单吗?",
          content: "",
          showCancel: true,
          success:function(res){
            if(res.confirm){
              app.request({
                method:'b2c.member.docancel',
                'order_cancel_reason[order_id]':orderID,
                'order_cancel_reason[reason_type]':0
              },function(){
                wx.showToast({
                  title: '订单取消成功',
                  icon: 'success',
                  duration:5000
                })
                that.data.pageNumber = 1;
                that.loadOrderListInfo(true);
              },function(){
              },true,true,true)
            }
          }
        });
    },
    /**支付订单**/
    payOrderAction:function(event){
      
      let orderID = event.target.dataset.orderId;
      let info = event.target.dataset.info;
      let typeAction = parseInt(event.target.dataset.type);
      if(typeAction == 0 || typeAction == 2){
        wx.showModal({
          title: info,
          content: "",
          showCancel: false
        });
      }
      else{
        //跳转支付页面,isLoadInfo需要设置为false
        this.data.isLoadInfo = false
        wx.navigateTo({
            url: '../payinfolist/payinfolist?' + 'orderID=' + orderID + '&isOrderPay=' + true + '&isCombinationPay=' + false,
        })
      }
    },
    /**跳转订单详情**/
    pustOrderDetail:function(event){
      let orderID = event.target.dataset.orderId
      if(this.data.selectIndex != 2){
          this.data.isLoadInfo = false
      }
      wx.navigateTo({
          url: '../orderdetail/orderdetail?' + 'id=' + orderID,
      })
    },
    /**查看物流**/
    checkExpressAction:function(event){
      let orderID = event.target.dataset.orderId;
      //跳转查看物流页面，传orderID和是否为订单查询,isLoadInfo不需要设置为false
      wx.navigateTo({
          url: '../orderdetail/logistics?' + 'id=' + orderID + '&isOrder=' + true,
      })
    },
    /**确认订单**/
    confirmOrderAction:function(event){
      let orderID = event.target.dataset.orderId;
      let info = event.target.dataset.info;
      let typeAction = parseInt(event.target.dataset.type);
      if(typeAction == 3){
        var that = this;
        app.request({
          method:'b2c.member.receive',
          order_id:orderID
        },function(){
          wx.showToast({
            title: '确认收货成功',
            icon: 'success',
            duration:5000
          })
          that.data.pageNumber = 1;
          that.loadOrderListInfo(true);
        },function(){
        },true,true,true)
      }
      else{
        wx.showModal({
          title: info,
          content: "",
          showCancel: false
        });
      }
    },
})

/**解析数据**/
function getOrderInfoArr(data){
  var orderArr = data.orders;
  var orderInfoArr = [];
  if(orderArr == null){
    return orderInfoArr;
  }
  for(var i = 0;i < orderArr.length;i++){
    var object = orderArr[i];
    /**预售订单数据**/
    let prepareObject = object.prepare;
    var prepareBeginTime;
    var prepareEndTime;
    var preparePayedMoney;
    var prepareFinalMoney;
    if(prepareObject != null){
      prepareBeginTime = parseInt(prepareObject.begin_time_final);
      prepareEndTime = parseInt(prepareObject.end_time_final);
      preparePayedMoney = prepareObject.preparesell_price;
      prepareFinalMoney = prepareObject.final_price;
    } 
    else{
      prepareBeginTime = "0";
      prepareEndTime = "0";
      prepareFinalMoney = "0";
      preparePayedMoney = "0";
    }
    var statusTxt = object.status_txt;
    let lastStatusObject = statusTxt[statusTxt.length - 1];
    let statusString = object.status;
    var statusContent = "";
    // for(var j = 0;j < statusTxt.length;j++){
    //   let statusObject = statusTxt[j];
    //   statusContent = statusContent + statusObject.name;
    // }
    // for(var j = 0;j < statusTxt.length;j++){
    let statusObject = statusTxt[statusTxt.length - 1];
    statusContent = statusObject.name;
    // }
    var realStatus = operation.getOrderStatus(statusString,lastStatusObject);
    let actionType = parseInt(object.pay_btn_code);
    if(actionType == 5){
      /**订单可评价**/
      realStatus = 14; 
    }
    let orderGitGoodArr = object.order.gift_items;
    let orderPointGoodArr = object.gift.gift_items;
    let orderNormalGoodArr = object.goods_items;
    let isContainPointOrder = orderPointGoodArr.length > 0;
    var isInitPointOrder = false;
    if(orderGitGoodArr.length == 0 && orderPointGoodArr.length != 0 && orderNormalGoodArr.length == 0){
      isInitPointOrder = true;
    }
    else{
      isInitPointOrder = false;
    }
    let actionTimeModel = operation.showPrepareTimeAction(object.promotion_type,realStatus,prepareBeginTime,isInitPointOrder);
    var isShowActionButton = actionTimeModel.showAction == "true";
    var isShowPrepareTime = actionTimeModel.showTime == "true";
    let payInfo = object.payinfo
    var model = {
      /**能否申请售后**/
      canAfterSale:object.is_afterrec,
      /**反馈**/
      comment:[],
      /**订单ID**/
      orderID:object.order_id,
      /**支付方式ID**/
      orderPayID:payInfo == null ? "" : payInfo.pay_app_id,
      /**是否为预售订单**/
      orderIsPrepare:object.promotion_type == "prepare",
      /**预售开始时间戳**/
      orderPrepareBeginTime:prepareBeginTime,
      /**预售结束时间戳**/
      orderPrepareEndTime:prepareEndTime,
      /**预售已付定金**/
      orderPreparePayedMoney:preparePayedMoney,
      /**预售尾款**/
      orderPrepareFinalMoney:prepareFinalMoney,
      /**订单状态显示**/
      orderStatusTxt:statusContent,
      /**订单的状态**/
      orderStatus:realStatus,
      /**订单总金额**/
      orderTotalMoney:(object.cur_amount == "" || object.cur_amount == null) ? object.total_amount : object.cur_amount,
      /**能否取消订单**/
      orderCanCancelOrder:object.cancel_order,
      /**能否删除订单**/
      orderCanDeleteOrder:object.delete_order,
      /**数量**/
      orderQuantity:object.itemnum,
      /**主操作按钮标题**/
      orderMainButtonTitle:object.pay_btn,
      /**主操作按钮操作动作**/
      orderMainButtonActionType:actionType,
      /**是否纯粹的积分订单**/
      orderIsInitPointOrder:isInitPointOrder,
      /**订单的商品数据**/
      orderGoodInfoArr:operation.getOrderGoodInfoArr(orderPointGoodArr,orderGitGoodArr,orderNormalGoodArr,object.promotion_type == "prepare"),
      /**订单使用的积分*/
      orderUsePoint:object.score_u,
      /**订单的价格显示文本**/
      orderPriceString:getOrderPriceInfoString(object,realStatus,isContainPointOrder,isInitPointOrder),
      /**是否显示操作按钮**/
      orderShowAction:isShowActionButton,
      /**预售订单是否显示尾款时间*/
      orderShowPrepareTime:isShowPrepareTime,
      /**预售订单的时间显示文本**/
      orderPrepareTimeInfo:operation.getPrepareTimeInfoString(prepareBeginTime,prepareEndTime),
    };
    orderInfoArr.push(model)
  }
  return orderInfoArr;
}
/**订单的价格显示文本**/
function getOrderPriceInfoString(object,orderStatus,isContainerPointGood,isInitPointOrder){
  var priceInfoStirng = "";
  let totalMoney = (object.cur_amount == "" || object.cur_amount == null) ? object.total_amount : object.cur_amount;
  if(object.promotion_type == "prepare"){
    if(orderStatus == 0){
      //待支付预售订单
      priceInfoStirng = "共" + object.itemnum + "件 " + "合计:" + totalMoney;
    }
    else if(orderStatus == 3){
      //部分支付的预售订单
      priceInfoStirng = "共" + object.itemnum + "件 " + "已付订金" + object.prepare.preparesell_price + " 待付尾款" + object.prepare.final_price;
    }
    else{
      //全支付的预售订单
      priceInfoStirng = "共" + object.itemnum + "件 " + "已付:" + totalMoney + " " + "无需补尾款";
    }
  }
  else{
    if(isContainerPointGood){
      if(isInitPointOrder){
        let scoreCost = (object.score_u == null || object.score_u.length == 0) ? "0" : object.score_u;
        priceInfoStirng = "共" + object.itemnum + "件 " + "兑换消费积分:" + scoreCost;
      }
      else{
      priceInfoStirng = "共" + object.itemnum + "件 " + "合计:" + totalMoney;
      }
    }
    else{
      priceInfoStirng = "共" + object.itemnum + "件 " + "合计:" + totalMoney;
    }
  }
  return priceInfoStirng;
}
module.exports = {
    getOrderInfoArr:getOrderInfoArr,
}
