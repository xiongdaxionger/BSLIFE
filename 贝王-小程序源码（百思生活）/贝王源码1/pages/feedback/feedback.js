var app = getApp();
Page({
    data:{
        feedBackData:{
            /**意见反馈类型数组**/
            feedBackTypeArr:[],
            /**客服电话**/
            feedBackMobile:""
        },
        imgURL: app.getImgURL(), //图片前面域名
        /**是否显示错误页面**/
        showFailNetWork:false,
        /**反馈标题**/
        title:"",
        /**反馈内容**/
        content:"",
        /**联系方式**/
        contact:"",
    },
    /**页面加载完成**/
    onLoad: function (options) {
        this.loadFeedBackInfo();
    },
    /**获取数据**/
    loadFeedBackInfo:function(){
         var that = this;
         app.request({
               method: 'b2c.member.feedback'
            }
            , function (data) {
                var infoArr = that.getFeedBackTypeInfo(data);
                that.setData({
                   showFailNetWork:false,
                   feedBackData:{
                       feedBackMobile:data.suggest_mobile,
                       feedBackTypeArr:infoArr
                   }
               })
            }, function () {
                that.setData({
                    showFailNetWork:true
               })
        }, true, false, true);
    },
    /**解析数据模型**/
    getFeedBackTypeInfo:function(infodata){
        var typeInfoArr = new Array();
        var array = infodata.suggest_type;
        for (var i = 0; i < array.length; i++) {
            var object = array[i];
            var select = i == 0;
            var model = {
                /**名称**/
                name:object.name,
                /**类型ID**/
                typeID:object.type_id,
                /**是否选中**/
                isSelect:select
            };
            typeInfoArr.push(model);
        }
        return typeInfoArr;
    },
    /**网络重载**/
    reloadData:function(){
        this.loadFeedBackInfo();
    },
    /**打电话**/
    callPhone:function(){
        wx.makePhoneCall({
            phoneNumber:this.data.feedBackData.feedBackMobile
        })
    },
    /**单行输入框输入内容更改**/
    inputChange:function(event){
        const key = event.target.id;
        const value = event.detail.value;
        this.data[key] = value;
    },
    /**点击提交按钮**/
    submitFeedBack:function(event){
        if(this.data.title.length == 0 || this.data.content.length == 0){
            wx.showModal({
                title: '请填写完整的反馈信息',
                content: '',
                showCancel:false
            })
            return;
        }
        var param = this.getSubmitFeedBackParam();
        app.request(
            param,
            function(data){
            wx.showModal({
                title: '提交成功，感谢您的反馈',
                content: '',
                showCancel:false
            })
            },
            function(){},
            true, true, true
        )
    },
    /**获取提交参数**/
    getSubmitFeedBackParam:function(){
        var param = {
            method:'b2c.member.send_msg',
            has_sent:'true',
        };
        param['comment'] = this.data.content;
        param['subject'] = this.data.title; 
        if(this.data.contact.length != 0){
            param['contact'] = this.data.contact;
        }
        for(var i = 0;i < this.data.feedBackData.feedBackTypeArr.length;i++){
            var object = this.data.feedBackData.feedBackTypeArr[i];
            if(object.isSelect){
                param['gask_type'] = object.typeID;
                break;
            }
        }
        return param;
    },
    /**反馈类型切换**/
    selectTypeAction:function(event){
        var selectInt = parseInt(event.target.dataset.index);
        var mobile = this.data.feedBackData.feedBackMobile;
        var typeInfoArr = [];
        for(var i = 0;i < this.data.feedBackData.feedBackTypeArr.length;i++){
            var object = this.data.feedBackData.feedBackTypeArr[i];
            object.isSelect = i == selectInt;
            typeInfoArr.push(object);
        }
        this.setData({
            feedBackData:{
                feedBackTypeArr:typeInfoArr,
                feedBackMobile:mobile
            }
        })  
    },
})