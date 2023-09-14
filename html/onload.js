window.onload = function () {
    tzoffset = (new Date()).getTimezoneOffset() * 60000;
    localISOTime = (new Date(Date.now() - tzoffset)).toISOString().slice(0, 10);
    document.getElementById('from').value = localISOTime;
    document.getElementById('to').value = localISOTime;
    document.getElementById('newDate').value = localISOTime;
    enumerate();
}
