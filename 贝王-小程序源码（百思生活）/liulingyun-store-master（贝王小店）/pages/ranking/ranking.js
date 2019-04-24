var app = getApp();
Page({
  /**
   * 页面的初始数据
   */
  data: {
    memberList:[],
    itemid:'1',
    rankremoke:'每日凌晨刷新',
    page:1,
    total:'1',
  },
  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function () {
    var id = this.data.itemid;
    this.memberList(id);
  },
  selecteditem:function(e){
    var rankremoke = '';
    var id = e.currentTarget.dataset.id;
    if (id == '1'){
      rankremoke = '每日凌晨刷新';
    } else if (id == '2'){
      rankremoke = '每周一凌晨刷新';
    } else if (id == '3') {
      rankremoke = '每月一号凌晨刷新';
    }
    this.setData({
      itemid: id,
      rankremoke: rankremoke,
      page: 1,
      memberList: [],
    })
    this.memberList(id);
  },
  memberList:function(id){
    var that = this;
    var params = {
      method: 'pos.store.add_ranking',
      page: that.data.page,
      type: id
    };
    app.request(params, function (data) {
      if (data.list.length > 0) {
        var memberList = that.data.memberList.concat(data.list);
        that.setData({
          memberList: memberList,
          total: data.pager.total
        })
      }
    }, function (msg, data) {

    }, true, false, true);
  },
  scrolltolower:function(e){
    if (this.data.page < this.data.total){
      this.setData({
        page: this.data.page + 1
      })
      var id = this.data.itemid;
      this.memberList(id);
    }
  }
})