// pages/addresslist/address_edit.js
var app = getApp();
var area_selected = null;
var stringJs = null;

Page({
  data: {
    id: null, //地址id，如果是编辑收货地址则大于0
    userId: null, //要获取的用户id, null则表示使用当前登录用户的

    isDefault: false, //是否是默认收货地址
    consignee: null, //收货人
    mobile: null, //手机号
    mainland: null, //上传用的
    detail_address: null, //详细地址
    area_content: '', //省市区组合

    fail: false, //加载失败

    loading: true, //是否需要加载

    confirmEnable: false, //是否可以保存

    areaTranslateAnimation: null, //地区弹出动画
    areaOpacityAnimation: null, //地区透明动画
    is_load_area: false, //是否正在加载地区信息
    cur_area_infos: null, //当前选择地区信息
    show_area: false, //是否显示地区
    area_selectedIndex: 0, //选中的地区
    area_scroll_top: 0, //回到顶部

    imgURL: app.getImgURL(), //图片前面域名
  },

  // 打开地区
  areaShow: function () {
    area_selected.show();
  },

  // 关闭地区
  areaClose: function () {
    area_selected.areaClose();
  },

  // 地区菜单按钮改变
  areaBarItemDidChange: function (event) {
    area_selected.areaBarItemDidChange(event);
  },

  //地区页面改变
  areaPageDidChange: function (event) {
    area_selected.areaPageDidChange(event);
  },

  // 点击地区行
  tapAreaItem: function (event) {
    area_selected.tapAreaItem(event);
  },

  // 选择地区完成
  areaDidDone: function (mainland, content) {

    this.setData({
      mainland: mainland,
      area_content: content
    });
    area_selected.setSelectedAreaInfos(this.data.cur_area_infos);
    this.detectSave();
  },

  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    stringJs = require("../../utils/string.js");
    // app = ;
    area_selected = require("../../views/widget/area_selected.js");

    const id = options.id;
    this.data.userId = options.userId;

    if (id != null) {
      this.setData({
        id : id,
      })
      this.reloadData(); //编辑收获地址
    } else {
      this.setData({
        loading: false,
      })
    }
  },
  onReady: function () {
    // 页面渲染完成
    wx.setNavigationBarTitle({
      title: this.data.id != null ? '编辑收货地址' : '新增收货地址'
    })
  },
  onShow: function () {
    // 页面显示
    area_selected.init(this);
  },
  onUnload: function () {
    // 页面关闭
    // app = null;
    area_selected.clear();
    area_selected = null;
    stringJs = null;
  },

  // 打钩
  tick:function(){
    var isDefault = this.data.isDefault;
    this.setData({
      isDefault : !isDefault
    })
  },

  // 删除收货地址
  deleteAddr: function () {

    const that = this;
    wx.showModal({
      title: '确定删除此收货地址？',
      content: "",
      showCancel: true,
      confirmText: "删除",
      confirmColor: "#f73030",
      success: function (res) {
        if (res.confirm) {
          var params = {
            method: 'b2c.member.del_rec',
            addr_id: that.data.id
          }
          if (that.data.userId != null) {
            params.member_id = that.data.userId
          }
          app.request(params, function (data) {
            wx.showToast({
              title: '删除成功',
              icon: 'success'
            });
            wx.setStorageSync('delete_addr_id', that.data.id);
            wx.navigateBack({
              delta: 1, // 回退前 delta(默认为1) 页面
            })
          })
        }
      }
    });
  },

  // 文字输入改变
  textDidChange: function (event) {
    const key = event.target.id;
    const value = event.detail.value;
    const data = this.data;
    data[key] = value;
    this.detectSave();
  },

  // 是否可以保存
  detectSave: function () {
    const data = this.data;

    const consignee = data.consignee;
    const mobile = data.mobile;
    const mainland = data.mainland;
    const detail_address = data.detail_address;

    var confirmEnable = consignee != null && consignee.length > 0
      && mobile != null && mobile.length > 0
      && mainland != null && mainland.length > 0
      && detail_address != null && detail_address.length > 0;
    this.setData({
      confirmEnable: confirmEnable
    });
  },

  // 确定保存
  confirm: function () {
    const data = this.data;
    if (!data.confirmEnable)
      return;
    const mobile = data.mobile;
    if (!stringJs.isMobileNumber(mobile)) {
      wx.showModal({
        title: '请输入有效手机号',
        content: "",
        showCancel: false
      });
      return;
    }
    const consignee = data.consignee;
    const mainland = data.mainland;
    const detail_address = data.detail_address;
    const id = data.id;
    const isDefault = data.isDefault;
    const userId = data.userId;
    const area_content = data.area_content;

    const that = this;
    // 绑定手机号
    var params = {
      method: 'b2c.member.save_rec',
      mobile: mobile,
      addr: detail_address,
      area: mainland,
      name: consignee,
      def_addr: isDefault ? 1 : 0
    };

    if (id != null) {
      params.addr_id = id;
    }

    if (userId != null) {
      params.member_id = userId;
    }

    app.request(params, function (data) {

      // 保存成功
      let areaStringArr = data.area.split(":");
      let model = {
        addressID: data.addr_id,
        personName: data.name,
        detailAddr: area_content + data.addr,
        mobile: data.mobile,
        value: data.value,
        isDefault: data.def_addr == 1,
        areaID: areaStringArr[2]
      }
      wx.setStorageSync('add_addr_info', model)
      wx.showToast({
        title: '保存成功',
        icon: 'success'
      });
      wx.navigateBack({
        delta: 1, // 回退前 delta(默认为1) 页面
      })
    }, function () {

    }, true, true, true);
  },

  // 重新加载
  reloadData: function () {
    // 加载地址编辑信息
    const that = this;
    that.setData({
      fail: false
    })

    var params = {
      method: 'b2c.member.modify_receiver',
      addr_id: that.data.id
    };
    if (that.data.userId != null) {
      params.member_id = that.data.userId;
    }
    app.request(params, function (data) {

      const mainland = data.area;
      const area_content = area_selected.setMainland(mainland);
      that.setData({
        loading: false,
        mobile: data.phone.mobile,
        consignee: data.name,
        detail_address: data.addr,
        mainland: mainland,
        isDefault: data.default == 1,
        area_content: area_content
      })
      that.detectSave();
    }, function () {
      that.setData({
        fail: true
      })
    }, true, true, true);
  }
})