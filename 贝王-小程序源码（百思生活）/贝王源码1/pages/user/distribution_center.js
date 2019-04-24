var app = getApp()
var util = require('../../utils/util.js')
var operation
Page({
    data: {
        /**是否显示加载失败的视图**/
        showFailNetWork:false,
        /**数据**/
        info:{},
    },
    //页面卸载
    onUnload:function(){
      operation = null
    },
    /**页面加载完成**/
    onLoad:function(options){
        operation = require('../../utils/orderOperation.js')
        this.loadDistributonCenterInfo(true);
    },
    /**获取详情数据**/
    loadDistributonCenterInfo:function(showLoading){
        var that = this;
        app.request({
            method:'distribution.fxmem.get_distribution_center',
        },function(data){
            that.setData({
              info:data,
              showFailNetWork:false
            })
        },function(data){
            that.setData({
              showFailNetWork:true
            })
        },showLoading,true,true)
    },

    //点击会员中心
    tapMemberCenter:function(even){
        wx.navigateBack({
            delta: 1, // 回退前 delta(默认为1) 页面
        })
    },
    //点击二维码
    tapQrCode:function(even){
        wx.navigateTo({
          url: '/pages/partner/partner_add_qrcode'
        })
    },
    //点击我的团队
    tapMyTeam:function(even){
        wx.navigateTo({
        url: '/pages/partner/partner_list'
        })
    },
    //点击我佣金
    tapMyCommision:function(even){
        wx.navigateTo({
            url: '/pages/balance/balance_home'
        })
    },
    //点击提现
    tapWithDraw:function(even){
        app.getAccountSecurityInfo(function(){

        if (app.shouldBindPhoneNumber()){
            app.bindPhoneNumber('/pages/balance/withdraw');
        }else{
            wx.navigateTo({
            url: '/pages/balance/withdraw'
            })
        }
        });
    }

})
