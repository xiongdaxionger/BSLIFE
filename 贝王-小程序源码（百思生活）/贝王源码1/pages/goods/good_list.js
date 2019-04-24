// 商品列表
var app = getApp();

const search = require('../../pages/goods/good_search.js');
var operation = null;

Page({
    data: {
        imgURL:app.getImgURL(),
        list_style: 0, // 列表样式 0 普通列表，1网格列表

        selectedIndex: 0, //菜单栏选中的下标 
        cur_sort: null, //当前排序
        sorts: [

        ], //排序信息
        show_sort_list: false, //是否显示下拉排序列表
        sort_selectedIndex: 0, //下拉选中的
        sort_title: '默认', //下拉选中的标题

        screening_enable: false, //是否可以筛选
        screening_cat_id: '', //获取筛选信息所需的分类id
        show_screening: false, //是否显示筛选列表
        screening_infos: null, //筛选信息
        is_load_screening: false, //是否正在加载筛选信息
        screening_params: null, //筛选参数 用来获取商品列表
        screeningTranslateAnimation: null, //筛选弹出动画
        screeningOpacityAnimation: null, //透明动画

        fail: false, //是否加载失败
        load_more: false, //是否在加载更多
        good_total_size: 0, //商品列表总数
        page: 0, //当前页码
        need_settings: true, //是否需要获取设置信息

        cat_id: '', //分类id
        is_virtual_cat: false, //是否是虚拟分类

        brand_id: '', //品牌id

        promotionTagId: '', //促销标签id

        only_presell: false, //是否只看预售商品

        good_infos: null, //商品信息
        show_comment_count: false, //是否显示评论数量

        search_text: null, //搜索关键字
        searching: false, //是否正在搜索
        show_associate: false, //是否显示搜索联想
        search_hot_infos: null, //热门搜索
        search_history_infos: null, //搜索历史
        search_associate_infos: null, //搜索联想

        showScrollToTop: false, //是否显示回到顶部按钮
        scroll_top: 0, //回到顶部

        shopcartCount: 0, //购物车数量
    },

    // 开始搜索
    searchDidBegin: function (event) {
        search.searchDidBegin(event, this.data.search_text);
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
        const search_text = search.doSearch();
        if (search_text != null) {
            this.setData({
                search_text: search_text
            });
            this.reloadData();
        }
    },

    // 点击热门搜索，最近搜索
    clickSearchItem: function (event) {
        const search_text = search.clickSearchItem(event);
        if (search_text != null) {
            this.setData({
                search_text: search_text
            });
            this.reloadData();
        }
    },

    // 清除聊天记录
    clearSearchHistory: function () {
        search.clearSearchHistory();
    },

    onLoad: function (options) {

        // 页面初始化 options为页面跳转所带来的参数
        const cat_id = options.cat_id;
       
        operation = require('../../utils/goodDetailOperation.js');
        if (cat_id != null) {

            const cat_name = options.cat_name;
            if (cat_name != null) {
                wx.setNavigationBarTitle({
                    title: cat_name,
                    success: function (res) {
                        // success
                    }
                });
            }
            const is_virtual_cat = options.is_virtual_cat;
            if (is_virtual_cat != "false") {
                this.data.is_virtual_cat = is_virtual_cat;
            }
            this.data.cat_id = cat_id;
        } else if (options.brand_id != null) {
            this.data.brand_id = options.brand_id; //品牌
        } else if (options.keyword != null) {
            this.setData({
                search_text : options.keyword
            })//搜索关键字
        } else if (options.promotion_tag_id != null) {
            this.data.promotionTagId = options.promotion_tag_id; //促销标签id
        } else if (options.only_presell != 'false') {
            this.data.only_presell = true;
        }

        this.loadGoodInfo();
    },

    onShow: function () {
        // 页面显示
        // 搜索初始化
        search.init(this, false);
        this.setData({
          shopcartCount: app.globalData.shopcartCount
        })
    },
  
    onUnload: function () {
        // 页面关闭
        operation = null;
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

    //   点击默认排序
    tapDefaultSort: function () {

        const show_sort_list = this.data.show_sort_list;
        const selectedIndex = this.data.selectedIndex;
        if (selectedIndex == 0) {
            const sorts = this.data.sorts;
            if (sorts == null || sorts.length < 2)
                return;
            this.setData({
                show_sort_list: show_sort_list ? false : true
            });
        } else {
            this.setData({
                selectedIndex: 0
            });
            this.reloadData();
        }
    },

    // 点击列表 透明地方
    tapSortTransparent: function () {
        const show_sort_list = this.data.show_sort_list;
        if (show_sort_list) {
            this.setData({
                show_sort_list: false
            })
        }
    },

    // 点击排序下拉列表
    tapSortItem: function (event) {
        this.tapSortTransparent();
        const index = parseInt(event.currentTarget.dataset.index);
        const sort_selectedIndex = this.data.sort_selectedIndex;
        if (index == sort_selectedIndex) {
            return;
        }

        const sort = this.data.sorts[index];
        this.setData({
            sort_selectedIndex: index,
            cur_sort: sort.sql,
            sort_title: sort.label
        })
        this.reloadData();
    },

    // 点击价格排序
    tapPriceSort: function () {
        const selectedIndex = this.data.selectedIndex;
        this.tapSortTransparent();
        if (selectedIndex == 1) {
            const cur_sort = this.data.cur_sort;
            this.setData({
                cur_sort: cur_sort == 'price asc' ? 'price desc' : 'price asc'
            })
        } else {
            this.setData({
                cur_sort: 'price asc',
                selectedIndex: 1
            })
        }
        this.reloadData();
    },

    // 点击销量排序
    tapBuycountSort: function () {
        const selectedIndex = this.data.selectedIndex;
        this.tapSortTransparent();
        if (selectedIndex != 2) {
            const cur_sort = this.data.cur_sort;
            this.setData({
                cur_sort: 'buy_count desc',
                selectedIndex: 2
            })
            this.reloadData();
        }
    },

    // 点击筛选
    tapScreening: function () {
        this.setData({
            show_screening: true
        })
        this.screeningAnimation(true);
    },


    // 筛选动画
    screeningAnimation: function (show) {
        var that = this;

        //  屏幕宽度
        const width = app.globalData.systemInfo.windowWidth;
        var animation = wx.createAnimation({
            duration: 300,
        });
        //修改透明度,偏移
        this.setData({
            screeningOpacityAnimation: animation.opacity(show ? 1 : 0).step().export(),
            screeningTranslateAnimation: animation.translateX(show ? (80 - width) : (width - 80)).step().export()
        })
    },

    // 关闭筛选
    closeScreening: function () {

        // 判断筛选内容是否已改变了
        var change = false;
        var params = this.getScreeningParams();
        // 对比和以前的参数，不相等则刷新数据
        const old_params = this.data.screening_params;

        if (old_params != null) {
            const paramsKeys = Object.getOwnPropertyNames(params);
            const old_parsmsKeys = Object.getOwnPropertyNames(old_params);
            if (paramsKeys.length == old_parsmsKeys.length) {
                for (var i = 0; i < paramsKeys.length; i++) {
                    const key = paramsKeys[i];
                    if (params[key] != old_params[key]) {
                        change = true;
                        break;
                    }
                }
            } else {
                change = true;
            }
        } else {
            change = true;
        }

        if (change) {
            //刷新商品列表
            this.data.screening_params = params;
            this.reloadData();
        }

        this.screeningAnimation(false);
        const that = this;
        var timer = setTimeout(function () {
            that.setData({
                show_screening: false
            })
            clearTimeout(timer);
            timer = null;
        }, 400)

    },

    // 获取筛选参数
    getScreeningParams: function () {
        const screening_infos = this.data.screening_infos;
        if (screening_infos == null)
            return null;
        var params = new Object();

        for (var i = 0; i < screening_infos.length; i++) {
            const item = screening_infos[i];
            const infos = item.infos;
            var index = 0;
            for (var j = 0; j < infos.length; j++) {
                const info = infos[j];
                if (info.selected) {
                    const key = item.key + '[' + index + ']';
                    params[key] = info.id;
                    index++;
                    if (item.single_selected) {
                        // 单选的
                        break;
                    }
                }
            }
        }
        return params;
    },

    // 筛选展开
    screeningExpand: function (event) {
        const index = parseInt(event.currentTarget.dataset.index);
        const screening_infos = this.data.screening_infos;
        var item = screening_infos[index];
        if (item.infos.length < 4)
            return;

        item.expand = !item.expand;
        this.setData({
            screening_infos: screening_infos
        })
    },

    // 点击筛选itemitem
    tapScreeningItem: function (event) {
        const index = parseInt(event.currentTarget.dataset.index);
        const section = parseInt(event.currentTarget.dataset.section);

        const screening_infos = this.data.screening_infos;
        var item = screening_infos[section];
        var infos = item.infos;
        var info = infos[index];
        // 只能单选
        if (!info.selected && item.single_selected) {
            //去掉以前选中的
            for (var i = 0; i < infos.length; i++) {
                info = infos[i];
                if (info.selected) {
                    info.selected = false;
                    break;
                }
            }
        }
        info.selected = !info.selected;
        this.setData({
            screening_infos: screening_infos
        })
    },

    // 筛选重置
    screeningReset: function () {
        const screening_infos = this.data.screening_infos;

        for (var i = 0; i < screening_infos.length; i++) {
            const item = screening_infos[i];
            const infos = item.infos;
            for (var j = 0; j < infos.length; j++) {
                const info = infos[j];
                if (info.selected) {
                    info.selected = false;
                    if (item.single_selected) {
                        // 单选的
                        break;
                    }
                }
            }
        }
        this.setData({
            screening_infos: screening_infos
        })
    },

    // 筛选完成
    screeningDone: function () {
        this.closeScreening();
    },

    // 点击列表样式
    tapListStyle: function () {
        const list_style = this.data.list_style;
        this.setData({
            list_style: list_style == 0 ? 1 : 0
        })
    },

    // 点击商品
    tapGood: function (event) {
        const index = parseInt(event.currentTarget.dataset.index);
        var info = this.data.good_infos[index];
        
        wx.navigateTo({
            url: '../gooddetail/gooddetail?' + 'goodID=' + info.good_id + '&productID=' + info.product_id + '&isGift=' + false,
        })
    },

    // 加载商品信息
    loadGoodInfo: function () {

        const that = this;
        const data = this.data;
        const page = data.page;
        var params = {
            method: data.need_settings ? 'b2c.gallery.index' : 'b2c.gallery.getList',
            page: page + 1
        }

        // 有分类id
        const cat_id = data.cat_id;
        if (parseInt(cat_id) > 0) {
            if (data.is_virtual_cat || data.is_virtual_cat == 'true') {
                params.virtual_cat_id = cat_id;
            } else {
                params.cat_id = cat_id;
            }
        }

        // 有品牌id
        const brand_id = data.brand_id;
        if (parseInt(brand_id) > 0) {
            params.brand_id = brand_id;
        }

        // 是否有排序
        const sort = data.cur_sort;
        if (sort != null) {
            params.orderBy = sort;
        }

        // 是否有搜索关键字
        const keyword = data.search_text;
        if (keyword != null) {
            params.search_keywords = keyword;
        }

        // 是否有促销标签
        const promotionTagId = data.promotionTagId;
        if (parseInt(promotionTagId) > 0) {
            params.pTag = promotionTagId;
        }

        // 是否是只看预售商品
        const only_presell = data.only_presell;
        if (only_presell) {
            params.show_preparesell_goods = only_presell;
        }

        // 筛选参数
        const screening_params = data.screening_params;
        if (screening_params != null) {
            for (const key in screening_params) {
                params[key] = screening_params[key];
            }
        }

        app.request(params, function (data) {

            // 加载成功
            that.parseGoodInfos(data);
        }, function () {

            const fail = data.load_more;
            that.setData({
                fail: !fail,
                load_more: false
            })
        }, page == 0)
    },

    // 解析商品信息
    parseGoodInfos: function (data) {
        var items = data.goodsData;
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
            fail: false,
            page : this.data.page + 1
        })

        // 商品总数
        this.data.good_total_size = data.pager.dataCount;

        if (this.data.need_settings) {
            // 配置信息
            const setting = data.setting;
            const show_comment_count = setting.commentListListnum != 'false';
            const list_style = setting.showtype == 'list' ? 0 : 1;

            const screen = data.screen;

            // 排序信息
            const orderBys = screen.orderBy;
            var sorts = new Array();
            if (orderBys != null && orderBys.length > 0) {
                for (var i = 0; i < orderBys.length; i++) {
                    var obj = orderBys[i];
                    const key = obj.sql;
                    // 去掉价格、销量排序
                    if (key != 'price asc' &&
                        key != 'price desc' &&
                        key != 'buy_count desc' &&
                        key != 'buy_w_count desc') {
                        sorts.push(obj);
                    }
                }

                if (sorts.length > 0) {
                    const sort = sorts[0];
                    this.setData({
                        cur_sort: sort.sql,
                        sort_title: sort.label
                    })
                }
            }

            // 筛选信息
            const screening_cat_id = screen.cat_id;
            const old_screening_cat_id = this.data.screening_cat_id;

            this.setData({
                need_settings: false,
                show_comment_count: show_comment_count,
                list_style: list_style,
                sorts: sorts,
                screening_cat_id: screening_cat_id,
                screening_enable: parseInt(screening_cat_id) > 0
            })

            if (this.data.screening_enable && screening_cat_id != old_screening_cat_id) {
                //加载筛选信息
                this.loadScreeningInfo();
            }
        }
    },

    // 创建商品信息对象
    goodInfoFromObj: function (obj) {
        var info = new Object();
        info.good_id = obj.goods_id;
        info.buy_count = obj.buy_count;
        info.name = obj.name;
        info.img = obj.image_default_id;
        info.comment_count = obj.comments_count;

        const products = obj.products;
        info.product_id = products.product_id;

        const prices = products.price_list;
        info.price = prices.price.format;
        info.market_price = prices.mktprice.format;
        info.inventory = products.store;

        // 是否是预售商品
        const presell = products.prepare;
        if (presell != null) {
            const presell_status = parseInt(presell.status);
            info.is_presell = presell_status > 0;
            if (info.is_presell) {
                // 预售商品信息
                info.presell_status = presell_status;
                info.presell_msg = presell.message;
            }
        }

        // 活动标签信息
        const promotion_tags = obj.promotion_tags;
        if (promotion_tags != null && promotion_tags.length > 0) {
            var tags = new Array();
            for (var i = 0; i < promotion_tags.length; i++) {
                var tagObj = promotion_tags[i];
                if (tagObj.tag_name != null) {
                    tags.push(tagObj.tag_name);
                }
            }
            info.promotion_tags = tags;
        }

        // 放在图片上的标签信息
        const image_tags = obj.tags;
        if (image_tags != null && image_tags.length > 0) {
            var tags = new Array();
            for (var i = 0; i < image_tags.length; i++) {
                var tagObj = image_tags[i];
                const params = tagObj.params;

                var tag = new Object();
                const img = params.tag_image;
                if (img == null || img.length == 0) {
                    //图片为空，使用文字
                    tag.text = tagObj.tag_name;
                    tag.textColor = tagObj.tag_fgcolor;
                    tag.backgroundColor = tagObj.tag_bgcolor;
                } else {
                    tag.img = img;
                }
                var pic_loc = params.pic_loc;
                var position = null;
                if (pic_loc == 'bl') {
                    //左下角
                    position = 'left:0;bottom:0;';
                } else if (pic_loc == 'tr') {
                    //右上角
                    position = 'right:0;top:0;';
                } else if (pic_loc == 'br') {
                    //右下角
                    position = 'right:0;bottom:0;';
                } else {
                    //左上角
                    position = 'top:0;left:0;';
                }
                tag.position = position;
                tags.push(tag);
            }
            info.image_tags = tags;
        }

        return info;
    },

    // 加载更多
    loadMore: function () {
        const infos = this.data.good_infos;
        if (infos.length < this.data.good_total_size && !this.data.load_more) {
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
            good_infos: null,
            page: 0
        })
        this.loadGoodInfo();
    },

    // 加载筛选信息
    loadScreeningInfo: function () {
        var that = this;

        // 把旧的信息清除
        that.setData({
            is_load_screening: true,
            screening_infos: null
        });

        app.request({
            method: 'b2c.gallery.filter_entries',
            cat_id: that.data.screening_cat_id
        }, function (data) {

            that.setData({
                is_load_screening: false
            })
            that.parseScreeningInfo(data);
        }, function () {
            that.setData({
                is_load_screening: false
            })
        })
    },

    // 解析筛选信息
    parseScreeningInfo: function (data) {
        const screens = data.screen.filter_entries;
        if (screens != null && screens.length > 0) {
            var items = new Array();
            // 品牌id
            const brand_id = data.brand_id;
            // 促销标签
            const promotionTagId = data.promotionTagId;

            for (var i = 0; i < screens.length; i++) {
                const obj = screens[i];
                const options = obj.options;
                if (options == null || options.length == 0)
                    continue;
                var item = new Object();
                item.name = obj.screen_name;
                item.key = obj.screen_field;
                item.single_selected = obj.screen_single; //是否单选
                item.expand = false;

                var infos = new Array();
                item.infos = infos;
                for (var j = 0; j < options.length; j++) {
                    const option = options[j];
                    var info = new Object();
                    info.id = option.val;
                    info.name = option.name;

                    info.selected = false;
                    // 把品牌和促销选中
                    if (item.key == 'brand_id' && info.id == brand_id) {
                        info.selected = true;
                        this.data.brand_id = null;
                    } else if (item.key == 'pTag' && info.id == promotionTagId) {
                        info.selected = true;
                        this.data.promotionTagId = null;
                    }
                    infos.push(info);
                }
                items.push(item);
            }

            this.data.screening_infos = items;

            var params = this.getScreeningParams();
            this.setData({
                screening_params: params,
                screening_infos: items
            })
        }
    },

    //打开购物车
    openShopcart: function(){
      wx.redirectTo({
        url: '/pages/shopcart/shopcart_nav_enable',
      })
    },

    //加入购物车
    addShopCarAction:function(event){

        if(!app.globalData.isLogin){
            app.showLogin()
            return
        }

        const that = this;
        let isPrepare = event.target.dataset.isPrepare
        let goodID = event.target.dataset.goodId
        let productID = event.target.dataset.productId
        let param
        if(isPrepare == null){
            param = operation.getAddShopCarParam(null,goodID,productID,1,0,null,0,"goods")
        }
        else{
            param = operation.getAddShopCarParam("is_fastbuy",goodID,productID,1,0,null,0,"goods")
        }
        app.request(param,
        function(data){
            if(isPrepare == null){
                wx.showToast({
                  title: '加入购物车成功',
                  success: 'success',
                });

                var shopcartCount = app.globalData.shopcartCount;
                shopcartCount ++;
                app.globalData.shopcartCount = shopcartCount;
                that.setData({
                  shopcartCount: shopcartCount
                })
            }
            else{
                let param = {};
                let key = "obj_ident" + "[" + 0 + "]";
                let id = goodID + "_" + productID
                let value = "goods_" + id
                param[key] = value
                param["isfastbuy"] = "true"
                param["method"] = "b2c.cart.checkout"
                var paramString = JSON.stringify(param);
                let isPointOrder = false
                wx.redirectTo({
                    url: '../confirmorder/confirmorder?' + 'model=' + paramString + '&isFastBuy=' + true + "&pointOrder=" + isPointOrder,
                })
            }
        },function(data){
            wx.hideToast();
        }
        ,true,true,true)
    }
})