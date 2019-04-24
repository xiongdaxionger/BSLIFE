var app = getApp()
Page({
    data: {
        //查询单号--物流单号/订单号
        checkID:"",
        //是否查询单号为订单号
        isOrderID:false,
        //是否加载失败
        showFailNetWork:false,
        //物流公司
        logisticsCompany:"",
        //物流单号
        logisticsNumber:"",
        //物流信息
        logisticsInfosArr:[],
        //图片域名
        imgURL: app.getImgURL(),
    },
    //页面加载完成
    onLoad:function(options){
        this.data.checkID = options.id
        this.data.isOrderID = options.isOrder == "true"
        this.loadLogisticsInfo(true)
    },
    //加载物流信息
    loadLogisticsInfo:function(showLoading){
        var that = this;
        var param = {
            method:'b2c.order.get_delivery'
        }
        if(this.data.isOrderID){
            param["order_id"] = this.data.checkID
        }
        else{
            param["delivery_id"] = this.data.checkID
        }
        app.request(param,function(data){
            let log_name
            let logi_no
            let tmpInfosArr = []
            let error = data.logi_error
            if(error == null){
                log_name = data.logi_name
                logi_no = data.logi_no
                let infosArr = data.logi
                for(var i = 0;i < infosArr.length;i++){
                    let object = infosArr[i]
                    let model = {
                        //时间
                        time:object.AcceptTime,
                        //信息
                        message:object.AcceptStation
                    }
                    tmpInfosArr.push(model)
                }
            }
            else{
                log_name = "暂无物流信息"
                logi_no = "暂无物流信息"
            }
            that.setData({
              showFailNetWork:false,
              logisticsCompany:log_name,
              logisticsNumber:logi_no,
              logisticsInfosArr:tmpInfosArr
            })
        },function(data){
            that.setData({
              showFailNetWork:true
            })
        },showLoading,true,true)
    },
    /**数据重载**/
    reloadData:function(){
        this.loadLogisticsInfo(true)
    },
})