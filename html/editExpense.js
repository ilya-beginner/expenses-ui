async function editExpense(id, date, sum, currency, tag, notes) {
    response = await fetch(EXPENSES_UI_BACKEND_HOST + "/expenses/" + id, {
        method: "PATCH",
        body: JSON.stringify({
            date: date,
            sum: sum,
            currency: currency,
            tag: tag,
            notes: notes
        }),
        headers: {
            "Content-Type": "application/json",
        },
    });

    return response.status;
}
