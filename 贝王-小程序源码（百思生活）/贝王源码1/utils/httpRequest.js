///服务器签名token
const token = 'c04b237488bfa8680f9bc99ede8f7c6e0684ba336b0733c6d13b037d52e615b0';
var md5 = require('../vendors/md5.js');
var url = 'https://www.ibwang.cn/';
/**构建http请求参数
 * @param params {} 参数
 * @param jsonFlag true 则不合并
 * @return 签名后的参数
 */
function buildData(params, jsonFlag) {

    // 把对象转成对象数组并排序
    var keys = Object.keys(params).sort();
    var array = [];
    for (var i = 0; i < keys.length; i++) {
        var key = keys[i];
        var obj = {};
        obj[key] = params[key];
        array.push(obj);
    }

    ///签名数组
    var signs = [];
    /*最后一个key
     *如果出现连续相同的参数key，则使用它的下标签名，
     *如 a[0]=1&a[1]=2，a[1]签名的使用使用1，而不是使用a1
     */
    var lastKey = '';

    ///参数数组
    if (!jsonFlag) {
        var paramArray = [];
    }

    var idx = 0;
    for (var i = 0; i < array.length; i++) {

        const obj = array[i];

        var key = null;
        for (var v in obj) {
            key = v;
        }
        const value = obj[key];

        if (!jsonFlag) {
            if (idx > 0) {
                paramArray.push('&');
            }

            paramArray.push(key);
            paramArray.push('=');
            paramArray.push(encodeURIComponent(value));
        }

        const index = key.indexOf('[');
        if (index != -1) {
            var theKey = key.substring(0, index);

            if (theKey == lastKey) {
                key = key.substring(index, key.length);
            }
            lastKey = theKey;
        }

        key = key.replace(/\[/g, '');
        key = key.replace(/\]/g, '');

        signs.push(key);
        signs.push(value);
        idx++;
    }

    var signString = signs.join('');

    // md5签名
    signString = md5.md5(signString).toUpperCase();
    signString += token;
    signString = md5.md5(signString).toUpperCase();

    if (!jsonFlag) {
        paramArray.push('&sign=' + signString);
        signString = paramArray.join('');
        return signString;
    } else {
        params.sign = signString;
        console.log(params);
        return params;
    }
}

///获取json长度
function getJsonLength(json) {
    var length = 0;
    for (var key in json) {
        length++;
    }
    return length;
}

///获取域名
function getDomain() {
  return url;
}

// 获取请求地址
function getRequestURL(){
  return url + 'index.php/mobile/';
}

// 获取图片地址头部 这个不改
function getImgURL(){
    return '';
}

// 微信appidid
function getWeixinAppId(){
  return 'wx3bb9017360909574';
}

// 微信appSecret
function getWeixinSecret(){
  return 'c6ca8fdba57063b355d93ca40d901fe6';
}

///开始加载
function startLoading() {
    wx.showToast({
        title: '加载中...',
        icon: 'loading',
        duration: 10000,
        mask: true
    });
}

///隐藏加载
function stopLoading() {
    wx.hideToast();
}

module.exports = {
    buildData: buildData,
    getJsonLength: getJsonLength,
    getDomain: getDomain,
    startLoading: startLoading,
    stopLoading: stopLoading,
    getRequestURL: getRequestURL,
    getWeixinAppId: getWeixinAppId,
    getWeixinSecret:getWeixinSecret,
    getImgURL: getImgURL
}