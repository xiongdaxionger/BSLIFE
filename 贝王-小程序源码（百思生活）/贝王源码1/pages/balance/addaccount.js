//添加提现账号页面
var app = getApp()
var timer = null
var stringUtil = null
Page({
    data:{
        //选项卡选中下标
        selectIndex:0,
        //图片前面域名
        imgURL: app.getImgURL(),
        //手机号码
        mobile:app.globalData.userInfo.phoneNumber,
        //秒数
        second:120,
        //是否请求了获取短信验证码
        isLoadCodeRequest:false,
        //银行卡号
        bank_number:"",
        //持卡人
        bank_person:"",
        //发卡银行
        bank_name:"",
        //支付宝账号
        ali_number:"",
        //支付宝账号名称
        ali_name:"",
        //验证码
        code:"",
        //银行卡数组
        bankNamesArr:[],
        //快递公司弹出动画
        companyTranslateAnimation: null,
        /**背景动画**/
        backgroundOpacityAnimation: null, 
        //是否显示银行公司
        isShowCompany:false,
    },
    //页面加载
    onLoad:function(options){
        stringUtil = require('../../utils/string.js')
        this.loadBankInfo()
    },
    //页面卸载
    onUnload:function(){
        this.stopTimer()
        stringUtil = null
    },
    //加载银行信息
    loadBankInfo:function(){
        var that = this
        app.request({
            "method":"b2c.wallet.banklist"
        },
        function(data){
            for(var i in data){
                that.data.bankNamesArr.push(i)
            }
        },function(data){  
        },
        true,true,true)  
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
    //添加账号
    submitAddAccount:function(){
        if(this.data.selectIndex == 0){
            if(this.data.bank_number.length == 0){
                this.showMessage("请输入银行卡号")
                return
            }
            else if(this.data.bank_number.length < 10){
                this.showMessage("请输入有效的银行卡号")
                return
            }

            if(this.data.bank_person.length == 0){
                this.showMessage("请输入持卡人姓名")
                return
            }

            if(this.data.bank_name.length == 0){
                this.showMessage("请选择发卡银行")
                return
            }
        }
        else{
            if(this.data.ali_number.length == 0){
                this.showMessage("请输入支付宝账号")
                return
            }

            if(!stringUtil.isMobileNumber(this.data.ali_number) && !stringUtil.isEmail(this.data.ali_number)){
                this.showMessage("请输入有效的支付宝账号")
                return
            }

            if(this.data.ali_name.length == 0){
                this.showMessage("请输入支付宝用户名")
                return
            }
        }

        if(this.data.code.length == 0){
            this.showMessage("请输入验证码")
            return
        }

        if(this.data.code.length < 6){
            this.showMessage("请输入有效的验证码")
            return
        }

        let param = {
            "method":"b2c.wallet.addbankcard",
            "vcode":this.data.code,
            "mobile":this.data.moblie
        }
        if(this.data.selectIndex == 0){
            param["bank_type"] = "1"
            param["bank_num"] = this.data.bank_number
            param["bank_name"] = this.data.bank_name
            param["real_name"] = this.data.bank_person
        }
        else{
            param["bank_type"] = "2"
            param["bank_num"] = this.data.ali_number
            param["bank_name"] = "支付宝"
            param["real_name"] = this.data.ali_name
        }
        var that = this
        app.request(param,
        function(data){
            wx.showToast({
                title: '添加账户成功',
                icon: 'success'
            });
            wx.navigateBack({
              delta: 1, // 回退前 delta(默认为1) 页面
            })
        },function(data){
            that.showMessage("添加账户失败，请重试")
        },
        true,true,true) 
    },
    //显示信息
    showMessage:function(message){
        wx.showModal({
            title: message,
            content: "",
            showCancel: false
        });
    },
    //输入改变
    inputChange:function(event){
        const key = event.target.id
        const value = event.detail.value
        this.data[key] = value
    },
    //获取短信验证码
    getPhoneCode:function(){
        if(this.data.isLoadCodeRequest){
            return
        }
        var that = this
        let param = {
            "method":"b2c.passport.send_vcode_sms",
            "type":"activation",
            "uname":that.data.mobile
        }
        app.request(param,
        function(data){
            that.startTimer()
            that.setData({
                isLoadCodeRequest:true
            })
        },function(data){
            wx.hideToast()
            that.startTimer()
            that.setData({
                isLoadCodeRequest:true
            })
        },
        true,true,true)   
    },
    //选择银行
    selectBank:function(){
        this.setData({
            isShowCompany: true,
            bankNamesArr:this.data.bankNamesArr
        })
        this.bankViewAnimation(true)
    },
    //关闭物流公司信息
    closeBankCompany:function(){
        this.bankViewAnimation(false)
        var that = this
        var timer = setTimeout(function () {
            that.setData({
                isShowCompany: false,
                bank_name:that.data.bank_name
            })
            clearTimeout(timer);
        }, 400)
    },
    //物流公司动画
    bankViewAnimation: function(show) {
        var that = this;
        //屏幕高度
        const height = app.globalData.systemInfo.windowHeight;
        var animation = wx.createAnimation({
            duration: 400,
        });
        //修改透明度,偏移
        let padding_height = (height - 350) + 44
        this.setData({            
            backgroundOpacityAnimation: animation.opacity(show ? 1 : 0).step().export(),
            companyTranslateAnimation: animation.translateY(show ? (-padding_height) : (padding_height)).step().export()
        })
    },
    //切换类型
    selectType:function(event){
        this.setData({
            selectIndex:event.target.dataset.index,
            bank_number:this.data.bank_number,
            bank_person:this.data.bank_person,
            bank_name:this.data.bank_name,
            ali_number:this.data.ali_number,
            ali_name:this.data.ali_name
        })
    },
    //选中发卡银行
    didSelectBank:function(event){
        this.data.bank_name = event.target.dataset.index
        this.closeBankCompany()
    }

})