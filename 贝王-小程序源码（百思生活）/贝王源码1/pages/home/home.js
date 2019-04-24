//获取应用实例)
var app = getApp()

///快报计时器
var articleTimer = null;

// 秒杀计时器
var secondKillTimer = null;

var search = require('../../pages/goods/good_search.js');
Page({
  data: {
    imgURL: app.getImgURL(),
    fail: false, //加载失败
    refreshing: false, //是否是下拉刷新
    scrollIntoView: 'article-0', ///快报滚动到某个地方
    homeDatas: null, ///首页数
    share:false,//转发
    isSecondKillEnd: false, //秒杀活动是否已结束

    isLoadServerTime: false, //是否已加载服务器时间
    serverTimeStamp: 0, // 服务器时间戳
    hour: '', ///倒计时小时
    minutes: '', //分
    second: '', //秒

    opacity: 1.0, //搜索栏背景透明度
    banner_height: 0, //轮播图默认高度

    searching: false, //是否正在搜索
    show_associate: false, //是否显示搜索联想
    search_hot_infos: null, //热门搜索
    search_history_infos: null, //搜索历史
    search_associate_infos: null, //搜索联想

    showScrollToTop: false, //是否显示回到顶部按钮
    scroll_top: 0, //回到顶部
  },

  // 开始搜索
  searchDidBegin: function (event) {
    search.searchDidBegin(event);
  },
  // 结束搜索
  searchDidEnd: function (event) {
    search.searchDidEnd(event);
  },

  // 搜索输入内容改变
  searchDidChange: function (event) {
    search.searchDidChange(event);
  },

  // 搜索
  doSearch: function () {
    search.doSearch();
  },

  // 点击热门搜索，最近搜索
  clickSearchItem: function (event) {
    search.clickSearchItem(event);
  },

  // 清除聊天记录
  clearSearchHistory: function () {
    search.clearSearchHistory();
  },

  onLoad: function () {

    // 设置轮播图默认高度
    this.data.banner_height = app.globalData.systemInfo.windowWidth * 500.0 / 1242.0;
    this.loadInfo(true);
  },

  onUnLoad: function () {
    //  页面关闭
    this.stopSecondKillTimer();
  },

  /**
   * 加载信息
   * showLoading 是否显示加载指示器
   */
  loadInfo: function (showLoading) {
    var that = this;
    this.loadServerTime();
    app.request(
      { method: 'mobile.index.index' },
      function success(data) {
        if (!that.data.isLoadServerTime) {
          // 服务器时间没加载完成 先使用本地时间
          var time = new Date().getTime() / 1000;
          that.data.serverTimeStamp = parseInt(time);
        }
        that.parseHomeData(data);
        if (that.data.refreshing) {
          wx.stopPullDownRefresh();
          that.setData({
            refreshing: false
          })
        }
      },
      function fail() {

        if (that.data.refreshing) {
          wx.stopPullDownRefresh();
          that.setData({
            refreshing: false
          })
        } else {
          that.setData({
            fail: true
          })
        }
      },
      showLoading);
  },

  // 加载服务器时间
  loadServerTime: function () {
    this.data.isLoadServerTime = false;
    var that = this;
    app.request({
      method: 'mobile.index.getTimes'
    }, function success(data) {
      var time = data.time;
      that.setData({
        isLoadServerTime: true,
        serverTimeStamp: time
      })

    }, function fail() {

    });
  },
  /*分享*/
  onShareAppMessage: function (res) {
    return app.onShareApp({title:"首页"})
  },
  // onShow: function () {
  //   // 搜索初始化
  //   search.init(this, true);
  //   this.openArticleTimer();
  // },

  onHide: function () {
    if (articleTimer != null) {
      clearInterval(articleTimer);
      articleTimer = null;
    }
  },

  // 开始快报计时器
  openArticleTimer: function () {

    if (articleTimer != null) {
      return;
    }
    var homeDatas = this.data.homeDatas;
    if (homeDatas == null)
      return;

    var count = 0;
    for (var i = 0; i < homeDatas.length; i++) {
      var obj = homeDatas[i];
      if (obj.type == 2) {
        count = obj.infos.length;
        break;
      }
    }

    // 存在快报
    if (count > 0) {
      var that = this;
      articleTimer = setInterval(function () {

        var id = that.data.scrollIntoView;
        id = id.replace('article-', '');
        var idx = parseInt(id, 10) + 1;
        if (idx >= count)
          idx = 0;

        that.setData({
          scrollIntoView: 'article-' + idx
        })
      }, 5000);
    }
  },

  // 启动秒杀计时器
  openSecondKillTimer: function () {
    if (secondKillTimer != null) {
      return;
    }

    var homeDatas = this.data.homeDatas;
    if (homeDatas == null)
      return;

    // 查看是否存在秒杀
    var info = null;
    for (var i = 0; i < homeDatas.length; i++) {
      var obj = homeDatas[i];
      if (obj.type == 4) {
        info = obj;
        break;
      }
    }


    if (info != null) {
      var that = this;

      if (info.endTime <= this.data.serverTimeStamp) {
        //秒杀已结束
        this.setData({
          isSecondKillEnd: true
        });
        info = null;
      }

      this.formatTimer(info);

      secondKillTimer = setInterval(function () {
        that.formatTimer(info);

      }, 1000);
    }
  },

  // 秒杀倒计时格式化
  formatTimer: function (info) {
    var serverTimeStamp = this.data.serverTimeStamp;

    var time = 0;
    if (info.beginTime > serverTimeStamp) {
      //秒杀未开始
      time = info.beginTime;
    } else if (info.endTime > serverTimeStamp) {
      // 秒杀未结束
      time = info.endTime;
    }

    if (time > 0) {

      time = time - serverTimeStamp;

      // 格式化时间戳
      var result = parseInt(time / 60);
      var second = time % 60;

      var minute = result % 60;
      var hour = parseInt(result / 60);
      this.setData({
        hour: hour < 10 ? '0' + hour : hour,
        minutes: minute < 10 ? '0' + minute : minute,
        second: second < 10 ? '0' + second : second,
        isSecondKillEnd: false
      })

    } else {
      this.stopSecondKillTimer();
      //秒杀已结束
      this.setData({
        isSecondKillEnd: true
      });
    }
    this.data.serverTimeStamp = serverTimeStamp + 1;
  },

  // 结束秒杀计时器
  stopSecondKillTimer: function () {
    if (secondKillTimer != null) {
      clearInterval(secondKillTimer);
      secondKillTimer = null;
    }
  },

  // 拨打电话
  tapPhone: function () {
    app.getUplineMobile(function (mobile) {
      wx.makePhoneCall({
        phoneNumber: mobile
      })
    });
  },
  // 扫一扫
  saoyisao:function(){
    var that = this;
    wx.scanCode({
      success: (res) => {
        var postData = {
          'bn': res.result,
          'method':'b2c.product.bnParams'
        };
        app.request(postData, function (e) {
          if (e.goods.product_id){
            wx.navigateTo({
              url: '/pages/gooddetail/gooddetail?productID=' + e.goods.product_id,
            })
          }
        }, function (msg, e) {
          
        }, true, false, true);
        
      },
      fail: (res) => {

      },
      complete: (res) => {

      }
    })
  },
  // 点击广告
  tapad: function (event) {
    var id = event.currentTarget.dataset.id;
    var type = event.currentTarget.dataset.type;
    app.openAdPage(type, id);
  },

  // 点击商品
  tapGood: function (event) {
    var productId = event.currentTarget.dataset.productid;
    wx.navigateTo({
      url: '/pages/gooddetail/gooddetail?productID=' + productId,
    })
  },

  // 点击秒杀右边
  tapSecondKillRight: function (event) {
    wx.navigateTo({
      url: '/pages/secondKill/second_kill'
    })
  },

  // 容器滑动
  containerScroll: function (event) {
    const y = event.detail.scrollTop;
    const banner_height = this.data.banner_height;

    // 屏幕高度
    const height = app.globalData.systemInfo.windowHeight;
    if (y >= banner_height) {
      this.setData({
        opacity: 1.0,
        showScrollToTop: y >= height * 2
      })
    } else {
      this.setData({
        opacity: 0,
        showScrollToTop: y >= height * 2
      })
    }
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

  // 解析首页数据
  parseHomeData: function (data) {
    // 解析首页数据
    var array = new Array();
    for (var i = 0; i < data.length; i++) {
      var object = data[i];
      var type = this.typeFromObject(object);
      if (type != -1) { //类型无法识别则忽略
        var params = object.params;
        //数组长度为0并且不是图片广告也忽略也忽略 
        //如果数组长度为0并且不显示图标也忽略
        var obj = null;
        switch (type) {
          case 0: {
            obj = this.parseBanner(params);
            break;
          }
          case 1: {
            obj = this.parseNavigation(params);
            break;
          }
          case 2: {
            obj = this.parseArticle(params);
            break;
          }
          case 3:
          case 6:
          case 7: {
            obj = this.parseImage(params);
            if (type == 6) {
              var infos = obj.infos;
              if (infos.length == 4) {
                var info = infos[0];
                var spacing = info.bottom_spacing;
                info.bottom_spacing = 0;

                info = infos[1];
                info.bottom_spacing = spacing;

                info = infos[2];
                info.right_spacing = spacing;

                info = infos[3];
                info.right_spacing = 0;
              }
            }
            if (type == 7) {
              var infos = obj.infos;
              if (infos.length == 5) {
                var info = infos[4];
                var spacing = info.right_spacing;
                info.right_spacing = 0;

                info = infos[2];
                var info0 = infos[0];
                info.top = info0.height + info0.bottom_spacing;

                info = infos[3];
                info.right_spacing = spacing;
              }
            }
            break;
          }
          case 4: {
            obj = this.parseSecondKill(params);
            break;
          }
          case 5: {
            obj = this.parseGoods(params);
            break;
          }
        }
        if (obj != null) {
          obj.type = type;
          array.push(obj);
        }
      }
    }

    if (articleTimer != null) {
      clearInterval(articleTimer);
    }
    this.setData({
      homeDatas: array,
      opacity: 0
    })
    this.stopSecondKillTimer();
    this.openSecondKillTimer();

    this.openArticleTimer();
  },

  // 首页数据类型
  typeFromObject: function (obj) {
    var type = -1;//无法识别的类型
    var str = obj.widgets_type;

    if (str == "main_slide") {
      type = 0;//轮播广告
    }
    else if (str == "wap_index_nav") {
      type = 1; //导航按钮
    }
    else if (str == "article") {
      type = 2; //文字快报
    }
    else if (str == "wap_index_banner2") {
      type = 3; //图片广告
    }
    else if (str == "goods_shopmax_starbuy") {
      type = 4;//秒杀
    }
    else if (str == "index_tab_goods") {
      type = 5; //商品列表
    }
    else if (str == "wap_index_banner") {
      var params = obj.params;
      var idx = params.bantype.selected;
      if (idx == 3) {
        return 6; //特殊挂件图片广告
      } else if (idx == 5) {
        return 7; //特殊挂件广告
      }
      return 3; //图片广告
    }

    return type;
  },

  // 解析轮播广告
  parseBanner: function (object) {
    var pic = object.pic;
    if (pic == null || pic.length == 0)
      return null;
    var obj = new Object();
    var scale = object.scale;
    if (scale == 0)
      scale = 1242.0 / 500.0;
    this.setData({
      banner_height: app.globalData.systemInfo.windowWidth / scale
    });
    var array = new Array(pic.length);
    for (var i = 0; i < pic.length; i++) {
      var banner = pic[i];
      var info = new Object();
      info.id = banner.url_id;
      info.img = banner.link;
      info.type = banner.url_type;
      array[i] = info;
    }
    obj.infos = array;
    return obj;
  },

  // 解析导航
  parseNavigation: function (object) {
    var navs = object.nav;
    if (navs == null || navs.length == 0)
      return null;
    var obj = new Object();
    var array = new Array(navs.length);
    for (var i = 0; i < navs.length; i++) {
      var nav = navs[i];
      var url = nav.url;
      var info = new Object();

      info.id = url.url_id;
      info.img = nav.img;
      info.name = nav.name;
      info.type = url.url_type;
      array[i] = info;
    }
    obj.infos = array;
    return obj;
  },

  // 解析快报
  parseArticle: function (object) {
    var articles = object.articles;
    if (articles == null || articles.length == 0)
      return null;
    var obj = new Object();
    var array = new Array(articles.length);
    for (var i = 0; i < articles.length; i++) {
      var article = articles[i];
      var info = new Object();

      info.id = article.article_id;
      info.name = article.title;
      info.type = 'article';
      array[i] = info;
    }
    obj.infos = array;
    return obj;
  },
  //获取当前链接(相对地址)
  getUrl:function(){

  },
  // 解析图片
  parseImage: function (object) {
    var bantype = object.bantype;
    var images = bantype.url;

    // 屏幕宽度
    var window_width = bantype.window_width;
    var titleObj = bantype.title;
    // header和footer的分割线
    var shouldDisplaySeparator = false;
    var shouldDisplayFooter = false;

    var shouldDisplayTitle = false; //是否显示标题
    if (titleObj != null) {
      shouldDisplaySeparator = bantype.title_unline;
      shouldDisplayFooter = bantype.node_unline;
      shouldDisplayTitle = titleObj.show_title; //是否显示标题
    }

    if ((images == null || images.length == 0) && !shouldDisplaySeparator && !shouldDisplayFooter && !shouldDisplayTitle) {
      return null;
    }
    // 标题
    var obj = new Object();
    obj.displayTitle = shouldDisplayTitle;
    obj.separator = shouldDisplaySeparator;
    obj.footer = shouldDisplayFooter;
    if (shouldDisplayTitle) {
      obj.title = titleObj.title_name;
      obj.titleColor = titleObj.color;
      obj.backgroundColor = titleObj.bgcolor;
      obj.displayLine = titleObj.show_line;
      var align = titleObj.text_align;
      if (align == null) {
        align = "center";
      }
      obj.textAlign = align;
    }

    const screen_width = app.globalData.systemInfo.windowWidth;
    var scale = screen_width / window_width;
    var spacing = bantype.spacing * scale;
    if (spacing < 0.5 && spacing > 0) {
      spacing = 0.5;
    }

    // 如果宽度小于 screen_width - 0.5，则有右边距
    var totalWidth = 0;
    // 有些宽度在外面
    var width = Math.floor(bantype.size_x * scale);
    var height = Math.floor(bantype.size_y * scale);

    if (images != null) {
      var array = new Array();
      for (var i = 0; i < images.length; i++) {
        var image = images[i];
        var info = new Object();
        info.img = image.img;
        info.type = image.url_type;
        info.id = image.url_id;
        info.bottom_spacing = spacing;

        if (width > 0) {
          info.width = width;
          info.height = height;
          array.push(info);
        } else {
          //大小在里面
          info.width = Math.floor(image.size_x * scale);
          info.height = Math.floor(image.size_y * scale);
          if (info.width > 0) {
            array.push(info);
          }
        }
        totalWidth += info.width + spacing;
        if (totalWidth < screen_width - 0.5) {
          info.right_spacing = spacing;
        } else {
          totalWidth = 0;
        }
      }

      // 移除最后一行的底部边距
      totalWidth = 0;
      for (var i = array.length - 1; i >= 0; i--) {
        var info = array[i];
        info.bottom_spacing = 0;
        totalWidth += info.width + spacing;
        if (totalWidth >= screen_width - 0.5)
          break;
      }

      obj.infos = array;
    }

    return obj;
  },

  // 解析商品
  parseGoods: function (object) {
    var goods = object.goodsRows;
    if (goods == null || goods.length == 0)
      return null;

    var obj = new Object();

    var array = new Array(goods.length);
    for (var i = 0; i < goods.length; i++) {
      var good = goods[i];
      var info = new Object();
      info.goodId = good.goodsId;
      info.productId = good.productId;
      info.goodName = good.goodsName;
      info.price = good.goodsSalePrice;
      // info.marketPrice = good.goodsMarketPrice;
      info.img = good.goodsPicM;
      array[i] = info;
    }
    obj.infos = array;

    return obj;
  },

  // 解析秒杀数据
  parseSecondKill: function (object) {
    var goods = object.goodsRows;
    if (goods == null || goods.length == 0)
      return null;

    var obj = new Object();
    obj.subtitle = object.title_right;
    obj.leftImg = object.title_left;
    obj.subtitleColor = object.title_right_color;

    var pro = object.pro;
    obj.beginTime = parseInt(pro.begin_time);
    obj.endTime = parseInt(pro.end_time);

    var array = new Array(goods.length);
    for (var i = 0; i < goods.length; i++) {
      var good = goods[i];
      var info = new Object();
      info.goodId = good.goods_id;
      info.productId = good.product_id;
      info.goodName = good.name;
      info.price = good.promotion_price;
      // info.marketPrice = good.price;
      info.img = good.goodsPicM;
      array[i] = info;
    }
    obj.infos = array;

    return obj;
  },

  ///点击加载失败调用
  reloadData: function () {

    this.setData({
      fail: false
    });

    this.loadInfo(true);
  },

  // 下拉属性
  onPullDownRefresh: function () {
    this.setData({
      refreshing: true,
      share:true
    })
    this.loadInfo(false);
  },
  onShow: function () {
    var that = this;
    // 搜索初始化
    search.init(this, true);
    this.openArticleTimer();
  },
  screenshot:function(){
    wx.canvasToTempFilePath({
      x: 0,
      y: 0,
      width: 600,
      height: 800,
      destWidth: 600,
      destHeight: 800,
      canvasId: 'myCanvas',
      success: function (res) {
        that.setData({
          shareImgSrc: res.tempFilePath
        })

      },
      fail: function (res) {
      }
    })
  }


//
})