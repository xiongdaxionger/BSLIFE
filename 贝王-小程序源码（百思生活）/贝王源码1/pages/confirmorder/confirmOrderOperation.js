//获取更新订单总价的参数
function getUpdateTotalMoenyParam(info,isFastBuy,isUsePoint,isOpenMember,selectMemberInfo){
    var param = {};
    if(isOpenMember){
        if(selectMemberInfo != null){
            param["address"] = selectMemberInfo.value
        }
    }
    else{
        if(info.defaultAddress != null){
            param["address"] = info.defaultAddress.value
        }
    }
    if(info.defaultShippingInfo != null){
        param["shipping"] = info.defaultShippingInfo.value
        param["is_protect"] = info.defaultShippingInfo.isProtectSelect ? "1" : "0"
    }
    if(info.currency != null){
        param["payment[currency]"] = info.currency
    }
    if(info.defaultPay != null){
        param["payment[pay_app_id]"] = info.defaultPay.payValue
    }
    if(info.isOpenInvioce){
        param["payment[is_tax]"] = "true"
        param["payment[tax_type]"] = info.invioceDict.invioceType
        param["payment[tax_company]"] = info.invioceDict.invioceHeader
        param["payment[tax_content]"] = info.invioceDict.invioceContent
    }  
    else{
        param["payment[is_tax]"] = "false"
    }
    if(isUsePoint){
        param["point[score]"] = info.pointSetting == null ? "0" : info.pointSetting.max_discount_value_point
    }
    if(isFastBuy){
        param["isfastbuy"] = "true"
    }
    param["method"] = "b2c.cart.total"
    return param;
}
//返回确认订单的参数
function getCommitOrderParam(confirmOrderInfo,isFastBuy,memo,memberID,isOpenMember,selectMemberInfo){
    let param = {}
    param["shipping_time[time]"] = "任意时间段"
    param["shipping_time[day]"] = "任意日期"
    param["source"] = "xcxweixin"
    param["method"] = "b2c.order.create"
    if(isFastBuy){
        param["isfastbuy"] = "true"
    }
    param["member_id"] = memberID
    param["address"] = isOpenMember ? selectMemberInfo.value : confirmOrderInfo.defaultAddress.value
    param["shipping"] = confirmOrderInfo.defaultShippingInfo.value
    param["payment[pay_app_id]"] = confirmOrderInfo.defaultPay.payValue
    param["md5_cart_info"] = confirmOrderInfo.md5Code
    param["payment[currency]"] = confirmOrderInfo.currency
    if(memo.length > 0){
        param["memo"] = memo
    }
    param["is_protect"] = confirmOrderInfo.defaultShippingInfo.isProtectSelect ? "1" : "0"
    if(confirmOrderInfo.isOpenInvioce){
        param["payment[is_tax]"] = "true"
        param["payment[tax_type]"] = confirmOrderInfo.invioceDict.invioceType
        param["payment[tax_content]"] = confirmOrderInfo.invioceDict.invioceContent
        param["payment[tax_company]"] = confirmOrderInfo.invioceDict.invioceHeader
    }
    else{
        param["payment[is_tax]"] = "false"
    }
    
    return param
}
module.exports = {
    getUpdateTotalMoenyParam:getUpdateTotalMoenyParam,
    getCommitOrderParam:getCommitOrderParam
}