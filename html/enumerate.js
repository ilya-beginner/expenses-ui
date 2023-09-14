async function enumerate() {
    from = document.getElementById('from').value;
    to = document.getElementById('to').value;
    response = await fetch(EXPENSES_UI_BACKEND_HOST + "/expenses?from=" + from + "&to=" + to);
    data = await response.json();

    columns = ["Date", "Type", "Sum", "Currency", "Tag", "Notes"];

    expenses_html = '<table class="table table-striped table-hover table-responsive"><thead><tr>';
    columns.forEach((column) => {
        expenses_html += '<th>' + column + '</th>';
    });

    expenses_html += '<th style="width:1px; white-space:nowrap;"></th>';
    expenses_html += "</tr></thead>";

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

        expenses_html += '<tr>';

        expenses_html += '<td>' + formatDate(expense['date']) + '</td>';
        expenses_html += '<td>' + formatType(expense['sum']) + '</td>';
        expenses_html += '<td>' + formatSum(expense['sum']) + '</td>';
        expenses_html += '<td>' + expense['currency'] + '</td>';
        expenses_html += '<td>' + expense['tag'] + '</td>';
        expenses_html += '<td>' + expense['notes'] + '</td>';

        expenses_html += '<td style="width:1px; white-space:nowrap;">';
        expenses_html += '<div class="btn-group">';
        expenses_html += '<button type="button" class="btn btn-warning me-1" data-bs-toggle="modal" data-bs-target="#editModal" onclick="onEdit(' + expense["id"] + ')">Edit</button>';
        expenses_html += '<button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" onclick="onDelete(' + expense["id"] + ')">Delete</button>';
        expenses_html += '</div>';
        expenses_html += '</td>';
        expenses_html += '</tr>';
    });
    expenses_html += "</table>";

    document.getElementById('expenses_table').innerHTML = expenses_html;

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
}
