var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    homeList:[
      // {
      //   typeid:0,
      //   name:'合伙人商品',
      //   image:'/image/011.png'
      // },
      {
        typeid: 1,
        name: '小店培训',
        image: '/image/012.png'
      },
      {
        typeid: 2,
        name: '小店活动',
        image: '/image/013.png'
      },
      {
        typeid: 3,
        name: '贝王商城',
        image: '/image/002.png'
      },
      {
        typeid: 4,
        name: '新增会员排名',
        image: '/image/rank.png'
      }
    ]
  },
  chooseItem:function(e){
    var typeId = e.currentTarget.dataset.id;
    if (typeId == '0'){
      wx.navigateTo({
        url: '/pages/goods/goods',
      })
    } else if (typeId == '1'){
      wx.navigateTo({
        url: '/pages/home/college',
      })
    } else if (typeId == '2') {
      wx.navigateTo({
        url: '/pages/home/activepage',
      })
    } else if (typeId == '3'){
      wx.navigateToMiniProgram({
        appId: 'wx3bb9017360909574',
        path: 'pages/home/home',
        extraData: {
          foo: 'bar'
        },
        envVersion: 'release',
        success(res) {
          
        }
      })
    } else if (typeId == '4'){
      wx.navigateTo({
        url: '/pages/ranking/ranking'
      })
    }
  },
  addMember:function(){
    wx.navigateTo({
      url: '../members/addmember',
    })
  },
  myMember:function(){
    wx.switchTab({
      url: '../members/list',
    })
    
  }
 
})