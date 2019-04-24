var app = getApp();
Page({
    data: {
        //能否选择地址
        canSelectAddress: false,
        //地址数据数组
        addressListInfoArr: [],
        /**是否显示加载失败的视图**/
        showFailNetWork: false,

        // 当前选中的
        selectedIndex: -1,
        //会员ID
        memberID:"",
        isEdit:false, //是否是编辑
    },
    //页面加载
    onLoad: function (options) {
        // 清除旧的信息
        wx.removeStorageSync('delete_addr_id');
        wx.removeStorageSync('add_addr_info');

        this.data.canSelectAddress = options.canSelect == "true"
        this.data.memberID = options.memberID
        this.loadAddressListInfo(true)
    },

    onShow: function () {

        var addressListInfoArr = this.data.addressListInfoArr;
        const selectedIndex = this.data.selectedIndex;
        if (selectedIndex == -1)
            return;

        // 删除收货地址
        const delete_addr_id = wx.getStorageSync('delete_addr_id');
 
        if (delete_addr_id != null && delete_addr_id.length > 0) {
            addressListInfoArr.splice(selectedIndex, 1);
            this.setData({
                addressListInfoArr: addressListInfoArr,
                selectedIndex: -1
            })
        } else {
            
            const add_addr_info = wx.getStorageSync('add_addr_info');
            
            if (add_addr_info != null && add_addr_info instanceof Object) {
                // 如果编辑的地址变成默认的，去除以前的默认
                if(add_addr_info.isDefault){
                    for(let i = 0;i < addressListInfoArr.length;i ++){
                        let info = addressListInfoArr[i];
                        if(info.isDefault){
                            info.isDefault = false;
                            break;
                        }
                    }
                }
                if(this.data.isEidt){
                    addressListInfoArr.splice(selectedIndex, 1 , add_addr_info);
                }else{
                    addressListInfoArr.push(add_addr_info);// 新增收货地址
                }
                
                this.setData({
                    addressListInfoArr: addressListInfoArr,
                    selectedIndex: -1
                })
            }
        }
        this.loadAddressListInfo(true)
    },

    //获取地址信息
    loadAddressListInfo: function (showLoading) {
        var that = this;
        app.request({
            method: "mobileapi.member.receiver",
            member_id: that.data.memberID
        }, function (data) {
            let receiverArr = data.receiver;
            let infoArr = [];
            if(receiverArr != null){
                for (var i = 0; i < receiverArr.length; i++) {
                let object = receiverArr[i];
                let isDefault = object.def_addr == 1 ? true : false;
                let areaStringArr = object.area.split(":");
                let model = {
                    //地址ID
                    addressID: object.addr_id,
                    //地址收货人
                    personName: object.name,
                    //地址组合
                    detailAddr: object.txt_area + object.addr,
                    //地址收货人联系
                    mobile: object.mobile,
                    //json字符串
                    value: object.value,
                    //是否为默认地址
                    isDefault: isDefault,
                    //区域ID
                    areaID: areaStringArr[2]
                }
                infoArr.push(model);
            }
            }
            that.setData({
                showFailNetWork: false,
                addressListInfoArr: infoArr
            })
        }, function (data) {
            that.setData({
                showFailNetWork: true
            })
        }, showLoading, true, true)
    },
    //编辑地址
    editButtonAction: function (event) {
        this.data.isEidt = true;
        this.data.selectedIndex = event.currentTarget.dataset.index;
        wx.navigateTo({
            url: '/pages/addresslist/address_edit?id=' + event.currentTarget.dataset.addr_id
        })
    },
    //选中地址
    selectAddressAction: function (event) {
        if (this.data.canSelectAddress) {
            let model = {
                addr: event.target.dataset.addr,
                addressID: event.target.dataset.addressId,
                areaID: event.target.dataset.areaId,
                mobile: event.target.dataset.mobile,
                name: event.target.dataset.name,
                value: event.target.dataset.value
            }
            wx.setStorageSync('selectAddress', model);
            wx.navigateBack({
                delta: 1
            })
        }
    },

    // 新增收获地址
    addAddressAction: function () {
        this.data.isEidt = false;
        this.data.selectedIndex = 0;
        wx.navigateTo({
            url: '/pages/addresslist/address_edit'
        })
    }
})