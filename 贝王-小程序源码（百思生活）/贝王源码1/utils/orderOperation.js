function formatTime(date) {
  var year = date.getFullYear()
  var month = date.getMonth() + 1
  var day = date.getDate()

  var hour = date.getHours()
  var minute = date.getMinutes()
  var second = date.getSeconds()


  return [year, month, day].map(formatNumber).join('/') + ' ' + [hour, minute, second].map(formatNumber).join(':')
}

function formatNumber(n) {
  n = n.toString()
  return n[1] ? n : '0' + n
}
/**解析订单状态**/
/**订单的状态--active/finish/dead**/
/**订单最新状态信息,ship_0/pay_0**/
function getOrderStatus(status,lastStatusObject){
      var orderStatus = 0;
      var code = lastStatusObject.code;
      if(status == "finish"){
        //已完成
        orderStatus = 12;
      }
      else if(status == "dead"){
        //已作废
        orderStatus = 13;
      }
      else{
        if(code.indexOf("pay") >= 0){
          var payCode = code.replace("pay_","");
          let payCodeInt = parseInt(payCode);
          switch(payCodeInt){
            case 0:{
              /**未付款**/
              orderStatus = 0;
              break;
            }
            case 1:{
              /**已支付**/
              orderStatus = 1;
              break;
            }
            case 2:{
              /**付款到担保方**/
              orderStatus = 2;
              break;
            }
            case 3:{
              /**部分付款**/
              orderStatus = 3;
              break;
            }
            case 4:{
              /**部分退款**/
              orderStatus = 4;
              break;
            }
            case 5:{
              /**全部退款**/
              orderStatus = 5;
              break;
            }
          }
        }
        else if(code.indexOf("ship") >= 0){
          var shipCode = code.replace("ship_","");
          let shipCodeInt = parseInt(shipCode);
          switch(shipCodeInt){
            case 0:{
              /**待发货**/
              orderStatus = 6;
              break;
            }
          case 1:{
            /**待收货**/
            orderStatus = 7;
            break;
            }
          case 2:{
            /**部分发货**/
            orderStatus = 8;
            break
            }
          case 3:{
            /**部分退货**/
            orderStatus = 9;
            break;
            }
          case 4:{
            /**全部退货**/
            orderStatus = 10;
            break;
            }
          case 5:{
            /**已收货**/
            orderStatus = 11;
            break;
            }
          }
        }
        else{
          var name = lastStatusObject.name;
          if(name.indexOf("退款") > 0){
            //部分退款
            orderStatus = 4;
          }
          else{
            //部分退货
            orderStatus = 9;
          }
        }
      }
      return orderStatus;
}
/**请求的订单状态**/
/**选中的下标**/
function requestOrderStatus(selectIndex){
      var status;
      switch(selectIndex){
        case 0:{
          status = "all";
          break;
        }
        case 1:{
          status = "nopayed";
          break;
        }
        case 2:{
          status = "noship";
          break;
        }
        case 3:{
          status = "noreceived";
          break;
        }
        case 4:{
          status = "nodiscuss";
          break;
        }
        case 5:{
          status = "prepare";
          break;
        }
      }
      return status;
}
    /**解析商品数据**/
    function getOrderGoodInfoArr(pointGoodArr,orderGiftArr,normalGoodArr,isPrepareOrder){
      var allGoodInfoArr = [];
      var that = this;
      for(var i = 0;i < normalGoodArr.length;i++){
        let normalObject = normalGoodArr[i];
        allGoodInfoArr.push(getOrderGoodInfo(normalObject,isPrepareOrder ? -1 : 0));
        let giftArr = normalObject.gift_items;
        if(giftArr != null && giftArr.length > 0){
          for(var j = 0;j < giftArr.length;j++){
            var giftObject = giftArr[j];
            allGoodInfoArr.push(getOrderGoodInfo(giftObject,1));
          }
        }
        let adjunctArr = normalObject.adjunct_items;
        if(adjunctArr != null && adjunctArr.length > 0){
          for(var k = 0;k < adjunctArr.length;k++){
            var adjunctObject = adjunctArr[k];
            allGoodInfoArr.push(getOrderGoodInfo(adjunctObject,2));
          }
        }
      }
      if(pointGoodArr != null && pointGoodArr.length > 0){
        for(var i = 0;i < pointGoodArr.length;i++){
          let pointObject = pointGoodArr[i];
          allGoodInfoArr.push(getOrderGoodInfo(pointObject,1));
        }
      }
      if(orderGiftArr != null && orderGiftArr.length > 0){
        for(var i = 0;i < orderGiftArr.length;i++){
          let giftObject = orderGiftArr[i];
          allGoodInfoArr.push(getOrderGoodInfo(giftObject,1));
        }
      }
      return allGoodInfoArr;
    }
    /**获取单个商品数据,goodType--0(普通商品)1(订单赠品)(2配件)**/
    function getOrderGoodInfo(object,goodType){
      let isComment = parseInt(object.is_comment);
      var goodTypeString = "";
      switch(goodType){
        case -1:{
          goodTypeString = "预售";
          break;
        }
        case 0:{
          goodTypeString = "普通";
          break;
        }
        case 1:{
          goodTypeString = "赠品"
          break;
        }
        case 2:{
          goodTypeString = "配件"
          break;
        }
      }
      var model = {
        /**商品类型**/
        orderGoodType:goodType,
        /**商品类型显示**/
        orderGoodTypeString:goodTypeString,
        /**能否评论**/
        orderGoodCanComment:isComment != 1,
        /**商品ID**/
        orderGoodID:object.goods_id,
        /**货品ID**/
        orderProductID:object.product_id,
        /**商品名称**/
        orderGoodName:object.name,
        /**图片**/
        orderGoodImage:object.thumbnail_pic,
        /**数量**/
        orderGoodQuantity:object.quantity,
        /**价格**/
        orderGoodPrice:object.price,
        /**规格**/
        orderGoodSpecInfo:object.attr 
      }
      return model;
    }
