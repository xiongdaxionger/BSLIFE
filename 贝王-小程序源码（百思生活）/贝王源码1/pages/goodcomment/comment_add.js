// pages/goodcomment/comment_add.js

var app = getApp();

Page({
  data: {
    imageURL: "", //商品图片图片
    orderId: "", //订单id
    goodId: "", //商品id
    productId: "", //产品id

    placeHolder: "", //评论提示信息
    scoreInfos: null, //可评价信息
    total_score: 5, //总评
    total_score_id: "", //总评id
    total_scroe_name: "", //总评名称

    is_anony: true, // 是否匿名
    comment_content: "", //输入的评价内容

    images: [], //选择的图片

    imgURL: app.getImgURL(),
    fail: false, //是否加载失败
    loading: true, //是否在加载
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    this.setData({
      imageURL: options.imageURL,
      orderId: options.orderId,
      goodId: options.goodId,
      productId: options.productId
    })

    this.loadInfo();
  },

  // 点击星星
  tapStar: function (event) {
    const index = event.currentTarget.dataset.index;
    const id = event.currentTarget.dataset.id;

    var score = index + 1;
    if (id == this.data.total_score_id) {
      //点击总评
      if (this.data.total_score == score) {
        score--;
      }
      this.setData({
        total_score: score
      })
    } else {
      // 点击其他评分
      var scoreInfos = this.data.scoreInfos;
      for (var i = 0; i < scoreInfos.length; i++) {
        var obj = scoreInfos[i];
        if (obj.type_id == id) {
          if (obj.score == score) {
            score--;
          }
          obj.score = score;
          this.setData({
            scoreInfos: scoreInfos
          })
          break;
        }
      }
    }
  },

  // 输入内容改变
  contentInput: function (event) {
    this.data.comment_content = event.detail.value;
  },

  // 点击匿名
  anonyDidChange: function (event) {
    this.setData({
      is_anony: event.detail.value
    })
  },

  // 删除图片
  deleteImg:function(event){
    const index = event.currentTarget.dataset.index;
    var images = this.data.images;
    images.splice(index, 1);
    this.setData({
      images: images
    })
  },

  // 选择相片相片
  tapCamera: function (event) {

    const that = this;
    var images = this.data.images;

    wx.chooseImage({
      count: 6 - images.length, // 最多可以选择的图片张数，默认9
      sizeType: ['compressed'], // original 原图，compressed 压缩图，默认二者都有
      sourceType: ['album', 'camera'], // album 从相册选图，camera 使用相机，默认二者都有
      success: function (res) {
        // success
        const tempFilePaths = res.tempFilePaths;
        if (tempFilePaths != null) {
          for (var i = 0; i < tempFilePaths.length; i++) {

            var obj = new Object();
            obj.file_url = tempFilePaths[i];
            obj.uploading = true;
            obj.uploadFail = false;
            images.push(obj);
            that.uploadImage(obj);
          }
        }
        that.setData({
          images: images
        })
      }
    })
  },

  // 上传图片
  uploadImage:function(obj){

    const that = this;
    const images = this.data.images;
    app.request({
              method: 'b2c.member.uploadImg'
            }, function (data) {
              obj.image_id = data.imgpath;
              obj.image_path = data.imgurl;
              obj.uploading = false;
              that.setData({
                images: images
              })
            }, function (res,msg) {
              obj.uploading = false;
              obj.uploadFail = true;
              that.setData({
                images: images
              })
             
            }, false, false, false, obj.file_url, 'file');
  },

  // 点击上传图片失败
  tapUploadFail:function(event){
    const index = event.currentTarget.dataset.index;
    var images = this.data.images;
    var obj = images[index];
    const that = this;

    wx.showActionSheet({
      itemList:['重新上传', '删除'],
      success:function(res){
        switch(res.tapIndex){
          case 0 : 
            obj.uploading = true;
            obj.uploadFail = false;

            that.setData({
              images : images
            })
            that.uploadImage(obj);
            break;

            case 1 : 
            images.splice(index, 1);
            that.setData({
              images : images
            })
            break;
          }
      }
    })
  },

  // 提交评价
  tapSubmit: function () {

    const data = this.data;
    const content = data.comment_content;
    if (content == null || content.length == 0) {
      wx.showModal({
        title: "请输入评价内容",
        content: "",
        showCancel: false
      });
      return;
    }

    const images = data.images;
    for (var i = 0; i < images.length; i++) {
      const obj = images[i];
      if (obj.uploading) {
        wx.showModal({
          title: "图片正在上传，请稍后",
          content: "",
          showCancel: false
        });
        return;
      } else if (obj.uploadFail) {
        wx.showModal({
          title: "图片上传失败，请重新上传",
          content: "",
          showCancel: false
        });
        return;
      }
    }

    var params = {
      method: 'b2c.comment.toDiscuss',
      goods_id: data.goodId,
      product_id: data.productId,
      order_id: data.orderId,
      comment: content,
      hidden_name : data.is_anony ? "YES" : "NO"
    }

    // 其他评分
    const scoreInfos = data.scoreInfos;
    for (var i = 0; i < scoreInfos.length; i++) {
      const obj = scoreInfos[i];
      params['point_type[' + obj.type_id + '][point]'] = obj.score;
    }

    params['point_type[' + data.total_score_id + '][point]'] = data.total_score;

    // 晒图
    for (var i = 0; i < images.length; i++) {
      const obj = images[i];
      params['images[' + i + ']'] = obj.image_id;
    }
    app.request(params, function (result) {
      wx.showToast({
        title: '评价成功',
        icon: 'success'
      });
      wx.navigateBack({
        delta: 1, // 回退前 delta(默认为1) 页面
      })
    }, function () {

    }, true, true, true)
  },

  // 加载页面信息
  loadInfo: function () {
    const that = this;

    app.request({
      method: 'b2c.member.nodiscuss'
    }, function (data) {

      var score_infos = new Array();
      const array = data.comment_goods_type;
      for (var i = 0; i < array.length; i++) {
        const obj = array[i];
        if (obj.is_default) {
          that.setData({
            total_score_id: obj.type_id,
            total_scroe_name: obj.name
          })
        } else {
          obj.score = 0;
          score_infos.push(obj);
        }
      }

      that.setData({
        loading: false,
        placeHolder: data.submit_comment_notice,
        scoreInfos: score_infos
      })
    }, function () {
      that.setData({
        fail: true
      })
    }, true, true)
  },

  // 重新加载
  reloadData: function () {
    this.setData({
      fail: false,
    })
    this.loadInfo();
  }
})