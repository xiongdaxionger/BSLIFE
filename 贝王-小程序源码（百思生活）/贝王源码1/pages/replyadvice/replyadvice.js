var app = getApp()
Page({
    data:{
        //设置信息
        settingInfo:{},
        //咨询信息
        info:{},
        //回复信息
        content:""
    },
    //页面加载完成
    onLoad:function(options){
        let modelString = options.model
        let settingString = options.setting
        this.setData({
            info:JSON.parse(modelString),
            settingInfo:JSON.parse(settingString)
        })
    },
    //提交
    submitAction:function(){
        if(this.data.content.length == 0){
            wx.showModal({
                title: "请输入回复内容",
                content: "",
                showCancel: false,
            })
            return
        }
       
        var that = this
        app.request({
          method:'b2c.comment.toReply',
          id:that.data.info.adviceID,
          comment:that.data.content
        },function(data){
            wx.showModal({
                title: data.msg,
                content: "",
                showCancel: false,
            })
            wx.navigateBack({
              delta: 1,
            })
        },function(data){
            wx.showModal({
                title: "",
                content: "提交失败，请重试",
                showCancel: false,
            })
        },true,true,true)
    },
    //输入变化
    inputChange:function(event){
        const key = event.target.id
        const value = event.detail.value
        this.data[key] = value
    },
    //拨打电话
    callPhone:function(){
        wx.makePhoneCall({
            phoneNumber:this.data.settingInfo.phone
        })
    },

})