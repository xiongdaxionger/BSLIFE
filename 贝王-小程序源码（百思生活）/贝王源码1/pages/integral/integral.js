// pages/integral/integral.js

var app = getApp();
var utilJs = null;

Page({
  data:{
    imgURL:app.getImgURL(),
    fail: false, //是否加载失败
    records: null, //积分记录

    integral:0, //可用积分
    integral_detail:'', //积分详情
    use_btn_title:null, //积分使用按钮

    load_more: false, //是否在加载更多
    total_size: 0, //商品列表总数
    page: 0, //当前页码
    loading:true, //是否在加载

    showScrollToTop: false, //是否显示回到顶部按钮
    scroll_top: 0, //回到顶部

    previous_page_integral_signin: false, //前一个界面是否是积分签到
  },
  onLoad:function(options){
    // 页面初始化 options为页面跳转所带来的参数
    this.data.previous_page_integral_signin = options.integral == 'true';
    utilJs = require("../../utils/util.js");
    this.loadIntegralInfo();
  },
  onUnload:function(){
    // 页面关闭
    utilJs = null;
  },

  // 使用积分
  useIntegral:function(event){
    if(this.data.previous_page_integral_signin){
      wx.navigateBack({
        delta: 1 // 回退前 delta(默认为1) 页面
      })
    }else{
      wx.navigateTo({
        url: '/pages/integral/integral_sign_in?integral=true'
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

  // 加载积分信息
  loadIntegralInfo: function () {

    const that = this;
    const data = this.data;
    const page = data.page;

    app.request({
      method: 'b2c.member.point_history',
      page: page + 1
      }, function (data) {

      // 加载成功
      that.parseIntegralInfos(data);
    }, function () {

      const fail = data.load_more;
      that.setData({
        fail: !fail,
        load_more: false
      })
    }, page == 0)
  },

  // 解析积分信息
  parseIntegralInfos: function (data) {

    // 积分信息
    if(this.data.page == 0){
      const obj = data.extend_point_html;
      var freezeIntegral = 0;
      if(obj != null){

        var integral_detail = new Array();
        const consumptionObj = obj.expense_point;
        if(consumptionObj != null){
          //消费冻结
          integral_detail.push(consumptionObj.name)
          integral_detail.push('：');
          freezeIntegral = consumptionObj.value;
          integral_detail.push(freezeIntegral + '积分');
        }
        const obtainObj = obj.obtained_point;
        if(obtainObj != null){
          //获取冻结
          integral_detail.push('    ');
          integral_detail.push(obtainObj.name);
          integral_detail.push('：');
          integral_detail.push(obtainObj.value + '积分');
        }
        
      }
      this.setData({
        use_btn_title:data.exchange_gift_link,
          integral: data.total - freezeIntegral,
          integral_detail: integral_detail.join('')
        });
    }
    var items = data.historys;
    var records = this.data.records;

    // 积分记录信息
    if (items != null) {
      var infos = new Array();
      for (var i = 0; i < items.length; i++) {
        const obj = items[i];
        infos.push(this.recordFromObj(obj));
      }
      if (records == null) {
        records = infos;
      } else {
        Array.prototype.push.apply(records, infos);
      }
    }

    this.setData({
      records: records,
      load_more: false,
      fail: false,
      loading:false,
      page : this.data.page + 1
    })

    // 积分记录总数
    this.data.total_size = data.pager.dataCount;
  },

  // 创建积分记录对象
  recordFromObj: function (obj) {
    var info = new Object();
    info.integral = obj.change_point;
    info.msg = obj.reason;
    info.time = utilJs.formatTimesamp(obj.addtime, 2); 

    return info;
  },

  // 加载更多
  loadMore: function () {
    const infos = this.data.records;
    if (infos.length < this.data.total_size && !this.data.load_more) {
      this.setData({
        load_more: true
      })
      //可以加载
      this.loadIntegralInfo();
    }
  },

  // 重新加载
  reloadData: function () {
    this.setData({
      fail:false,
      loading:true
    })
    this.loadIntegralInfo();
  }
})