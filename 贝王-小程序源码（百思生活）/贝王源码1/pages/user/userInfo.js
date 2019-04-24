
var app = getApp();
var area_selected = null;

Page({
    data: {
        imgURL: app.getImgURL(),
        fail: false, //页面是否加载失败
        namePrefix: null, //名字前缀

        //  信息类
        info_type: {
            other: -1,//其他
            avatar: 0, //头像
            account: 1, //账号
            phoneNumber: 2, //手机号
            email: 3, //邮箱
            name: 4, //昵称姓名
            sex: 5 //性别
        },

        // 输入内容类型
        content_type: {
            text_unlimited: 0, //文本输入无限制
            only_number: 1, //只能输入数字
            only_letter: 2, //只能输入字母
            number_letter: 3, //数字和字母
            radio: 4, //单选
            multi_selection: 5, //多选
            area: 6, //地区
            date: 7, //时间
            img: 8 //图片
        },

        // 可编辑的信息
        infos: null,

        selectedIndex: -1, //要编辑的信息下标 -1 表示没有选中的

        endDate: null, //结束时间

        show_options: false, //是否显示选项列表
        options: null, //选项信息
        optionsTranslateAnimation: null, //选项弹出动画
        optionsOpacityAnimation: null, //透明动画
        options_title: '', //选项标题

        areaTranslateAnimation: null, //地区弹出动画
        areaOpacityAnimation: null, //地区透明动画
        is_load_area: false, //是否正在加载地区信息
        cur_area_infos: null, //当前选择地区信息
        show_area: false, //是否显示地区
        area_selectedIndex: 0, //选中的地区
        area_scroll_top: 0, //回到顶部
    },

    // 关闭地区
    areaClose: function () {
        area_selected.areaClose();
    },

    // 地区菜单按钮改变
    areaBarItemDidChange: function (event) {
        area_selected.areaBarItemDidChange(event);
    },

    //地区页面改变
    areaPageDidChange: function (event) {
        area_selected.areaPageDidChange(event);
    },

    // 点击地区行
    tapAreaItem: function (event) {
        area_selected.tapAreaItem(event);
    },

    // 选择地区完成
    areaDidDone: function (mainland, content) {

        const infos = this.data.infos;
        const info = infos[this.data.selectedIndex];
        const that = this;
        var params = {
            method: 'b2c.member.save_setting'
        };
        params[info.key] = mainland;
        app.request(params, function (result) {

            info.content = content;
            area_selected.setSelectedAreaInfos(that.data.cur_area_infos);
            that.setData({
                infos: infos
            })
            wx.showToast({
                title: '设置成功',
                icon: 'success'
            });
        }, function () {

        }, true, true, true);
    },

    onLoad: function (options) {
        // 页面初始化 options为页面跳转所带来的参数

        // 如果开启分销并且名称前缀不为空，则添加
        const globalData = app.globalData;
        var userInfo = globalData.userInfo;
        if (userInfo.openFenxiao && userInfo.namePrefix != null && userInfo.namePrefix.length > 0) {
            this.data.namePrefix = userInfo.namePrefix;
        }
        // 清除旧的信息
        wx.removeStorageSync('userInfo_modify_value');
        area_selected = require("../../views/widget/area_selected.js");
        this.loadEditableUserInfo();
    },
    onReady: function () {
        // 页面渲染完成

    },
    onShow: function () {
        // 页面显示
        area_selected.init(this);
        if (this.data.selectedIndex < 0)
            return;
        // 获取修改后的信息刷新UI
        const value = wx.getStorageSync('userInfo_modify_value');

        const infos = this.data.infos;
        const info = infos[this.data.selectedIndex];
        const info_type = this.data.info_type;

        if (value != null && value.length > 0) {
            wx.showToast({
                title: '设置成功',
                icon: 'success'
            });

            info.content = value;

            if (info.type == info_type.account) {
                info.editable = false; //账号只能设置一次
            }
            this.setData({
                infos: infos
            })
            wx.removeStorageSync('userInfo_modify_value');
        }

        if (info.type == info_type.phoneNumber) {
            const phoneNumber = app.globalData.userInfo.phoneNumber;
            if (phoneNumber != null) {
                info.content = phoneNumber;
                this.setData({
                    infos: infos
                })
            }
        }
    },
    onUnload: function () {
        // 页面关闭
        area_selected.clear();
        area_selected = null;
    },

    // 显示选项
    showOptions: function () {

        const infos = this.data.infos;
        const info = infos[this.data.selectedIndex];
        var arrayUtil = require('../../utils/array.js');

        var options = new Array();
        for (var i = 0; i < info.options.length; i++) {
            var option = new Object();
            option.title = info.options[i];
            option.selected = arrayUtil.contains(option.title, info.selectedOptions);
            options.push(option);
        }

        this.setData({
            show_options: true,
            options: options,
            options_title: info.title
        })
        this.optionsAnimation(true);
    },


    // 选项动画
    optionsAnimation: function (show) {
        var that = this;

        //屏幕高度
        const height = app.globalData.systemInfo.windowHeight;
        var animation = wx.createAnimation({
            duration: 300,
        });

        //修改透明度,偏移
        this.setData({
            optionsOpacityAnimation: animation.opacity(show ? 1 : 0).step().export(),
            optionsTranslateAnimation: animation.translateY(show ? -height * 0.7 : height * 0.7).step().export()
        })
    },

    // 关闭选项
    closeoptions: function () {
        this.optionsAnimation(false);
        const that = this;
        var timer = setTimeout(function () {
            that.setData({
                show_options: false
            })
            clearTimeout(timer);
            timer = null;
        }, 400)

    },

    // 点击选项item
    tapOptionsItem: function (event) {
        const index = parseInt(event.currentTarget.dataset.index);

        const options = this.data.options;
        var option = options[index];
        const content_type = this.data.content_type;
        const infos = this.data.infos;
        const info = infos[this.data.selectedIndex];

        // 只能单选
        if (info.content_type == content_type.radio) {
            if (!option.selected) {
                var params = new Object();
                const info_type = this.data.info_type;
                if (info.type == info_type.sex) {
                    params[info.key] = option.title == '男' ? 'male' : 'female';
                } else {
                    params[info.key] = option.title;
                }
                this.optionsSubmit(params, info, infos, [option.title]);
            }
        } else {
            option.selected = !option.selected;
            this.setData({
                options: options
            })
        }
    },

    // 选项完成
    optionsDone: function () {
        const content_type = this.data.content_type;
        const infos = this.data.infos;
        const info = infos[this.data.selectedIndex];
        if (info.content_type == content_type.multi_selection) {
            const options = this.data.options;
            var params = new Object();
            var selectedOptions = new Array();
            var count = 0;
            for (var i = 0; i < options.length; i++) {
                const option = options[i];
                if (option.selected) {
                    params[info.key + '[' + count + ']'] = option.title;
                    selectedOptions.push(option.title);
                    count++;
                }
            }
            if (count == 0) {
                params[info.key] = '';
            }
            this.optionsSubmit(params, info, infos, selectedOptions);
        }
    },

    // 提交选项
    optionsSubmit: function (params, info, infos, selectedOptions) {
        this.closeoptions();

        params.method = 'b2c.member.save_setting';
        const that = this;
        app.request(params, function (result) {

            info.content = selectedOptions.join('，');
            info.selectedOptions = selectedOptions;
            that.setData({
                infos: infos
            })
            wx.showToast({
                title: '设置成功',
                icon: 'success'
            });
        }, function () {

        }, true, true, true);
    },

    // 时间选择改变
    dateDidChange: function (event) {

        const value = event.detail.value;
        const index = parseInt(event.currentTarget.id);
        const infos = this.data.infos;
        const info = infos[index];
        if (value == info.content) //内容没有改变
            return;

        var params = {
            method: 'b2c.member.save_setting'
        }
        params[info.key] = value;

        const that = this;
        app.request(params, function (result) {

            info.content = value;
            that.setData({
                infos: infos
            })
            wx.showToast({
                title: '设置成功',
                icon: 'success'
            });
        }, function () {

        }, true, true, true);
    },

    // 点击行
    tapRow: function (event) {
        const index = event.currentTarget.dataset.index;


        const info = this.data.infos[index];
        if (!info.editable)
            return;
        this.data.selectedIndex = index;
        const info_type = this.data.info_type;
        const content_type = this.data.content_type;

        switch (info.type) {
            case info_type.avatar: {
                this.pickImage();
                break;
            }
            case info_type.name:
            case info_type.account: {
                this.openModifyPage(info);
                break;
            }
            case info_type.sex: {
                // 性别
                this.showOptions();
                break;
            }
            case info_type.phoneNumber: {
                // 绑定手机号
                if (info.content == null || info.content.length == 0) {
                    wx.navigateTo({
                        url: '/pages/user/bind_phone'
                    })
                }
                break;
            }
            case info_type.other: {
                switch (info.content_type) {
                    case content_type.img: {
                        this.pickImage();
                        break;
                    }
                    case content_type.area: {
                        //地区
                        area_selected.show();
                        break;
                    }
                    case content_type.date: {
                        //时间

                        break;
                    }
                    case content_type.radio:
                    case content_type.multi_selection: {
                        // 单选多选
                        this.showOptions();
                        break;
                    }
                    default: {
                        this.openModifyPage(info);
                        break;
                    }
                }
                break;
            }
        }
    },

    // 修改个人信息
    openModifyPage: function (info) {
        const param = JSON.stringify(info);
        wx.navigateTo({
            url: '/pages/user/userInfo_modify?info=' + param
        })
    },

    // 选择图片
    pickImage: function () {

        const that = this;
        wx.chooseImage({
            count: 1, // 最多可以选择的图片张数，默认9
            sizeType: ['compressed'], // original 原图，compressed 压缩图，默认二者都有
            sourceType: ['album', 'camera'], // album 从相册选图，camera 使用相机，默认二者都有
            success: function (res) {
                const tempFilePaths = res.tempFilePaths;
                if (tempFilePaths != null && tempFilePaths.length > 0) {

                    const infos = that.data.infos;
                    const info = infos[that.data.selectedIndex];
                    app.request({
                        method: 'b2c.member.save_setting'
                    }, function (data) {
                        if (data != null) {
                            info.content = data.image_src;
                            that.setData({
                                infos: infos
                            })
                            wx.showToast({
                                title: '上传成功',
                                icon: 'success'
                            });
                        }
                    }, function () {

                    }, true, true, true, tempFilePaths[0], info.key);
                }
            },
        })
    },

    //   加载可编辑的资料信息
    loadEditableUserInfo: function () {

        const that = this;
        app.request({
            method: 'b2c.member.setting'
        }, function (data) {

            that.parseEditableUserInfo(data);
        }, function () {
            that.setData({
                fail: true
            })
        }, true, true);
    },

    // 解析可编辑的资料信息
    parseEditableUserInfo: function (data) {

        const attrs = data.attr;
        var infos = new Array();

        const info_type = this.data.info_type;
        const content_type = this.data.content_type;

        var index = 0;
        for (var i = 0; i < attrs.length; i++) {
            const attr = attrs[i];
            const key = attr.attr_column;

            const type = this.typeForKey(key);
            var content = attr.attr_value;
            if (content == null) {
                content = "";
            }
            var info = new Object();
            info.title = attr.attr_name;
            info.content = content;
            info.editable = attr.attr_edit == 'true'; //是否可编辑
            info.type = type;
            info.key = key;
            info.content_type = 0;

            switch (type) {
                case info_type.avatar: {
                    if (content == null || content.length == 0) {
                        info.content = data.addUploadImg; //默认头像
                    }
                    index++;
                    break;
                }
                case info_type.sex: {
                    if (content == 'male') {
                        info.content = '男';
                    } else if (content == 'female') {
                        info.content = '女';
                    } else {
                        info.content = '';
                    }
                    info.content_type = content_type.radio;
                    info.options = ['男', '女'];
                    info.selectedOptions = [info.content];

                    break;
                }
                case info_type.other: {
                    var inputType = attr.attr_type;
                    if (inputType == 'text') {
                        // 文本输入
                        inputType = attr.attr_valtype;
                    }
                    info.content_type = this.contentTypeForKey(inputType);

                    switch (info.content_type) {
                        case content_type.area: {
                            // 地区

                            if (content != null && content.length > 0) {
                                area_selected.setMainland(content);
                                content = content.replace('mainland:', '');
                                var array = content.split(':');
                                content = array[0].replace('/', '');
                                info.content = content;
                            }
                            break;
                        }
                        case content_type.multi_selection: {
                            //多选
                            info.key = 'box:' + info.key;
                            if (content instanceof Array) {
                                info.selectedOptions = content;
                                info.content = content.join('，');
                            } else {
                                info.content = '';
                                info.selectedOptions = new Array();
                            }
                            info.options = attr.attr_option; //可选的内容
                            break;
                        }
                        case content_type.radio: {
                            info.options = attr.attr_option; //可选的内容
                            if (content != null && content.length > 0) {
                                info.selectedOptions = new Array(content);
                            } else {
                                info.selectedOptions = new Array();
                            }
                            break;
                        }
                    }
                }
            }
            infos.push(info);
        }

        const mem = data.mem;
        // 用户名
        var info = new Object();
        info.title = "用户名";
        info.content = mem.local;
        info.editable = info.content == null || info.content.length == 0;
        info.type = info_type.account;
        info.content_type = 0;
        infos.splice(index, 0, info);
        index++;

        // 手机号
        info = new Object();
        info.title = "手机号";
        info.content = mem.mobile;
        info.editable = info.content == null || info.content.length == 0;
        info.type = info_type.phoneNumber;
        infos.splice(index, 0, info);
        index++;

        // 邮箱
        info = new Object();
        info.title = "邮箱";
        info.content = mem.email;
        info.editable = false;
        info.type = info_type.email;
        infos.splice(index, 0, info);

        var date = new Date(new Date().getTime() - 365 * 24 * 60 * 60 * 16 * 1000);

        var utils = require('../../utils/util.js');
        const dateTime = utils.formatTimesamp(date.getTime() / 1000, 2);

        this.setData({
            infos: infos,
            endDate: dateTime
        })
        utils = null;
    },

    // 获取信息类型
    typeForKey: function (key) {
        const info_type = this.data.info_type;
        if (key == "contact[name]") {
            return info_type.name;
        }
        else if (key == "profile[gender]") {
            return info_type.sex;
        }
        else if (key == "contact[avatar]") {
            return info_type.avatar;
        }

        return info_type.other;
    },

    // 获取输入框类型
    contentTypeForKey: function (key) {

        const content_type = this.data.content_type;
        if (key == "number") {
            return content_type.only_number;
        }
        else if (key == "alpha") {
            return content_type.only_letter;
        }
        else if (key == "alphaint") {
            return content_type.numer_letter;
        }
        else if (key == "date") {
            return content_type.date;
        }
        else if (key == "region") {
            return content_type.area;
        }
        else if (key == "checkbox") {
            return content_type.multi_selection;
        }
        else if (key == "select") {
            return content_type.radio;
        }
        else if (key == "image") {
            return content_type.img;
        }

        return content_type.text_unlimited;

    },

    ///点击加载失败调用
    reloadData: function () {

        this.setData({
            fail: false
        });

        this.loadEditableUserInfo();
    },
})