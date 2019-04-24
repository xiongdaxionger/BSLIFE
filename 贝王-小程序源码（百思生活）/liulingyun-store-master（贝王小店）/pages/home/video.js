var app = getApp();
var util = require('../../utils/util.js');
Page({

  /**
   * 页面的初始数据
   */
  data: {
    videoSrc: '',
    posterSrc: "",
    pubtime:'',
    headImg:'',
    author:'',
    title:'',
    commentList:[],
    memberRemoke: '',
    articleId:'',
    articleBox:'',
    inputFocus:false,
    ifpraise:false,
    praiseList:[],
    bgcolor:'9ed99d',
    wxprointro:[]
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var that = this;
    var userinfos = wx.getStorageSync('userinfo');
    var params = {
      method: 'content.article.index',
      article_id: options.id,
      wx_pro_mid: userinfos.memberId,
    };
    app.request(params, function (data) {
      that.setData({
        videoSrc: data.bodys.video_path,
        posterSrc: data.bodys.video_poster,
        pubtime: util.formatTimesamp(data.indexs.pubtime, 1),
        headImg: data.bodys.image_id,
        author: data.indexs.author,
        title: data.indexs.title,
        articleId: options.id,
        ifpraise: data.indexs.ifpraise,
        wxprointro: data.bodys.wxprointro
      })
      that.commentList(options.id);
      that.praiseList(options.id);
    }, function (msg, data) {

    }, true, false, true);
  },
  // 评论列表
  commentList:function(e){
    var that = this;
    var params = {
      method: 'content.article.getcommentlist',
      article_id: e,
      ifpraise:false,
      page:1,
      page_size:10,
      bwstore:true
    };
    app.request(params, function (data) {
      data.comment_list.forEach(function (item) {
        item.uptime = util.formatTimesamp(item.uptime, 1);
      })
      that.setData({
        commentList: data.comment_list
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  // 点赞列表
  praiseList:function(e){
    var that = this;
    var params = {
      method: 'content.article.getcommentlist',
      article_id: e,
      ifpraise: true,
      page: 1,
      page_size: 10,
      bwstore: true
    };
    app.request(params, function (data) {
      
      that.setData({
        praiseList: data.comment_list
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  // 设置评论
  setRemoke: function (e) {
    if (e.detail.value != ''){
      this.setData({
        memberRemoke: e.detail.value,
        bgcolor:'1aad16'
      })
    }else{
      this.setData({
        bgcolor: '9ed99d',
        memberRemoke:''
      })
    }
  },
  //确认  
  confirm: function () {
    var that = this;
    if (that.data.memberRemoke == '') {
      wx.showModal({
        title: '提示',
        content: '请输入评论',
      })
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
        memberRemoke: '',
        bgcolor: '9ed99d',
      });
      wx.showToast({
        title: '评论成功',
        icon: 'success',
        duration: 2000,
        success: function () {
          var res = {
            id: that.data.articleId
          }
          that.setData({
            articleBox: ''
          })
          that.onLoad(res);
        }
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  // 弹窗点赞评论
  givealike: function (e) {
    var id = e.currentTarget.dataset.id;
    if (id == this.data.articleBox) {
      this.setData({
        articleBox: ''
      })
    } else {
      this.setData({
        articleBox: id
      })
    }

  },
  // 点赞
  givelike: function (e) {
    var id = e.currentTarget.dataset.id;
    var userinfos = wx.getStorageSync('userinfo');
    var params = {
      method: 'content.article.addPraise',
      ifpraise: 'true',
      article_id: id,
      wx_pro_mid: userinfos.memberId,
    };
    var that = this;
    app.request(params, function (data) {
      wx.showToast({
        title: '成功',
        icon: 'success',
        duration: 2000,
        success: function () {
          var res = {
            id: that.data.articleId
          }
          that.setData({
            articleBox: ''
          })
          that.onLoad(res);
        }
      })
    }, function (msg, data) {

    }, true, false, true);
  },
  jumpVideo:function(){
    this.setData({
      inputFocus:true
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
        if (res.tapIndex == '0') {
          var params = {
            method: 'pos.cashier.del_comment',
            comment_id: comId,
            member_id: userinfos.memberId,
          };
          app.request(params, function (data) {
            var res = {
              id: that.data.articleId
            }
            that.setData({
              articleBox:''
            })
            that.onLoad(res);
          }, function (msg, data) {

          }, true, false, true);
        }
      },
      fail: function (res) {

      }
    })
  }
})