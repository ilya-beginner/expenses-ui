async function enumerateExpensesMobile() {
    from = document.getElementById('from').value;
    to = document.getElementById('to').value;

    sessionStorage.setItem("fromTime", from);
    sessionStorage.setItem("toTime", to);

    response = await fetch(EXPENSES_UI_BACKEND_HOST + "/expenses?from=" + from + "&to=" + to);
    data = await response.json();
 
    div = document.querySelector("#expenses-div");
    div.innerHTML = ''

    const tableTemplate = document.querySelector("#table-template");
    const tableClone = tableTemplate.content.cloneNode(true);
    div.appendChild(tableClone);

    data.forEach((expense) => {
        const tbody = document.querySelector("#expenses-table");
        const template = document.querySelector("#row-template");
        const clone = template.content.cloneNode(true);
        
        clone.querySelector("#date").innerText = formatDate(expense['date']);
        clone.querySelector("#type").textContent = formatType(expense['sum']);
        clone.querySelector("#sum").innerText = formatSum(expense['sum']);
        clone.querySelector("#currency").innerText = expense['currency'];

        if (expense['tag']) {
            let tag = clone.querySelector("#tag-span");
            tag.innerText = expense['tag'];
            clone.querySelector("#tag-div").removeAttribute("hidden");
        }
        
        if (expense['notes']) {
            let notes = clone.querySelector("#notes-span");
            notes.innerText = expense['notes'];
            clone.querySelector("#notes-div").removeAttribute("hidden");
        }

        clone.getElementById("edit-button").onclick=async function(){onEdit(expense['id'])};
        clone.getElementById("delete-button").onclick=async function(){onDelete(expense['id'])};

        tbody.appendChild(clone);
    });
}
