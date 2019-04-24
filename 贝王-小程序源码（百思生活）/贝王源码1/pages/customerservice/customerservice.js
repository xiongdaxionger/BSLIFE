var app = getApp();
Page({
    customerServiceData:{
        /**客户服务类型**/
        serviceInfoArr:[],
        /**客服电话**/
        mobile:'',
        /**第三方服务类型**/
        serviceType:'',
        /**第三方服务账号**/
        serviceNumber:'',
        /**客服服务说明**/
        serviceInfo:'',
    },
    /**是否显示加载失败的视图**/
    showFailNetWork:false,
    /**页面加载完成*/
    onLoad: function (options) {
        this.loadServiceInfo();
    },
    /**请求客服信息*/
    loadServiceInfo:function(){
        var that = this;
         app.request({
               method: 'b2c.activity.cs'
            }
            , function (data) {
               that.setData({
                   customerServiceData:{
                       mobile:data.mobile,
                       serviceType:data.type,
                       serviceNumber:data.val,
                       serviceInfo:data.explain,
                       serviceInfoArr:[{
                            /**名称**/
                            name:'在线客服',
                            /**图标**/
                            image:data.imgs[0],
                            },{
                            name:'意见反馈',
                            image:data.imgs[1],
                            },{
                            name:'客服电话',
                            image:data.imgs[2],
                            }
                        ]
                   },
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
        this.loadServiceInfo();
    },
    /**点击事件**/
    serviceAction:function(even){
        let index = parseInt(even.target.dataset.index);
        switch (index){
            case 0:{
                wx.navigateTo({
                    url: '../login/login',
                })
                break;
            }
            case 1:{
                if(!app.globalData.isLogin){
                    wx.navigateTo({
                        url: '../login/login',
                    })
                }
                else{
                    wx.navigateTo({
                        url: '../feedback/feedback',
                    })
                }                
                break;
            }
            case 2:{
                wx.makePhoneCall({
                    phoneNumber:this.data.customerServiceData.mobile
                })
                break;
            }
        }
    }
})