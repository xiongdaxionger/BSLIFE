var app = getApp()
var util = null
Page({
    data:{
        //数据
        billInfosArr:[],
        //页码
        page:1,
        //总数量
        totoal:0,
        //能否上拉
        load_more:false,
        //是否网络错误
        showFailNetWork:false,
        //选中的下标
        selectIndex:0,
        //类型
        typesInfo:["支出","收入"],
        showScrollToTop: false, //是否显示回到顶部按钮
        scroll_top: 0, //回到顶部
    },
    //页面加载
    onLoad:function(options){
        util = require('../../utils/util.js')
        this.loadBillInfo(true)
    },
    //页面卸载
    onUnload:function(){
        util = null
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
    //加载数据
    loadBillInfo:function(showLoading){
        var that = this
        let param = {"method":"b2c.member.balance"}
        param["type"] = this.data.selectIndex == 0 ? "in" : "out"
        param["page"] = this.data.page
        app.request(param
        ,function(data){
            let tmpBillArr = that.data.billInfosArr
            let dataBillArr = []
            let total = data.pager.dataCount
            let logsArr = data.advlogs
            for(var i = 0;i < logsArr.length;i++){
                let object = logsArr[i]
                let money = object.import_money.length == 0 ? "-" + object.explode_money : "+" + object.import_money
                let model = {
                    //图片
                    image:object.img,
                    //时间
                    time:util.formatTimesamp(object.mtime,0),
                    //标题
                    title:object.message,
                    //订单ID
                    orderID:object.order_id,
                    //金额
                    money:money
                }
                dataBillArr.push(model)
            }
            if(that.data.page == 1){
                tmpBillArr = dataBillArr;
            }
            else{
                Array.prototype.push.apply(tmpBillArr, dataBillArr);
            }
            that.setData({
                load_more:false,
                showFailNetWork:false,
                billInfosArr:tmpBillArr,
                selectIndex:that.data.selectIndex,
                total:total
            })
        },function(data){
            that.setData({
                showFailNetWork:true
            })
        },showLoading,true,true)
    },
    // 加载更多
    loadMore: function () {
        let length = this.data.billInfosArr.length
        if (length < this.data.total && !this.data.load_more) {
            this.setData({
                load_more: true
            })
            this.data.page = this.data.page + 1
            //可以加载
            this.loadBillInfo(true);
        }
    },
    //切换类型
    changeType:function(event){
        this.data.selectIndex = event.target.dataset.index
        this.reloadData()
    },
    //重载数据
    reloadData:function(){
        this.data.page = 1
        this.data.billInfosArr = []
        this.loadBillInfo(true)
    }
})