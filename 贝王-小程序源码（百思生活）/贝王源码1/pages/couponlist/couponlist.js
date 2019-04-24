var app = getApp();
Page({
    /**领取优惠券的数据**/
    couponListArr:[],
    /**是否显示加载失败的视图**/
    showFailNetWork:false,
    /**页面加载完成*/
    onLoad: function (options) {
    },
    /**页面展示**/
    onShow:function(options){
        this.loadReceiveCouponListInfo();
    },
    /**获取领取优惠券数据**/
    loadReceiveCouponListInfo:function(){
        var that = this;
         app.request({
               method: 'b2c.activity.coupon_receive'
            }
            , function (data) {
                var infoArr = that.getReceiveCouponListInfoArr(data);
                that.setData({
                   couponListArr:infoArr,
                   showFailNetWork:false,
               })
            }, function () {
                that.setData({
                    showFailNetWork:true
               })
        }, true, false, true);
    },
    /**网络重载**/
    reloadData:function(){
        this.loadReceiveCouponListInfo();
    },
    /**数据解析**/
    getReceiveCouponListInfoArr:function(data){
        var infoArr = [];
        for(var i = 0;i < data.length;i++){
            var object = data[i];
            let toTime = object.from_time;
            let endTime = object.to_time;
            let receiveStatus = object.receiveStatus;
            var model = {
                /**名称**/
                title:object.cpns_name,
                /**优惠券码**/
                couponCode:object.cpns_prefix,
                /**优惠券ID**/
                couponID:object.cpns_id,
                /**优惠券子标题**/
                couponSubtitle:'商城专属优惠券',
                /**优惠券使用时间**/
                couponTime:'有效期' + toTime + '至' + endTime,
                /**领取按钮的标题**/
                couponButtonString:object.receiveStatusName,
                /**优惠券的说明**/
                couponInfo:object.description,
                /**优惠券能否领取**/
                couponEnableReceive:receiveStatus == "1"
            };
            infoArr.push(model);
        }
        return infoArr;
    },
    /**领取优惠券**/
    receiveCouponAction:function(even){
        var that = this;
        let code = even.target.dataset.code;
        app.request({
            method:"b2c.member.get_coupon",
            cpnsCode:code
        },function(data){
            wx.showToast({
                title: '领券成功',
                icon: 'success',
            })
            that.loadReceiveCouponListInfo();
        },function(){

        },true,true,true)
    },
})