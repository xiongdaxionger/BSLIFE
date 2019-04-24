/**
 //普通商品--可勾选，可更改数量，可删除，可收藏
 ShopCarGoodTypeNormalGood = 0,
    
 //赠品(商品自带赠品、订单赠品)--不可勾选，不可更改数量，不可删除，不可收藏
 ShopCarGoodTypeGiftGood = 1,
    
 //配件商品--不可勾选，可更改数量，可删除，可收藏
 ShopCarGoodTypeAdjunctGood = 2,
    
 //积分兑换商品--可勾选，可更改数量，可删除，可收藏
 ShopCarGoodTypeExchangeGood = 3,
 **/
/**解析购物车数据**/
function getShopCartInfo(data){
    let cartObject = data.aCart;
    let objectData = cartObject.object;
    let normalGood = objectData.goods;
    var shopCarGroupGoodArr = [];
    if(normalGood != null && normalGood.length > 0){
        var normalGoodInfoArr = [];
        var normalGiftAdjunctGoodInfoArr = [];
        for(var k = 0;k < normalGood.length;k++){
            let normalGoodDict = normalGood[k];
            let giftAdjunctGoodInfoArr = getNormalGiftAdjunctInfo(normalGoodDict);
            normalGoodInfoArr.push(getNormalGoodInfo(normalGoodDict));
            normalGiftAdjunctGoodInfoArr.push(giftAdjunctGoodInfoArr);
        }
        for(var l = 0;l < normalGoodInfoArr.length;l++){
            let normalGoodInfo = normalGoodInfoArr[l];
            let newArr = [];
            newArr.push(normalGoodInfo);
            Array.prototype.push.apply(newArr, normalGiftAdjunctGoodInfoArr[l]);
            let groupGoodModel = {
                //商品组别类型
                groupType:0,
                //组商品包含的商品数组
                groupGoodInfosArr:newArr,
                //组名称
                groupName:'普通商品'
            };
            shopCarGroupGoodArr.push(groupGoodModel)
        }
    }
    let giftDict = objectData.gift;
    let exchangeGoodsArr = giftDict.cart;
    if(exchangeGoodsArr != null && exchangeGoodsArr.lenght > 0){
        let exchangeGroupGoodModel = {
            //商品组别类型
            groupType:2,
            //组商品包含的商品数组
            groupGoodInfosArr:getExchangeGoodInfo(exchangeGoodsArr),
            //组名称
            groupName:'积分兑换商品'
        }
        shopCarGroupGoodArr.push(exchangeGroupGoodModel)
    }
    let orderGiftGoodsArr = giftDict.order;
    if(orderGiftGoodsArr != null && orderGiftGoodsArr.length > 0){
        let giftGroupGoodModel = {
            //商品组别类型
            groupType:1,
            //组商品包含的商品数组
            groupGoodInfosArr:getGiftGoodInfo(orderGiftGoodsArr),
            //组名称
            groupName:'订单赠送赠品'
        }
        shopCarGroupGoodArr.push(giftGroupGoodModel)
    }
    let promotion = cartObject.promotion
    let model = {
        /**是否显示未享受优惠**/
        showUnusePromotion:data.cart_promotion_display == "true",
        /**未显示优惠数组**/
        unusePromotionArr:getRuleInfoArr(data.unuse_rule,false),
        /**已享受优惠数组**/
        usePromotionArr:getRuleInfoArr(promotion == null ? null : promotion.order,true),
        /**总节省金额**/
        totalDiscountMoney:cartObject.discount_amount_order,
        /**获取的总积分**/
        totalGainScore:cartObject.subtotal_gain_score,
        /**购物车总价**/
        totalPrice:cartObject.promotion_subtotal,
        /**购物车商品组别数组**/
        groupGoodInfoArr:shopCarGroupGoodArr,
    };
    return model;
}
/**解析优惠数据/未享受优惠数据**/
function getRuleInfoArr(dataArr,needAction){
    var ruleInfoArr = [];
    if(dataArr == null){
        return ruleInfoArr;
    }
    for(var i = 0;i < dataArr.length;i++){
        let ruleObject = dataArr[i];
        let model = {
            /**标签**/
            ruleTag:ruleObject.desc_tag,
            /**内容**/
            ruleContent:ruleObject.name,
            /**能否凑单**/
            canAction:needAction ? false : ruleObject.fororder_status == "true"
        };
        ruleInfoArr.push(model);
    }
    return ruleInfoArr;
}
/**解析普通商品数据*/
function getNormalGoodInfo(normalDict){
    let specialType = normalDict.special_type;
    let goodPromotionRule = [];
    if(specialType != null && specialType.length > 0){
        goodPromotionRule.push({
            ruleContent:normalDict.special_name,
            ruleTag:specialType
        })
    }
    else{
        Array.prototype.push.apply(goodPromotionRule, getRuleInfoArr(normalDict.promotion,true));
    }
    let model = {
        //商品的目标ID
        objIdent:normalDict.obj_ident,
        //商品的货品ID
        productID:normalDict.product_id,
        //商品的商品ID
        goodID:normalDict.goods_id,
        //商品名称
        goodName:normalDict.name,
        //名称标签
        goodTag:"普通",
        //商品库存
        goodStore:normalDict.store,
        //最大购买量
        maxBuyCount:normalDict.max,
        //规格
        specInfo:normalDict.spec_info,
        //购买价
        goodPrice:normalDict.price,
        //市场价
        goodMarketPrice:normalDict.mktprice,
        //图片
        thumbnail:normalDict.thumbnail,
        //数量
        quantity:normalDict.quantity,
        //最终购买价
        finalPrice:normalDict.subtotal_prefilter_after,
        //折扣
        discountPrice:normalDict.discount_amount,
        //商品享受的优惠
        goodPromotion:goodPromotionRule,
        //商品类型
        goodType:0,
        //商品是否选择
        goodIsSelect:parseInt(normalDict.store) == 0 ? false : normalDict.selected == "true",
        //商品的编辑装填是否选择
        goodEditIsSelect:false
    };
    return model;
}
/**解析普通商品的配件和赠品*/
function getNormalGiftAdjunctInfo(normalDict){
    let giftAdjunctGoodArr = [];
    if(normalDict.gift != null && normalDict.gift.length > 0){
        Array.prototype.push.apply(giftAdjunctGoodArr, getGiftGoodInfo(normalDict.gift));
    }
    if(normalDict.adjunct != null && normalDict.adjunct.length > 0){
        Array.prototype.push.apply(giftAdjunctGoodArr, getAdjunctGoodInfo(normalDict.adjunct));
    }
    return giftAdjunctGoodArr;
}
/**解析赠品数据**/
function getGiftGoodInfo(giftArr){
    let giftInfoArr = [];
    if(giftArr == null){
        return giftInfoArr;
    }
    for(var i = 0;i < giftArr.length;i++){
        let giftDict = giftArr[i];
        let model = {
            //价格
            goodPrice:giftDict.price,
            //货品ID
            productID:giftDict.product_id,
            //商品名称
            goodName:giftDict.name,
            //名称标签
            goodTag:"赠品",
            //规格
            specInfo:giftDict.spec_info,
            //图片
            thumbnail:giftDict.thumbnail,
            //数量
            quantity:giftDict.quantity,
            //商品ID
            goodID:giftDict.goods_id,
            //标签
            tag:giftDict.desc_tag,
            //商品类型
            goodType:1
        };
        giftInfoArr.push(model);
    }
    return giftInfoArr;
}
/**解析配件数据**/
function getAdjunctGoodInfo(adjunctArr){
    let adjunctInfoArr = [];
    if(adjunctArr == null){
        return adjunctInfoArr;
    }
    for(var i = 0;i < adjunctArr.length;i++){
        let adjunctDict = adjunctArr[i];
        let model = {
            //货品ID
            productID:adjunctDict.product_id,
            //商品名称
            goodName:adjunctDict.name,
            //名称标签
            goodTag:"配件",
            //商品ID
            goodID:adjunctDict.goods_id,
            //数量
            quantity:adjunctDict.quantity,
            //规格
            specInfo:adjunctDict.spec_info,
            //市场价
            goodMarketPrice:adjunctDict.mktprice,
            //销售价
            goodPrice:adjunctDict.price,
            //最大购买量
            maxBuyCount:adjunctDict.max,
            //图片
            thumbnail:adjunctDict.thumbnail,
            //类型
            goodType:2,
            //配件所在组的ID
            groupID:adjunctDict.group_id,
            //最终价格
            finalPrice:adjunctDict.subtotal_price
        };
        adjunctInfoArr.push(model);
    }
    return adjunctInfoArr;
}
/**解析积分兑换商品数据**/
function getExchangeGoodInfo(exchangeGoodArr){
    let exchangeInfoArr = [];
    if(exchangeGoodArr == null){
        return exchangeInfoArr;
    }
    for(var i = 0;i < exchangeGoodArr.length;i++){
        let exchangeDict = exchangeGoodArr[i];
        let model = {
            //配件的目标ID
            objIdent:exchangeDict.obj_ident,
            //数量
            quantity:exchangeDict.quantity,
            //销售价
            goodPrice:exchangeDict.price,
            //商品ID
            goodID:exchangeDict.goods_id,
            //货品ID
            productID:exchangeDict.product_id,
            //类型
            goodType:3,
            //商品名称
            goodName:exchangeDict.name,
            //名称标签
            goodTag:"兑换",
            //消耗的积分
            consumeScore:exchangeDict.consume_score,
            //规格
            specInfo:exchangeDict.spec_info,
            //图片
            thumbnail:exchangeDict.thumbnail,
            //是否选中
            goodIsSelect:exchangeDict.selected == "true",
            //编辑选中
            goodEditIsSelect:false,
            //最大购买量
            maxBuyCount:exchangeDict.max
        }
        exchangeInfoArr.push(exchangeDict)
    }
    return exchangeInfoArr;
}
//返回编辑状态下购物车是否全选
function editStatusIsSelectAll(shopCarInfo){
    var isSelectAll = true;
    for(var i = 0;i < shopCarInfo.groupGoodInfoArr.length;i++){
        let groupInfo = shopCarInfo.groupGoodInfoArr[i];
        if(groupInfo.groupType == 0){
            let normalGoodInfo = groupInfo.groupGoodInfosArr[0];
            if(normalGoodInfo.goodStore != "0" && !normalGoodInfo.goodEditIsSelect){
                isSelectAll = false;
            }
        }
        else{

        }
    }
    return isSelectAll;
}
//返回网络状态下购物车是否全选
function netWorkStatusIsSelectAll(shopCarInfo){
    var isSelectAll = true;
    for(var i = 0;i < shopCarInfo.groupGoodInfoArr.length;i++){
        let groupInfo = shopCarInfo.groupGoodInfoArr[i];
        if(groupInfo.groupType == 0){
            let normalGoodInfo = groupInfo.groupGoodInfosArr[0];
            if(normalGoodInfo.goodStore != "0" && !normalGoodInfo.goodIsSelect){
                isSelectAll = false;
            }
        }
        else{

        }
    }
    return isSelectAll;
}
//返回选中的商品数量
function getSelectShopCarGoodQuantity(shopCarInfo){
        var quantity = 0;
        for(var i = 0;i < shopCarInfo.groupGoodInfoArr.length;i++){
        let groupInfo = shopCarInfo.groupGoodInfoArr[i];
        if(groupInfo.groupType == 0){
            let normalGoodInfo = groupInfo.groupGoodInfosArr[0];
            if(normalGoodInfo.goodIsSelect){
                for(var j = 0;j < groupInfo.groupGoodInfosArr.length;j++){
                    let goodInfo = groupInfo.groupGoodInfosArr[j]
                    if(goodInfo.goodType != 1){
                        quantity = quantity + parseInt(goodInfo.quantity);
                    }
                }
            }
        }
        else{

        }
        }

        return quantity
}
//返回购物车当前选中的商品
function getCurrentSelectGoodObjIdent(shopCarInfo,isEditStatus){
    var objIdentArr = [];
    for(var i = 0;i < shopCarInfo.groupGoodInfoArr.length;i++){
        let groupInfo = shopCarInfo.groupGoodInfoArr[i];
        if(groupInfo.groupType == 0){
            let normalGoodInfo = groupInfo.groupGoodInfosArr[0];
            if(isEditStatus){
                if(normalGoodInfo.goodEditIsSelect){
                    objIdentArr.push(normalGoodInfo.objIdent)
                }
            }
            else{
                if(normalGoodInfo.goodIsSelect){
                    objIdentArr.push(normalGoodInfo.objIdent)
                }
            }
        }
    }
    
    return objIdentArr;
}
//批量删除商品的参数
function batchDeleteGoodInfo(shopCarInfo){
    let param = {};
    param["method"] = "b2c.cart.remove";
    for(var i = 0;i < shopCarInfo.groupGoodInfoArr.length;i++){
        let groupInfo = shopCarInfo.groupGoodInfoArr[i];
        if(groupInfo.groupType == 0){
            let normalGoodInfo = groupInfo.groupGoodInfosArr[0];
            if(normalGoodInfo.goodEditIsSelect){
                let goodProductID = "goods_" + normalGoodInfo.goodID + "_" + normalGoodInfo.productID;
                let key = "modify_quantity" + "[" + goodProductID + "]" + "[quantity]";
                param[key] = normalGoodInfo.quantity;
            }
        }
    }
    return param;
}
//解析确认订单页面的数据
function getConfirmOrderInfo(data){
    let aCartObject = data.aCart;
    let object = aCartObject.object;
    let couponObjectArr = object.coupon;
    let selectCouponInfo = null;
    if(couponObjectArr != null && couponObjectArr.length > 0){
        let firstCoupon = couponObjectArr[0];
        selectCouponInfo = {
            //优惠码
            couponCode:firstCoupon.coupon,
            //数量
            quantity:firstCoupon.quantity,
            //是否正在使用
            isUsing:true,
            //优惠券名称
            name:firstCoupon.name
        }
    }
    else{
        selectCouponInfo = null;
    }
    //商品信息数组
    let groupGoodInfosArr = getShopCartInfo(data).groupGoodInfoArr;
    //默认地址
    let defaultAddr = data.def_addr;
    let defaultAddrrModel = null;
    if(defaultAddr != null){
        let area = defaultAddr.area;
        let areaArr = area.split(":")
        defaultAddrrModel = {
            //地址组合
            addressDetail:defaultAddr.txt_area + defaultAddr.addr,
            //地址ID
            addressID:defaultAddr.addr_id,
            //手机号码
            mobile:defaultAddr.mobile == null ? defaultAddr.tel : defaultAddr.mobile,
            //收货人名称
            name:defaultAddr.name,
            //json字符串
            value:defaultAddr.value,
            //地区
            area:area,
            //地区ID
            areaID:areaArr[2]
        }
    }
    //配送时间
    let shippingTime = data.shipping_time;
    console.log("data")
    console.log(data,shippingTime)
    //支付方式
    let paymentsArr = data.payments;
    let paymentModel = null;
    if(paymentsArr != null){
        let firstPayObject = paymentsArr[0];
        paymentModel = {
            //支付方式说明
            payDesc:firstPayObject.app_pay_brief,
            //支付方式ID
            payID:firstPayObject.app_id,
            //json字符串
            payValue:firstPayObject.value,
            //支付方式名称
            payName:(firstPayObject.app_name == null || firstPayObject.app_name.length > 0) ? firstPayObject.app_display_name : firstPayObject.app_name 
        }
    }
    //默认配送方式
    let shippingMethodInfoArr = getShippingMethodInfoArr(data.shippings)
    let defaultShippingMethod = data.shipping_method;
    let defaultShippingInfo = null;
    if(defaultShippingMethod != null && typeof defaultShippingMethod == "object" && shippingMehtodInfoArr.length > 0){
        let defaultMethodID = defaultShippingMethod.shipping_id;
        for(var i = 0;i < shippingMethodInfoArr.length;i++){
            let methodInfo = shippingMethodInfoArr[i];
            if(methodInfo.methodID == defaultMethodID){
                defaultShippingInfo = methodInfo;
                break;
            }
        }
    }
    //发票信息
    let tax_setting = data.tax_setting;
    let taxInfo = null;
    let firstTaxInfo = null;
    if(tax_setting != null){
        firstTaxInfo = tax_setting.tax_type[0]
        taxInfo = {
            //发票内容
            taxContent:tax_setting.tax_content,
            //发票类型
            taxType:tax_setting.tax_type
        }
    }
    let isOpenInvioce = true;
    if(firstTaxInfo != null){
        let tax_value = firstTaxInfo.tax_value;
        if(tax_value == "false"){
            isOpenInvioce = false;
        }
    }
    else{
        isOpenInvioce = false;
    }
    //订单价格信息
    let orderDetail = data.order_detail;
    let promotion_type = data.promotion_type;
    let showPoint = false;
    let pointObject = data.point_dis;
    if(pointObject != null && pointObject.max_discount_value_point != 0){
        showPoint = true;
    }
    let model = {
        //优惠券信息--可能为null
        selectCoupon : selectCouponInfo,
        //商品信息
        groupGoodInfosArr:groupGoodInfosArr,
        //md5码
        md5Code:data.md5_cart_info,
        //默认地址--可能为null
        defaultAddress:defaultAddrrModel,
        //是否开启了配送时间
        isShippingTime:shippingTime != null,
        //默认的支付方式--可能为null
        defaultPay:paymentModel,
        //所有的配送方式
        shippingMethodInfoArr:shippingMethodInfoArr,
        //默认的配送方式--可能为null
        defaultShippingInfo:defaultShippingInfo,
        //货币类型--可能为null，为null时需要通过获取配送送方式重新获取
        currency:data.current_currency == null ? null : data.current_currency,
        //是否开发票
        isOpenInvioce:isOpenInvioce,
        //已开发票信息
        invioceDict:{
            //发票类型
            invioceType:firstTaxInfo == null ? "" : firstTaxInfo.tax_value,
            //发票抬头
            invioceHeader:"",
            //发票内容
            invioceContent:""
        },
        //发票信息
        taxInfo:taxInfo,
        //订单的积分配置，当后台开启积分只用于兑换时，字段为null
        pointSetting:data.point_dis == null ? null : data.point_dis,
        //是否显示积分兑换
        showPoint:showPoint,
        //订单商品总金额
        totalMoney:orderDetail.cost_item,
        //选中的商品字符传数组
        selectObjIdentArr:data.obj_ident == null ? null : data.obj_ident,
        //是否为预售订单
        isPrepareOrder:promotion_type == null ? false : true,
        //订单总金额
        orderTotal:promotion_type == null ? orderDetail.total_amount : data.prepare.preparesell_price,
        //价格标题文本
        priceTitle:getConfirmOrderPriceInfo(orderDetail).title,
        //价格文本
        priceInfo:getConfirmOrderPriceInfo(orderDetail).price,
    }
    return model;
}
//价格信息
function getConfirmOrderPriceInfo(object){
  var priceInfo = "";
  var priceTitleInfo = "";
  if(object.price_total != null && object.price_total != "0"){
      priceInfo = priceInfo + object.price_total + "\n"
      priceTitleInfo = priceTitleInfo + "商品金额" + "\n"
  }
  if(object.discount_amount_prefilter != null && object.discount_amount_prefilter != "0"){
      priceInfo = priceInfo + object.discount_amount_prefilter + "\n"
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
  if(object.cost_freight != null && object.cost_freight != "0"){
      priceInfo = priceInfo + object.cost_freight + "\n"
      priceTitleInfo = priceTitleInfo + "运费" + "\n"
  }
  if(object.cost_protect != null && object.cost_protect != "0"){
      priceInfo = priceInfo + object.cost_protect + "\n"
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
  if(object.total_amount != null && object.total_amount != "0"){
      priceInfo = priceInfo + object.total_amount + "\n"
      priceTitleInfo = priceTitleInfo + "订单总金额" + "\n"
  }
  if(object.totalConsumeScore != null && object.totalConsumeScore != "0"){
      priceInfo = priceInfo + object.totalConsumeScore + "\n"
      priceTitleInfo = priceTitleInfo + "订单消费积分" + "\n"
  }
  if(object.totalGainScore !=null && object.totalGainScore != "0"){
      priceInfo = priceInfo + object.totalGainScore + "\n"
      priceTitleInfo = priceTitleInfo + "订单获得积分" + "\n"
  }
  if(object.prepare_total_amount != null && object.prepare_total_amount != "0"){
      priceInfo = priceInfo + object.prepare_total_amount + "\n"
      priceTitleInfo = priceTitleInfo + "预售商品订金" + "\n"
  }
  return {title:priceTitleInfo,price:priceInfo};
}
//解析配送方式数据
function getShippingMethodInfoArr(shippingMethodArr){
    let shippingMethodInfoArr = [];
    if(shippingMethodArr != null && shippingMethodArr.length > 0){
        for(var i = 0;i < shippingMethodArr.length;i++){
            let shippingMethodObject = shippingMethodArr[i]
            //是否开启物流报价
            let isProtect = shippingMethodObject.protect == "true";
            let model = {
                //物流报价的信息
                message:shippingMethodObject.text,
                //配送方式ID
                methodID:shippingMethodObject.dt_id,
                //json字符串
                value:shippingMethodObject.value,
                //配送方式名称
                methodName:shippingMethodObject.dt_name,
                //配送方式运费
                methodPrice:shippingMethodObject.money,
                //是否开启物流保价
                isProtect:isProtect ? isProtect : false,
                //物流保价是否选中
                isProtectSelect:isProtect ? shippingMethodObject.protect_checked == "true" : false,
            }
            shippingMethodInfoArr.push(model)
        }
    }
    return shippingMethodInfoArr;
}
module.exports = {
    getShopCartInfo: getShopCartInfo,
    netWorkStatusIsSelectAll:netWorkStatusIsSelectAll,
    editStatusIsSelectAll:editStatusIsSelectAll,
    getSelectShopCarGoodQuantity:getSelectShopCarGoodQuantity,
    getCurrentSelectGoodObjIdent:getCurrentSelectGoodObjIdent,
    batchDeleteGoodInfo:batchDeleteGoodInfo,
    getConfirmOrderInfo:getConfirmOrderInfo,
    getConfirmOrderPriceInfo:getConfirmOrderPriceInfo,
    getShippingMethodInfoArr:getShippingMethodInfoArr
}