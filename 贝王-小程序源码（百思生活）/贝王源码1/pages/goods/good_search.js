
// app实例
const app = getApp();

///传page的this
var target = null;

var search_text = ''; //搜索内容

//是否需要跳转
var shouldNavigate = true;

// 获取搜索联想
function loadSearchAssociate(key) {

    app.request({
        method: 'b2c.search.associate',
        value: key
    }, function (data) {
        target.setData({
            search_associate_infos: data
        });
    });
}

// 获取热门搜索
function loadSearchHot() {

    app.request({
        method: 'b2c.gallery.hot_search'
    }, function (data) {
        target.setData({
            search_hot_infos: data
        });
    });
}

// 获取搜索历史
function loadSearchHistory() {
    wx.getStorage({
        key: 'search_history',
        success: function (res) {
            target.setData({
                search_history_infos : res.data
            })
        }
    })
}

// 清除搜索历史
function clearSearchHistory() {

    target.setData({
        search_history_infos: null
    })
    wx.removeStorage({
        key: 'search_history'
    })
}

// 保存搜索历史
function saveSearchHistory(key) {

   var search_history_infos = target.data.search_history_infos;
    // 清除相同的记录
    if (search_history_infos != null) {
        for (var i = 0; i < search_history_infos.length; i++) {
            const obj = search_history_infos[i];
            if (obj == key) {
                search_history_infos.splice(i, 1);
                break;
            }
        }
    } else {
        search_history_infos = new Array();
    }
    search_history_infos.splice(0, 0, key);

    wx.setStorage({
        key: 'search_history',
        data: search_history_infos
    })
    target.setData({
        search_history_infos: saveSearchHistory
    })
}

// 开始搜索
function searchDidBegin(event, search_value) {
    target.setData({
        searching: true,
        search_text : search_value
    })
    this.loadSearchHistory();
    this.loadSearchHot();
    search_text = search_value;
    this.shouldShowAssociate();
}

// 结束搜索
function searchDidEnd() {
    target.setData({
        searching: false
    })
}

// 搜索内容改变
function searchDidChange(event) {
    search_text = event.detail.value;
    this.shouldShowAssociate();
}

// 检测是否需要显示搜索联想
function shouldShowAssociate(){
    if(search_text != null && search_text.replace(/(^\s*)|(\s*$)/g, "")){
        target.setData({
            show_associate:true
        })
        this.loadSearchAssociate(search_text);
    }else{
         target.setData({
             show_associate:false,
            search_associate_infos: null
        });
    }
}

/**
 * 点击热门搜索，最近搜索
 * @return 搜索关键字
 *  */ 
  function clickSearchItem(event){
      search_text = event.currentTarget.dataset.value;
      return this.doSearch();
  }

/**
 * 搜索 
 * @return 搜索关键字
 * */
function doSearch() {
    if (search_text != null && search_text.replace(/(^s*)|(s*$)/g, "").length > 0) {
        this.searchDidEnd();
        if (shouldNavigate) {
            wx.navigateTo({
                url: '/pages/goods/good_list?keyword=' + search_text
            })
        }
        this.saveSearchHistory(search_text);
        return search_text;
    }
    return null;
}

/**
 * 初始化
 * @param target 可设置page里面的this
 * @param shouldNav bool 是否需要跳到商品列表
 */
function init(that, shouldNav) {
    target = that;
    shouldNavigate = shouldNav;
}

module.exports = {
    loadSearchAssociate: loadSearchAssociate,
    loadSearchHot: loadSearchHot,
    loadSearchHistory: loadSearchHistory,
    clearSearchHistory: clearSearchHistory,
    saveSearchHistory: saveSearchHistory,
    searchDidBegin: searchDidBegin,
    searchDidEnd: searchDidEnd,
    searchDidChange: searchDidChange,
    doSearch: doSearch,
    init: init,
    clickSearchItem:clickSearchItem,
    shouldShowAssociate:shouldShowAssociate,
}