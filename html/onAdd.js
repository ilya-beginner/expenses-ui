async function onAdd() {
    date = document.getElementById('newDate').value;
    type = document.getElementById('newType').value;
    sum = parseFloat(document.getElementById('newSum').value.replace(',','.'));
    alert(sum);
    currency = document.getElementById('newCurrency').value;
    tag = document.getElementById('newTag').value;
    notes = document.getElementById('newNotes').value;

    if (type == "expense") {
        sum = -1.00 * sum;
    }

    status = await addExpense(date, sum, currency, tag, notes);

    if (status == 201) {
        document.getElementById('add-alert').innerHTML = '<div class="alert alert-success alert-dismissible fade show"><button id="add-alert-button" type="button" class="btn-close" data-bs-dismiss="alert"></button><strong>Success!</strong> Expense added</div>';
        setTimeout(function () {
            CloseAlert("add-alert-button")
        }, 3000);

        recomputeTime(date);
        sessionStorage.setItem("newDate", date);

        await enumerateExpenses();

        document.getElementById('newType').value = 'expense';
        document.getElementById('newSum').value = '';
        document.getElementById('newCurrency').value = 'BYN';
        document.getElementById('newTag').value = '';
        document.getElementById('newNotes').value = '';
    }
    else {
        document.getElementById('add-alert').innerHTML = '<div class="alert alert-danger alert-dismissible fade show"><button id="add-alert-button" type="button" class="btn-close" data-bs-dismiss="alert"></button><strong>Error!</strong> Failed to add expense</div>';
        setTimeout(function () {
            CloseAlert("add-alert-button")
        }, 3000);
    }
}
