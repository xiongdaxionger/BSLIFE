var app = getApp()
var operation
var confirmOperation
Page({
    data:{
        //是否为积分订单
        isPointOrder:false,
        //是否使用积分抵扣金额
        isUsePoint:false,
        //是否立即购买
        isFastBuy:false,
        //订单信息
        confirmOrderInfo:{},
        //确认订单的请求参数
        param:{},
        /**是否显示加载失败的视图**/
        showFailNetWork:false,
        //是否跳转地址选择
        isNavigateToAddress:false,
        //是否跳转到发票页面
        isNavigateToInvioce:false,
        //是否跳转到优惠券页面
        isNavigateToCoupon:false,
        //配送方式弹出动画
        shippingTranslateAnimation: null, 
        //透明动画
        shippingOpacityAnimation: null, 
        //是否显示配送方式
        isShowShippingMethod:false,
        //是否需要重新加载配送方式
        isNeedLoadShipping:true,
        //是否需要重新选择配送方式
        isNeedSelectShipping:false,
        //填写的备注
        memoString:"",
        //是否开启分销
        isOpenFenXiao:false,
        //是否开启代客下单
        isOpenMember:false,
        //选中的会员名称
        selectMemberName:"",
        //选中的会员ID
        selectMemberID:"",
        //选中的会员地址
        selectMemberAddr:null,
        //是否跳转选择会员
        isNavigateToMember:false,
        imgURL: app.getImgURL(), //图片前面域名
    },
    //页面卸载
    onUnload:function(){
      operation = null
      confirmOperation = null
    },
    //页面加载完成
    onLoad:function(options){
        this.data.isOpenFenXiao = app.globalData.userInfo.openFenxiao
        operation = require('../../utils/shopCartOperation.js')
        confirmOperation = require('/confirmOrderOperation.js')
        this.data.isFastBuy = options.isFastBuy == "true"
        this.data.isUsePoint = options.pointOrder == "true"
        this.data.param = JSON.parse(options.model);
        this.loadConfirmOrderInfo(this.data.param);
    },
    //页面展示
    onShow:function(options){
        //地址数据
        if(this.data.isNavigateToAddress){
            this.data.isNavigateToAddress = false
            let model = wx.getStorageSync('selectAddress')
            if(typeof model == "string" || model == null){
                return;
            }
            //判断地区id和地址id是否变化，不管是否变化，其他如地址、手机等信息都要刷新
            wx.setStorageSync('selectAddress', "");
            let addressModel = {
                    addressDetail:model.addr,
                    addressID:model.addressID,
                    mobile:model.mobile,
                    name:model.name,
                    value:model.value,
                    areaID:model.areaID
            }
            let addressInfo = this.data.isOpenMember ? this.data.selectMemberAddr : this.data.confirmOrderInfo.defaultAddress 
            if(addressInfo == null){
                if(this.data.isOpenMember){
                    this.data.selectMemberAddr = addressModel
                    this.setData({
                        selectMemberAddr:addressModel
                    })
                }
                else{
                    this.data.confirmOrderInfo.defaultAddress = addressModel
                    this.setData({
                        confirmOrderInfo:this.data.confirmOrderInfo
                    })
                }
            }
            else{
                if(addressInfo.areaID != model.areaID){
                    //重新选择配送方式,重新选择之后再刷新
                    if(this.data.confirmOrderInfo.defaultShippingInfo != null){
                        this.data.confirmOrderInfo.defaultShippingInfo = null;
                            wx.showModal({
                                title: "信息变更",
                                content: "您变更了您的地址信息，请重新选择配送方式",
                                showCancel: false,
                            });
                                    this.data.isNeedSelectShipping = true
                                    this.data.confirmOrderInfo.isNeedLoadShipping = true
                                    this.downLoadShippingInfoArr(); 
                    }
                }
                if(this.data.isOpenMember){
                    this.data.selectMemberAddr = addressModel
                    this.setData({
                        selectMemberAddr:addressModel
                    })
                }
                else{
                    this.data.confirmOrderInfo.defaultAddress = addressModel
                    this.setData({
                        confirmOrderInfo:this.data.confirmOrderInfo
                    })
                }
            }
        }
        //获取开票的数据
        if(this.data.isNavigateToInvioce){
            this.data.isNavigateToInvioce = false
            let model = wx.getStorageSync('invioceInfo')
            if(typeof model == "string" || model == null){
                return
            }
            wx.setStorageSync('invioceInfo', "");
            if(model.invioceType == this.data.confirmOrderInfo.invioceDict.invioceType){
                this.data.confirmOrderInfo.invioceDict = model;
                this.setData({
                    confirmOrderInfo:this.data.confirmOrderInfo
                })
            }
            else{

                this.data.confirmOrderInfo.isOpenInvioce = model.invioceType != "false";
                this.data.confirmOrderInfo.invioceDict = model;
                this.updateTotalMoney();
            }
        } 
        //获取优惠券的数据
        if(this.data.isNavigateToCoupon){
            this.data.isNavigateToCoupon = false
            let couponModel = wx.getStorageSync('couponUse')
            if(typeof couponModel == "string" || couponModel == null){
                return
            }
            wx.setStorageSync('couponUse', "")
            this.data.confirmOrderInfo.md5Code = couponModel.md_info
            this.data.confirmOrderInfo.pointSetting = couponModel.point
            if(couponModel.couponName != null){
                this.data.confirmOrderInfo.selectCoupon = {
                    name:couponModel.couponName,
                    isUsing:true
                }
            }
            else{
                this.data.confirmOrderInfo.selectCoupon = null
            }
            this.updateTotalMoney()
        }
        //选择会员
        if(this.data.isNavigateToMember){
            this.data.isNavigateToMember = false
            //selectedPartnerInfo
            let memberModel = wx.getStorageSync('selectedPartnerInfo')
            if(typeof memberModel == "string" || memberModel == null){
                return
            }
            wx.setStorageSync('selectedPartnerInfo',"")
            this.data.selectMemberID = memberModel.user_id
            this.setData({
                selectMemberName:memberModel.name
            })
        }
    },
    //请求确认订单数据
    loadConfirmOrderInfo:function(param){
        var that = this;
        app.request(param,
           function(data){
               let model = operation.getConfirmOrderInfo(data);
               that.data.confirmOrderInfo = model;
               that.updateTotalMoney();
           },function(data){
               that.setData({
                   showFailNetWork:true
               })
           },true,true,true)
    },
    //更新订单价格信息
    updateTotalMoney:function(){
        var that = this;
        app.request(
            confirmOperation.getUpdateTotalMoenyParam(that.data.confirmOrderInfo,that.data.isFastBuy,that.data.isUsePoint,that.data.isOpenMember,that.data.selectMemberAddr)
        ,function(data){
            let priceDetail = data.order_detail;
            that.data.confirmOrderInfo.totalMoney = priceDetail.cost_item;
            that.data.confirmOrderInfo.orderTotal = that.data.confirmOrderInfo.isPrepareOrder ? priceDetail.prepare_total_amount : priceDetail.total_amount;
            that.data.confirmOrderInfo.priceTitle = operation.getConfirmOrderPriceInfo(priceDetail).title;
            that.data.confirmOrderInfo.priceInfo = operation.getConfirmOrderPriceInfo(priceDetail).price;
            that.data.isNeedSelectShipping = false;
            that.setData({
                showFailNetWork:false,
                isOpenFenXiao:that.data.isOpenFenXiao,
                isOpenMember:that.data.isOpenMember,
                confirmOrderInfo:that.data.confirmOrderInfo
            })
        },function(data){
            that.setData({
                showFailNetWork:true
            })
        },true,true,true)
    },
    //点击弹出配送方式
    tapShippingMethod:function(){
        let addressInfo = this.data.isOpenMember ? this.data.selectMemberAddr : this.data.confirmOrderInfo.defaultAddress 
        if(addressInfo == null){
            wx.showModal({
                title: "注意",
                content: "请先填写收货地址信息",
                showCancel: false,
            });
            return
        }
        if(this.data.isNeedLoadShipping){
            this.downLoadShippingInfoArr();
        }
        else{
            this.setData({
                isShowShippingMethod: true,
            })
            this.shippingAnimation(true)
        }
    },
    //关闭配送方式选择
    closeShippingMethod:function(){
        this.shippingAnimation(false)
        var that = this
        var timer = setTimeout(function () {
            that.setData({
                isShowShippingMethod: false
            })
            clearTimeout(timer);
        }, 400)
        if(this.data.isNeedSelectShipping){
            this.updateTotalMoney()
        }
    },
    //配送方式动画
    shippingAnimation: function(show) {
        var that = this;
        //屏幕高度
        const height = app.globalData.systemInfo.windowHeight;
        var animation = wx.createAnimation({
            duration: 400,
        });
        //修改透明度,偏移
        this.setData({
            shippingOpacityAnimation: animation.opacity(show ? 1 : 0).step().export(),
            shippingTranslateAnimation: animation.translateY(show ? (150 - height) : (height - 150)).step().export()
        })
    },
    //下载配送方式数据
    downLoadShippingInfoArr:function(){
        let param = {};
        var that = this;
        let addressInfo = this.data.isOpenMember ? this.data.selectMemberAddr : this.data.confirmOrderInfo.defaultAddress 
        param["method"] = "b2c.cart.delivery_change";
        param["area"] = addressInfo.areaID;
        if(this.data.isFastBuy){
            param["isfastbuy"] = "true"
        }
        app.request(param,
        function(data){
            that.data.isNeedLoadShipping = false
            let shippingMethodArr = operation.getShippingMethodInfoArr(data.shippings)
            that.data.confirmOrderInfo.shippingMethodInfoArr = shippingMethodArr;
            that.setData({
                isShowShippingMethod: true,
                confirmOrderInfo:that.data.confirmOrderInfo
            })
            that.shippingAnimation(true)
        },function(data){},
        true,true,true)
    },
    //选择配送方式
    selectShippingMethod:function(event){
        var that = this;
        let value = event.target.dataset.value;
        let selectIndex = parseInt(event.target.dataset.selectIndex);
        let isProtect = event.target.dataset.isProtect == true;
        let isProtectSelect = event.target.dataset.isProtectSelect == true;
        let methodInfoArr = this.data.confirmOrderInfo.shippingMethodInfoArr;
        let selectModel = methodInfoArr[selectIndex]
        if(isProtect){
            if(isProtectSelect){
                wx.showModal({
                    title: "物流保价",
                    content: "您使用了该配送方式的物流保价，您需要取消使用物流保价吗？",
                    showCancel: true,
                    cancelText:"取消使用",
                    confirmText:"继续使用",
                    success:function(res){
                        if(res.confirm){ 
                        }
                        else{
                            selectModel.isProtectSelect = false
                        }
                        that.selectShippingMethodRequest(value,selectModel)
                    }
                });
            }
            else{
                for(var i = 0;i < methodInfoArr.length;i++){
                    let methodModel = methodInfoArr[i];
                    methodModel.isProtectSelect = false;
                }
                wx.showModal({
                    title: "物流保价",
                    content: "该配送方式开启了物流保价，您需要使用物流保价吗？",
                    showCancel: true,
                    cancelText:"不需要",
                    confirmText:"需要",
                    success:function(res){
                        if(res.confirm){
                            selectModel.isProtectSelect = true
                        }
                        that.selectShippingMethodRequest(value,selectModel)
                    }
                });
            }
        }   
        else{
            this.selectShippingMethodRequest(value,selectModel)
        }
    },
    //选中配送方式请求
    selectShippingMethodRequest:function(value,selectModel){
        var that = this
        app.request({
            method:"b2c.cart.delivery_confirm",
            shipping:value
        },function(data){
            that.closeShippingMethod()
            that.data.confirmOrderInfo.currency = data.current_currency;
            that.data.confirmOrderInfo.defaultPay = {
                payDesc:data.payment.app_pay_brief,
                payID:data.payment.app_id,
                payValue:data.payment.value,
                payName:data.payment.app_display_name
            } 
            that.data.confirmOrderInfo.defaultShippingInfo = selectModel;
            that.updateTotalMoney();
        },function(data){},
        true,true,true)
    },
    //提交订单
    commitOrderAction:function(){
        var that = this
        if(this.data.isOpenMember && this.data.selectMemberID.length == 0){
            wx.showModal({
                title: "请选择下单会员",
                content: "",
                showCancel: false,
            });
            return
        }
        let addressInfo = this.data.isOpenMember ? this.data.selectMemberAddr : this.data.confirmOrderInfo.defaultAddress 
        if(addressInfo == null){
            wx.showModal({
                title: "请选择收货信息",
                content: "",
                showCancel: false,
            });
            return
        }
        if(this.data.confirmOrderInfo.defaultShippingInfo == null){
            wx.showModal({
                title:"请选择配送方式",
                content:"",
                showCancel:false
            })
            return
        }
        
        app.request(confirmOperation.getCommitOrderParam(that.data.confirmOrderInfo,that.data.isFastBuy,that.data.memoString,that.data.isOpenMember ? that.data.selectMemberID : app.globalData.userInfo.userId,that.data.isOpenMember,that.data.selectMemberAddr),
        function(data){
            if(!that.data.isFastBuy){
                app.globalData.shopcartCount = 0;
            }
            let orderId = data.order_id
            wx.redirectTo({
                url: '../payinfolist/payinfolist?' + 'orderID=' + orderId + '&isPrepare=' + that.data.confirmOrderInfo.isPrepareOrder + '&isOrderPay=' + false + '&isCombinationPay=' + false + '&isOpenMember=' + that.data.isOpenMember,
            })
        },function(data){},
        true,true,true)
    },
    //选择地址
    selectAddress:function(){
        if(this.data.isOpenMember && this.data.selectMemberID.length == 0){
            wx.showModal({
                title: "请先选择会员",
                content: "",
                showCancel: false,
            });
            return
        }
        this.data.isNavigateToAddress = true;
        wx.navigateTo({
          url: '../addresslist/addresslist?' + 'canSelect=' + true + '&memberID=' + this.data.selectMemberID,
        })
    },
    //选中发票
    invioceAction:function(){
        this.data.isNavigateToInvioce = true;
        let taxInfo = this.data.confirmOrderInfo.taxInfo;
        taxInfo["isOpen"] = this.data.confirmOrderInfo.isOpenInvioce ? "true" : "false";
        taxInfo["invioce"] = this.data.confirmOrderInfo.invioceDict;
       
        // var invioceString = JSON.stringify(this.data.confirmOrderInfo.taxInfo);
        wx.setStorageSync('taxBasic', this.data.confirmOrderInfo.taxInfo);
        wx.navigateTo({
          url: '../invioce/invioce'
        })
    },
    //备注填写
    memoInput:function(event){
        let memo = event.detail.value
        this.data.memoString = memo
    },
    //使用积分
    usePointChange:function(event){
        this.data.isUsePoint = event.detail.value
        if(event.detail.value){
            this.usePointRequest()
        }  
        else{
            this.data.isUsePoint = false
            this.updateTotalMoney()
        }
    },
    //使用积分请求
    usePointRequest:function(){
        var that = this;
        let param = {
            "method":"b2c.cart.count_digist",
            "point[rate]":this.data.confirmOrderInfo.pointSetting.discount_rate,
            "point[score]":this.data.confirmOrderInfo.pointSetting.max_discount_value_point
        };
        app.request(param,
        function(data){
            that.isUsePoint = true
            that.updateTotalMoney()
        },function(data){
            that.setData({
                isUsePoint:false
            })
        },true,true,true)
    },
    //跳转优惠券使用
    useCoupon:function(){
        this.data.isNavigateToCoupon = true
        wx.navigateTo({
          url: '../usecouponlist/usecouponlist?' + 'isFastBuy=' + this.data.isFastBuy + '&wanSelect=' + true
        })
    },
    //代客下单开关变更
    selectMemberChange:function(event){
        this.data.confirmOrderInfo.defaultShippingInfo = null
        this.data.isOpenMember = event.detail.value
        this.updateTotalMoney()
    },
    //选择会员
    selectMember:function(){
        this.data.isNavigateToMember = true
        wx.navigateTo({
          url: '/pages/partner/partner_list?' + 'select_partner=' + true
        })
    },
    //重载信息
    reloadData:function(){
        this.loadConfirmOrderInfo(this.data.param)
    }

})