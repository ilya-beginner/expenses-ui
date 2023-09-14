async function onAdd() {
    date = document.getElementById('newDate').value;
    type = document.getElementById('newType').value;
    sum = document.getElementById('newSum').value;
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
        }

        await enumerate();

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
