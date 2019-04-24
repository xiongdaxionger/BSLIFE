// pages/user/userInfo_modify.js

var stringJs = null;

Page({
  data: {
    info: null, //要修改的个人信息
    placeholder: '', //输入框信息
    input_type: 'text', //输入类型
    input_content: '', // 输入内容

    msg: null, //提示信息

    showErrMsg: false, //是否显示错误信息
    errMsg: '', //错误信息
    saveEnable: false, //是否可以保存
  },
  onLoad: function (options) {
    stringJs = require("../../utils/string.js");
    // 页面初始化 options为页面跳转所带来的参数
    const info = JSON.parse(options.info);
    var input_type = 'text';
    switch (info.content_type) {
      case 1: {
        input_type = 'number';
      }
    }

    var msg = null;
    switch (info.type) {
      case 1: {
        msg = info.title + '设置后不可修改';
      }
    }

    this.setData({
      info: info,
      placeholder: '请输入' + info.title,
      input_content: info.content,
      input_type: input_type,
      msg: msg
    })

    this.saveEnable();
  },
  onReady: function () {
    // 页面渲染完成
    wx.setNavigationBarTitle({
      title: this.data.info.title
    });
  },
  onUnload: function () {
    // 页面关闭
    stringJs = null;
  },

  // 输入内容改变
  textDidChange: function (event) {
    this.data.input_content = event.detail.value;
    this.saveEnable();
  },

  // 监听是否可以保存
  saveEnable: function () {
    const input_content = this.data.input_content;
    var enable = true;
    const info = this.data.info;
    var errMsg = null;
    var showErrMsg = false;

    if (input_content == null || input_content.length == 0) {
      enable = false;
    } else {
      switch (info.content_type) {
        case 1: {
          // 只能输入数字
          if (!stringJs.isPureNumber(input_content)) {
            showErrMsg = true;
            errMsg = info.title + '只能输入数字';
            enable = false;
          }
          break;
        }
        case 2: {
          //只能输入字母
          if (!stringJs.isPureLetter(input_content)) {
            showErrMsg = true;
            errMsg = info.title + '只能输入字母';
            enable = false;
          }
          break;
        }
        case 3: {
          //只能输入字母和数字
          if (!stringJs.isNumberAndLetter(input_content)) {
            showErrMsg = true;
            errMsg = info.title + '只能输入字母和数字';
            enable = false;
          }
          break;
        }
      }
    }

    this.setData({
      saveEnable: enable,
      showErrMsg: showErrMsg,
      errMsg: errMsg
    })
  },

  // 保存
  save: function () {

    const data = this.data;
    if(!data.saveEnable)
    return;
    const info = data.info;

    //内容没有修改，直接返回
    if (data.input_content == info.content) {
      wx.navigateBack({
        delta: 1, // 回退前 delta(默认为1) 页面
      });
      return;
    }

    // 保存
    var params = null;
    if (info.type == 1) {
      // 设置账号
      params = {
        method: 'b2c.passport.save_local_uname',
        local_name: data.input_content
      }
    } else {
      params = {
        method: 'b2c.member.save_setting'
      }
      params[info.key] = data.input_content;
    }
    const app = getApp();
    app.request(params, function (result) {

      wx.setStorageSync('userInfo_modify_value', data.input_content);
      wx.navigateBack({
        delta: 1, // 回退前 delta(默认为1) 页面
      });
    }, function () {

    }, true, true, true);
  }
})