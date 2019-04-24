// pages/integral/integral_sign_in.js

var app = getApp();

Page({
  data: {
    imgURL: app.getImgURL(),
    pig_image_url: "", //猪
    wallet_image_url: "", //钱包
    money_image_url: "", //钱
    top_bg_image_url: "", //顶部背景

    rule: "", //签到规则
    continuousSignInDay: "", //已连续签到天数
    signInNearDay: '', //签到的天数接近 的规则 天数
    signInNearIntegral: '', //签到的天数接近 的规则 积分

    fail: false, //是否加载失败
    good_infos: null, //商品信息

    load_more: false, //是否在加载更多
    total_size: 0, //商品列表总数
    page: 0, //当前页码
    loading: true, //是否在加载

    showScrollToTop: false, //是否显示回到顶部按钮
    scroll_top: 0, //回到顶部

    previous_page_integral: false, //前一个是否是积分界面
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    this.data.previous_page_integral = options.integral == 'true';

    var httpRequest = require('../../utils/httpRequest.js');
    const domain = httpRequest.getDomain() + 'wap/images/integral_';
    this.setData({
      pig_image_url: domain + 'pig.png',
      wallet_image_url: domain + 'wallet.png',
      money_image_url: domain + 'money.png'
    })
    httpRequest = null;

    this.signin();
  },

  // 点击商品
  tapGood: function (event) {
    const index = parseInt(event.currentTarget.dataset.index);
    var info = this.data.good_infos[index];
    wx.navigateTo({
      url: '/pages/gooddetail/gooddetail?' + 'goodID=' + info.good_id + '&productID=' + info.product_id + '&isGift=' + true,
    })
  },

  // 我的积分
  myIntegral: function () {
    if (this.data.previous_page_integral) {
      wx.navigateBack({
        delta: 1 // 回退前 delta(默认为1) 页面
      })
    } else {
      wx.navigateTo({
        url: '/pages/integral/integral?integral=true'
      })
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

  // 签到
  signin: function () {
    const that = this;
    this.setData({
      loading: true
    })
    app.request({
      method: 'b2c.member.signin'
    }, function (data, org) {
      that.parseSignInInfo(data, org);
    }, function () {
      that.setData({
        fail: true,
        loading: false
      })
    }, true, true, true)
  },

  // 解析签到信息
  parseSignInInfo: function (data, org) {
    const data1 = data.data;

    // 签到规则
    const rule = data1.rule;
    var rules = new Array();
    if (rule.new != null) {
      rules.push(rule.new);
    }
    if (rule.one != null) {
      rules.push(rule.one);
    }
    if (rule.two != null) {
      rules.push(rule.two);
    }
    if (rule.three != null) {
      rules.push(rule.three);
    }

    const near = data1.near;

    this.setData({
      rule: rules.join('\n'),
      signInNearDay: near.fate,
      signInNearIntegral: near.number,
      continuousSignInDay: data.content,
      loading: false,
      top_bg_image_url: data1.image
    });

    // const status = parseInt(data.status);
    wx.showModal({
      title: org.msg,
      content: "",
      showCancel: false
    });
    this.loadGoodInfo();
  },

  // 加载商品信息信息
  loadGoodInfo: function () {

    const that = this;
    const data = this.data;
    const page = data.page;

    app.request({
      method: 'gift.gift.lists',
      page: page + 1
    }, function (data) {

      // 加载成功
      that.parseGoodInfos(data);
    }, function () {

      that.setData({
        load_more: false
      })
    }, page == 0)
  },

  // 解析商品信息
  parseGoodInfos: function (data) {

    var items = data.data;
    var good_infos = this.data.good_infos;

    // 商品信息
    if (items != null) {
      var infos = new Array();
      for (var i = 0; i < items.length; i++) {
        const obj = items[i];
        infos.push(this.goodInfoFromObj(obj));
      }
      if (good_infos == null) {
        good_infos = infos;
      } else {
        Array.prototype.push.apply(good_infos, infos);
      }
    }

    this.setData({
      good_infos: good_infos,
      load_more: false,
      page: this.data.page + 1
    })

    // 积分记录总数
    this.data.total_size = data.pager.dataCount;
  },

  // 创建商品信息
  goodInfoFromObj: function (obj) {
    var info = new Object();
    info.img = obj.image_default_id;
    info.good_id = obj.goods_id;
    info.name = obj.name;
    info.product_id = obj.product_id;
    info.integral = obj.consume_score;

    return info;
  },

  // 加载更多
  loadMore: function () {
    const infos = this.data.good_infos;
    if (infos.length < this.data.total_size && !this.data.load_more) {
      this.setData({
        load_more: true
      })
      //可以加载
      this.loadGoodInfo();
    }
  },

  // 重新加载
  reloadData: function () {
    this.setData({
      fail: false
    })
    this.signin();
  }
})