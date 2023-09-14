async function onDelete2() {
    id = document.getElementById('deleteId').value;

    status = await deleteExpense(id);

    if (status == 200) {
        await enumerate();
        document.getElementById('closeDeleteModal').click();
    }
    else {
        document.getElementById('delete-alert').innerHTML = '<div class="alert alert-danger alert-dismissible fade show"><button id="delete-alert-button" type="button" class="btn-close" data-bs-dismiss="alert"></button><strong>Error!</strong> Failed to delete expense</div>';
        setTimeout(function () {
            CloseAlert("delete-alert-button")
        }, 3000);
    }
}
