var app = getApp()
var operation = null
// 秒杀计时器
var secondKillTimer = null;
var util = null;
Page({
    data:{
        //是否显示加载失败视图
        time:[],
        showFailNetWork:false,
        //当前选中的下标--指商品/详情/评价的选中下标
        selectIndex:0,
        //顶部导航栏信息
        navigateItemInfos:["商品","详情","评价"],
        //货品ID
        productID:"",
        //是否为赠品商品
        isGiftGood:false,
        //商品详情数据模型
        model:{},
        //猜你喜欢的商品
        goodSimilarArr:[],
        //客服信息
        customServiceDict:{},
        //商品优惠信息是否展开
        isPromotionDrop:false,
        //配件或猜你喜欢的标签内容
        tagArr:[],
        //配件或猜你喜欢选中的类型--0配件/1猜你喜欢
        tagSelectIndex:0,
        //弹出动画
        translateAnimation: null, 
        //透明动画
        opacityAnimation: null, 
        //是否弹出商品属性视图
        isShowGoodExtra:false,
        //是否弹出商品规格视图
        isShowGoodSpec:false,
        //购买数量
        buyQuantity:1,
        //图文详情页选中的类型--指图文详情/规格参数/销售记录的类型,默认显示图文详情
        graphicTypeIndex:0,
        //销售记录的数据
        sellLogInfosArr:[],
        //是否请求了销售记录数据
        isGetSellLog:false,
        //销售记录分页
        sellLogPage:1,
        //当前规格底部按钮能否购买状态
        specInfoCanBuy:false,
        //当前规格底部按钮是否立即购买
        specInfoIsFastBuy:false,
        //当前规格底部按钮能否到货通知
        specInfoNotify:false,
        //当前规格底部按钮的类型
        specInfoValue:"",
        //规格底部按钮能否点击
        specInfoButtonCanTap:false,
        //规格底部按钮的标题
        specInfoButtonTitle:"",
        //是否切换规格重新加载
        isFirstLoad:true,
        //底部图片
        buttonImages:[],
        imgURL: app.getImgURL(), //图片前面域名

        shopcartCount: 0, //购物车数量
    },
    //页面加载完成
    onLoad:function(options){
        this.data.productID = options.productID
        this.data.isGiftGood = options.isGift == "true"
        operation = require('../../../utils/goodDetailOperation.js')
        util = require('../../../utils/util.js')
        this.loadCustomServiceInfo();
        this.loadGoodDetailInfo();
        this.startTimeOut("2018/3/30 18:00")
    },
    startTimeOut(str) {//倒计时
      var _this = this;
      app.globalData.timeOutId = setInterval(function () {
        _this.setData({ time: app.timeOut(str) });
      }, 1000)
    },
    onShareAppMessage: function (res) {
        return app.onShareApp({title:this.data.model.name})
    },
    onShow:function(){
      this.setData({
        shopcartCount: app.globalData.shopcartCount
      })
    },
    //页面卸载
    onUnload:function(){
      operation = null
      util = null
      this.stopTimer()
    },
    //获取商品销售记录信息
    loadGoodSellLogInfo:function(){
        var that = this
        that.data.isGetSellLog = true
        app.request({
            "method":"b2c.product.goodsSellLoglist",
            "goods_id":that.data.model.goodID,
            "page":that.data.sellLogPage
        },function(data){
            //是否显示销售价
            let showPrice = data.selllog_member_price == "true"
            //销售记录
            let logList = data.sellLogList.data
            let sellLogHeaderArr = []
            if(that.data.sellLogPage == 1 && logList.length != 0){
                sellLogHeaderArr = ["买家昵称","数量","购买时间"]
                if(showPrice){
                    sellLogHeaderArr.push("购买价")
                }
                that.data.sellLogInfosArr.push(sellLogHeaderArr)
            }
            let infosArr = []
            for(var i = 0;i < logList.length;i++){
                let object = logList[i]
                let arr = [object.name,object.number,util.formatTimesamp(object.createtime,2)]
                if(showPrice){
                    arr.push(object.price)
                }
                infosArr.push(arr)
            }
            Array.prototype.push.apply(that.data.sellLogInfosArr,infosArr);
            that.setData({
                sellLogHeaderArr:that.data.sellLogHeaderArr,
                sellLogInfosArr:that.data.sellLogInfosArr
            })
        },function(data){
            that.setData({
                sellLogInfosArr:[]
            })
        },true,true,true)
    },
    //获取商品详情信息
    loadGoodDetailInfo:function(){
        var that = this
        let param = {}
        param["method"] = "b2c.product.index"
        param["product_id"] = this.data.productID
        param["type"] = this.data.isGiftGood ? "gift" : "product"
        app.request(param,
        function(data){
            that.stopTimer()
            that.data.model = operation.getGoodDetailInfoWithData(data)
            if(that.data.model.goodType == 3){
                that.startTimer()
            }
            if(that.data.isFirstLoad){
                // 保存浏览记录
                let historyJs = require("../../goods/good_browse_history.js");
                historyJs.insertHistory(that.data.model);
                historyJs = null;
                that.loadSimilarInfo(that.data.model.goodID)
                that.data.buttonImages.push('/images/goodDetail/help.png')
                if(that.data.model.isFav){
                    that.data.buttonImages.push('/images/goodDetail/hav_fav.png')
                }
                else{
                  that.data.buttonImages.push('/images/goodDetail/no_fav.png')
                }
                that.data.buttonImages.push('/images/goodDetail/shop_car.png');
            }
            else{
                let found = false
                for(var i = 0;i < that.data.model.buttonList.length;i++){
                    let button = that.data.model.buttonList[i]
                    let valueTmp = button.value
                    if(valueTmp == that.data.specInfoValue){
                        found = true
                        that.data.specInfoCanBuy = button.buy
                        that.data.specInfoNotify = button.show_notify
                        that.data.specInfoIsFastBuy = valueTmp == "fastbuy"
                        break
                    }
                }
                if(!found){
                    let button = that.data.model.buttonList[0]
                    that.data.specInfoCanBuy = button.buy
                    that.data.specInfoNotify = button.show_notify
                    that.data.specInfoValue = button.value
                    that.data.specInfoIsFastBuy = button.value == "fastbuy"
                }
                that.dealWithSpecInfoButton()
                that.setData({
                    specInfoButtonCanTap:that.data.specInfoButtonCanTap,
                    specInfoButtonTitle:that.data.specInfoButtonTitle,
                    model:that.data.model,
                })
            }
        },function(data){
            that.setData({
                showFailNetWork:true
            })
        },true,true,true)
    },
    //获取客服信息
    loadCustomServiceInfo:function(){
        var that = this
        app.request({
            "method":"b2c.activity.cs"
        },function(data){
            that.data.customServiceDict = data
        })
    },
    //获取相似商品信息
    loadSimilarInfo:function(goodID){
        var that = this
        app.request({
            "method":"b2c.product.goodsLink",
            "goods_id":goodID
        },function(data){
            if(data.page_goodslink != null && data.page_goodslink.link != null){
                let goodsLinkArr = data.page_goodslink.link
                let productIDDict = data.page_goodslink.products
                for(var i = 0;i < goodsLinkArr.length;i++){
                    let linkObject = goodsLinkArr[i]
                    let goodID = linkObject.goods_id
                    let linkModel = {
                        goodID:linkObject.goods_id,
                        image:linkObject.image_default_id,
                        goodName:linkObject.name,
                        price:linkObject.price,
                        productID:productIDDict.goodID,
                    }
                    that.data.goodSimilarArr.push(linkModel)
                }
            }
            let similarIsZero = that.data.goodSimilarArr.length != 0
            let adjunctCountIsZero = that.data.model.adjunctNamesArr.length != 0
            if(similarIsZero && adjunctCountIsZero){
                that.data.tagSelectIndex = 0
                that.data.tagArr = [{name:"配件推荐",typeIndex:0},{name:"猜你喜欢",typeIndex:1}]
            }
            else if(similarIsZero || adjunctCountIsZero){
                if(that.data.goodSimilarArr.length != 0){
                    that.data.tagSelectIndex = 1
                    that.data.tagArr = [{name:"猜你喜欢",typeIndex:1}]
                }
                else{
                    that.data.tagSelectIndex = 0
                    that.data.tagArr = [{name:"配件推荐",typeIndex:0}]
                }
            }
            that.setData({
                showFailNetWork:false,
                model:that.data.model,
                goodSimilarArr:that.data.goodSimilarArr,
                tagSelectIndex:that.data.tagSelectIndex,
                tagArr:that.data.tagArr,
                buttonImages:that.data.buttonImages,
            })
        },function(data){
            that.setData({
                showFailNetWork:false,
                model:that.data.model,
                goodSimilarArr:[]
            })
        },true,true,true)
    },
    // 启动倒计时
    startTimer: function () {
        if (secondKillTimer != null)
            return;
        var that = this
        secondKillTimer = setInterval(function () {
            that.formatTimer();
        }, 1000)
    },
    // 结束秒杀计时器
    stopTimer: function () {
        if (secondKillTimer != null) {
            clearInterval(secondKillTimer);
            secondKillTimer = null;
        }
    },
    // 秒杀倒计时格式化
    formatTimer: function () {
        let secondKillInfo = this.data.model.secondKillInfo
        if(secondKillInfo == null){
            return
        }
        const serverTimeStamp = secondKillInfo.systemTime;
        var time = 0;
        if (secondKillInfo.beginTime > serverTimeStamp) {
            //秒杀未开始
            time = secondKillInfo.beginTime;
            secondKillInfo.timerTitle = "距开始";
        } else if (secondKillInfo.endTime > serverTimeStamp) {
            // 秒杀未结束
            time = secondKillInfo.endTime;
            secondKillInfo.timerTitle = "距结束";
        } else {
            time = 0; //已结束
        }
        if (time > 0) {
            time = time - serverTimeStamp;
            // 格式化时间戳
            var result = parseInt(time / 60);
            var second = time % 60;

            var minute = result % 60;
            var hour = parseInt(result / 60);
            secondKillInfo.hour = hour < 10 ? '0' + hour : hour;
            secondKillInfo.minutes = minute < 10 ? '0' + minute : minute;
            secondKillInfo.second = second < 10 ? '0' + second : second;
            secondKillInfo.isSecondKillEnd = false;
        } else {
            //秒杀已结束
            secondKillInfo.isSecondKillEnd = true;
        }
        secondKillInfo.systemTime = secondKillInfo.systemTime + 1
        this.data.model.secondKillInfo = secondKillInfo
        this.setData({
            model:this.data.model
        })
    },
    //改变优惠信息的展开
    changePromotionAction:function(){
        this.setData({
            isPromotionDrop:!this.data.isPromotionDrop
        })
    },
    //点击配件或者猜你喜欢的状态切换
    adjunctSimilarTap:function(event){
        let typeIndex = event.target.dataset.typeIndex
        if(typeIndex == this.data.tagSelectIndex){
            return
        }
        this.setData({
            tagSelectIndex:typeIndex
        })
    },
    //点击配件的组名
    adjGroupNameTap:function(event){
        let index = event.target.dataset.index
        if(this.data.model.adjSelectIndex == index){
            return
        }
        for(var i = 0;i < this.data.model.adjunctNamesArr.length;i++){
            let item = this.data.model.adjunctNamesArr[i]
            item.isSelect = false
        }
        let selectItem = this.data.model.adjunctNamesArr[index]
        selectItem.isSelect = true
        this.data.model.adjSelectIndex = index
        this.setData({
            model:this.data.model
        })
    },
    //配件商品选中
    adjGoodTap:function(event){
        let index = event.target.dataset.index
        let adjGood = this.data.model.adjunctGoodsArr[this.data.model.adjSelectIndex][index]
        adjGood.isSelect = !adjGood.isSelect
        this.setData({
            model:this.data.model
        })
    },
    //点击弹出商品属性
    tapGoodExtra:function(){
        this.setData({
            isShowGoodExtra: true,
        })
        this.popViewAnimation(true)
    },
    //关闭弹出视图
    closePopView:function(){
        this.popViewAnimation(false)
        var that = this
        var timer = setTimeout(function () {
            that.setData({
                isShowGoodExtra: false,
                isShowGoodSpec:false
            })
            clearTimeout(timer);
        }, 400)
    },
    //弹出视图动画
    popViewAnimation: function(show) {
        var that = this;
        //屏幕高度
        const height = app.globalData.systemInfo.windowHeight;
        var animation = wx.createAnimation({
            duration: 400,
        });
        //修改透明度,偏移
        this.setData({
            opacityAnimation: animation.opacity(show ? 1 : 0).step().export(),
            translateAnimation: animation.translateY(show ? (165 - height) : (height - 165)).step().export()
        })
    },
    //弹出规格动画
    specInfoTap:function(){
        this.dealWithSpecInfoButton()
        this.setData({
            specInfoButtonCanTap:this.data.specInfoButtonCanTap,
            specInfoButtonTitle:this.data.specInfoButtonTitle,
            isShowGoodSpec: true,
        })
        this.popViewAnimation(true)
    },
    //减少购买数量
    minusGoodAction:function(){
        if(this.data.buyQuantity == 1){
            return
        }
        this.setData({
            buyQuantity:this.data.buyQuantity - 1
        })
    },
    //增加购买数量
    addGoodAction:function(){
        if(this.data.buyQuantity + 1 > this.data.model.buyLimit){
            this.showMessage("超出购买数量了")
            return;
        }
        this.setData({
            buyQuantity:this.data.buyQuantity + 1
        })
    },
    //选中某个规格
    selectSpecInfo:function(event){
        this.data.isFirstLoad = false
        this.data.productID = event.target.dataset.productId
        this.loadGoodDetailInfo()
    },
    //点击查看图文详情
    tapGraphic:function(){
        this.setData({
            selectIndex:1
        })  
    },
    //点击导航栏选项卡
    tapNavigateItem:function(event){
        let index = event.target.dataset.index
        if(index == 2){
            const that = this;
            wx.navigateTo({
                url: '/pages/goodcomment/comment_list?good_id=' + that.data.model.goodID
            })
            return
        }
        this.setData({
            selectIndex:index
        })
    },
    //点击图文详情的选项卡
    changeGraphicSelect:function(event){
        let tabType = event.target.dataset.type
        this.setData({
            graphicTypeIndex:tabType
        })
        if(tabType == 2 && !this.data.isGetSellLog){
            this.loadGoodSellLogInfo()
        }
    },
    //跳转商品的评价
    goodCommentTap:function(){
        const that = this;
        wx.navigateTo({
          url: '/pages/goodcomment/comment_list?good_id=' + that.data.model.goodID
        })
    },
    //收藏/购物车/客服等按钮点击
    imageButtonTap:function(event){
        let index = event.target.dataset.index
        switch(index){
          case 0 : {
            wx.makePhoneCall({
              phoneNumber: this.data.customServiceDict.mobile
            })
            break;
          }
          case 1 : {
            var that = this
            if (this.data.model.isFav) {
              app.request({
                "method": "b2c.member.ajax_del_fav",
                "gid": that.data.model.goodID
              }, function (data) {
                that.data.buttonImages.splice(1, 1, '/images/goodDetail/no_fav.png')
                that.showMessage("取消收藏成功")
                that.data.model.isFav = false
                that.setData({
                  buttonImages: that.data.buttonImages
                })
              }, function (data) {
                that.showMessage("取消收藏失败")
              }, true, true, true)
            }
            else {
              app.request({
                "method": "b2c.member.ajax_fav",
                "gid": that.data.model.goodID,
                "type": "goods"
              }, function (data) {
                that.data.buttonImages.splice(1, 1, '/images/goodDetail/hav_fav.png')
                that.showMessage("收藏成功")
                that.data.model.isFav = true
                that.setData({
                  buttonImages: that.data.buttonImages
                })
              }, function (data) {
                that.showMessage("收藏失败")
              }, true, true, true)
            }
            break;
          }
          case 2 : {
            wx.redirectTo({
              url: '/pages/shopcart/shopcart_nav_enable',
            })
            break;
          }
        }

    },
    //加入购物车/立即购买按钮点击
    textButtonTap:function(event){
        let value = event.target.dataset.value
        this.data.specInfoValue = value
        this.data.specInfoCanBuy = event.target.dataset.buy
        this.data.specInfoNotify = event.target.dataset.notify
        this.data.specInfoIsFastBuy = value == "fastbuy"
        this.specInfoTap()
    },
    //点击弹出规格选择
    popSpecInfo:function(){
        let firstButton = this.data.model.buttonList[0]
        this.data.specInfoValue = firstButton.value
        this.data.specInfoCanBuy = firstButton.buy
        this.data.specInfoNotify = firstButton.show_notify
        this.data.specInfoIsFastBuy = firstButton.value == "fastbuy"
        this.specInfoTap()
    },
    //弹出规格选择前的处理
    dealWithSpecInfoButton:function(){
        if(this.data.specInfoCanBuy){
            this.data.specInfoButtonTitle = "确定"
            this.data.specInfoButtonCanTap = !this.data.specInfoNotify
        }
        else{
            this.data.specInfoButtonTitle = this.data.specInfoNotify ? "到货通知" : "确定"
            this.data.specInfoButtonCanTap = this.data.specInfoNotify ? true : false
        }
    },
    //提交购物车/确认订单
    commitShopTap:function(){
        if(this.data.specInfoCanBuy){
            if(!this.data.specInfoNotify){
                if(this.data.specInfoIsFastBuy){
                    //立即购买
                    this.fastBuyGood()
                }
                else{
                    if(this.data.model.goodType == 2 || this.data.model.goodType == 4){
                        //立即购买
                        this.fastBuyGood()
                    }
                    else{
                        //加入购物车
                        this.addGoodToShopCart()
                    }
                }
            }
        }
        else{
            if(this.data.specInfoNotify){
                //跳转到货通知
                wx.navigateTo({
                url: '../gooddetail/goodnotify?' + 'goodid=' + this.data.model.goodID + '&productid=' + this.data.model.productID,
                })
            }
        }
    },
    //加入购物车
    addGoodToShopCart:function(){
        var that = this
        app.request(this.getBuyGoodParam(false),
        function(data){
            that.showMessage("加入购物车成功");
            var shopcartCount = app.globalData.shopcartCount;
            shopcartCount ++;
            app.globalData.shopcartCount = shopcartCount;
            that.setData({
                shopcartCount: shopcartCount
            })
        },function(data){
            that.showMessage("加入购物车失败")
        },true,true,true)
    },
    //立即购买
    fastBuyGood:function(){
        var that = this
        if(!app.globalData.isLogin){
            app.showLogin()
            return
        }
        if(this.data.model.goodType == 4 && !this.data.model.giftInfo.canExchange){
            this.showMessage(this.data.model.giftInfo.reason)
            return
        }
        if(this.data.model.goodType == 2 && !this.data.model.prepareInfo.status != 1){
            this.showMessage(this.data.model.prepareInfo.statusMessage)
            return
        }
        app.request(this.getBuyGoodParam(true),
        function(data){
            let param = {};
            let key = "obj_ident" + "[" + 0 + "]";
            let id = that.data.model.goodID + "_" + that.data.model.productID
            let value = that.data.model.goodType == 4 ? "gift_" + id : "goods_" + id
            param[key] = value
            param["isfastbuy"] = "true"
            param["method"] = "b2c.cart.checkout"
            var paramString = JSON.stringify(param);
            let isPointOrder = that.data.model.goodType == 4;
            wx.redirectTo({
                url: '../confirmorder/confirmorder?' + 'model=' + paramString + '&isFastBuy=' + true + "&pointOrder=" + isPointOrder,
            })
        },function(data){
            that.showMessage("购买失败,请重试")
        },true,true,true)
    },    
    showMessage:function(message){
        wx.showModal({
            title:message,
            content:"",
            showCancel: false
        })
    },
    //加入购物车/立即购买的参数
    getBuyGoodParam:function(isFastBuy){
        let param = operation.getAddShopCarParam(isFastBuy ? "is_fastbuy" : null,this.data.model.goodID,this.data.model.productID,this.data.buyQuantity,0,null,0,this.data.model.goodType == 4 ? "gift" : "goods")
        for(var i = 0;i < this.data.model.adjunctGoodsArr.length;i++){
            let group = this.data.model.adjunctGoodsArr[i]
            for(var j = 0;j < group.length;j++){
                let adjGood = group[j]
                if(adjGood.isSelect){
                    let key = "adjunct[" + i + "]" + "[" + adjGood.productID + "]"
                    param[key] = 1
                }
            }
        }
        return param
    },
    //点击咨询
    adviceTap:function(){
        wx.navigateTo({
          url: '../advice/advicelist?' + 'goodid=' + this.data.model.goodID,
        })
    },
    //点击品牌
    tapBrand:function(event){
        wx.navigateTo({
            url: '/pages/goods/good_list?brand_id=' + event.target.dataset.brandId
        })
    },
    //重载信息
    reloadData:function(){
        this.loadGoodDetailInfo()
    },
})