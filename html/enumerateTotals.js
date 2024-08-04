async function enumerateTotals() {
    from = document.getElementById('from').value;
    to = document.getElementById('to').value;

    sessionStorage.setItem("fromTime", from);
    sessionStorage.setItem("toTime", to);

    response = await fetch(EXPENSES_UI_BACKEND_HOST + "/expenses?from=" + from + "&to=" + to);
    data = await response.json();

    totals_income = {
        'BYN': 0,
        'USD': 0,
        'EUR': 0,
        'PLN': 0,
        'RUB': 0
    };

    totals_expenses = {
        'BYN': 0,
        'USD': 0,
        'EUR': 0,
        'PLN': 0,
        'RUB': 0
    };

    totals = {
        'BYN': 0,
        'USD': 0,
        'EUR': 0,
        'PLN': 0,
        'RUB': 0
    };

    data.forEach((expense) => {
        if (expense['sum'] > 0) {
            totals_income[expense['currency']] += expense['sum'];
        }
        else {
            totals_expenses[expense['currency']] += Math.abs(expense['sum']);
        }

        totals[expense['currency']] += expense['sum'];
    });

    period_days = (Math.abs(new Date(document.getElementById('to').value) - new Date(document.getElementById('from').value)) + 86400000) / 86400000;

    totals_html = '<table class="table table-striped table-hover table-responsive">';
    totals_html += "<thead><th>Currency</th><th>Total</th><th>Total/day</th><th>Income</th><th>Income/day</th><th>Expenses</th><th>Expenses/day</th></thead>";

    currencies = ['BYN', 'USD', 'EUR', 'PLN', 'RUB'];
    currencies.forEach((currency) => {
        if (totals_income[currency] != 0 || totals_expenses[currency] != 0) {
            totals_html += "<tr>";
            totals_html += "<td>" + currency + "</td>";
            totals_html += "<td>" + totals[currency].toFixed(2) + "</td>";
            totals_html += "<td>" + (totals[currency] / period_days).toFixed(2) + "</td>";
            totals_html += "<td>" + totals_income[currency].toFixed(2) + "</td>";
            totals_html += "<td>" + (totals_income[currency] / period_days).toFixed(2) + "</td>";
            totals_html += "<td>" + totals_expenses[currency].toFixed(2) + "</td>";
            totals_html += "<td>" + (totals_expenses[currency] / period_days).toFixed(2) + "</td>";
            totals_html += "</tr>";
        }
    });

    totals_html += "</table>";

    document.getElementById('totals_table').innerHTML = totals_html;

    tag_distribution = new Map();
    data.forEach((expense) => {
        if (expense["tag"]) {
            if (tag_distribution[expense["tag"] + ' - ' + expense["currency"]]) {
                tag_distribution[expense["tag"] + ' - ' + expense["currency"]] += expense["sum"];
            }
            else {
                tag_distribution[expense["tag"] + ' - ' + expense["currency"]] = expense["sum"];
            }
            
        }
    });
    for (var elt in tag_distribution) {
        document.getElementById('tags').innerHTML += (elt + ' ' + tag_distribution[elt] + '<br>');
    }
}
