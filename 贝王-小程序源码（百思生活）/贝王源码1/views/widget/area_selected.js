
// app实例
const app = getApp();

///传page的this
var target = null;

// 已选择的地区最后一级id
var lastAreaId = null;

// 地区信息
var areaInfos = null;

// 选中的地区信息
var selectedAreaInfos = null;

// 是否是点击地区item
var selectedAreaItemIndex = -1;

// 获取地区信息
function loadAreaInfos() {
    target.setData({
        is_load_area: true
    })
    app.request({
        method: 'mobile.index.area'
    }, function (data) {
        parseAreaInfos(data);
    }, function () {
        target.setData({
            is_load_area: false
        })
    });
}

// 解析地区信息
function parseAreaInfos(data) {
    const infoObj = data.info;
    const treeObj = data.tree;
    const items = treeObj[0];

    areaInfos = new Object();
    var infos = new Array();
    for (var i = 0; i < items.length; i++) {
        const item = items[i];
        const info = areaInfoFromObj(treeObj, infoObj, item);
        if (info != null) {
            infos.push(info);
        }
        areaInfos['0'] = infos;
    }

    // 设置已选择的地区信息
    selectedAreaInfos = new Array();
    if (lastAreaId != null && parseInt(lastAreaId) != 0) {
        getSelectedAreaInfos(treeObj, infoObj, lastAreaId);
        const childs = areaInfos[lastAreaId];
        if (childs != null) {
            var obj = new Object();
            obj.title = '请选择';
            selectedAreaInfos.push(obj);
        }
    } else {
        var obj = new Object();
        obj.title = '请选择';
        obj.parent_id = '0';
        selectedAreaInfos.push(obj);
    }

    target.setData({
        is_load_area: false
    });

    show();
}

// 获取已选择的地区信息
function getSelectedAreaInfos(treeObj, infoObj, id) {
    const obj = infoObj[id];
    var parent_id = obj.parent_id;
    var info = new Object();
    if (parent_id != null && parseInt(parent_id) != 0) {
        info.parent_id = parent_id;
        getSelectedAreaInfos(treeObj, infoObj, parent_id);
    }else{
        info.parent_id = '0';
    }
    
    info.title = obj.local_name;
    info.id = obj.region_id;
    
    selectedAreaInfos.push(info);
}

// 创建地区信息
function areaInfoFromObj(treeObj, infoObj, areaId) {
    const obj = infoObj[areaId];
    if (obj == null)
        return null;

    var info = new Object();
    info.id = obj.region_id;
    info.name = obj.local_name;

    // 拿次级地区信息
    const items = treeObj[areaId];
    if (items != null && items.length > 0) {
        var childs = new Array();
        for (var i = 0; i < items.length; i++) {
            const item = items[i];
            const child = areaInfoFromObj(treeObj, infoObj, item);
            if (child != null) {
                childs.push(child);
            }
            areaInfos[areaId] = childs;
        }
    }

    return info;
}

// 点击地区
function tapAreaItem(event) {
    const index = parseInt(event.currentTarget.dataset.index);
    const cur_area_infos = target.data.cur_area_infos;
    const area_selectedIndex = target.data.area_selectedIndex;
    const info = cur_area_infos[area_selectedIndex];

    const areaInfo = info.infos[index];

    // 点击已选择的忽略
    if (areaInfo.name != info.title) {
        const childs = areaInfos[areaInfo.id];
        if (childs != null) {
            selectedAreaItemIndex = area_selectedIndex + 1;
            // 不是最后一级
            var obj = new Object();
            obj.parent_id = areaInfo.id;
            obj.title = '请选择';
            obj.infos = childs;
            info.title = areaInfo.name;
            if (area_selectedIndex < cur_area_infos.length - 1) {

                cur_area_infos.splice(area_selectedIndex + 1, cur_area_infos.length - area_selectedIndex - 1, obj);
            } else {

                cur_area_infos.splice(area_selectedIndex + 1, 0, obj);
            }
        
            target.setData({
                cur_area_infos: cur_area_infos,
                area_selectedIndex: area_selectedIndex + 1,
            })
            scrollToTop();
        } else {
            //已经是最后一级
            info.title = areaInfo.name;
            var mainland = new Array('mainland:');
            for (var i = 0; i < cur_area_infos.length; i++) {
                var obj = cur_area_infos[i];
                mainland.push(obj.title);
                if (i == cur_area_infos.length - 1) {
                    mainland.push(':');
                    mainland.push(areaInfo.id);
                }
            }
            areaClose();
            const value = mainland.join('');
            target.areaDidDone(value, setMainland(value));
        }
    }
}

