var app = getApp()
Page({
    data:{
        //设置信息
        settingInfo:{},
        //商品ID
        goodID:"",
        //类型数组
        typesArr:[],
        //咨询输入信息
        content:"",
        /**图片域名**/
        imgURL:app.getImgURL(),
        //是否匿名
        isHiddenName:false,
    },
    //页面加载完成
    onLoad:function(options){
        let typeString = options.typeString
        let settingString = options.setting
        let goodID = options.goodid
        this.setData({
            typesArr:JSON.parse(typeString),
            settingInfo:JSON.parse(settingString),
            goodID:goodID
        })
    },
    //提交咨询
    submitAction:function(){
        if(this.data.content.length == 0){
            wx.showModal({
                title: "请输入咨询内容",
                content: "",
                showCancel: false,
            })
            return
        }
        var that = this
        let typeID = ""
        for(var i = 0;i < this.data.typesArr.length;i++){
            let object = this.data.typesArr[i]
            if(object.isSelect){
                typeID = object.typeID
                break
            }
        }
        app.request({
          method:'b2c.comment.toAsk',
          goods_id:that.data.goodID,
          comment:that.data.content,
          gask_type:typeID,
          hidden_name:that.data.isHiddenName ? "YES" : "NO"
        },function(data){
            wx.showToast({
                title: data.msg,
                icon: 'success'
            });
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
    //输入内容
    inputChange:function(event){
        const key = event.target.id
        const value = event.detail.value
        this.data[key] = value
    },
    //切换类型
    selectTypeAction:function(event){
        var selectInt = event.target.dataset.index;
        var typeInfoArr = [];
        for(var i = 0;i < this.data.typesArr.length;i++){
            var object = this.data.typesArr[i];
            object.isSelect = i == selectInt;
            typeInfoArr.push(object);
        }
        this.setData({
            typesArr:typeInfoArr,
        })  
    },
    //匿名切换
    switchChange:function(event){
        this.data.isHiddenName = event.detail.value
    },
    //拨打电话
    callPhone:function(){
        wx.makePhoneCall({
            phoneNumber:this.data.settingInfo.phone
        })
    }
})