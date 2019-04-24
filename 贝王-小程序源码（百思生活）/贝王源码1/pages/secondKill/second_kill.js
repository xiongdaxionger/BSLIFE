
//app实例
const app = getApp();

// 秒杀计时器
var secondKillTimer = null;

Page({
    data: {
        imgURL:app.getImgURL(),
        fail: false, //加载失败


        banner_infos: null, //轮播广告信息
        banner_height: 0, //轮播广告高度
        section_infos: null, //秒杀场次信息

        selectedSection: 0, //当前选中的场次
        serverTimeStamp: 0, // 服务器时间戳

        good_swiper_height: 0,  //秒杀商品高度

        showScrollToTop: false, //是否显示回到顶部按钮
        scroll_top: 0, //回到顶部

        screen_width: 0,// 屏幕宽度
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
    onLoad: function (options) {
        // 页面初始化 options为页面跳转所带来的参数
        // 设置轮播图默认高度
      
        this.data.banner_height = 750.0 * 500.0 / 1242.0;

        this.data.screen_width = app.globalData.systemInfo.windowWidth;
        this.loadInfo();
    },
    onUnload: function () {
        // 页面关闭
        this.stopTimer();
    },

    // 点击广告
    tapad: function (event) {
        const type = event.currentTarget.dataset.type;
        const id = event.currentTarget.dataset.id;

        app.openAdPage(type, id);
    },

    // 商品页面切换
    goodPageDidChange: function (event) {
        const current = event.detail.current;
        this.refreshGoodList(current);
    },

    // 选择场次
    tapSection: function (event) {
        const index = event.currentTarget.dataset.index;
        if (index != this.data.selectedSection) {
            this.refreshGoodList(index);
        }
    },

    // 刷新商品列表
    refreshGoodList: function (index) {

        const sectionInfo = this.data.section_infos[index];
        const good_infos = sectionInfo.infos;

        this.setData({
            selectedSection: index,
            good_swiper_height: good_infos.length * 130 + 40
        })
    },

    // 点击商品
    tapGood: function (event) {
        const index = event.currentTarget.dataset.index;

        const section_infos = this.data.section_infos;
        const sectionInfo = [this.data.selectedSection];
        const good_infos = sectionInfo.infos;
        const info = good_infos[index];

        // 查看商品详情
         wx.navigateTo({
      url: '/pages/gooddetail/gooddetail?productID=' + info.productId,
    })
    },

    // 点击立即抢购,提醒
    tapShopBtn: function (event) {
        const index = event.currentTarget.dataset.index;

        const section_infos = this.data.section_infos;
        const sectionInfo = section_infos[this.data.selectedSection];
        const good_infos = sectionInfo.infos;
        
        const that = this;
        if (sectionInfo.status == 1) {
            //已开始，判断商品是否已卖完
            const info = good_infos[index];
            if (!info.soldout) {
                if (!app.globalData.isLogin) {
                    // 弹出登录
                    app.showLogin();
                } else {
                  wx.navigateTo({
                    url: '/pages/gooddetail/gooddetail?productID=' + info.productId,
                  })
                }
            }
        } else if (sectionInfo.status == 3) {
            // 提醒或者取消提醒
            if (!app.globalData.isLogin) {
                // 弹出登录
                app.showLogin();
            } else {
                const info = good_infos[index];
                if (info.is_remind) {
                    // 取消提醒
                    app.request({
                        method: 'starbuy.special.del_remind',
                        product_id: info.productId
                    }, function (data) {
                        wx.showToast({
                            title: '已取消提醒',
                            icon: 'success',
                        });
                        info.is_remind = false;
                        that.setData({
                            section_infos: section_infos
                        })
                    }, function () {

                    }, true, true, true)
                } else {
                    // 提醒
                    app.request({
                        method: 'starbuy.special.save_remind',
                        type_id: 2,
                        product_id: info.productId,
                        remind_time: sectionInfo.remindTime,
                        begin_time: sectionInfo.beginTime,
                        member_id: app.globalData.userInfo.userId
                    }, function (data) {
                        wx.showToast({
                            title: '设置成功',
                            icon: 'success',
                        });
                        info.is_remind = true;
                        that.setData({
                            section_infos: section_infos
                        })
                    }, function () {

                    }, true, true, true)
                }
            }
        }
    },

    // 启动倒计时
    startTimer: function () {
        if (secondKillTimer != null)
            return;

        var that = this;
        const section_infos = this.data.section_infos;
        this.secondKillCountDown();
        if (section_infos != null && section_infos.length > 0) {
            secondKillTimer = setInterval(function () {
                that.secondKillCountDown();
            }, 1000)
        }
    },

    // 结束秒杀计时器
    stopTimer: function () {
        if (secondKillTimer != null) {
            clearInterval(secondKillTimer);
            secondKillTimer = null;
        }
    },

    // 秒杀倒计时
    secondKillCountDown: function () {
        const section_infos = this.data.section_infos;
        for (var i = 0; i < section_infos.length; i++) {
            const sectionInfo = section_infos[i];
            this.formatTimer(sectionInfo);
        }

        const serverTimeStamp = this.data.serverTimeStamp;
        this.setData({
            section_infos: section_infos,
            serverTimeStamp: serverTimeStamp + 1
        });
    },

    // 秒杀倒计时格式化
    formatTimer: function (sectionInfo) {
        const serverTimeStamp = this.data.serverTimeStamp;

        var time = 0;
        if (sectionInfo.beginTime > serverTimeStamp) {
            //秒杀未开始
            time = sectionInfo.beginTime;
            sectionInfo.timer_title = "距开始";

            if (sectionInfo.remindTime > serverTimeStamp) {
                //可提醒了
                sectionInfo.status = 3;
            } else {
                sectionInfo.status = 2; //未开始
            }
        } else if (sectionInfo.endTime > serverTimeStamp) {
            // 秒杀未结束
            time = sectionInfo.endTime;
            sectionInfo.timer_title = "距结束";
            sectionInfo.status = 1;  //已开始 未结束
        } else {
            sectionInfo.status = 0; //已结束
        }

        if (time > 0) {
            time = time - serverTimeStamp;
            // 格式化时间戳
            var result = parseInt(time / 60);
            var second = time % 60;

            var minute = result % 60;
            var hour = parseInt(result / 60);
            sectionInfo.hour = hour < 10 ? '0' + hour : hour;
            sectionInfo.minutes = minute < 10 ? '0' + minute : minute;
            sectionInfo.second = second < 10 ? '0' + second : second;
            sectionInfo.isSecondKillEnd = false;

        } else {
            //秒杀已结束
            sectionInfo.isSecondKillEnd = true;
        }
    },

    //   加载秒杀信息
    loadInfo: function () {

        const that = this;
        app.request({
            method: 'starbuy.special.index',
            type_id: 2
        }, function (data) {

            that.parseInfos(data)
        }, function () {
            that.setData({
                fail: true
            });
        }, true)
    },

    // 解析秒杀信息
    parseInfos: function (data) {

        const items = data.data;
        var sectionInfos = new Array();
        // 秒杀信息
        if (items != null && items.length > 0) {

            for (var i = 0; i < items.length; i++) {
                const item = items[i];

                const goods = item.goods;
                if (goods == null || goods.length == 0)
                    continue;

                const sectionObj = item.info;
                var sectionInfo = this.sectionInfoFromObj(sectionObj);

                // 商品信息
                var goodInfos = new Array();
                for (var j = 0; j < goods.length; j++) {
                    const goodObj = goods[j];
                    var goodInfo = new Object();
                    goodInfo.goodId = goodObj.goods_id;
                    goodInfo.productId = goodObj.product_id;
                    goodInfo.goodName = goodObj.product_name;
                    goodInfo.img = goodObj.image_default_id;
                    goodInfo.price = goodObj.promotion_price;
                    goodInfo.market_price = goodObj.price;
                    goodInfo.soldout = goodObj.status != 'true'; //是否已售罄
                    goodInfo.is_remind = goodObj.is_remind; //是否已订阅提醒

                    goodInfos.push(goodInfo);
                }
                sectionInfo.infos = goodInfos;
                sectionInfos.push(sectionInfo);
            }
        }

        // 轮播广告信息
        const banners = data.slideBox.params.pic;
        var infos = new Array();
        if (banners != null && banners.length > 0) {

            // 轮播广告高度
            const scale = parseInt(data.slideBox.params);
            if (scale > 0) {
                this.data.banner_height = app.globalData.systemInfo.windowWidth / scale;
            }

            for (var i = 0; i < banners.length; i++) {
                const banner = banners[i];
                var info = new Object();
                info.id = banner.url_id;
                info.img = banner.link;
                info.type = banner.url_type;
                infos.push(info);
            }
        }

        this.setData({
            section_infos: sectionInfos,
            banner_infos: infos
        })

        if (this.data.section_infos.length > 0) {
            this.refreshGoodList(0);
        }
        this.startTimer();
    },

    // 创建秒杀场次对象
    sectionInfoFromObj: function (obj) {

        var sectionInfo = new Object();
        sectionInfo.remindTime = obj.remind_time;
        sectionInfo.beginTime = obj.begin_time;
        sectionInfo.endTime = obj.end_time;
        sectionInfo.name = obj.name;

        this.data.serverTimeStamp = obj.sys_time;

        const date = new Date(parseInt(sectionInfo.beginTime) * 1000);

        const month = date.getMonth() + 1
        const day = date.getDate()

        const hour = date.getHours()
        const minute = date.getMinutes()
        sectionInfo.date = this.formatNumber(month) + '月' + this.formatNumber(day);
        sectionInfo.time = this.formatNumber(hour) + ':' + this.formatNumber(minute);

        return sectionInfo;
    },

    // 补0
    formatNumber: function (n) {
        n = n.toString()
        return n[1] ? n : '0' + n
    },

    ///点击加载失败调用
    reloadData: function () {

        this.setData({
            fail: false
        });

        this.loadInfo();
    }
})