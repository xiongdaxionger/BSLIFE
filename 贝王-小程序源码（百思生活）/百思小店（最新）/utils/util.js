const formatTime = date => {
  const year = date.getFullYear()
  const month = date.getMonth() + 1
  const day = date.getDate()
  const hour = date.getHours()
  const minute = date.getMinutes()
  const second = date.getSeconds()

  return [year, month, day].map(formatNumber).join('/') + ' ' + [hour, minute, second].map(formatNumber).join(':')
}

const formatNumber = n => {
  n = n.toString()
  return n[1] ? n : '0' + n
}
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
module.exports = {
  formatTime: formatTime,
  formatTimesamp: formatTimesamp
}
