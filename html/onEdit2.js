async function onEdit2() {
    id = document.getElementById('editId').value;
    type = document.getElementById('editType').value;
    date = document.getElementById('editDate').value;
    sum = document.getElementById('editSum').value;
    currency = document.getElementById('editCurrency').value;
    tag = document.getElementById('editTag').value;
    notes = document.getElementById('editNotes').value;

    if (type == "expense") {
        sum = -1.00 * sum;
    }

    status = await editExpense(id, date, sum, currency, tag, notes);

    if (status == 204) {
        document.getElementById('edit-alert').innerHTML = '<div class="alert alert-success alert-dismissible fade show"><button id="edit-alert-button" type="button" class="btn-close" data-bs-dismiss="alert"></button><strong>Success!</strong> Expense modified</div>';
        setTimeout(function () {
            CloseAlert("edit-alert-button")
        }, 3000);
        recomputeTime(date);
        await enumerateExpenses();
    }
    else {
        document.getElementById('edit-alert').innerHTML = '<div class="alert alert-danger alert-dismissible fade show"><button id="edit-alert-button" type="button" class="btn-close" data-bs-dismiss="alert"></button><strong>Error!</strong> Failed to modify expense</div>';
        setTimeout(function () {
            CloseAlert("edit-alert-button")
        }, 3000);
    }
}
