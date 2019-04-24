var app = getApp()
var util = require('../../utils/util.js');
var wxbarcode = require('../../utils/index.js');
var operation
Page({
    data: {
        /**是否显示加载失败的视图**/
        showFailNetWork:false,
        /**订单详情数据**/
        orderDetail:{},
        /**订单ID**/
        orderID:"",
        imgURL: app.getImgURL(), //图片前面域名
    },
    //页面卸载
    onUnload:function(){
      operation = null
    },
    /**页面加载完成**/
    onLoad:function(options){
        operation = require('../../utils/orderOperation.js')
        this.data.orderID = options.id;
        this.loadOrderDetailInfo(true);
        // 条形码
        wxbarcode.barcode('barcode', options.id, 680, 200);
        // 二维码
        wxbarcode.qrcode('qrcode', options.id, 420, 420);
    },
    /**获取订单详情数据**/
    loadOrderDetailInfo:function(showLoading){
        var that = this;
        app.request({
            method:'b2c.member.orderdetail',
            order_id:that.data.orderID,
        },function(data){
            that.setData({
              orderDetail:that.getOrderDetailInfo(data),
              showFailNetWork:false
            })
        },function(data){
            that.setData({
              showFailNetWork:true
            })
        },showLoading,true,true)
    },
    /**解析订单详情数据**/
    getOrderDetailInfo:function(data){
        let object = data.order;
        let payTime = object.pay_time;
        /**预售订单数据**/
        let prepareObject = object.prepare;
        var prepareBeginTime;
        var prepareEndTime;
        if(prepareObject != null){
          prepareBeginTime = parseInt(prepareObject.begin_time_final);
          prepareEndTime = parseInt(prepareObject.end_time_final);
        } 
        else{
          prepareBeginTime = "0";
          prepareEndTime = "0";
        }
        var statusTxt = object.status_txt;
        let lastStatusObject = statusTxt[statusTxt.length - 1];
        let statusString = object.status;
        var realStatus = operation.getOrderStatus(statusString,lastStatusObject);
        let actionType = parseInt(object.pay_btn_code);
        if(actionType == 5){
          realStatus = 14; 
        }
        let orderGitGoodArr = object.order.gift_items;
        let orderPointGoodArr = object.gift.gift_items;
        let orderNormalGoodArr = object.goods_items;
        let mobile = object.consignee.mobile;
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
        /**物流信息**/
        let logistic = object.logistic;
        var logisticID = "";
        var logisticType = "";
        if(logistic != null && logistic.length > 0){
            let lastLogistic = logistic[logistic.length - 1];
            logisticID = lastLogistic.delivery_id;
            logisticType = lastLogistic.behavior;
        }
        let priceDict = operation.getOrderDetailPriceInfo(object);
        var model = {
            /**买家姓名**/
            buyerName:object.name == null ? "" : object.name,
            /**订单ID**/
            orderID:object.order_id,
            /**订单的状态说明文本**/
            orderStatusString:object.caption.msg,
            /**订单的下单时间**/
            orderCreateTimeString:util.formatTime(new Date(parseInt(object.createtime) * 1000)),
            /**订单的支付时间--可能为空**/
            orderPayTimeString:(payTime == null || payTime.length == 0) ? "" : util.formatTime(new Date(parseInt(payTime) * 1000)),
            /**订单总价**/
            orderTotalMoney:object.total_amount_format,
            /**支付方式ID**/
            orderPayInfoID:object.payinfo.pay_app_id,
            /**支付方式名称**/
            orderPayInfoName:object.payinfo.app_name,
            /**是否开了发票**/
            orderIsTax:object.is_tax == "true",
            /**开发票的类型--公司/个人**/
            orderTaxType:object.taxType,
            /**开发票的抬头**/
            orderTaxTitle:object.taxTitle,
            /**开发票的内容**/
            orderTaxContent:object.taxContent,
            /**订单享受的优惠**/
            orderPromotionInfoString:operation.getOrderPromotionInfo(object.order_pmt),
            /**订单的备注**/
            orderMemo:object.memo,
            /**是否为预售订单**/
            orderIsPrepare:object.promotion_type == "prepare",
            /**预售开始时间戳**/
            orderPrepareBeginTime:prepareBeginTime,
            /**预售结束时间戳**/
            orderPrepareEndTime:prepareEndTime,
            /**能否取消订单**/
            orderCanCancelOrder:object.cancel_order,
            /**能否删除订单**/
            orderCanDeleteOrder:object.delete_order,
            /**订单的状态**/
            orderStatus:realStatus,
            /**主操作按钮标题**/
            orderMainButtonTitle:object.pay_btn,
            /**主操作按钮操作动作**/
            orderMainButtonActionType:actionType,
            /**收货人**/
            orderAddressName:object.consignee.name,
            /**收货地址**/
            orderAddress:object.consignee.addr,
            /**收货人手机号码**/
            orderAddressMobile:(mobile == null || mobile.lenght == 0) ? object.consignee.telephone : mobile,
            /**配送时间**/
            orderShippingTime:object.consignee.r_time == null ? "" : object.consignee.r_time,
            /**配送方式**/
            orderShippingName:object.shipping.shipping_name,
            /**是否显示操作按钮**/
            orderShowAction:isShowActionButton,
            /**预售订单是否显示尾款时间*/
            orderShowPrepareTime:isShowPrepareTime,
            /**预售订单补款时间**/
            orderPrepareTimeInfo:operation.getPrepareTimeInfoString(prepareBeginTime,prepareEndTime),
            /**订单商品时间**/
            orderGoodInfoArr:operation.getOrderGoodInfoArr(orderPointGoodArr,orderGitGoodArr,orderNormalGoodArr,object.promotion_type == "prepare"),
            /**物流单号**/
            orderDeliveryID:logisticID,
            /**物流类型**/
            orderDeliveryType:logisticType,
            /**价格标题**/
            orderPriceTitle:priceDict.title,
            /**价格**/
            orderPriceInfo:priceDict.price
        };  
        return model;
    },
    /**数据重载**/
    reloadData:function(){
        this.loadOrderDetailInfo(true);
    },

     //评价晒单
    tapComment:function(event){
      const index = parseInt(event.currentTarget.dataset.index);
      const data = this.data;
      const goodInfo = data.orderDetail.orderGoodInfoArr[index];
      
      wx.redirectTo({
        url: '/pages/goodcomment/comment_add?orderId=' + data.orderID + '&goodId=' + goodInfo.orderGoodID + '&productId=' + goodInfo.orderProductID + 
        '&imageURL=' + goodInfo.orderGoodImage,
      })
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
                wx.navigateBack(1)
              },function(){
              },true,true,true)
            }
          }
        });
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
          title: '商品在次加入购物车成功',
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
                wx.navigateBack(1)
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
        wx.redirectTo({
            url: '../payinfolist/payinfolist?' + 'orderID=' + orderID + '&isOrderPay=' + true + '&isCombinationPay=' + false,
        })
      }
    },
    /**查看物流**/
    checkExpressAction:function(event){
      let orderID = event.target.dataset.orderId;
      //跳转查看物流页面，传orderID和是否为订单查询,isLoadInfo不需要设置为true
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
          wx.navigateBack(1)
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
