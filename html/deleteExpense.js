async function deleteExpense(id) {
    response = await fetch(EXPENSES_UI_BACKEND_HOST + "/expenses/" + id.toString(), { method: "DELETE" });

    return response.status;
}
