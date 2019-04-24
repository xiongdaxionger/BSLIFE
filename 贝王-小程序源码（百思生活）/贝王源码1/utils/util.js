function formatTime(date) {
  var year = date.getFullYear()
  var month = date.getMonth() + 1
  var day = date.getDate()

  var hour = date.getHours()
  var minute = date.getMinutes()
  var second = date.getSeconds()


  return [year, month, day].map(formatNumber).join('/') + ' ' + [hour, minute, second].map(formatNumber).join(':')
}

function formatNumber(n) {
  n = n.toString()
  return n[1] ? n : '0' + n
}

/**
 * flag
 * 0 yyyy-MM-dd HH:mm:ss
 * 1 yyyy-MM-dd HH:mm
 * 2 yyyy-MM-dd"
 * 3 MM月dd日 HH:mm
 */

/**
 * 格式化时间戳
 * @param timsamp 时间戳
 * @param flag 
 */
function formatTimesamp(timsamp, flag) {
  const date = new Date(parseInt(timsamp) * 1000);

  var year = date.getFullYear()
  var month = date.getMonth() + 1
  var day = date.getDate()

  var hour = date.getHours()
  var minute = date.getMinutes()
  var second = date.getSeconds()

  var result = '';
  switch (flag) {
    case 0: {
      result = [year, month, day].map(formatNumber).join('-') + ' ' +
        [hour, minute, second].map(formatNumber).join(':');
      break;
    }
    case 1: {
      result = [year, month, day].map(formatNumber).join('-') + ' ' +
        [hour, minute].map(formatNumber).join(':');
      break;
    }
    case 2: {
      result = [year, month, day].map(formatNumber).join('-');
      break;
    }
    case 3: {
      result = formatNumber(month) + '月' + formatNumber(day) + '日' + ' ' +
        [hour, minute].map(formatNumber).join(':');
      break;
    }
  }
  return result

}

// 返回多少天前
function previousDateFromTimesamp(timesamp) {
  var interval = new Date().getTime() / 1000 - timesamp;
  if (interval < 0)
    interval = - interval;
  const oneM = 60;
  if (interval < oneM) {
    return "刚刚";
  }

  interval = parseInt(interval / oneM);
  if (interval < oneM) {
    return interval + "分钟前";
  }

  interval = parseInt(interval / oneM);
  if (interval < 24) {
    return interval + "小时前";
  }

  interval = parseInt(interval / 24);

  if (interval < 30) {
    return interval + "天前";
  }

  interval = parseInt(interval / 30);

  if (interval < 12) {
    return interval + "月前";
  }

  return parseInt(interval / 12) + "年前";
}

module.exports = {
  formatTime: formatTime,
  formatTimesamp: formatTimesamp,
  previousDateFromTimesamp : previousDateFromTimesamp
}
