var app = getApp()
var util = null
Page({
    data:{
        //是否显示数据失败视图
        showFailNetWork:false,
        //选中的下标
        selectIndex:0,
        //标题栏信息
        statusInfo:[
            "申请退款","退款记录","申请退货","退货记录"
        ],
        //数据
        infosArr:[],
        //页码
        page:1,
        //空视图提示语
        emptyTipString:"",
        //各个条目的总数量
        total:0,
        imgURL: app.getImgURL(), //图片前面域名,
        /**是否正在请求数据**/
        isLoadInfo:false,
        /**物流信息输入框动画**/
        logisticsTranslateAnimation: null, 
        /**背景动画**/
        backgroundOpacityAnimation: null, 
        /**是否显示物流信息输入**/
        isShowLogistics:false,
        //物流单号
        logisticsNum:"",
        //物流公司
        companyName:"",
        //退货的快递公司数组
        shipCompany:[],
        //快递公司弹出动画
        companyTranslateAnimation: null, 
        //是否显示物流公司
        isShowCompany:false,
        //选中的订单
        selectOrderID:"",
        showScrollToTop: false, //是否显示回到顶部按钮
        scroll_top: 0, //回到顶部
    },
    /**页面展示**/
    onShow:function(options){
      if(!this.data.isLoadInfo){
        this.data.page = 1
        this.data.infosArr = []
        this.getRefundInfo()
      }
    },
    //页面加载完成
    onLoad:function(options){
        util = require('../../utils/util.js')
        this.data.isLoadInfo = true
        this.getRefundInfo()
    },
    //页面卸载
    onUnload:function(){
        util = null
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
    //获取退款/退货数据
    getRefundInfo:function(){
        var that = this
        app.request({
            "method":"aftersales.aftersales.afterlist",
            "page":that.data.page,
            "type":that.data.selectIndex == 0 ? "refund":"reship"
        },function(data){
            let operation = require("../orderlist/orderlist.js");
            let arr = operation.getOrderInfoArr(data)
            operation = null;
            that.data.total = data.pager.dataCount
            Array.prototype.push.apply(that.data.infosArr,arr);
            let emptyString = ""
            if(that.data.infosArr.length == 0){
                if(that.data.selectIndex == 0){
                    emptyString = "暂无退款订单"
                }
                else{
                    emptyString = "暂无退货订单"
                }
            }
            that.setData({
                emptyTipString:emptyString,
                infosArr:that.data.infosArr,
                showFailNetWork:false,
                selectIndex:that.data.selectIndex
            })
        },function(data){
            that.setData({
                showFailNetWork:true
            })
        },true,true,true)
    },
    //获取退款/退货记录数据
    getRefundRecordInfo:function(){
        var that = this
        app.request({
            "method":"aftersales.aftersales.afterrec",
            "page":that.data.page,
            "type":that.data.selectIndex == 1 ? "refund" : "reship"
        },function(data){
            let arr = that.getRecordInfosArr(data)
            Array.prototype.push.apply(that.data.infosArr,arr);
            let emptyString = ""
            if(that.data.infosArr.length == 0){
                if(that.data.selectIndex == 1){
                    emptyString = "暂无退款记录"
                }
                else{
                    emptyString = "暂无退货记录"
                }
            }
            that.setData({
                emptyTipString:emptyString,
                infosArr:that.data.infosArr,
                showFailNetWork:false,
                selectIndex:that.data.selectIndex
            })
        },function(data){
            that.setData({
                showFailNetWork:true
            })
        },true,true,true)
    },
    //重载数据
    reloadData:function(){
        this.getReLoadInfo()
    },
    //重新获取数据
    getReLoadInfo:function(){
        this.data.page = 1
        this.data.infosArr = []
        if(this.data.selectIndex == 1 || this.data.selectIndex == 3){
            this.getRefundRecordInfo()
        }
        else{
            this.getRefundInfo()
        }
    },
    //解析记录数据
    getRecordInfosArr:function(data){
        let arr = []
        this.data.total = data.pager.dataCount
        this.data.shipCompany = data.dlycorp
        let list = data.return_list
        for(var i = 0;i < list.length;i++){
            let object = list[i]
            let comment = object.comment
            let commentArr = []
            for(var j = 0;j < comment.length;j++){
                let dict = comment[j]
                commentArr.push(util.formatTimesamp(dict.time,1))
                commentArr.push(dict.content)
            }
            let delivery = object.delivery_data
            let deliveryArr = []
            if(delivery instanceof Array){
                deliveryArr = []
            }
            else{
                deliveryArr.push(delivery.crop_code)
                deliveryArr.push(delivery.crop_no)
            }
            let refund = {
                //订单ID
                orderID:object.order_id,
                //退款ID
                refundID:object.return_id,
                //退款理由
                reason:object.title,
                //能否填写快递信息
                canDelivery:object.delivery_status == 1,
                //状态
                status:object.status,
                //店主反馈
                comment:commentArr,
                //物流信息--为空时是个空数组
                delivery:deliveryArr,
                //商品信息
                orderGoodInfoArr:this.getRecordGoodInfosArr(object.product_data)
            }
            arr.push(refund)
        }
        return arr
    },
    //解析退款/退货记录的商品数据
    getRecordGoodInfosArr:function(arr){
        let goods = []
        for(var i = 0;i < arr.length;i++){
            let object = arr[i]
            let good = {
                //商品名称
                orderGoodName:object.name,
                //商品价格
                orderGoodPrice:object.price,
                //商品图片
                orderGoodImage:object.image_default_id,
                //商品数量
                orderGoodQuantity:object.num,
                //商品规格
                orderGoodSpecInfo:object.attr == null ? "" : object.attr,
                //类型
                orderGoodType:0
            }
            goods.push(good)
        }
        return goods
    },
    //切换状态栏
    changeIndex:function(event){
        this.data.selectIndex = event.target.dataset.status
        this.getReLoadInfo()
    },
    //申请退款/申请退货
    applyAction:function(event){
        this.data.isLoadInfo = false
        let orderID = event.target.dataset.orderId
        let refundType = this.data.selectIndex == 0 ? "refund":"reship"
        wx.navigateTo({
            url: '../refund/refunddetail?' + 'orderid=' + orderID + '&type=' + refundType,
        })
    },
    //查看详情
    pustOrderDetail:function(event){

    },
    //填写物流信息
    expressInfoFill:function(event){
        this.data.selectOrderID = event.target.dataset.orderId
        this.setData({
            isShowLogistics: true,
        })
        this.logisticsViewAnimation(true)
    },
    //关闭物流信息输入框
    closeLogisticsView:function(){
        this.logisticsViewAnimation(false)
        var that = this
        var timer = setTimeout(function () {
            that.setData({
                isShowLogistics: false,
            })
            clearTimeout(timer);
        }, 400)
    },
    //物流单号输入框动画
    logisticsViewAnimation: function(show) {
        var that = this;
        //屏幕高度
        const height = app.globalData.systemInfo.windowHeight;
        var animation = wx.createAnimation({
            duration: 400,
        });
        //修改透明度,偏移
        this.setData({
            backgroundOpacityAnimation: animation.opacity(show ? 1 : 0).step().export(),
            logisticsTranslateAnimation: animation.translateY(show ? (height / 2 - 154) : (154 - height / 2)).step().export()
        })
    },
    //选择物流公司
    selectCompany:function(){
        this.setData({
            isShowCompany: true,
            shipCompany:this.data.shipCompany
        })
        this.logisticsCompanyViewAnimation(true)
    },
    //关闭物流公司信息
    closeLogisticsCompany:function(){
        this.logisticsCompanyViewAnimation(false)
        var that = this
        var timer = setTimeout(function () {
            that.setData({
                isShowCompany: false,
                companyName:that.data.companyName
            })
            clearTimeout(timer);
        }, 400)
    },
    //物流公司动画
    logisticsCompanyViewAnimation: function(show) {
        var that = this;
        //屏幕高度
        const height = app.globalData.systemInfo.windowHeight;
        var animation = wx.createAnimation({
            duration: 400,
        });
        //修改透明度,偏移
        let padding_height = (height - 350) + 44
        this.setData({
            companyTranslateAnimation: animation.translateY(show ? (-padding_height) : (padding_height)).step().export()
        })
    },
    //扫描物流单号
    scanLogistics:function(){
        var that = this
        wx.scanCode({
          success: function(res){
              if(res.scanType == "CODE_128"){
                that.setData({
                    logisticsNum:res.result
                })
              }
          },
          fail: function() {
            that.setData({
                logisticsNum:""
            })
          },
        })
    },
    //输入物流单号
    inputChange:function(event){
        const key = event.target.id
        const value = event.detail.value
        this.data[key] = value
    },
    //选中物流公司
    didSelectCompany:function(event){
        this.data.companyName = event.target.dataset.index
        this.closeLogisticsCompany()
    },
    //提交物流信息
    submitLogistics:function(){
        var that = this
        if(this.data.logisticsNum.length == 0){
            wx.showModal({
                title: "请输入快递单号",
                content: "",
                showCancel: false
            });
            return
        }
        if(this.data.companyName.length == 0){
            wx.showModal({
                title: "请选择物流公司",
                content: "",
                showCancel: false
            });
            return
        }
        app.request({
            "method":"aftersales.aftersales.save_return_delivery",
            "crop_code":that.data.companyName,
            "crop_no":that.data.logisticsNum,
            "return_id":that.data.selectOrderID,
        },function(data){
            wx.showToast({
                title: "提交成功",
                icon: 'success'
            });
            that.closeLogisticsView()
            that.getReLoadInfo()
        },function(data){
            wx.showModal({
                title: "提交失败，请重试",
                content: "",
                showCancel: false
            });
        },true,true,true)

    },

})