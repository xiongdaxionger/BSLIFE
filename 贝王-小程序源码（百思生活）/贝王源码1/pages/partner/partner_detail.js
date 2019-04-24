// 会员详情

var app = getApp();
var util = null;

Page({
  data: {
    selectedIndex: 0, //选中的下标
    imgURL: app.getImgURL(),
    barInfo: [], //菜单信息

    intros: [], //用户简介信息

    partner_infos: null, //团队信息
    partner_load_more: false, //团队会员是否在加载更多
    partner_total_size: 0, //团队会员总数
    partner_page: 0, //团队会员当前页码

    order_infos: null, //订单信息
    order_load_more: false, //团队会员是否在加载更多
    order_total_size: 0, //订单总数
    order_page: 0, //订单当前页码

    showScrollToTop: false, //是否显示回到顶部按钮
    scroll_top: 0, //回到顶部

    userInfo: {}, //用户信息
    hierarchy: 0, //可查看的层级 小于等于1时无法查看团队
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数

    util = require('../../utils/util.js');
    const userInfo = wx.getStorageSync('tapPartnerInfo');
    wx.removeStorageSync('tapPartnerInfo');
    const intros = this.introsFromUserInfo(userInfo);
    const hierarchy = options.hierarchy;

    var barInfo = [
      '简介',
      '订单'
    ];
    if (hierarchy > 1) {
      barInfo.splice(1, 0, '团队');
    }

    this.setData({
      userInfo: userInfo,
      hierarchy: hierarchy,
      intros: intros,
      barInfo: barInfo
    })
  },

  onUnload: function () {
    // 页面关闭
    util = null;
  },

  // 获取会员简介
  introsFromUserInfo: function (userInfo) {
    // 会员简介
    return [
      {
        title: '累计下单：',
        content: userInfo.order_count
      },
      {
        title: '带来收益：',
        content: userInfo.amount
      },
      {
        title: '联系电话：',
        content: userInfo.mobile
      },
      {
        title: '收货地区：',
        content: userInfo.addr
      },
      {
        title: '注册时间：',
        content: userInfo.time
      }
    ]
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

  // 菜单改变
  barItemDidChange: function (event) {
    const index = parseInt(event.currentTarget.dataset.index)

    if (index == this.data.selectedIndex)
      return;
    this.setData({
      selectedIndex: index
    }
    )

    if (index == 0)
      return;

    if (this.selectPartner()) {
      if (this.data.partner_infos == null) {
        this.loadPartnerInfo();
      }
    } else {
      if (this.data.order_infos == null) {
        this.loadOrderInfo();
      }
    }
  },

  // 点击团队
  tapPartner: function (event) {
    const index = parseInt(event.currentTarget.dataset.index);
    var partner_infos = this.data.partner_infos;
    const info = partner_infos[index];
    const hierarchy = this.data.hierarchy - 1;
    // 查看会员详情
    wx.setStorageSync('tapPartnerInfo', info);
    const url = "/pages/partner/partner_detail?hierarchy=" + hierarchy;
    wx.redirectTo({
      url: url
    })
  },

  // 是否是选择团队
  selectPartner: function () {
    var selectPartner = false;
    if (this.data.selectedIndex == 1 && this.data.hierarchy > 1) {
      selectPartner = true;
    }

    return selectPartner;
  },

  // 加载团队信息
  loadPartnerInfo: function () {

    const that = this;
    const data = this.data;
    const page = data.partner_page;
    var params = {
      method: 'distribution.fxmem.all_members',
      page: page + 1,
      member_id: data.userInfo.user_id,
    }

    app.request(params, function (data) {

      // 加载成功
      that.parsePartnerInfos(data);
    }, function () {

      that.setData({
        partner_load_more: false
      })
    }, page == 0)
  },

  // 解析会员信息
  parsePartnerInfos: function (data) {
    var items = data.List;
    var partner_infos = this.data.partner_infos;

    // 商品信息
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
      partner_load_more: false,
      partner_page: this.data.partner_page + 1
    })

    // 会员总数
    this.data.partner_total_size = data.pager.dataCount;
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

    info.time = util.formatTimesamp(obj.regtime);

    return info;
  },

  // 加载订单信息
  loadOrderInfo: function () {
    const that = this;
    const data = this.data;
    const page = data.order_page;
    var params = {
      method: 'b2c.member.orders',
      member_id: data.userInfo.user_id,
      is_fx: false,
      order_status: 'all',
      page: page + 1
    }

    app.request(params, function (data) {

      // 加载成功
      that.parseOrderInfos(data);
    }, function () {

      that.setData({
        order_load_more: false
      })
    }, page == 0)
  },

  // 解析订单信息
  parseOrderInfos: function (data) {
    var orders = data.orders;
    var order_infos = this.data.order_infos;

    // 订单信息
    if (orders != null) {
      var infos = new Array();
      for (var i = 0; i < orders.length; i++) {
        const obj = orders[i];
        infos.push(this.orderInfoFromObj(obj));
      }
      if (order_infos == null) {
        order_infos = infos;
      } else {
        Array.prototype.push.apply(order_infos, infos);
      }
    }

    this.setData({
      order_infos: order_infos,
      order_load_more: false,
      order_page: this.data.order_page + 1
    })

    // 会员总数
    this.data.partner_total_size = data.pager.dataCount;
    
  },

  // 创建订单信息对象
  orderInfoFromObj: function (obj) {

    var info = new Object();
    const status = obj.status_txt;
    var statusString = '';
    for (var i = 0; i < status.length; i++) {
      var statusObj = status[i];
      statusString += statusObj.name;
    }
    info.status = statusString;

    const goods = obj.goods_items;
    if (goods != null && goods.length > 0) {
      const goodObj = goods[0];
      info.img = goodObj.thumbnail_pic;
      info.name = goodObj.name;
    }

    if (obj.cur_amount == null || obj.cur_amount.length == 0) {
      info.amount = obj.total_amount;
    } else {
      info.amount = obj.cur_amount;
    }

    info.time = util.formatTimesamp(obj.createtime, 0);

    return info;
  },

  // 加载更多
  loadMore: function () {
    const data = this.data;
    if (this.selectPartner()) {
      const infos = data.partner_infos;
      if (infos.length < data.partner_total_size && !data.partner_load_more) {
        this.setData({
          partner_load_more: true
        })
        //可以加载
        this.loadPartnerInfo();
      }
    } else {
      const infos = data.order_infos;
      if (infos.length < data.order_total_size && !data.order_load_more) {
        this.setData({
          order_load_more: true
        })
        //可以加载
        this.loadOrderInfo();
      }
    }
  },
})