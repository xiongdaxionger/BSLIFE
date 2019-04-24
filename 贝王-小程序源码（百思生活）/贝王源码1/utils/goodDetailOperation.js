var util = require('/util.js');
/**加入购物车参数**/
/**购买类型--立即购买(is_fastbuy)/不传为加入购物车**/
/**商品ID**/
/**货品ID**/
/**购买数量**/
/**配件的组ID**/
/**配件的商品ID**/
/**配件的购买数量**/
/**商品类型:goods商品/gift积分商品**/
function getAddShopCarParam(buyType,goodID,productID,buyQuantity,adjunctGroupID,adjunctGoodID,adjunctBuyQuantity,goodType){
    let param = {}
    param["method"] = "b2c.cart.add"
    param["obj_type"] = goodType
    param["goods[goods_id]"] = goodID
    param["goods[product_id]"] = productID
    param["goods[num]"] = buyQuantity
    if(buyType != null){
        param["btype"] = buyType
    }
    if(adjunctGoodID != null){
        let adjunctKey = "adjunct" + "[" + adjunctGroupID + "]" + "[" + adjunctGoodID + "]"
        param[adjunctKey] = adjunctBuyQuantity
    }
    return param
}
/**返回商品详情的数据**/
function getGoodDetailInfoWithData(data){
    console.log(data);
    let basicDict = data.page_product_basic
    //是否为积分商品
    let isGift = basicDict.is_gift
    //商品的评分信息
    let pointDict = data.goods_point
    //后台的设置信息
    let settingDict = data.setting
    let setting = {
        //是否显示消费记录
        showSellLog:settingDict.selllog == "true",
        //是否显示评论
        showComment:settingDict.acomment.switch.discuss == "on",
        //是否显示咨询
        showAdvice:settingDict.acomment.switch.ask == "on",
        //是否显示好评率
        showGoodRate:pointDict == null ? false : true
    }
    //商品标签信息
    let tagsArr = data.service_tag_list
    let tagsNameArr = []
    for(var i = 0;i < tagsArr.length;i++){
        let tagDict = tagsArr[i]
        tagsNameArr.push(tagDict.name)
    }
    //规格详细参数
    let paramsArr = basicDict.params
    let paramsInfoArr = []
    if(paramsArr != null){
        for(var i = 0;i < paramsArr.length;i++){
            let paramObject = paramsArr[i]
            let paramSubArr = paramObject.group_param
            let paramSubInfoArr = []
            for(var j = 0;j < paramSubArr.length;j++){
                let subObject = paramSubArr[j]
                let subModel = {
                    //参数内容
                    content:subObject.value,
                    //参数名字
                    name:subObject.name
                }
                paramSubInfoArr.push(subModel)
            }
            let paramModel = {
                //详细参数组名
                paramGroupName:paramObject.group_name,
                //详细参数内容
                paramContentArr:paramSubInfoArr
            }
            paramsInfoArr.push(paramModel)
        }
    }
    //规格参数
    let specsArr = basicDict.spec
    let specInfosArr = []
    //选中的规格信息
    let specInfoString = ""
    for(var k = 0;k < specsArr.length;k++){
        let specObject = specsArr[k]
        let specValueArr = specObject.group_spec
        let specValueInfoArr = []
        let selectIndex = 0
        let isImageSpec = true
        for(var l = 0;l < specValueArr.length;l++){
            var valueObject = specValueArr[l]
            console.log("valueobject")
            console.log(valueObject)
            let valueModel = {
                //规格是否选中
                isSelect:valueObject.select == "true",
                //规格的货品ID
                valueProductID:valueObject.product_id,
                //规格选中的图片
                valueImage:valueObject.spec_image == null ? null : valueObject.spec_image,
                //规格的名称
                valueName:valueObject.spec_value
            }
            if(valueObject.select == "true"){
                selectIndex = l
                specInfoString = specInfoString + valueModel.valueName + "、"
            }
            if(valueModel.valueImage == null){
                isImageSpec = false
            }
            specValueInfoArr.push(valueModel)
        }
        let specModel = {
            //规格名称
            specName:specObject.group_name,
            //规格的内容
            specValueArr:specValueInfoArr,
            //选中的下标
            selectIndex:selectIndex,
            //是否为图片规格
            isImageSpec:isImageSpec
        }
        specInfosArr.push(specModel)
    }
    //商品类型
    let goodType = basicDict.promotion_type
    let goodTypeInt = 0
    if(goodType == null || goodType.length == 0){
        //普通商品
        goodTypeInt = 1
    }
    else{
        //秒杀或预售
        goodTypeInt = goodType == "starbuy" ? 3 : 2
    }
    //预售信息
    let prepare = basicDict.prepare
    let prepareModel
    if(prepare != null){
        prepareModel = {
            //预售状态
            statusMessage:prepare.message,
            //预售描述
            description:prepare.description,
            //预售规则
            rule:prepare.preparename,
            //状态
            status:parseInt(prepare.status)
        }
    }
    else{
        prepareModel = null
    }
    //秒杀信息
    let secondKillDict = basicDict.special_info
    let secondKillInfo
    if(secondKillDict != null){
        secondKillInfo = {
            //开始时间
            beginTime:parseInt(secondKillDict.begin_time),
            //结束时间
            endTime:parseInt(secondKillDict.end_time),
            //系统时间
            systemTime:data.now_time,
            //秒杀商品的标题
            timerTitle:"秒杀",
            //秒杀时
            hour:"0",
            //秒杀分
            minutes:"0",
            //秒杀秒
            second:"0",
            //秒杀是否结束
            isSecondKillEnd:false
        }
    }   
    else{
        secondKillInfo = null
    }
    let giftDict = basicDict.gift
    let giftInfo
    if(giftDict != null){
        let memberLevel = giftDict.member_lv_data
        let memberString = ""
        for(var i = 0;i < memberLevel.length;i++){
            let memberObject = memberLevel[i]
            console.log(memberObject)
            if(i == memberLevel.length - 1){
                memberString = memberString + memberObject.name   
            }
            else{
                memberString = memberString + memberObject.name + "/" 
            }
        }
        giftInfo = {
            //能否兑换
            canExchange:giftDict.permission,
            //不能兑换的理由
            reason:giftDict.permission ? "" : giftDict.permissionMsg,
            //最大兑换量
            max:giftDict.max,
            //消耗的积分
            consumeScore:giftDict.consume_score,
            //开始时间戳
            beginTime:util.formatTimesamp(giftDict.from_time,1),
            //结束时间戳
            endTime:util.formatTimesamp(giftDict.to_time,1),
            //会员信息
            memberString:memberString
        }
    }
    else{
        giftInfo = null
    }
    //最大购买量
    let buyLimit = 0
    if(isGift){
        goodTypeInt = 4
        buyLimit = parseInt(giftInfo.max)
    }
    else{
        buyLimit = goodTypeInt == 3 ? secondKillDict.limit : basicDict.store
    }
    //商品的状态栏信息
    let menuBarArr = []
    menuBarArr.push({
        //名称
        tabName:"图文详情",
        //类型--0表示web，1是规格参数，2是销售记录
        tabType:0,
    })
    // if(paramsArr.lenght != 0){
    //     menuBarArr.push({
    //         tabName:"规格参数",
    //         tabType:1
    //     })
    // }
    if(setting.showSellLog){
        menuBarArr.push({
            tabName:"销售记录",
            tabType:2
        })
    }   
    // for(var i = 0;i < data.async_request_list.length;i++){
    //     let menuObject = data.async_request_list[i]
    //     goodMenuBarInfosArr.push({
    //         tabName:menuObject.name,
    //         tabContent:menuObject.content,
    //         tabType:0
    //     })
    // }
    //商品的优惠信息
    let proDict = basicDict.promotion
    let proTagsArr = []
    let proContentsArr = []
    if(proDict != null){
        let goodProArr = proDict.goods
        if(goodProArr != null){
          for (var i = 0; i < goodProArr.length;i++){
                let goodProModel = goodProArr[i]
                proTagsArr.push(goodProModel.tag)
                proContentsArr.push({
                    tag:goodProModel.tag,
                    content:goodProModel.name,
                    tagID:goodProModel.tag_id
                })
            }
        }
        let giftProArr = proDict.gift
        if(giftProArr != null){
            proTagsArr.push("赠品")
            let goodName = ""
            for(var i = 0;i < giftProArr.length;i++){
                if(i == giftProArr.length - 1){
                    goodName = goodName + giftProArr[i].name
                }
                else{
                    goodName = goodName + giftProArr[i].name + "\n"
                }
            }
            proContentsArr.push({
                tag:"赠品",
                content:goodName,
                tagID:""
            })
        }
    }
    //配件信息
    let adjunctsArr = data.page_goods_adjunct
    let adjunctNamesArr = []
    let adjunctGoodsArr = []
    if(adjunctsArr != null){
        let adjunctImages = data.adjunct_images
        console.log("image")
        console.log(adjunctImages)
        for(var i = 0;i < adjunctsArr.length;i++){
            let adjunctObject = adjunctsArr[i]
            adjunctNamesArr.push({
                //是否选中
                isSelect:i == 0,
                //名称
                groupName: adjunctObject.name
            })
            let groupGoodsArr = []
            let items = adjunctObject.items
            for(var j = 0;j < items.length;j++){
                let item = items[j]
                let goodID = item.goods_id
                console.log(goodID)
                groupGoodsArr.push({
                    //是否勾选
                    isSelect:false,
                    goodName:item.name,
                    goodID:goodID,
                    price:item.adjprice,
                    productID:item.product_id,
                    image:adjunctImages[goodID]
                })
            }
            adjunctGoodsArr.push(groupGoodsArr)
        }
    }
    let marketable = basicDict.product_markerable ="true"
    let showPrice = ""
    let storeString = ""
    let storeTitle = basicDict.store_title == null ? "" :  basicDict.store_title
    if(goodTypeInt == 4){
        showPrice = "兑换所需积分:" + giftInfo.consumeScore
        storeString = "限兑:" + giftInfo.max
    }
    else{
        showPrice = basicDict.price_list.show.format
        if(marketable){
            storeString = "库存:" + storeTitle
        }
        else{
            storeString = "该规格已下架"
        }
    }

    var mktprice = '';
    var mktpriceName = '';
    if (basicDict.price_list.mktprice){
      mktprice = basicDict.price_list.mktprice.format;
      mktpriceName = basicDict.price_list.mktprice.name;
    }

    let model = {
        //商品类型
        goodType:goodTypeInt,
        //购买数量
        buyQuantity:1,
        //商品是否上架
        marketAble:marketable,
        //商品单位
        unit:basicDict.unit == null ? "" : basicDict.unit,
        //后台设置
        setting:setting,
        //好评率
        goodPointRate:pointDict == null ? "暂无好评":"好评率:" + pointDict.best_avg,
        //商品标签
        tagsArr:tagsNameArr,
        //商品咨询数量
        adviceCount:data.askCount,
        //拓展属性
        propsArr:basicDict.props,
        //规格详细参数
        paramsInfoArr:paramsInfoArr,
        //商品的规格参数--加入购物车时选择的规格
        specInfosArr:specInfosArr,
        //选中的规格信息
        specInfoString:specInfoString,
        //商品的简介
        brief:basicDict.brief == null ? "" : basicDict.brief,
        //轮播图片
        images:basicDict.images,
        //品牌信息
        brandInfo:basicDict.brand.brand_id == null ? null : basicDict.brand,
        //预售信息
        prepareInfo:prepareModel,
        //秒杀信息
        secondKillInfo:secondKillInfo,
        //商品ID
        goodID:basicDict.goods_id,
        //货品ID
        productID:basicDict.product_id,
        //购买数量
        buyCount:parseInt(basicDict.buy_count),
        //标签栏信息
        barInfosArr:menuBarArr,
        //商品名称
        name:basicDict.title,
        //商品的库存文本
        store:storeTitle,
        //市场价
        marketPrice:mktprice,
        //市场价名称
        marketPriceName:mktpriceName,
        //展示价
        showPrice:basicDict.price_list.show.format == null ? "" : basicDict.price_list.show.format,
        //展示价名称
        showPriceName:basicDict.price_list.show.name,
        //最低价
        minPrice:basicDict.price_list.minprice == null ? "" : basicDict.price_list.minprice.format,
        //最低价名称
        minPriceName:basicDict.price_list.minprice == null ? "" : basicDict.price_list.minprice.name,
        //是否收藏该商品
        isFav:basicDict.is_fav,
        //选中的图片
        selectImage:basicDict.image_default_id,
        //操作按钮
        buttonList:data.btn_page_list,
        //底部视图图片
        bottomImages:data.bottom_bg,
        //最大购买量
        buyLimit:buyLimit,
        //积分信息
        giftInfo:giftInfo,
        //配送商品
        adjunctGoodsArr:adjunctGoodsArr,
        //配件组名
        adjunctNamesArr:adjunctNamesArr,
        //配件选中的组下标
        adjSelectIndex:0,
        //商品的优惠信息
        proContentsArr:proContentsArr,
        //商品的优惠标签信息
        proTagsArr:proTagsArr,
        //价格显示文本
        priceString:showPrice,
        //库存显示文本
        storeString:storeString,
        //小程序图文详情
        graphicInfo:basicDict.wxprointro
    }
    return model
}
module.exports = {
    getAddShopCarParam:getAddShopCarParam,
    getGoodDetailInfoWithData:getGoodDetailInfoWithData
}