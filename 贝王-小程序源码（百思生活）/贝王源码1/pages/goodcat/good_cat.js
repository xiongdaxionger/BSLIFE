
const app = getApp();
const search = require('../../pages/goods/good_search.js');

Page({
  data: {
    selectedIndex: 0, //选中的下标
    imgURL: app.getImgURL(),
    barInfo: [
      '分类',
      '品牌'
    ],

    cat_selectedIndex: 0, //选中的分类下标
    cat_fail: false, //分类加载失败
    cat_infos: null, //分类信息
    existThreeCat:true, //是否存在3级分类
    secondary_cat_infos: null, ///右边的次级分类信息

    brand_fail: false, //品牌加载失败
    brand_page: 0, //当前页码
    brand_infos: null,// 品牌信息
    brand_load_more:false, //品牌加载更多
    brand_total_size: 0, //品牌信息总数

    searching: false, //是否正在搜索
    show_associate: false, //是否显示搜索联想
    search_hot_infos: null, //热门搜索
    search_history_infos:null, //搜索历史
    search_associate_infos:null, //搜索联想

    showScrollToTop: false, //是否显示回到顶部按钮
    scroll_top: 0, //回到顶部
    brand_offsetY:0, // 品牌当前offsetY
  },

// 开始搜索
  searchDidBegin:function(event){
    search.searchDidBegin(event);
  },

  // 结束搜索
  searchDidEnd:function(event){
    search.searchDidEnd(event);
  },
  saoyisao: function () {
    var that = this;
    wx.scanCode({
      success: (res) => {
        var postData = {
          'bn': res.result,
          'method': 'b2c.product.bnParams'
        };
        app.request(postData, function (e) {
          if (e.goods.product_id) {
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
  // 搜索输入内容改变
  searchDidChange:function(event){
    search.searchDidChange(event);
  },

  // 搜索
  doSearch:function(){
    search.doSearch();
  },

// 点击热门搜索，最近搜索
  clickSearchItem:function(event){
    search.clickSearchItem(event);
  },

  // 清除聊天记录
  clearSearchHistory:function(){
    search.clearSearchHistory();
  },

  /**状态栏动作**/
  barItemDidChange: function (event) {

    const index = parseInt(event.target.dataset.index)
    this.setData( {
        selectedIndex:index
      }
    )
    if(index == 1){
      this.setData({
        scroll_top: this.data.brand_offsetY
      })
    }
    this.loadInfo();
  },

  // 拨打电话
  tapPhone: function () {
    app.getUplineMobile(function (mobile) {
      wx.makePhoneCall({
        phoneNumber: mobile
      })
    });
  },

  // 点击左边分类
  tapLeftCat: function (event) {
    const index = parseInt(event.currentTarget.dataset.index);
    
    const info = this.data.cat_infos[index];
    if (info.infos != null && info.infos.length > 0) {
      if (index == this.data.cat_selectedIndex) //点中已选中的分类
        return;
      //有二级分类，刷新右边列表
      this.setData({
        cat_selectedIndex: index,
        secondary_cat_infos: info.infos,
        existThreeCat : info.existThreeCat
      })
    } else {
      //没有二级分类，直接打开商品列表
      this.openGoodList(info.id, info.is_virtual_cat);
    }
  },

  // 点击右边分类
  tapRightCat:function(event){
    const cat_id = event.currentTarget.dataset.cat_id;
    const is_virtual_cat = event.currentTarget.dataset.is_virtual_cat
    this.openGoodList(cat_id, is_virtual_cat);
  },

  // 打开商品列表
  openGoodList:function(cat_id, is_virtual_cat){
    wx.navigateTo({
      url: '/pages/goods/good_list?cat_id=' + cat_id + '&is_virtual_cat=' + is_virtual_cat
    })
  },

  // 点击品牌
  tapBrand:function(event){
    const index = parseInt(event.target.dataset.index);
    const info = this.data.brand_infos[index];
     wx.navigateTo({
      url: '/pages/goods/good_list?brand_id=' + info.brand_id
    })
  },

      // 品牌容器滑动
    brandContainerScroll: function (event) {
        const y = event.detail.scrollTop;
        // 屏幕高度
        const height = app.globalData.systemInfo.windowHeight;
        this.setData({
            showScrollToTop: y >= height * 2,
            brand_offsetY: y
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

  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    
    this.loadInfo();
  },
  onShow: function () {
    // 页面显示
    search.init(this, true);
  },

  // 加载信息
  loadInfo: function () {
    const selectedIndex = this.data.selectedIndex;
    switch (selectedIndex) {
      case 0: {
        // 加载分类信息
        if (this.data.cat_infos == null) {
          this.setData({
            cat_fail: false
          });
          this.loadCatInfo();
        }
        break;
      }
      case 1: {
        // 加载品牌信息
        if(this.data.brand_infos == null){
          this.setData({
            brand_fail:false
          });
          this.loadBrandInfo();
        }
        break;
      }
    }
  },

  // 加载分类信息
  loadCatInfo: function () {

    var that = this;
    app.request({
      method: 'b2c.gallery.cat'
    }, function (data) {
      
      that.parseCatInfo(data);
    }, function () {

      that.setData({
        cat_fail: true
      })
    }, true)
  },

  // 解析分类信息
  parseCatInfo: function (data) {
    // 分类加载成功
    var catObj = data.cat;

    // 普通分类
    var infos = new Array();
    this.catInfosFromCatObj(catObj, infos);
    // 虚拟分类
    catObj = data.vcat;
    this.catInfosFromCatObj(catObj, infos);

    // 获取有二级分类的分类下标
    var index = 0;
    var secondary_cat_infos = null;
    var existThreeCat = false;
    for (var i = 0; i < infos.length; i++) {
      var info = infos[i];
      if (info.infos != null && info.infos.length > 0) {
        index = i;
        secondary_cat_infos = info.infos;
        existThreeCat = info.existThreeCat;
        break;
      }
    }

    if (infos.length > 0) {
      this.setData({
        cat_selectedIndex: index,
        cat_fail: false,
        cat_infos: infos,
        existThreeCat : existThreeCat,
        secondary_cat_infos: secondary_cat_infos
      });
    }
  },

  // 获取分类信息
  catInfosFromCatObj: function (catObj, infos) {
    const infoObj = catObj.info;

    ///0 是一级分类
    const treeObj = catObj.tree;
    const items = treeObj['0'];

    if (items == null || items.length == 0)
      return;

    for (var i = 0; i < items.length; i++) {
      const id = items[i];
      const obj = infoObj[id];
      if (obj != null) {
        const info = this.catInfoFromObj(obj);
        infos.push(info);
        // 二级分类
        const items2 = treeObj[id];
        if (items2 != null && items2.length > 0) {
          var infos2 = new Array();
          info.infos = infos2;
          for (var j = 0; j < items2.length; j++) {

            const id2 = items2[j];
            const obj2 = infoObj[id2];
            if (obj2 != null) {
              const info2 = this.catInfoFromObj(obj2);
              infos2.push(info2);

              // 三级分类
              const items3 = treeObj[id2];
              if (items3 != null && items3.length > 0) {
                info.existThreeCat = true;
                var infos3 = new Array();
                info2.infos = infos3;
                for (var k = 0; k < items3.length; k++) {

                  const id3 = items3[k];
                  const obj3 = infoObj[id3];
                  if (obj3 != null) {
                    const info2 = this.catInfoFromObj(obj3);
                    infos3.push(info2);
                  }
                }
              }else{
                info.existThreeCat = false;
              }
            }
          }
        }
      }
    }
  },

  // 创建分类对象
  catInfoFromObj: function (obj) {
    var info = new Object();
    var id = obj.cat_id;
    if (id == null) {
      //是虚拟分类
      info.id = obj.virtual_cat_id;
      info.name = obj.virtual_cat_name;
      info.is_virtual_cat = true;
    } else {
      info.id = id;
      info.name = obj.cat_name;
      info.is_virtual_cat = false;
    }
    info.img = obj.image_default_id;
    return info;
  },

  // 加载品牌信息
  loadBrandInfo:function(){
    var that = this;
    app.request({
      method: 'b2c.brand.showList',
      page : that.data.brand_page + 1
    }, function (data) {

// 解析json数据
      const brandList = data.brandList;
      if(brandList != null){
        var infos = that.data.brand_infos;
        if(infos == null){
          infos = brandList;
        }else{
          Array.prototype.push.apply(infos, brandList);
        }

        const page = that.data.brand_page + 1;
        that.setData({
          brand_infos : infos,
          brand_page : page,
          brand_load_more : false,
          brand_total_size: data.pager.dataCount
        });
      }
    }, function () {

      const fail = that.data.brand_load_more;
      that.setData({
        brand_fail: !fail,
        brand_load_more: false
      })
    }, that.data.brand_page == 0)
  },

  // 品牌信息加载更多
  loadMoreBrand:function(){
    const infos = this.data.brand_infos;
    if(infos.length < this.data.brand_total_size && !this.data.brand_load_more){
      this.setData({
        brand_load_more:true
      })
      //可以加载
      this.loadBrandInfo();
    }
  },

  ///点击加载失败调用
  reloadData: function () {
    this.loadInfo();
  }
})