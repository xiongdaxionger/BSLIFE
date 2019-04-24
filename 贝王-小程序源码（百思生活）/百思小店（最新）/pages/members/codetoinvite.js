var app = getApp();
var codebgimg = '';
wx.downloadFile({
  url: 'https://www.go-bslife.com/public/wxpro/images/home/0039.png',
  success: function (res) {
    if (res.statusCode == 200) {
      codebgimg = res.tempFilePath;
    }
  }
})

Page({

  /**
   * 页面的初始数据
   */
  data: {
    codeimg:'',
    imageWidth:'320',
    imageHeight: '420',
    shareImgSrc:'',
    share: false,
    uname:'',
    referralsurl:''
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function () {
    var that = this;
    var userinfos = wx.getStorageSync('userinfo');
    var params = {
      method: 'b2c.member.index',
      wx_pro_mid: userinfos.memberId,
    };
    app.request(params, function (data) {
      that.setData({
        uname: data.member.uname,
        referralsurl: data.referrals_url
      })
      
    }, function (msg, data) {

    }, true, false, true);
    that.setData({
      imageWidth:wx.getSystemInfoSync().windowWidth
    })
    that.downloadsFile();
  },
  onShow:function(){
    this.onLoad();
  },
  downloadsFile: function () {
    var that = this;
    var userinfos = wx.getStorageSync('userinfo');
    var params = {
      method: 'b2c.activity.register',
      wx_pro_mid: userinfos.memberId,
    };
    app.request(params, function (data) {
      wx.downloadFile({
        url: data.code_image_id,
        success: function (e) {
          if (e.statusCode === 200) {
            that.canvas_inits(e.tempFilePath);
          }
        }
      })
    }, function (msg, data) {

    }, true, false, true);
    
  },
  canvas_inits: function (img) {
    var that = this;
    var codeimg = img;
    var bgimg = codebgimg;
    var imageWidth = that.data.imageWidth;
    var context = wx.createCanvasContext('firstCanvas');
    var uname = '我是'+that.data.uname;
    context.setFillStyle('white')
    // 背景图
    context.fillRect(0, 0, imageWidth, 420);
    context.drawImage(bgimg, 0, 0, imageWidth, 420);
    
    // 二维码
    context.drawImage(codeimg, imageWidth / 1.7, 260, 100, 100);
    // wxbarcode.qrcode(context, that.data.referralsurl, 200, 100);
    context.stroke();
    context.setFontSize(16)
    context.setFillStyle('#e60012');
    context.fillText(uname, 70, 30);

    context.setFontSize(15)
    context.setFillStyle('#9B9B9B');
    context.fillText('我是百思品牌合伙人', 70, 50);

    context.stroke()
    context.draw(true, function (e) {
      that.transform_img()
    })
    
  },
  transform_img: function () {
    var that = this;
    var transformwidth =  that.data.imageWidth * 3;
    wx.canvasToTempFilePath({
      x: 0,
      y: 0,
      width: that.data.imageWidth,
      height: 420,
      destWidth: transformwidth,
      destHeight: 1260,
      quality: 1,
      fileType: 'jpg',
      canvasId: 'firstCanvas',
      success: function (res) {
        that.setData({
          shareImgSrc: res.tempFilePath
        })
      },
      fail: function (res) {
        console.log(res)
      }
    })
  },
  saveImgToPhoto: function () {
    var that = this;
    //保存
    wx.saveImageToPhotosAlbum({
      filePath: that.data.shareImgSrc,
      success(res) {
        wx.showModal({
          title: '存图成功',
          content: '图片成功保存到相册了',
          showCancel: false,
          confirmText: '确认',
          confirmColor: '#72B9C3',
          success: function (res) {

          }
        })
      },
      fail: function (res) {
        console.log(res)
      }
    })
  },
  share_friend: function () {
    this.setData({
      share: false
    })
  },
  // onShareAppMessage: function (res) {
  //   return app.onShareApp({ title: '邀请二维码' })
  // },
})