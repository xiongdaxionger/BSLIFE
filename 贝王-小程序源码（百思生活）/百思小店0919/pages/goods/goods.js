// pages/goods/goods.js
Page({

  /**
   * 页面的初始数据
   */
  data: {
    goodsType:[
      {
        typeid:0,
        name:'全部商品'
      },
      {
        typeid: 1,
        name: '默认分类'
      },
      {
        typeid: 2,
        name: '服饰'
      }
    ],
    typeid:0
  },
  chooseType:function(e){
    this.setData({
      typeid: e.currentTarget.dataset.id
    })
  }
})