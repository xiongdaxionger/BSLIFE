var app = getApp()

Page({
    data:{
        //发票类型
        invioceTypeArr:[],
        //发票内容
        invioceContentArr:[],
        //是否开发票
        isOpenInvioce:false,
        //已开发票内容
        invioceInfo:{},
        imgURL: app.getImgURL(), //图片前面域名

    },
    //页面加载
    onLoad:function(options){
        let model = wx.getStorageSync('taxBasic')
        this.setData({
            isOpenInvioce:model.isOpen == "true",
            invioceInfo:model.invioce,
            invioceTypeArr:model.taxType,
            invioceContentArr:model.taxContent
        })
    },
    //发票类型切换
    typeChange:function(event){
        let value = event.target.dataset.value
        this.data.isOpenInvioce = value != "false"
        this.data.invioceInfo.invioceType = value
        this.setData({
            invioceInfo:this.data.invioceInfo,
            isOpenInvioce:this.data.isOpenInvioce
        })
    },
    //抬头输入
    headerInput:function(event){
        let headerInput = event.detail.value
        this.data.invioceInfo.invioceHeader = headerInput
        this.setData({
            invioceInfo:this.data.invioceInfo
        })
    },
    //选择发票内容
    selectContent:function(event){
        let content = event.target.dataset.content
        this.data.invioceInfo.invioceContent = content
        this.setData({
            invioceInfo:this.data.invioceInfo,
        })
    },
    //确认返回
    invioceCommit:function(){
        if(this.data.isOpenInvioce){
            if(this.data.invioceInfo.invioceHeader.length == 0){
                wx.showModal({
                    title: "请填写发票抬头",
                    content: "",
                    showCancel: false,
                });
                return
            }
            if(this.data.invioceInfo.invioceContent.length == 0){
                wx.showModal({
                    title: "请选择开票内容",
                    content: "",
                    showCancel: false,
                });
                return
            }
        }
        wx.setStorageSync('invioceInfo', this.data.invioceInfo);
        wx.navigateBack({
            delta: 1
        })
    }
})