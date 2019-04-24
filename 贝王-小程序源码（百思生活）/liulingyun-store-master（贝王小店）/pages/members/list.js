var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    memberList:[],
    hiddenmodalput: true,
    memberRemoke:'',
    memberId:'',
    page:'1',
    total:'0',
    mem_birthday:'',
    milk:''
  },
  onLoad:function(){
    var userinfo = wx.getStorageSync('userinfo');
    var that = this;
    var params = {
      method: 'pos.store.all_members',
      member_id: userinfo.memberId,
      page: '1'
    };
    app.request(params, function (data) {
      that.setData({
        memberList: data.List,
        total: data.pager.total,
        page:'1'
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  // 调用我的会员接口
  allMembers:function(){
    var userinfo = wx.getStorageSync('userinfo');
    var that = this;
    var params = {
      method: 'pos.store.all_members',
      member_id: userinfo.memberId,
      page: that.data.page
    };
    app.request(params, function (data) {
      that.setData({
        memberList: that.data.memberList.concat(data.List),
        total: data.pager.total
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  onShow: function () {
    this.onLoad();
  },
  // 跳转到会员详情
  memberDetail:function(e){
    wx.navigateTo({
      url: './detail?id=' + e.currentTarget.dataset.id + '&price=' + e.currentTarget.dataset.price + '&order=' + e.currentTarget.dataset.arr.order_num + '&phone=' + e.currentTarget.dataset.arr.mobile + '&area=' + e.currentTarget.dataset.arr.area + '&regtime=' + e.currentTarget.dataset.arr.regtime + '&avatar=' + e.currentTarget.dataset.arr.avatar,
    })
  },
  // 设置备注信息
  remoke:function(e){
    var memberId = e.currentTarget.dataset.id;
    this.setData({
      hiddenmodalput: !this.data.hiddenmodalput,
      memberId: memberId,
      memberRemoke: e.currentTarget.dataset.remoke,
      mem_birthday: e.currentTarget.dataset.birthday,
      milk: e.currentTarget.dataset.milk,
    })
  },
  //取消按钮  
  cancel: function () {
    this.setData({
      hiddenmodalput: true,
      memberRemoke:'',
      memberId:'',
      mem_birthday:'',
      milk:''
    });
  },
  //确认备注
  confirm: function () {
    var that = this;
    var userinfo = wx.getStorageSync('userinfo');
    var params = {
      method: 'distribution.fxmem.mymember_remark',
      member_id: that.data.memberId,
      mymember_remark: that.data.memberRemoke,
      mem_birthday: that.data.mem_birthday,
      like_milk: that.data.milk,
      wx_pro_mid: userinfo.memberId
    };
    app.request(params, function (data) {
      that.setData({
        hiddenmodalput: true,
        memberRemoke: '',
        memberId: ''
      })
      wx.showToast({
        title: '备注成功',
        icon: 'success',
        duration: 2000,
        success:function(){
          that.onLoad();
        }
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  // 设置备注
  setRemoke:function(e){
    this.setData({
      memberRemoke: e.detail.value
    })
  },
  // 备注喜欢喝的牛奶
  milkblur:function(e){
    this.setData({
      milk: e.detail.value
    })
  },
  // 下拉刷新
  buttolower:function(e){
    var page = parseFloat(this.data.page) + 1;
    var memberList = this.data.memberList.length;
    var total = parseFloat(this.data.total);
    if (memberList >= total){
      return;
    }
    this.setData({
      page: page
    })
    this.allMembers();
  },
  // 搜索会员
  searchinp:function(e){
    var keyword = e.detail.value;
    var userinfo = wx.getStorageSync('userinfo');
    var that = this;
    var params = {
      method: 'pos.store.all_members',
      member_id: userinfo.memberId,
      page: '1',
      keyword: keyword
    };
    app.request(params, function (data) {
      that.setData({
        memberList: data.List,
        total: data.pager.total,
        page: '1',
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  bindDateChange:function(e){
    this.setData({
      mem_birthday: e.detail.value
    })
  }
  
})