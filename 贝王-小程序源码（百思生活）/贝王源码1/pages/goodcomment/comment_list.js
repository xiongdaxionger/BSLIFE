// pages/goodcomment/comment_list.js
var app = getApp();
var utilJs = null;

Page({
  data: {
    imgURL: app.getImgURL(),
    fail: false, //是否加载失败
    comment_infos: null, //评价信息

    relay_enable: false, //是否可以回复评价
    total_score: 0, //总评评分
    total_score_float: 0, //总评小数

    score_infos: null, //评分信息
    filter_infos: null, //筛选信息

    good_id: null, //商品id
    filter: null, //当前筛选字段
    selected_filter_index: 0,//当前选中的筛选下标

    load_more: false, //是否在加载更多
    total_size: 0, //列表总数
    page: 0, //当前页码
    loading: false, //是否正则加载

    showScrollToTop: false, //是否显示回到顶部按钮
    scroll_top: 0, //回到顶部
    current_reply: "", //当前回复内容
    replying: false, //是否正在回复
    relpyIndex: 0, //当前回复的评价
  },

  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    this.data.good_id = options.good_id;
    utilJs = require("../../utils/util.js");
    this.loadInfo();
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
    const index = event.currentTarget.dataset.index;
    if (index != this.data.selected_filter_index) {
      var obj = this.data.filter_infos[index];
      this.setData({
        selected_filter_index: index,
        filter: obj.value,
        comment_infos: null,
        page: 0,
        load_more: false
      })
      this.loadInfo();
    }
  },

  // 点击图片
  tapImage: function (event) {

    const index = event.currentTarget.dataset.index;
    const idx = event.currentTarget.dataset.idx;
    var comment_infos = this.data.comment_infos;
    const info = comment_infos[index];

    wx.previewImage({

      current: info.images[idx], // 当前显示图片的http链接
      urls: info.images // 需要预览的图片http链接列表
    })
  },

  // 回复
  tapReply: function (event) {
    if (!app.globalData.isLogin) {
      app.showLogin();
      return;
    }
    const index = event.currentTarget.dataset.index;
    var comment_infos = this.data.comment_infos;
    const info = comment_infos[index];
    this.setData({
      replying: true,
      relpyIndex: index
    })
  },

  // 取消回复
  replyCancel: function () {
    this.setData({
      replying: false,
      current_reply: ''
    })
  },

  // 确认回复
  replyConfirm: function () {

    const that = this;
    const data = this.data;
    const content = data.current_reply;
    if (content == null || content.length == 0) {
      wx.showModal({
        title: "请输入回复内容",
        content: "",
        showCancel: false
      });
      return;
    }

    const comment_infos = data.comment_infos;
    const info = comment_infos[data.relpyIndex];
    app.request({
      method: 'b2c.comment.toReply',
      comment: content,
      id: info.id
    }, function (result, org) {

      const comlist = result.comlist;

      // 判断是否需要直接显示出来
      var enable = false;
      if (comlist != null) {
        const items = comlist.items;
        if (items != null) {
          enable = true;
          var replys = new Array();
          for (var i = 0; i < items.length; i++) {

            const obj = items[i];
            replys[i] = {
              name: obj.author,
              content: obj.comment
            };
          }
          info.replys = replys;
          that.setData({
            comment_infos: comment_infos,
          });
        }
      }

      if (!enable) {
        wx.showToast({
          title: org.msg,
          icon: 'success'
        });
      }

      that.replyCancel();

    }, function () {

    }, true, true, true);
  },

  // 回复内容输入改变
  replyInputDidChange: function (event) {
    this.data.current_reply = event.detail.value;
  },

  // 点击更多
  tapMore: function (event) {
    const index = event.currentTarget.dataset.index;
    const comment_infos = this.data.comment_infos;
    const info = comment_infos[index];
    info.expand = !info.expand;
    this.setData({
      comment_infos: comment_infos
    })
  },

  // 加载评价信息
  loadInfo: function () {

    const that = this;
    const data = this.data;

    const method = data.page == 0 && data.filter == null ? 'b2c.product.goodsDiscuss' : 'b2c.comment.getDiscuss';
    var params = {
      method: method,
      goods_id: data.good_id,
      page: data.page + 1,
      loading: true
    };
    if (data.filter != null) {
      params.type = data.filter
    }
    app.request(params, function (data) {
      that.parseCommentInfos(data);
    }, function () {
      const fail = data.load_more;
      that.setData({
        fail: !fail && data.filter_infos == null,
        load_more: false,
        loading: false
      })
    }, data.page == 0)
  },

  // 解析评价信息
  parseCommentInfos: function (data) {
    const commentObj = data.comments;

    // 总评信息
    if (this.data.page == 0 && this.data.filter == null) {
      const settings = commentObj.setting;

      const filter_infos = data.goodsDiscuss_type;
      var filter = null;
      if (filter_infos != null && filter_infos.length > 0) {
        filter = filter_infos[0].value;
      }
      this.setData({
        relay_enable: settings.switch_reply == 'on',
        total_score_float: commentObj.goods_point.avg_num,
        total_score: parseInt(commentObj.goods_point.avg_num),
        score_infos: commentObj._all_point,
        filter_infos: filter_infos,
        filter: filter,
      })
    }

    // 评价列表信息
    var comments = commentObj.list.discuss;
    var comment_infos = this.data.comment_infos;

    if (comments != null) {
      var infos = new Array();
      for (var i = 0; i < comments.length; i++) {
        const obj = comments[i];
        infos.push(this.commentInfoFromObj(obj));
      }
      if (comment_infos == null) {
        comment_infos = infos;
      } else {
        Array.prototype.push.apply(comment_infos, infos);
      }
    }

    this.setData({
      comment_infos: comment_infos,
      load_more: false,
      fail: false,
      page: this.data.page + 1,
      loading: false
    })

    // 评价总数
    this.data.total_size = parseInt(data.pager.dataCount);
  },

  // 创建评价信息对象
  commentInfoFromObj: function (obj) {
    var info = new Object();
    info.id = obj.comment_id;
    info.name = obj.author;
    info.content = obj.comment;
    info.score = parseInt(obj.goods_point);
    info.time = utilJs.previousDateFromTimesamp(obj.time);

    info.img = obj.member_avatar;
    info.level = obj.member_lv_name;
    info.images = obj.images;
    info.expand = false;
    info.replys = new Array();
    const items = obj.items;
    if (items != null) {
      for (var i = 0; i < items.length; i++) {
        obj = items[i];
        info.replys[i] = {
          name: obj.author,
          content: obj.comment
        };
      }
    }

    return info;
  },

  // 加载更多
  loadMore: function () {
    const infos = this.data.comment_infos;
    if (infos.length < this.data.total_size && !this.data.load_more) {
      this.setData({
        load_more: true
      })
      //可以加载
      this.loadInfo();
    }
  },

  // 重新加载
  reloadData: function () {
    this.setData({
      comment_infos: null,
      page: 0,
      fail: false,
    })
    this.loadInfo();
  }
})