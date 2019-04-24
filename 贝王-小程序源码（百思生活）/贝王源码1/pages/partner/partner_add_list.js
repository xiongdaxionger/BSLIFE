// pages/partner/partner_add_list.js
Page({
  data:{
    infos: [
      {
        title : '二维码邀请',
        desc :'好友扫一扫二维码后注册并登陆即可成为会员。',
        img : getApp().getImgURL() + '/images/partner/partner_add_qrcode.png'
      },
      {
        title : '添加会员',
        desc : '会员提供资料，代会员注册即可成为会员。',
        img : getApp().getImgURL() + '/images/partner/partner_add_directly.png'
      }
    ] //列表信息
  },
  onLoad:function(options){
    // 页面初始化 options为页面跳转所带来的参数
  },

  // 点击行
  tapRow : function(event){
    const index = event.currentTarget.dataset.index;
    switch(index){
      case 0 : {
        wx.navigateTo({
          url: '/pages/partner/partner_add_qrcode'
        })
        break;
      }
      case 1 : {
        wx.navigateTo({
          url: '/pages/partner/partner_add_directly'
        })
        break;
      }
    }
  }
  
})