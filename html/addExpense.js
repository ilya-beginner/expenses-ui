async function addExpense(date, sum, currency, tag, notes) {
    response = await fetch(EXPENSES_UI_BACKEND_HOST + "/expenses", {
        method: "POST",
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
