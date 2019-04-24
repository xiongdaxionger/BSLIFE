var app = getApp()
//倒计时计时器
var timer = null
Page({
    data:{
        //是否为设置支付密码
        isSetPayPass:false,
        //是否显示加载失败的视图
        showFailNetWork:false,
        //是否需要验证手机号码--设置时通过登录密码验证/修改或忘记是否绑定手机号验证
        needVerifyPhone:false,
        //是否需要图形验证码
        needImageCode:false,
        //第一次输入的支付密码
        firstPayPassWord:"",
        //再次输入的支付密码
        seconPayPassWord:"",
        //输入的图形验证码--多次错误输入登录密码后要图形验证码
        imageCode:"",
        //手机短信验证码
        phoneCode:"",
        //输入的登录密码
        logInPassWord:"",
        //图形验证码的链接
        imageCodeURL:"",
        //手机号码
        phoneNumber:"",
        //获取短信验证码的秒倒计时
        second:120,
        //是否请求了短信验证码接口
        isLoadCodeRequest:false,
    },
    //启动短信倒计时
    startTimer:function(){
        var that = this
        if(timer != null){
            return
        }
        timer = setInterval(function () {
            if(that.data.second == 0){
                that.stopTimer()
                that.data.second = 120
                that.setData({
                    isLoadCodeRequest:false
                })
            }
            else{
                that.setData({
                    second:that.data.second - 1
                })
            }
      }, 1000);
    },
    //停止短信倒计时
    stopTimer:function(){
        if (timer != null) {
        clearInterval(timer);
        timer = null;
        }
    },
    //页面卸载
    onUnload:function(){
        this.stopTimer()
    },
    //页面加载
    onLoad:function(options){
        this.data.isSetPayPass = options.isSetPayPass == "true"
        if (this.data.isSetPayPass) {
            console.log("isSetPayPass")
            this.data.needVerifyPhone = false
            this.setData({
                isSetPayPass:this.data.isSetPayPass,
                needVerifyPhone:this.data.needVerifyPhone,
                showFailNetWork:false
            })
        }
        else{
            this.loadPayPassWordSettingInfo()
        }
    },
    //加载修改/忘记支付密码的数据
    loadPayPassWordSettingInfo:function(){
        var that = this
        app.request({
            "method":"b2c.member.verify",
            "verifyType":"verifypaypassword"
        },function(data){
            
            let needPhone = data.site_sms_valide == "true"
            that.data.needVerifyPhone = needPhone
            if(needPhone){
                that.data.phoneNumber = data.data.mobile
                that.data.needImageCode = data.show_varycode
                that.data.imageCodeURL = that.data.needImageCode ? data.code_url : ""
            }
            else{
                that.data.needImageCode = false
            }
            that.setData({
                needImageCode:that.data.needImageCode,
                imageCodeURL:that.data.imageCodeURL,
                needVerifyPhone:that.data.needVerifyPhone,
                phoneNumber:that.data.phoneNumber
            })
        },function(data){
            that.setData({
                showFailNetWork:true
            })
        },true,true,true)
    },
    //输入框回调
    textInput:function(event){
        let inputType = event.target.dataset.inputType
        let value = event.detail.value
        if(inputType == "login"){
            this.data.logInPassWord = value
        }
        else if(inputType == "firstPayPass"){
            this.data.firstPayPassWord = value
        }
        else if(inputType == "commitPayPass"){
            this.data.seconPayPassWord = value
        }
        else if(inputType == "imageCode"){
            this.data.imageCode = value
        }
        else{
            this.data.phoneCode = value
        }
    },
    //确认按钮
    buttonCommit:function(event){
      console.log("1-",this.data);
        if(this.data.needImageCode && this.data.imageCode.length == 0){
          console.log("1-");
            wx.showModal({
                title: "请输入图形验证码",
                content: "",
                showCancel: false
            })
            return
        }
        if(this.data.needVerifyPhone){
          console.log("2-");
            if(this.data.phoneCode.length == 0){
                wx.showModal({
                    title:"请输入手机验证码",
                    content:"",
                    showCancel:false
                })
                return
            }
        }
        else{
          console.log("3-");
            if(this.data.logInPassWord.length == 0){
                wx.showModal({
                    title:"请输入登录密码",
                    content:"",
                    showCancel:false
                })
                return
            }
        }

        if(this.data.firstPayPassWord.length == 0){
            wx.showModal({
                title:"请输入支付密码",
                content:"",
                showCancel:false
            })
            return
        }
        else{
            if(this.data.firstPayPassWord.length < 6){
                wx.showModal({
                    title:"请输入6位的支付密码",
                    content:"",
                    showCancel:false
                })
                return
            }
        }

        if(this.data.seconPayPassWord.length == 0){
            wx.showModal({
                title:"请再次输入支付密码",
                content:"",
                showCancel:false
            })
            return
        }
        else{
            if(this.data.seconPayPassWord.length < 6){
                wx.showModal({
                    title:"请输入6位的支付密码",
                    content:"",
                    showCancel:false
                })
                return
            }
        }
        
        if(this.data.seconPayPassWord.length != 0 && this.data.firstPayPassWord.length != 0){
            if(this.data.seconPayPassWord != this.data.firstPayPassWord){
                wx.showModal({
                    title:"两次输入的密码不一致，请更改",
                    content:"",
                    showCancel:false
                })
                return
            }
        }

        var params = {};
        const data = this.data;
        var that = this;

        if(data.isSetPayPass){
            //设置支付密码
            console.log("4-");
            params["method"] = "b2c.member.verify_vcode2"
            params["password"] = data.logInPassWord
            params["pay_password"] = data.firstPayPassWord
            params["re_pay_password"] = data.seconPayPassWord
            params["verifyType"] = "setpaypassword"
            if(data.needImageCode){
              console.log("4-1",data.needImageCode);
              params["verifycode"] = data.imageCode
            }
        }
        else{
            //修改支付密码
          console.log("5-");
            params['method'] = 'b2c.member.verify_vcode2';
            params['verifyType'] = 'verifypaypassword';
            params['pay_password'] = data.firstPayPassWord;
            params['re_pay_password'] = data.seconPayPassWord;
  
          if (data.needVerifyPhone){
            //修改密码或忘记密码--通过手机验证修改或重设
            
            params['send_type'] = 'mobile';
            params['vcode[mobile]'] = data.phoneCode;
            params['mobile'] = data.phoneNumber;
          }else{
            params['password'] = data.logInPassWord;
          }

        }

        app.request(params, function (data) {
          console.log("6-");
          if (data.isSetPayPass){
            app.globalData.has_pay_password = true
            wx.setStorageSync('paypassword', { "paypassword": that.data.firstPayPassWord });
          }
          wx.navigateBack({
            delta: 1
          })
        }, function (msg, data) {
          wx.hideToast();
          if (data != null) {
            let codeURL = data.code_url
            if (codeURL != null) {
              that.data.needImageCode = true
              that.setData({
                needImageCode: that.data.needImageCode,
                imageCodeURL: codeURL + "?" + new Date().getTime()
              })
            }
          }
        }, true, true, true)

    },
    //重载验证码
    tapImageCode:function(){
        var imageCodeURL = this.data.imageCodeURL;
        if(imageCodeURL != null && imageCodeURL.length > 0){
             this.setData({
            imageCodeURL: imageCodeURL + "?" + new Date().getTime(),
        });
        }
    },
    //重载信息
    reloadData:function(){
       this.loadPayPassWordSettingInfo() 
    },
    //获取短信验证码
    getPhoneCode:function(){
        if(this.data.isLoadCodeRequest){
            return
        }
        if(this.data.needImageCode && this.data.imageCode.length == 0){
            wx.showModal({
                title:"请输入图形验证码",
                content:"",
                showCancel:false
            })
            return
        }
        var that = this
        let param = {
            "method":"b2c.passport.send_vcode_sms",
            "type":"activation",
            "uname":that.data.phoneNumber
        }
        if(this.data.needImageCode){
            param["sms_vcode"] = this.data.imageCode
        }
        app.request(param,
        function(data){
            that.startTimer()
            that.setData({
                isLoadCodeRequest:true
            })
        },function(data){
            wx.hideToast();
                        that.startTimer()
            that.setData({
                isLoadCodeRequest:true
            })
        },
        true,true,true)        
    },
})