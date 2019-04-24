var app = getApp()
var utilJs = null;
Page({
    data:{
        /**是否显示加载失败的视图**/
        showFailNetWork:false,
        /**页码**/
        pageNumber:1,
        /**咨询数据**/
        adviceInfosArr:[],
        /**选中的下标**/
        selectIndex:0,
        /**商品ID**/
        goodID:"",
        /**商品咨询的类型**/
        adviceTypeInfosArr:[],
        /**咨询的设置信息**/
        adviceSettingInfo:{},
        /**总数**/
        total:0,
        /**图片域名**/
        imgURL: app.getImgURL(),
        /**是否跳转回复/发表咨询**/
        isRefresh:false,
        load_more: false, //是否在加载更多

    },
    /**页面显示**/
    onShow:function(){
        if(this.data.isRefresh){
            this.getContentInfo(true)
            this.data.isRefresh = false   
        }
    },
    /**页面加载完成**/
    onLoad:function(options){
        this.data.goodID = options.goodid
        utilJs = require("../../utils/util.js");
        this.getFirstPageInfo(true)
    },
    /**请求第一页的数据**/
    getFirstPageInfo:function(showLoading){
        var that = this;
        app.request({
          method:'b2c.product.goodsConsult',
          goods_id:that.data.goodID
        },function(data){
          let commentsDict = data.comments
          let settingDict = commentsDict.setting
          let adviceSettingInfo = {
              //客服电话
              phone:settingDict.submit_comment_notice_tel,
              //能否回复咨询
              canReplyAdvice:settingDict.switch_reply == "on",
              //是否需要管理员审核
              needAdminVerify:settingDict.display == "false",
              //咨询疑问提示语
              tip:settingDict.submit_comment_notice,
              //提交咨询成功提示语
              successTip:settingDict.submit_notice,
              //回复咨询的验证码
              replyCode:settingDict.verifyCode,
              //发表咨询的验证码
              adviceCode:settingDict.askVerifyCode
          }
          let total = data.pager.dataCount
          let gaskTypeInfosArr = commentsDict.gask_type
          let adviceTypeInfosArr = []
          for(var i = 0;i < gaskTypeInfosArr.length;i++){
              let typeObject = gaskTypeInfosArr[i]
              let info = {
                  //类型ID
                  typeID:typeObject.type_id,
                  //类型名称
                  name:typeObject.name,
                  //咨询数量
                  typeNumber:typeObject.total,
                  //咨询是否选中
                  isSelect:i == 0
              }
              adviceTypeInfosArr.push(info)
          }
          that.setData({
            adviceSettingInfo:adviceSettingInfo,
            adviceTypeInfosArr:adviceTypeInfosArr,
            adviceInfosArr:that.getAdviceListInfosArr(commentsDict.list.ask),
            total:total,
            load_more:false,
            showFailNetWork:false
          })
        },function(data){
            that.setData({
              showFailNetWork:true
            })
        },showLoading,true,true)
    },
    /**请求多页的数据**/
    getContentInfo:function(showLoading){
        var that = this
        let selectModel = this.data.adviceTypeInfosArr[this.data.selectIndex]
        app.request({
          method:'b2c.comment.getAsk',
          page:this.data.pageNumber, 
          goods_id:that.data.goodID,
          type_id:selectModel.typeID,
        },function(data){
          let listInfosArr = that.getAdviceListInfosArr(data.comments.list.ask)
          let tmpArr = that.data.adviceInfosArr
          let total = data.pager.dataCount
          if(that.data.pageNumber == 1){
            tmpArr = listInfosArr;
          }
          else{
            Array.prototype.push.apply(tmpArr, listInfosArr);
          }
          that.setData({
            adviceInfosArr:tmpArr,
            total:total,
            load_more:false,
            showFailNetWork:false
          })
        },function(data){
            that.setData({
              showFailNetWork:true
            })
        },showLoading,true,true)
    },
    //解析咨询列表数据
    getAdviceListInfosArr:function(list){
        let listArr = []
        for(var i = 0;i < list.length;i++){
            let object = list[i]
            let items = object.items
            let answerItems = []
            if(items != null){
                for(var j = 0;j < items.length;j++){
                        let item = items[j]
                        let info = {
                        //回复ID
                        adviceID:item.comment_id,
                        //回复内容
                        content:item.comment,
                        //咨询时间
                        time:utilJs.previousDateFromTimesamp(item.time),
                        //咨询发布者用户名
                        authorName:item.author,
                        //咨询发布者ID
                        authorID:item.author_id,
                        //回复类型
                        contentType:item.author_id == "0" ? 2 : 3
                    }
                    answerItems.push(info)
                }
            }
            let model = {
                //咨询ID
                adviceID:object.comment_id,
                //咨询内容
                content:object.comment,
                //咨询时间
                time:utilJs.previousDateFromTimesamp(object.time),
                //咨询发布者用户名
                authorName:object.author,
                //咨询发布者ID
                authorID:object.author_id,
                //是否显示更多
                showMoreOpen:false,
                //咨询类型-1代表提问,2代表管理员回答,3代表用户回答
                contentType:1,
                //回答的内容
                items:answerItems
            }
            listArr.push(model)
        }
        return listArr
    },
    /**发布咨询**/
    addAdvice:function(){
        this.data.isRefresh = true
        let settingString = JSON.stringify(this.data.adviceSettingInfo)
        let typeString = JSON.stringify(this.data.adviceTypeInfosArr)
        wx.navigateTo({
            url: '../advice/addadvice?' + 'goodid=' + this.data.goodID + '&setting=' + settingString + '&typeString=' + typeString,
        })
    },
    /**更改点击显示更多状态**/
    changeShowMore:function(event){
        let index = event.target.dataset.index
        let model = this.data.adviceInfosArr[index]
        model.showMoreOpen = !model.showMoreOpen
        this.setData({
            adviceInfosArr:this.data.adviceInfosArr
        })
    },
    /**更改状态**/
    changeType:function(event){
        let index = event.target.dataset.index
        this.setData({
            selectIndex:index
        })
        this.data.pageNumber = 1
        this.getContentInfo(true)
    },
    /**回复咨询**/
    replyAction:function(event){
        this.data.isRefresh = true
        let model = this.data.adviceInfosArr[event.target.dataset.index]
        let modelString = JSON.stringify(model)        
        let settingString = JSON.stringify(this.data.adviceSettingInfo)
        wx.navigateTo({
            url: '../replyadvice/replyadvice?' + 'model=' + modelString + '&setting=' + settingString,
        })
    },
    // 加载更多
    loadMore: function () {
        let length = this.data.adviceInfosArr.length;
        if (length < this.data.total && !this.data.load_more) {
            this.setData({
                load_more: true
            })
            this.data.pageNumber = this.data.pageNumber + 1
            //可以加载
            this.getContentInfo(true);
        }
    },
    /**重新加载信息**/
    reloadData:function(){
      this.getFirstPageInfo(true)
    },
})