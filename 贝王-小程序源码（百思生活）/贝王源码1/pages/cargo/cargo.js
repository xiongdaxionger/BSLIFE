const app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    record:'none',
    cargo:'',
    selected:'selected',
    active:'',
    getinven:[],
    getpicklog:[]
  },
  onLoad:function(){
    var that = this;
    var postData = {
      method: 'pos.cartweb.getinven',
      member_id: app.globalData.userInfo.userId,
      page:'1'
    };
    app.request(postData, function (e) {
      that.setData({
        getinven:e.list
      })
    }, function (msg, e) {
      
    }, true, false, true);
    
  },
  showCargo:function(){
    this.setData({
      record: 'none',
      cargo: '',
      selected: 'selected',
      active: ''
    })
  },
  showRecord:function(){
    var that = this;
    var param = {
      method: 'pos.cartweb.getpicklog',
      member_id: app.globalData.userInfo.userId,
      page: '1'
    }
    app.request(param, function (res) {
      that.setData({
        record: '',
        cargo: 'none',
        selected: '',
        active: 'selected',
        getpicklog: res.list
      })
    }, function (msgg, res) {

    }, true, false, true);
    
  },
  tapGood: function (event) {
    var productId = event.currentTarget.dataset.productid;
    wx.navigateTo({
      url: '/pages/gooddetail/gooddetail?productID=' + productId,
    })
  },
})