async function CloseAlert(id) {
    add_alert_button = document.getElementById(id);
    if (add_alert_button !== null) {
        add_alert_button.click();
    }
}
