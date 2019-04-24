// 统计
var app = getApp();

Page({
  data: {
    fail: false, //是否加载失败
    loading: true, //是否在加载

    selectedIndex: 0, //选中的菜单

    xAxis: null, //x轴信息
    xAxisWidth: 0, //x轴宽度
    pointRadius: 3.5, //圆点半径

    barInfo: null, //菜单信息

    title: '', //当前标题
    amount: '', //当前金额

    infos: null, //佣金收入信息

    points: null, //当前显示的点
    touching: false, //是否正在点击
    selectedPoint: null, //当前点击的位置
    selectedPointIndex: -1, //当前点击的位置下标
  },
  onLoad: function (options) {
    // 页面初始化 options为页面跳转所带来的参数
    this.loadInfo();
  },

  /**状态栏动作**/
  barItemDidChange: function (event) {

    const index = parseInt(event.target.dataset.index)
    if (index == this.data.selectedIndex)
      return;
    this.setData({
      selectedIndex: index
    }
    )
    this.reloadChart();
  },

  // 触摸图标事件
  touchStart: function (event) {
    this.refreshTouch(event.touches[0].pageX);
  },

  touchMove: function (event) {
    this.refreshTouch(event.touches[0].pageX);
  },

  touchEnd: function (event) {
    this.stopTouch();
  },

  touchCancel: function (event) {
    this.stopTouch();
  },

  // 刷新触摸位置
  refreshTouch: function (x) {


    const points = this.data.points;
    var selectedPointIndex = points.length - 1;
    for (var i = 1; i < points.length; i++) {
      const point = points[i];
      if (x <= point.x + 1.0) {
        selectedPointIndex = i;
        if (i != 0) {
          const previousPoint = points[i - 1];
          if (x <= previousPoint.x + 1 + (point.x - previousPoint.x) / 2) {
            selectedPointIndex = i - 1;
          }
        }
        break;
      }
    }


    const selectedPoint = this.data.xAxis[selectedPointIndex];
    this.setData({
      selectedPoint: selectedPoint,
      selectedPointIndex: selectedPointIndex,
      touching: true
    })

    // const point = points[selectedPointIndex];
    //     const screenWidth = app.globalData.systemInfo.windowWidth;
    //     const ctx = wx.createCanvasContext('bubble')
    //     ctx.setFillStyle('white');
    //     ctx.setLineCap('round');
    //     ctx.setLineJoin('round');
    //     ctx.moveTo(0, 60);
    //     ctx.lineTo(point.x - 10, 60);
    //     ctx.lineTo(point.x, 70);
    //     ctx.lineTo(point.x + 10, 60);
    //     ctx.lineTo(screenWidth, 60);
    //     ctx.lineTo(screenWidth, 0);
    //     ctx.lineTo(0, 0);
    //     ctx.lineTo(0, 60);
    //     ctx.fill();
    //      ctx.draw();
  },

  // 结束触摸
  stopTouch: function () {
    this.setData({
      touching: false,
      selectedPointIndex: -1
    })
  },

  // 刷新图表
  reloadChart: function () {
    const info = this.data.infos[this.data.selectedIndex];


    const list = info.list;
    var points = new Array();
    const scale = 225;

    const screenWidth = app.globalData.systemInfo.windowWidth;

    const widthEach = screenWidth / list.length;
    const margin = widthEach / 2;
    var x = margin;

    var xAxis = new Array();
    // 计算点
    for (var i = 0; i < list.length; i++) {
      const obj = list[i];
      points[i] = {
        x: x,
        y: scale - obj.data * scale / screenWidth
      };
      xAxis[i] = obj;
      x += widthEach;
    }
    this.setData({
      title: info.label,
      amount: info.sum,
      xAxisWidth: widthEach,
      xAxis: xAxis,
      points: points
    })

    const ctx = wx.createCanvasContext('statistical')
    ctx.setStrokeStyle('#f73030');
    ctx.setLineWidth(2);
    ctx.setLineCap('round');
    ctx.setLineJoin('round');

    for (var i = 0; i < points.length; i++) {
      var point = points[i];
      if (i == 0) {
        ctx.moveTo(point.x, point.y);
      } else {
        ctx.lineTo(point.x, point.y);
      }
    }
    ctx.stroke();

    const pointRadius = this.data.pointRadius;
    ctx.setFillStyle('#f73030');
    for (var i = 0; i < points.length; i++) {
      ctx.beginPath();
      var point = points[i];
      ctx.arc(point.x, point.y, pointRadius, 0, Math.PI * 2, true);
      ctx.closePath();
      ctx.fill();
    }
    ctx.draw();
  },

  // 加载统计信息
  loadInfo: function () {
    const that = this;
    app.request({
      method: 'distribution.stats.income'
    }, function (data) {

      const array = data.data;
      var barInfo = new Array();
      var infos = new Array();

      for (var i = 0; i < array.length; i++) {
        const obj = array[i];
        barInfo[i] = obj.label;
        infos[i] = obj.list[0];
      }

      that.setData({
        barInfo: barInfo,
        infos: infos,
        loading: false
      })

      that.reloadChart();
    }, function () {
      that.setData({
        fail: true
      })
    }, true, true, true)
  },

  // 重新加载
  reloadData: function () {
    this.setData({
      fail: false,
    })
    this.loadInfo();
  }
})