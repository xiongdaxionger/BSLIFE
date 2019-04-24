var app = getApp()
var util = null;
Page({
    data:{
        //手机号码
        mobile:"",
        //邮箱
        email:"",
        //商品ID
        goodID:"",
        //货品ID
        productID:""
    },
    //界面加载
    onLoad:function(options){
        util = require('../../utils/string.js')
        this.data.goodID = options.goodid
        this.data.productID = options.productid
    },
    //页面卸载
    onUnload:function(){
      util = null
    },
    //输入更改
    inputChange:function(event){
        const key = event.target.id;
        const value = event.detail.value;
        this.data[key] = value;
    },
    //点击提交
    submitNotify:function(){
        if(this.data.mobile.length == 0 && this.data.email.length == 0){
            this.showMessage("请输入邮箱或手机号码")
            return
        }
        else{
            if (!util.isMobileNumber(this.data.mobile) && this.data.mobile.length != 0) {
            this.showMessage("请输入正确的手机号码")
            return;
            }
            if (!util.isEmail(this.data.email) && this.data.email.length != 0) {
            this.showMessage("请输入正确的邮箱")
            return;
            }
        }
        let param = {}
        param["method"] = "b2c.product.toNotify"
        param["goods_id"] = this.data.goodID
        param["product_id"] = this.data.productID
        if(this.data.mobile.length != 0){
            param["cellphone"] = this.data.mobile
        }
        else{
            param["email"] = this.data.email
        }
        app.request(param
        , function (data) {
            wx.showToast({
                title: "提交成功",
                icon: 'success'
            });
            wx.navigateBack({
              delta: 1,
            })
        }, function () {
            that.showMessage("提交失败，请重试")
    }, true, false, true);
    },
    //显示信息
    showMessage:function(message){
        wx.showModal({
            title:message,
            content:"",
            showCancel: false
        })
    },
})