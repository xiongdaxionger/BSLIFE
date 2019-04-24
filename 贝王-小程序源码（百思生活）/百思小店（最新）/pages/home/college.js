var app = getApp();
var util = require('../../utils/util.js');
Page({

  /**
   * 页面的初始数据
   */
  data: {
    typeId:'1',
    audioList:[], //音频列表
    mediaList:[], //精选列表
    videoList:[], //视频列表
    audioId:'',
    hiddenmodalput: true,
    memberRemoke:'',
    articleId:'',
    articleBox:''
  },
  onLoad:function(){
    var data = '1';
    this.setContent(data);
  },
  // 切换顶部选项卡
  chooseType:function(e){
    this.setData({
      typeId: e.currentTarget.dataset.id,
      articleBox:'',
    })
    this.setContent(e.currentTarget.dataset.id);
  },
  // 调用接口公共方法
  setContent:function(res){
    var that = this;
    var userinfos = wx.getStorageSync('userinfo');
    var params = {
      method: 'pos.cashier.college',
      type: res,
      wx_pro_mid: userinfos.memberId,
    };
    app.request(params, function (data) {
      data.articles.forEach(function (item) {
        item.pubtime = util.formatTimesamp(item.pubtime, 1);
      })
      if(res == '1'){
        that.setData({
          mediaList: data.articles,
          articleBox: ''
        })
      }else if(res == '2'){
        that.setData({
          videoList: data.articles,
          articleBox: ''
        })
      } else if (res == '3') {
        that.setData({
          audioList: data.articles,
          articleBox: ''
        })
      }
      
    }, function (msg, data) {

    }, true, false, true);
  },
  // 每次进入都重新加载接口
  onShow:function(){
    this.onLoad();
  },
  // 跳转到视频详情页
  jumpVideo:function(e){
    var id = e.currentTarget.dataset.id;
    wx.navigateTo({
      url: './video?id='+id,
    })
  },
  // 一次只播放一个音频
  audioPlay:function(res){
    console.log(res);
    var audioId = res.currentTarget.id
    var that = this;
    if (that.data.audioId != ''){
      if (that.data.audioId == audioId){
        wx.createAudioContext(that.data.audioId).seek(0)
      }else{
        wx.createAudioContext(that.data.audioId).pause();
      }
    }
    that.setData({
      audioId: audioId
    })
  },
  // 弹窗点赞评论
  givealike:function(e){
    var id = e.currentTarget.dataset.id;
    if (id == this.data.articleBox){
      this.setData({
        articleBox: ''
      })
    }else{
      this.setData({
        articleBox: id
      })
    }
    
  },
  // 点赞
  givelike:function(e){
    var id = e.currentTarget.dataset.id;
    var userinfos = wx.getStorageSync('userinfo');
    var that = this;
    var params = {
      method: 'content.article.addPraise',
      ifpraise: 'true',
      article_id: id,
      wx_pro_mid: userinfos.memberId,
    };
    app.request(params, function (data) {
      wx.showToast({
        title: '成功',
        icon: 'success',
        duration: 2000,
        success: function () {
          that.setData({
            articleId: '',
            articleBox:''
          })
          that.setContent(that.data.typeId);
        }
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  // 设置评论
  setRemoke: function (e) {
    if (e.detail.value != ''){
      this.setData({
        memberRemoke: e.detail.value
      })
    }else{
      this.setData({
        memberRemoke: ''
      })
    }
  },
  //取消按钮  
  cancel: function () {
    this.setData({
      hiddenmodalput: true,
      memberRemoke: '',
      articleId: ''
    });
  },
  //确认  
  confirm: function () {
    var that = this;
    if (that.data.memberRemoke == ''){
      return;
    }
    var userinfos = wx.getStorageSync('userinfo');
    var params = {
      method: 'content.article.addPraise',
      ifpraise: 'false',
      article_id: that.data.articleId,
      wx_pro_mid: userinfos.memberId,
      content: that.data.memberRemoke
    };
    app.request(params, function (data) {
      that.setData({
        hiddenmodalput: true,
        memberRemoke: '',
        articleId: ''
      });
      wx.showToast({
        title: '评论成功',
        icon: 'success',
        duration: 2000,
        success: function () {
           that.setContent(that.data.typeId);
        }
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  comments: function (e) {
    var articleId = e.currentTarget.dataset.id;
    this.setData({
      hiddenmodalput: !this.data.hiddenmodalput,
      articleId: articleId
    })
  },
  // 删除
  actioncnt: function (e) {
    var comId = e.currentTarget.dataset.id;
    var mid = e.currentTarget.dataset.mid;
    var userinfos = wx.getStorageSync('userinfo');
    if (mid != userinfos.memberId) {
      return;
    }
    var that = this;
    wx.showActionSheet({
      itemList: ['删除'],
      success: function (res) {
        if (res.tapIndex == '0'){
          var params = {
            method: 'pos.cashier.del_comment',
            comment_id: comId,
            member_id: userinfos.memberId,
          };
          app.request(params, function (data) {
            that.setContent(that.data.typeId);
          }, function (msg, data) {

          }, true, false, true);
        }
      },
      fail: function (res) {

      }
    })
  }
})