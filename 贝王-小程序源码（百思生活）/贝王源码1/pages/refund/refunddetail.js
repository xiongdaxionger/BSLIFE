var app = getApp()
Page({
    data:{
        //订单ID
        orderID:"",
        //是否为退款订单
        isMoneyRefund:false,
        //类型
        refundType:"",
        //退款/售后类型数组
        refundTypesArr:[],
        //商品数组
        goodsArr:[],
        //图片前面域名
        imgURL: app.getImgURL(), 
        //选中图片
        selectImage:"",
        //未选中图片
        unselectImage:"",
        //退款金额
        refundMoney:0.00,
        //理由
        reason:"",
        //详细描述
        content:"",
        //选择的图片
        images: [],
    },
    //页面加载
    onLoad:function(options){
        
        this.data.orderID = options.orderid
        this.data.refundType = options.type
        this.data.isMoneyRefund = options.type == "refund"
        this.data.selectImage = this.data.imgURL + "/images/shopcart/shop_Car_Select.png"
        this.data.unselectImage = this.data.imgURL + "/images/shopcart/shop_Car_UnSelect.png"
        this.getRefundDetailInfo(true)
    },
    //获取退款/退换信息
    getRefundDetailInfo:function(showLoading){
        var that = this
        app.request({
            "method":"aftersales.aftersales.add",
            "order_id":that.data.orderID,
            "type":that.data.refundType
        },function(data){
            let tmpTypesArr = data.refund_type
            let typesArr = []
            for(var i = 0;i < tmpTypesArr.length;i++){
                let object = tmpTypesArr[i]
                let info = {
                    //类型名称
                    name:object.name,
                    //类型ID
                    value:object.value,
                    //是否选中
                    isSelect:i == 0
                }
                typesArr.push(info)
            }
            let tmpGoodsArr = data.goods_items
            let goodsArr = []
            for(var j = 0;j < tmpGoodsArr.length;j++){
                let object = tmpGoodsArr[j]
                let num = object.num == null ? object.quantity : object.num
                let info = {
                    //bn码
                    bnCode:object.bn,
                    //货品ID
                    productID:object.product_id,
                    //图片
                    imageURL:object.thumbnail_pic == null ? object.image_default_id : object.thumbnail_pic,
                    //购买数量
                    quantiy:parseInt(num),
                    //价格
                    salePrice:object.price,
                    //格式化价格
                    formatPrice:object.price_format,
                    //商品名称
                    name:object.name,
                    //最终申请数量
                    finalQuantiy:parseInt(num),
                    //是否选中
                    isSelect:false
                }
                goodsArr.push(info)
            }
            that.setData({
                goodsArr:goodsArr,
                refundTypesArr:typesArr,
                showFailNetWork:false,
                isMoneyRefund:that.data.isMoneyRefund,
                selectImage:that.data.selectImage,
                unselectImage:that.data.unselectImage,
                refundMoney:that.data.refundMoney
            })
        },function(data){
            that.setData({
                showFailNetWork:true
            })
        },showLoading,true,true)
    },
    //重载网络
    reloadData:function(){
        this.getRefundDetailInfo(true)
    },
    //提交退款/退货
    submitRefund:function(){
        var hasSelectGood = false
        var param = {}
        for(var i = 0;i < this.data.goodsArr.length;i++){
            let model = this.data.goodsArr[i]
            
            if(model.isSelect){
                hasSelectGood = true
                param["product_bn[" + model.productID + "]"] = model.bnCode
                param["product_nums[" + model.productID + "]"] = model.finalQuantiy
                param["product_name[" + model.productID + "]"] = model.name
                param["product_price[" + model.productID + "]"] = model.salePrice
            }
        }
        if(!hasSelectGood){
            wx.showModal({
                title: "请选择商品",
                content: "",
                showCancel: false
            });
            return
        }
        if(this.data.reason.length == 0){
            wx.showModal({
                title: "请输入申请理由",
                content: "",
                showCancel: false
            });
            return
        }
        var that = this
        param["method"] = "aftersales.aftersales.return_save"
        param["order_id"] = this.data.orderID
        param["title"] = this.data.reason
        param["agree"] = "on"
        if(this.data.content.length != 0){
            param["content"] = this.data.content
        }
        if(this.data.images.length != 0){
            for(var i = 0;i < this.data.images.length;i++){
                let obj = this.data.images[i]
                param["file[" + i + "]"] = obj.image_id
            }
        }
        for(var j = 0;j < this.data.refundTypesArr.length;j++){
            let model = this.data.refundTypesArr[j]
            if(model.isSelect){
                param["type"] = model.value
                break
            }
        }
        app.request(param
        ,function(data){
            wx.showToast({
                title: '申请成功',
                icon: 'success'
            });
            wx.navigateBack({
                delta: 1,
            })
        },function(data){
            wx.showModal({
                title: "申请失败，请重试",
                content: "",
                showCancel: false
            });
        },true,true,true)
    },
    //选择商品
    selectGood:function(event){
        let index = event.target.dataset.index
        let model = this.data.goodsArr[index]
        model.isSelect = !model.isSelect
        let newMoney = this.getRefundMoney()
        this.setData({
            goodsArr:this.data.goodsArr,
            refundMoney:newMoney
        })
    },
    //减少商品
    minusGoodAction:function(event){
        let index = event.target.dataset.index
        let model = this.data.goodsArr[index]
        if(model.finalQuantiy == 1){
            return
        }
        model.isSelect = true
        model.finalQuantiy = model.finalQuantiy - 1
        let newMoney = this.getRefundMoney()
        this.setData({
            goodsArr:this.data.goodsArr,
            refundMoney:newMoney
        })
    },
    //增加商品
    addGoodAction:function(event){
        let index = event.target.dataset.index
        let model = this.data.goodsArr[index]
        if(model.finalQuantiy == model.quantity){
            wx.showModal({
                title: "申请数量大于购买数量",
                content: "",
                showCancel: false
            });
            return
        }
        model.isSelect = true
        model.finalQuantiy = model.finalQuantiy + 1
        let newMoney = this.getRefundMoney()
        this.setData({
            goodsArr:this.data.goodsArr,
            refundMoney:newMoney
        })
    },
    //类型更改
    typeChange:function(event){
        let index = event.target.dataset.index
        for(var i = 0;i < this.data.refundTypesArr.length;i++){
            let model = this.data.refundTypesArr[i]
            model.isSelect = index == i
        }
        this.setData({
            refundTypesArr:this.data.refundTypesArr
        })        
    },
    //输入更改
    inputChange:function(event){
        const key = event.target.id
        const value = event.detail.value
        this.data[key] = value
    },
    //获取金额
    getRefundMoney:function(){
        let newMoney = 0.0
        for(var i = 0;i < this.data.goodsArr.length;i++){
            let model = this.data.goodsArr[i]
            if(model.isSelect){
                newMoney = newMoney + parseFloat(model.salePrice) * parseFloat(model.finalQuantiy)
            }
        }
        return newMoney
    },
    // 删除图片
    deleteImg:function(event){
        const index = event.currentTarget.dataset.index;
        var images = this.data.images;
        images.splice(index, 1);
        this.setData({
        images: images
        })
    },

    // 选择相片相片
    tapCamera: function (event) {
        const that = this;
        var images = this.data.images;
        wx.chooseImage({
        count: 3 - images.length, // 最多可以选择的图片张数，默认9
        sizeType: ['compressed'], // original 原图，compressed 压缩图，默认二者都有
        sourceType: ['album', 'camera'], // album 从相册选图，camera 使用相机，默认二者都有
        success: function (res) {
            // success
            const tempFilePaths = res.tempFilePaths;
            if (tempFilePaths != null) {
            for (var i = 0; i < tempFilePaths.length; i++) {
                var obj = new Object();
                obj.file_url = tempFilePaths[i];
                obj.uploading = true;
                obj.uploadFail = false;
                images.push(obj);
                that.uploadImage(obj);
                }
            }
            that.setData({
                images: images
            })
            }
        })
    },

    // 上传图片
    uploadImage:function(obj){
        const that = this;
        const images = this.data.images;
        app.request({
                method: 'b2c.member.uploadImg'
                }, function (data) {
                obj.image_id = data.imgpath;
                obj.image_path = data.imgurl;
                obj.uploading = false;
                that.setData({
                    images: images
                })
                }, function () {
                obj.uploading = false;
                obj.uploadFail = true;
                that.setData({
                    images: images
                })
                }, false, false, false, obj.file_url, 'file');
    },

    // 点击上传图片失败
    tapUploadFail:function(event){
        const index = event.currentTarget.dataset.index;
        var images = this.data.images;
        var obj = images[index];
        const that = this;
        wx.showActionSheet({
        itemList:['重新上传', '删除'],
        success:function(res){
            switch(res.tapIndex){
            case 0 : 
                obj.uploading = true;
                obj.uploadFail = false;

                that.setData({
                images : images
                })
                that.uploadImage(obj);
                break;

                case 1 : 
                images.splice(index, 1);
                that.setData({
                images : images
                })
                break;
            }
        }
        })
    },
})