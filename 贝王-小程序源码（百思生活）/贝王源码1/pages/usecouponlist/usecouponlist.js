var app = getApp()
var util = require('../../utils/util.js')

Page({
    data:{
      /**是否显示加载失败的视图**/
      showFailNetWork:false,
      /**是否能使用优惠券**/
      wantSelectCoupon:false,
      /**是否为立即购买**/
      isFastBuy:false,
      /**当前选中的下标**/
      selectIndex:0,
      /**展示优惠券数组**/
      couponShowInfoArr:[],
      /**可用优惠券数组**/
      couponCanUseInfoArr:[],
      /**不可用优惠券数组**/
      couponCantUseInfoArr:[],
      /**可用优惠券页码**/
      canUsePage:1,
      /**可用优惠券数据总数**/
      canUseTotal:1,
      /**失效优惠券页码**/
      cantUsePage:1,
      /**失效优惠券数据总数**/
      cantUseTotal:1,
      /**是否已经加载过失效优惠券**/
      isRequestNoUseCoupon:false,
      /**是否重载数据**/
      isReLoad:false,
      /**是否展示优惠券输入框**/
      isShowCoupon:false,
      /**优惠码框动画**/
      translateAnimation: null, 
      /**背景动画**/
      backgroundOpacityAnimation: null, 
      /**输入的优惠券码**/
      inputCouponCode:"",
      /**状态栏**/
      statusBarInfo:[{
          "title":"可用",
          "index":0
      },{
          "title":"失效",
          "index":1
      }]
    },
    /**页面加载**/
    onLoad:function(options){
        this.data.isFastBuy = options.isFastBuy == "true"
        this.data.wantSelectCoupon = options.wanSelect == "true"
        this.loadCouponInfo()
    },
    /**页面展示**/
    onShow:function(options){
        this.reLoadInfo()
    },
    reLoadInfo:function(){
        if(this.data.isReLoad && this.data.selectIndex == 0){
            this.data.isReLoad = false
            this.data.couponCanUseInfoArr = []
            this.loadCouponInfo()
        }
    },
    /**请求数据**/
    loadCouponInfo:function(){
        var that = this
        var param = {}
        param["method"] = "b2c.member.coupon"
        param["page"] = this.data.selectIndex == 0 ? this.data.canUsePage : this.data.cantUsePage
        if(this.data.selectIndex == 1){
            this.data.isRequestNoUseCoupon = true
        }
        if(this.data.isFastBuy){
            param["isfastbuy"] = "true"
        }
        param["status"] = this.data.selectIndex == 0 ? "use" : "unuse"
        var filterType = 0
        if(this.data.wantSelectCoupon && this.data.selectIndex == 0){
            filterType = 1
        }
        param["filter_coupon"] = filterType
        app.request(param,
        function(data){
            let infoArr = that.getCouponInfoArr(data)
            if(that.data.selectIndex == 0){
                Array.prototype.push.apply(that.data.couponCanUseInfoArr, infoArr);
            }
            else{
                Array.prototype.push.apply(that.data.couponCantUseInfoArr, infoArr);
            }
            that.data.couponShowInfoArr = that.data.selectIndex == 0 ? that.data.couponCanUseInfoArr : that.data.couponCantUseInfoArr
            that.setData({
                showFailNetWork:false,
                couponShowInfoArr:that.data.couponShowInfoArr,
                selectIndex:that.data.selectIndex,
                wantSelectCoupon:that.data.wantSelectCoupon
            })
        },function(data){
            that.setData({
                showFailNetWork:true
            })
        },true,true,true)
    },
    /**解析数据**/
    getCouponInfoArr:function(data){
        let coupons = data.coupons
        let couponsInfoArr = []
        for(var i = 0;i < coupons.length;i++){
            let coupon = coupons[i]
            let isUsing = false
            if(coupon.useing == null){
                isUsing = false
            }
            else{
                isUsing = coupon.useing
            }
            let initTitle = coupon.cpns_name
            var couponName = ""
            var count = 0
            if(coupon.count == null){
                count = 1
            }
            else{
                count = parseInt(coupon.count)
            }
            if(isUsing){
                count = count - 1
                if(count == 0){
                    couponName = initTitle
                }
                else{
                    couponName = initTitle + "(" + count + ")" 
                }
            }
            else{
                couponName = initTitle + "(" + count + ")" 
            }
            let toTime = coupon.to_time
            let fromTime = coupon.from_time
            let timeString = "有效期:" + util.formatTimesamp(fromTime,2) + "至" + util.formatTimesamp(toTime,2)
            let status = -1
            let statusString = ""
            if(coupon.memc_code != null){
                if(coupon.due){
                    //不可用
                    status = 0
                    statusString = coupon.memc_status
                }
                else{
                    //可用
                    status = 1
                    statusString = "可使用"
                }
            }
            else{
                //过期
                status = 2
                statusString = coupon.memc_status
            }
            let model = {
                //优惠券ID
                couponID:coupon.cpns_id,
                //优惠券码
                couponCode:coupon.memc_code,
                //是否正在使用
                isUsing:isUsing,
                //优惠券数量
                count:count,
                //优惠券名称
                couponName:couponName,
                //副标题
                subTitle:"商城专享优惠券",
                //描述
                descInfo:coupon.description,
                //时间字符串
                time:timeString,
                //状态
                status:status,
                //状态描述
                statusString:statusString
            }
            couponsInfoArr.push(model)
        }
        return couponsInfoArr
    },
    //获取更多优惠券
    getMoreCoupon:function(){
        this.data.isReLoad = true
        wx.navigateTo({
            url: '../couponlist/couponlist',
        })
    },
    //切换状态选择
    changeStatus:function(event){
        this.data.selectIndex = parseInt(event.target.dataset.orderStatus)
        if(this.data.selectIndex == 1 && !this.data.isRequestNoUseCoupon){
            this.loadCouponInfo()
            return
        }
        if(this.data.isReLoad && this.data.selectIndex == 0){
            this.reLoadInfo()
            return
        }
        this.data.couponShowInfoArr = this.data.selectIndex == 0 ? this.data.couponCanUseInfoArr : this.data.couponCantUseInfoArr
        this.setData({
            selectIndex:this.data.selectIndex,
            couponShowInfoArr:this.data.couponShowInfoArr
        })
    },
    //优惠券动作
    couponAction:function(event){
        var that = this
        let code = event.target.dataset.code
        let isUsing = event.target.dataset.isUsing == true
        if(isUsing){
            let param = {}
            param["method"] = "b2c.cart.removeCartCoupon"
            if(this.data.isFastBuy){
                param["is_fastbuy"] = "true"
            }
            param["cpn_ident"] = "coupon_" + code
            app.request(param,
            function(data){
               
                that.data.couponCanUseInfoArr = []
                let md5Code = data.md5_cart_info
                let model = {
                    md_info:md5Code,
                    point:data.point_dis
                }
                that.loadCouponInfo()
                wx.setStorageSync('couponUse', model);
            },function(data){}
            ,true,true,true)
        }
        else{
            let param = {}
            param["method"] = "b2c.cart.add"
            param["obj_type"] = "coupon"
            param["coupon"] = code
            if(this.data.isFastBuy){
                param["is_fastbuy"] = "true"
            }
            app.request(param,
            function(data){
                
                that.data.couponCanUseInfoArr = []
                let md5Code = data.md5_cart_info
                let coupons = data.coupons
                let couponName = coupons[0].name
                let model = {
                    couponName:couponName,
                    md_info:md5Code,
                    point:data.point_dis
                }
                that.loadCouponInfo()
                wx.setStorageSync('couponUse', model);
            },function(data){
            },true,true,true)
        }
    },
    //添加优惠券
    addCouponAction:function(){
        this.setData({
            isShowCoupon: true,
        })
        this.couponAnimation(true)
    },
    //关闭输入框
    closeCouponMethod:function(){
        this.couponAnimation(false)
        var that = this
        var timer = setTimeout(function () {
            that.setData({
                isShowCoupon: false,
            })
            clearTimeout(timer);
        }, 400)
    },
    //输入框动画
    couponAnimation: function(show) {
        var that = this;
        //屏幕高度
        const height = app.globalData.systemInfo.windowHeight;
        var animation = wx.createAnimation({
            duration: 400,
        });
        //修改透明度,偏移
        this.setData({
            backgroundOpacityAnimation: animation.opacity(show ? 1 : 0).step().export(),
            translateAnimation: animation.translateY(show ? (height / 2 - 80) : (80 - height / 2)).step().export()
        })
    },
    //优惠券码输入
    couponCodeInput:function(event){
        this.data.inputCouponCode = event.detail.value
        this.setData({
            inputCouponCode:this.data.inputCouponCode
        })
    },
    //确认输入
    commitAction:function(event){
        var that = this
        this.closeCouponMethod()
        app.request({
            "method":"b2c.member.get_coupon",
            "cpnsCode":that.data.inputCouponCode
        },function(data){
            wx.showToast({
                title: '添加优惠券成功',
                icon: 'success',
                duration: 2000
            })
            if(that.data.selectIndex == 1){
                that.data.selectIndex = 0
                that.data.couponCanUseInfoArr = []
            }
            that.loadCouponInfo()
        },function(data){
            wx.showModal({
                    title: data.msg,
                    content: "",
                    showCancel: false})
        },true,true,true)
    }
})