var app = getApp();

Page({
    data:{
        //旧密码
        oldPass:"",
        //新密码
        newPass:"",
        //确认新密码
        confirmPass:""
    },
    //页面展示
    onLoad:function(options){

    },
    //内容输入
    textDidChange:function(event){
        let id = event.target.id
        if(id == "oldpass"){
            this.data.oldPass = event.detail.value
        }
        else if(id == "newpass"){
            this.data.newPass = event.detail.value
        }
        else{
            this.data.confirmPass = event.detail.value
        }
    },
    //确认修改密码
    commitChange:function(){
        var that = this
        if(this.data.oldPass.length == 0){
            this.showMessage("请输入原登录密码")
            return
        }
        else if(this.data.oldPass.length < 6){
            this.showMessage("请输入至少6位的密码")
            return
        }

        if(this.data.newPass.length == 0){
            this.showMessage("请输入新密码")
            return
        }
        else if(this.data.newPass.length < 6){
            this.showMessage("请输入至少6位的密码")
            return
        }

        if(this.data.confirmPass.length == 0){
            this.showMessage("请确认输入的新密码")
            return
        }
        else if(this.data.confirmPass.length < 6){
            this.showMessage("请输入至少6位的密码")
            return
        }

        if(this.data.confirmPass != this.data.newPass){
            this.showMessage("两次输入的新密码不一致")
            return
        }
        app.request({
            "method":"b2c.member.save_security",
            "old_passwd":that.data.oldPass,
            "passwd":that.data.newPass,
            "passwd_re":that.data.confirmPass
        },function(data){
            that.showMessage("修改登录密码成功")
        },function(data){
            that.showMessage("修改登录密码失败")
        },true,true,true)
    },
    //显示错误信息
    showMessage:function(message){
        wx.showModal({
            title:message,
            content:"",
            showCancel: false
        })
    },
})