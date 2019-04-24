
// 是否包含某个元素
 function contains(obj, array) {
    for (var i = 0; i < array.length; i++) {
        if (array[i] == obj) {
            return true;
        }
    }
    return false;
}

module.exports = {
    contains: contains,
}