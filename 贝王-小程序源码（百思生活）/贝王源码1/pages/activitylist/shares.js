var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    codeimg:'',
    shareImgSrc:'',
    logo:'https://www.ibwang.cn/public/wxpro/images/home/logo.png',
    logoimg:''
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function () {
    var that = this;
    var logo = that.data.logo;
    wx.downloadFile({
      url: logo,
      success: function (res) {
        that.setData({
          logo: res.tempFilePath
        })
      }
    })
    var param = {
      method: 'b2c.activity.register',
      member_id: app.globalData.userInfo.userId
    }
    app.request(param, function (e) {
      that.setData({
        codeimg: e.code_image_id
      })
      that.downloadsFile();
      
    }, function (msg, e) {

    }, true, false, true);
    
  },
  canvas_inits:function(img){
    var that = this;
    var context = wx.createCanvasContext('firstCanvas')
    var codeimg = img;
    var logo = that.data.logo;
    context.setFillStyle('white')
    // logo图片
    context.fillRect(0, 0, 320, 420);
    context.drawImage(logo, 150, 50, 60, 60);
    // 二维码图片
    context.setFillStyle('white')
    context.drawImage(codeimg, 80, 190, 200, 200);

    context.setFontSize(14)
    context.setFillStyle('black')
    context.fillText('邀请注册，即可获得积分', 100, 130)

    context.setFontSize(14)
    context.setFillStyle('gray')
    context.fillText('保存二维码或直接扫码进入哦~', 85, 160)
    // 横线
    context.setStrokeStyle("gray")
    context.setLineWidth(2)
    context.moveTo(40, 180);//路径的起点  
    context.lineTo(330, 180);//路径的终点 

    context.stroke()
    context.draw(true, function (e) {
      that.transform_img()
    })
  },
  downloadsFile:function(){
    var that = this;
    wx.downloadFile({
      url: that.data.codeimg,
      success: function (e) {
        if (e.statusCode === 200) {
          that.canvas_inits(e.tempFilePath);
        }
      }
    })
  },
  transform_img:function(){
    var that = this;
    wx.canvasToTempFilePath({
      x: 60,
      y: 0,
      width: 960,
      height: 1500,
      destWidth: 960,
      destHeight: 1500,
      quality: 1,
      fileType: 'jpg',
      canvasId: 'firstCanvas',
      success: function (res) {
        that.setData({
          shareImgSrc: res.tempFilePath
        })
      },
      fail: function (res) {
        
      }
    })
  },
  saveImgToPhoto:function(){
    var that = this;
    //保存
    wx.saveImageToPhotosAlbum({
      filePath: that.data.shareImgSrc,
      success(res) {
        wx.showModal({
          title: '存图成功',
          content: '图片成功保存到相册了，去发圈噻~',
          showCancel: false,
          confirmText: '好哒',
          confirmColor: '#72B9C3',
          success: function (res) {
            
          }
        })
      },
      fail: function (res) {
       
      }
    })
  }
})