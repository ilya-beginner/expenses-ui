async function enumerateExpenses() {
    if (window.innerHeight > window.innerWidth) {
        enumerateExpensesMobile()
    }
    else {
        enumerateExpensesDesktop()
    }
}