/**预售时间跟操作栏显示**/
function showPrepareTimeAction(promotionType,realStatus,prepareBeginTime,isInitPointOrder){
  var isShowActionButton = ""
  var isShowPrepareTime = ""
  if(promotionType == "prepare"){
    if(realStatus == 0){
      isShowActionButton = "true";
      isShowPrepareTime = "false";
    }
    else if(realStatus == 3){
      isShowActionButton = "true";
      let time = new Date().getTime() / 1000;
      let timeStamp = parseInt(time);
      isShowPrepareTime = prepareBeginTime >= timeStamp ? "false" : "true"
    }
    else{
      isShowActionButton = "false";
      isShowPrepareTime = "false";
    }
  }
    else{
      if(realStatus == 0 || realStatus == 3 || realStatus == 7 || realStatus == 8 || realStatus == 12 || realStatus == 13 || realStatus == 14){
        isShowActionButton = "true";
      }
      else if(realStatus == 6){
        isShowActionButton = isInitPointOrder ? "false" : "true";
      }
      else{
        isShowActionButton = "false";
    }
  }
  return {showTime:isShowPrepareTime,showAction:isShowActionButton}
}
/**订单详情价格信息**/
function getOrderDetailPriceInfo(object){
  var that = this
  var priceInfo = "";
  var priceTitleInfo = "";
  if(object.cost_item != null && object.cost_item != "0"){
      priceInfo = priceInfo + object.cost_item + "\n"
      priceTitleInfo = priceTitleInfo + "商品金额" + "\n"
  }
  if(object.pmt_goods != null && object.pmt_goods != "0"){
      priceInfo = priceInfo + object.pmt_goods + "\n"
      priceTitleInfo = priceTitleInfo + "商品优惠" + "\n"
  }
  if(object.pmt_order != null && object.pmt_order != "0"){
      priceInfo = priceInfo + object.pmt_order + "\n"
      priceTitleInfo = priceTitleInfo + "订单优惠" + "\n"
  }
  if(object.point_dis_price != null && object.point_dis_price != "0"){
      priceInfo = priceInfo + object.point_dis_price + "\n"
      priceTitleInfo = priceTitleInfo + "积分抵扣金额" + "\n"
  }
  let shippingDict = object.shipping;
  if(shippingDict.cost_shipping != null && shippingDict.cost_shipping != "0"){
      priceInfo = priceInfo + shippingDict.cost_shipping + "\n"
      priceTitleInfo = priceTitleInfo + "运费" + "\n"
  }
  if(shippingDict.cost_protect != null && shippingDict.cost_protect != "0"){
      priceInfo = priceInfo + shippingDict.cost_protect + "\n"
      priceTitleInfo = priceTitleInfo + "物流保价费" + "\n"
  }
  if(object.cost_payment != null && object.cost_payment != "0"){
      priceInfo = priceInfo + object.cost_payment + "\n"
      priceTitleInfo = priceTitleInfo + "手续费" + "\n"
  }
  if(object.cost_tax != null && object.cost_tax != "0"){
      priceInfo = priceInfo + object.cost_tax + "\n"
      priceTitleInfo = priceTitleInfo + "发票税金" + "\n"
  }
  if(object.total_amount_format != null && object.total_amount_format != "0"){
      priceInfo = priceInfo + object.total_amount_format + "\n"
      priceTitleInfo = priceTitleInfo + "订单总金额" + "\n"
  }
  if(object.score_u != null && object.score_u != "0"){
      priceInfo = priceInfo + object.score_u + "\n"
      priceTitleInfo = priceTitleInfo + "订单消费积分" + "\n"
  }
  if(object.score_g !=null && object.score_g != "0"){
      priceInfo = priceInfo + object.score_g + "\n"
      priceTitleInfo = priceTitleInfo + "订单获得积分" + "\n"
  }
  if(object.prepare_total_amount != null && object.prepare_total_amount != "0"){
      priceInfo = priceInfo + object.prepare_total_amount + "\n"
      priceTitleInfo = priceTitleInfo + "预售商品订金" + "\n"
  }
  if(object.payed != null && object.payed != "0"){
      priceInfo = priceInfo + object.payed
      priceTitleInfo = priceTitleInfo + "已支付金额"
  }
  return {title:priceTitleInfo,price:priceInfo};
}
    /**解析订单享受的优惠内容**/
    function getOrderPromotionInfo(promotion){
        var infoString = [];
        if(promotion == null || promotion.length == 0){
            return infoString;
        }
        else{
            for(var i = 0;i < promotion.length;i++){
                let promotionObject = promotion[i];
                let tagString = "[" + promotionObject.pmt_tag + "] ";
                let newModel = {
                  tag:tagString,
                  content:promotionObject.pmt_memo
                }
                infoString.push(newModel)
            }
            return infoString;
        }
    }
        /**预售订单的时间显示文本**/
    function getPrepareTimeInfoString(beginTime,finalTime){
      var timeString ="";
      let currentTime = new Date().getTime();
      if(beginTime * 1000 >= currentTime){
        let beginTimeString = formatTime(new Date(beginTime * 1000));
        timeString = "尾款补款期限于" + beginTimeString + "开启";
      }
      else{
        let finalTimeString = formatTime(new Date(finalTime * 1000));
        if(finalTime * 1000 > currentTime){
          timeString = "请在" + finalTimeString + "前补完尾款";
        }
        else{
          timeString = "尾款补款期限于" + finalTimeString + "结束";
        }
      }
      return timeString;
    }
module.exports = {
    getOrderStatus: getOrderStatus,
    requestOrderStatus:requestOrderStatus,
    showPrepareTimeAction:showPrepareTimeAction,
    getOrderGoodInfoArr:getOrderGoodInfoArr,
    getOrderDetailPriceInfo:getOrderDetailPriceInfo,
    getOrderPromotionInfo:getOrderPromotionInfo,
    getPrepareTimeInfoString:getPrepareTimeInfoString
}