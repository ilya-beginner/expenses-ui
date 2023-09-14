async function onDelete(id) {
    response = await fetch(EXPENSES_UI_BACKEND_HOST + "/expenses/" + id);
    data = await response.json();

    document.getElementById('deleteId').value = id;
    document.getElementById('deleteDate').value = data[0]['date'];
    document.getElementById('deleteType').value = formatType2(data[0]['sum']);
    document.getElementById('deleteSum').value = formatSum(data[0]['sum']);
    document.getElementById('deleteCurrency').value = data[0]['currency'];
    document.getElementById('deleteTag').value = data[0]['tag'];
    document.getElementById('deleteNotes').value = data[0]['notes'];
}
