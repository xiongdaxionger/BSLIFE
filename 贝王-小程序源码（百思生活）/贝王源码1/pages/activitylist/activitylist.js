var app = getApp()
Page({
    /**活动类型数组**/
    activityListArr:[],
    /**是否显示加载失败的视图**/
    showFailNetWork:false,
    /**页面加载完成*/
    onLoad: function (options) {
        this.loadActivityListInfo();
    },
    /**获取活动数据**/
    loadActivityListInfo:function(){
        var that = this;
         app.request({
               method: 'b2c.activity.alist'
            }
            , function (data) {
                var infoArr = that.getActivityListInfoArr(data);
                that.setData({
                   activityListArr:infoArr,
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
        this.loadActivityListInfo();
    },
    /**数据解析**/
    getActivityListInfoArr:function(data){
        var infoArr = [];
        for(var i = 0;i < data.length;i++){
            var object = data[i];
            var model = {
                /**名称**/
                name:object.name,
                /**图片**/
                image:object.img,
                /**活动类型**/
                activityType:object.type
            };
            infoArr.push(model);
        }
        if(infoArr.length % 3 != 0){
            var integer = 3 - infoArr.length % 3;
            for(var i = 0;i < integer;i++){
                infoArr.push({});
            }
        }
        return infoArr;
    },
    /**选中某个活动**/
    activityAction:function(event){
        let activityType = event.target.dataset.type;
        if(activityType == "coupons"){
            wx.navigateTo({
                url: '../couponlist/couponlist',
            })
        }
        else if(activityType == "sign"){
            wx.navigateTo({
                url: '/pages/integral/integral_sign_in?integral=false'
            })
        }
        else if (activityType == "recharge"){
            app.request({
                method: 'b2c.member.deposit'
                }, function (data) {
                var actEnable = false;
                const activityObj = data.active.recharge;
                if (activityObj.status == 1) {
                    actEnable = activityObj.filter != null && activityObj.filter.length > 0;
                }
                const json = JSON.stringify(data);
                if (actEnable) {
                    // 有充值活动
                    wx.navigateTo({
                    url: '/pages/balance/topup_activity?data=' + json,
                    })
                } else {
                    // 没充值活动
                    const payInfos = data.payments;
                    const amount_symbol = data.def_cur_sign;

                    var url = '/pages/balance/topup_confirm?payInfos=' + JSON.stringify(payInfos) + '&amount_symbol=' + amount_symbol;
                    wx.navigateTo({
                    url: url
                    })
                }
                }, function () {
            }, true, true, true);
        }
        else if (activityType == "register"){
          wx.navigateTo({
            url: './shares',
          })
        }
    },
})