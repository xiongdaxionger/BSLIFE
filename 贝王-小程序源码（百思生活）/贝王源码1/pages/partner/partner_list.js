// pages/partner/partner_list.js

var util = null;
var app = getApp();

Page({
  data: {
    imgURL: app.getImgURL(),
    fail: false, //是否加载失败
    partner_infos: null, //会员信息
    searchKey: '', //搜索关键字
    inputSearchKey: '', //输入的关键字
    searching: false, //是否正在搜索

    select_partner: false, //是否是选择会员
    hierarchy: 0, //可查看的层级 小于等于1时无法查看团队

    load_more: false, //是否在加载更多
    total_size: 0, //商品列表总数
    page: 0, //当前页码

    showScrollToTop: false, //是否显示回到顶部按钮
    scroll_top: 0, //回到顶部
    loading: false, //是否正在加载
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    wx.removeStorageSync('addPartnerResult');
    util = require('../../utils/util.js');

    // 如果是选择会员要传 select_partner 参数
    if (options.select_partner == 'true') {
      this.data.select_partner = true;
    }
    this.loadPartnerInfo();
  },

  onUnload: function () {
    // 页面关闭
    util = null;
  },

  onShow:function(){
    // 添加会员成功，刷新列表
    var result = wx.getStorageSync('addPartnerResult');
    if(result){
      wx.removeStorageSync('addPartnerResult');
      this.setData({
        page: 0,
        partner_infos: null
      })
      this.loadPartnerInfo();
    }
  },

  // 容器滑动
  containerScroll: function (event) {
    const y = event.detail.scrollTop;
    // 屏幕高度
    const height = app.globalData.systemInfo.windowHeight;
    this.setData({
      showScrollToTop: y >= height * 2
    })
  },

  // 回到顶部
  scrollToTop: function () {
    this.setData({
      scroll_top: 1
    })
    // 必须要有改变才会刷新Ui的
    this.setData({
      scroll_top: 0
    })
  },

  // 添加会员
  addPartner: function (event) {
    wx.navigateTo({
      url: '/pages/partner/partner_add_list'
    })
  },

  // 点击会员
  tapPartner: function (event) {
    const info = this.data.partner_infos[event.currentTarget.dataset.index];


    // 选择会员
    if (this.data.select_partner) {
      wx.setStorageSync('selectedPartnerInfo', info);
      wx.navigateBack({
        delta: 1, // 回退前 delta(默认为1) 页面
      })
    } else {
      // 查看会员详情
      wx.setStorageSync('tapPartnerInfo', info);
      const url = "/pages/partner/partner_detail?hierarchy=" + this.data.hierarchy;
     
      wx.navigateTo({
        url: url
      })
    }
  },

  // 搜索
  doSearch: function () {
    this.searchDidEnd();
  },

  // 搜索输入改变
  searchDidChange: function (event) {
    this.data.inputSearchKey = event.detail.value;
  },

  //开始搜索
  searchDidBegin: function () {
    this.setData({
      searching: true
    })
  },

  // 结束搜索
  searchDidEnd: function () {
    if (this.data.loading)
      return;
    this.setData({
      searching: false
    })
    const inputSearchKey = this.data.inputSearchKey;
    if (inputSearchKey != this.data.searchKey) {
      this.setData({
        searchKey: inputSearchKey,
        page: 0,
        partner_infos: null
      })
      this.loadPartnerInfo();
    }
  },

  // 加载会员信息
  loadPartnerInfo: function () {

    const that = this;
    const data = this.data;
    const page = data.page;
    var params = {
      'member_id': app.globalData.userInfo.userId,
      method: 'distribution.fxmem.all_members',
      page: page + 1
    }

    const searchKey = data.searchKey;
    if (searchKey != null && searchKey.length > 0) {
      params['keyword'] = searchKey;
    }

    app.request(params, function (data) {

      // 加载成功
      that.parsePartnerInfos(data);
    }, function () {

      const fail = data.load_more;
      that.setData({
        fail: !fail,
        load_more: false
      })
    }, page == 0 && !data.searching)
  },

  // 解析会员信息
  parsePartnerInfos: function (data) {
    var items = data.List;
    var partner_infos = this.data.partner_infos;

    // 信息
    if (items != null) {
      var infos = new Array();
      for (var i = 0; i < items.length; i++) {
        const obj = items[i];
        infos.push(this.partnerInfoFromObj(obj));
      }
      if (partner_infos == null) {
        partner_infos = infos;
      } else {
        Array.prototype.push.apply(partner_infos, infos);
      }
    }

    this.setData({
      partner_infos: partner_infos,
      hierarchy: data.show_lv,
      load_more: false,
      fail: false,
      page: this.data.page + 1
    })

    // 会员总数
    this.data.total_size = data.pager.dataCount;
  },

  // 创建会员信息对象
  partnerInfoFromObj: function (obj) {
    var info = new Object();
    info.user_id = obj.member_id;
    info.name = obj.name;
    info.mobile = obj.mobile;
    info.img = obj.avatar;
    info.order_count = obj.order_num;
    info.amount = obj.income;
    info.referral_num = obj.nums;

    const addObj = obj.addr;
    if (addObj != null) {
      info.addr = addObj.area;
    } else {
      info.addr = '';
    }

    info.time = util.formatTimesamp(obj.regtime, 2);

    return info;
  },

  // 加载更多
  loadMore: function () {
    const infos = this.data.partner_infos;
    if (infos.length < this.data.total_size && !this.data.load_more) {
      this.setData({
        load_more: true
      })
      //可以加载
      this.loadPartnerInfo();
    }
  },

  // 重新加载
  reloadData: function () {
    this.setData({
      partner_infos: null,
      page: 0
    })
    this.loadPartnerInfo();
  }
})