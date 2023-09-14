async function onEdit(id) {
    response = await fetch(EXPENSES_UI_BACKEND_HOST + "/expenses/" + id);
    data = await response.json();

    document.getElementById('editId').value = id;
    document.getElementById('editDate').value = data[0]['date'];
    document.getElementById('editType').value = formatType2(data[0]['sum']);
    document.getElementById('editSum').value = formatSum(data[0]['sum']);
    document.getElementById('editCurrency').value = data[0]['currency'];
    document.getElementById('editTag').value = data[0]['tag'];
    document.getElementById('editNotes').value = data[0]['notes'];
}
