async function enumerateExpenses() {
    from = document.getElementById('from').value;
    to = document.getElementById('to').value;

    sessionStorage.setItem("fromTime", from);
    sessionStorage.setItem("toTime", to);

    response = await fetch(EXPENSES_UI_BACKEND_HOST + "/expenses?from=" + from + "&to=" + to);
    data = await response.json();

    columns = ["Date", "Type", "Sum", "Currency", "Tag", "Notes"];

    expenses_html = '<table class="table table-striped table-hover table-responsive"><thead><tr>';
    columns.forEach((column) => {
        expenses_html += '<th>' + column + '</th>';
    });

    expenses_html += '<th style="width:1px; white-space:nowrap;"></th>';
    expenses_html += "</tr></thead>";

    data.forEach((expense) => {
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
}
