async function recomputeTime(date) {
    from = new Date(document.getElementById('from').value);
    to = new Date(document.getElementById('to').value);

    new_from = new Date(Math.min(from, new Date(date)));
    new_to = new Date(Math.max(to, new Date(date)));

    if (new_from != from || new_to != to) {
        tzoffset = (new Date()).getTimezoneOffset() * 60000;

        new_from_localISOTime = (new Date(new_from - tzoffset)).toISOString().slice(0, 10);
        new_to_localISOTime = (new Date(new_to - tzoffset)).toISOString().slice(0, 10);

        document.getElementById('from').value = new_from_localISOTime;
        document.getElementById('to').value = new_to_localISOTime;

        sessionStorage.setItem("fromTime", new_from_localISOTime);
        sessionStorage.setItem("toTime", new_to_localISOTime);
    }
}
