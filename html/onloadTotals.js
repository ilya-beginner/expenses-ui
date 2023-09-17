window.onload = function () {
    fromTime = sessionStorage.getItem("fromTime");
    toTime = sessionStorage.getItem("toTime");
    newDate = sessionStorage.getItem("newDate");

    if (fromTime === null || toTime === null || newDate === null) {
        tzoffset = (new Date()).getTimezoneOffset() * 60000;
        localISOTime = (new Date(Date.now() - tzoffset)).toISOString().slice(0, 10);
        document.getElementById('from').value = localISOTime;
        document.getElementById('to').value = localISOTime;

        sessionStorage.setItem("fromTime", localISOTime);
        sessionStorage.setItem("toTime", localISOTime);
    }
    else
    {
        document.getElementById('from').value = fromTime;
        document.getElementById('to').value = toTime;
    }

    enumerateTotals();
}