// 点击菜单栏
function areaBarItemDidChange(event) {
    const index = parseInt(event.target.dataset.index)
    if (index != target.data.area_selectedIndex) {

        target.setData({
            area_selectedIndex: index,
        })
        scrollToTop();
    }
}

// 回到顶部
function scrollToTop(){
    target.setData({
        area_scroll_top: 1
    })
    target.setData({
        area_scroll_top: 0
    })
}

// 滑动页改变
function areaPageDidChange(event) {
    var current = event.detail.current;
    if(selectedAreaItemIndex != -1 && selectedAreaItemIndex != current){
        current = selectedAreaItemIndex;
        selectedAreaItemIndex = -1;
    }
    console.log(current);

    target.setData({
        area_selectedIndex: current,
    })
    console.log(target.data);
}

// 设置已选中的地址信息
function setMainland(mainland) {
    if (mainland == null || mainland.length == 0)
        return '';
    mainland = mainland.replace('mainland:', '');
    var array = mainland.split(':');
    mainland = array[0].replace('/', '');
    lastAreaId = array[1];
    return mainland;
}

// 关闭
function areaClose() {
    areaAnimation(false);
    var timer = setTimeout(function () {
        target.setData({
            show_area: false
        })
        clearTimeout(timer);
        timer = null;
    }, 400)
}

// 显示
function show() {
    if (areaInfos != null) {
        var cur_area_infos = new Array();
        for (var i = 0; i < selectedAreaInfos.length; i++) {
            const obj = selectedAreaInfos[i];
            var info = new Object();
            info.title = obj.title;
            info.id = obj.id;
            info.parent_id = obj.parent_id;
            info.infos = areaInfos[info.parent_id];
            cur_area_infos.push(info);
        }

        var info = cur_area_infos[target.data.area_selectedIndex];
        target.setData({
            cur_area_infos: cur_area_infos,
        })

    } else {
        loadAreaInfos();
    }

    if (!target.data.show_area) {
        target.setData({
            show_area: true
        })
        areaAnimation(true);
    }
}

// 选项动画
function areaAnimation(show) {

    //屏幕高度
    const height = app.globalData.systemInfo.windowHeight;
    var animation = wx.createAnimation({
        duration: 300,
    });

    //修改透明度,偏移
    target.setData({
        areaOpacityAnimation: animation.opacity(show ? 1 : 0).step().export(),
        areaTranslateAnimation: animation.translateY(show ? -height * 0.7 : height * 0.7).step().export()
    })
}

/**
 * 初始化
 * @param target 可设置page里面的this
 */
function init(that) {
    target = that;
    selectedAreaInfos = null;
    lastAreaId = null;
    selectedAreaItemIndex = -1;
}

// 清除
function clear() {
    target = null;
    selectedAreaInfos = null;
    areaInfos = null;
    lastAreaId = null;
}

// 设置选择的地区信息
function setSelectedAreaInfos(infos) {
    selectedAreaInfos = infos;
}

module.exports = {
    tapAreaItem: tapAreaItem,
    show: show,
    areaClose: areaClose,
    areaBarItemDidChange: areaBarItemDidChange,
    init: init,
    setMainland: setMainland,
    clear: clear,
    areaPageDidChange: areaPageDidChange,
    setSelectedAreaInfos: setSelectedAreaInfos
}
