<html>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    async function deleteExpense(id) {
      try {
        response = await fetch("${EXPENSES_UI_BACKEND_HOST}/expenses/" + id.toString(), {method: "DELETE"});
      } catch (err) {
        alert(err);
      }
    }
  </script>
  <script>
    async function addExpense(date, sum, currency, tag, notes) {
      try {
        response = await fetch("${EXPENSES_UI_BACKEND_HOST}/expenses", {
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
      } catch (err) {
        alert(err);
      }
    }
  </script>
  <script>
    async function editExpense(id, date, sum, currency, tag, notes) {
      try {
        response = await fetch("${EXPENSES_UI_BACKEND_HOST}/expenses/" + id, {
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
      } catch (err) {
        alert(err);
      }
    }
  </script>
  <script>
    async function onAdd() {
      date = document.getElementById('newDate').value;
      sum = document.getElementById('newSum').value;
      currency = document.getElementById('newCurrency').value;
      tag = document.getElementById('newTag').value;
      notes = document.getElementById('newNotes').value;

      await addExpense(date, sum, currency, tag, notes);

      document.getElementById('newSum').value = '';
      document.getElementById('newCurrency').value = 'BYN';
      document.getElementById('newTag').value = '';
      document.getElementById('newNotes').value = '';
    }
  </script>
  <script>
    async function onEdit(id) {
      response = await fetch("${EXPENSES_UI_BACKEND_HOST}/expenses/" + id);
      data = await response.json();

      document.getElementById('editId').value = id;
      document.getElementById('editDate').value = data[0]['date'];
      document.getElementById('editSum').value = data[0]['sum'];
      document.getElementById('editCurrency').value = data[0]['currency'];
      document.getElementById('editTag').value = data[0]['tag'];
      document.getElementById('editNotes').value = data[0]['notes'];
    }
  </script>
  <script>
    async function onEdit2() {
      id = document.getElementById('editId').value;
      date = document.getElementById('editDate').value;
      sum = document.getElementById('editSum').value;
      currency = document.getElementById('editCurrency').value;
      tag = document.getElementById('editTag').value;
      notes = document.getElementById('editNotes').value;

      await editExpense(id, date, sum, currency, tag, notes);
    }
  </script>
  <script>
    async function enumerate() {
      from = document.getElementById('from').value;
      to = document.getElementById('to').value;
      response = await fetch("${EXPENSES_UI_BACKEND_HOST}/expenses?from=" + from + "&to=" + to);
      data = await response.json();

      function capitalizeFirstLetter(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
      }

      columns = ["date", "sum", "currency", "tag", "notes"];

      content = '<table id="tmp-table" class="table table-striped table-hover table-sm"><thead><tr>';
      columns.forEach((column) => {
        content += '<th>' + capitalizeFirstLetter(column) + '</th>';
      });
      content += '<th></th>';
      content += "</tr></thead>";

      date = null;
      data.forEach((expense) => {
        if (expense['date'] != date) {
          content += '<tr class="table-info"><td colspan="6"><h3>' + expense['date'] + '</h3></td></tr>';
          date = expense['date'];
        }
        content += '<tr>';
          columns.forEach((column) => {
          content += '<td>' + expense[column] + '</td>';
        });
        content += '<td>';
        content += '<div class="btn-toolbar">';
        content += '<button type="button" class="btn btn-warning me-1" data-bs-toggle="modal" data-bs-target="#editModal" onclick="onEdit(' + expense["id"] + ')">Edit</button>';
        content += '<button type="button" class="btn btn-danger" onclick="deleteExpense(' + expense["id"] + ')">Delete</button>';
        content += '</div>'
        content += '</td>'
        content += '</tr>';
      });
      content += "</table>";

      document.getElementById('table').innerHTML = content;
    }
  </script>
  <script>
    window.onload=function() {
        tzoffset = (new Date()).getTimezoneOffset() * 60000;
        localISOTime = (new Date(Date.now() - tzoffset)).toISOString().slice(0, 10);
        document.getElementById('from').value = localISOTime;
        document.getElementById('to').value = localISOTime;
        document.getElementById('newDate').value = localISOTime;
        enumerate();
    }
  </script>
  <body>
    <nav class="navbar navbar-expand-sm bg-dark navbar-dark">
      <div class="container-fluid">
        <a class="navbar-brand" href="#">Expense Tracker</a>
      </div>
    </nav>
    <div class="container">
      <form id="form" action="${EXPENSES_UI_BACKEND_HOST}/expenses" method="get">
        <div class="row">
          <div class="col mb-3 mt-3">
            <div class="row">
              <label for="from" class="col form-label">From:</label>
              <input type="date" class="col form-control" id="from" name="from" onchange="enumerate()">
            </div>
          </div>
          <div class="col mb-3 mt-3">
            <div class="row">
              <label for="to" class="col form-label">To:</label>
              <input type="date" class="col form-control" id="to" name="to" onchange="enumerate()">
            </div>
          </div>
        </div>
      </form>
      <br>

      <!-- Button to Open the Add Modal -->
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
        Add expense
      </button>

      <!-- The Add Modal -->
      <div class="modal" id="addModal">
        <div class="modal-dialog">
          <div class="modal-content">

            <!-- Add Modal Header -->
            <div class="modal-header">
              <h4 class="modal-title">New expense</h4>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Add Modal body -->
            <div class="modal-body">
             <form id="form2" action="${EXPENSES_UI_BACKEND_HOST}/expenses" method="post">
                <div class="mb-3 mt-3">
                    <label for="date" class="form-label">Date:</label>
                    <input type="date" class="form-control" id="newDate" name="date">
                </div>
                <div class="mb-3">
                    <label for="sum" class="form-label">Sum:</label>
                    <input type="number" class="form-control" id="newSum" placeholder="-1.00" name="sum">
                </div>
                <div class="mb-3">
                    <label for="currency" class="form-label">Currency:</label>
                    <select id="newCurrency" name="currency" form="form2">
                      <option value="BYN">BYN</option>
                      <option value="USD">USD</option>
                      <option value="EUR">EUR</option>
                      <option value="PLN">PLN</option>
                      <option value="RUB">RUB</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="tag" class="form-label">Tag:</label>
                    <input type="text" class="form-control" id="newTag" placeholder="food" name="tag">
                </div>
                <div class="mb-3">
                    <label for="notes" class="form-label">Notes:</label>
                    <input type="text" class="form-control" id="newNotes" placeholder="bag of walnuts" name="notes">
                </div>
            </form>
            </div>

            <!-- Add Modal footer -->
            <div class="modal-footer">
              <button type="button" class="btn btn-success" onclick="onAdd()">Save</button>
              <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
            </div>

          </div>
        </div>
      </div>

      <!-- The Edit Modal -->
      <div class="modal" id="editModal">
        <div class="modal-dialog">
          <div class="modal-content">

            <!-- Edit Modal Header -->
            <div class="modal-header">
              <h4 class="modal-title">Edit expense</h4>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Edit Modal body -->
            <div class="modal-body">
              <form id="form3" action="${EXPENSES_UI_BACKEND_HOST}/expenses" method="post">
                <div id="editId"></div>
                <div class="mb-3 mt-3">
                    <label for="date" class="form-label">Date:</label>
                    <input type="date" class="form-control" id="editDate" name="date">
                </div>
                <div class="mb-3">
                    <label for="sum" class="form-label">Sum:</label>
                    <input type="number" class="form-control" id="editSum" placeholder="-1.00" name="sum">
                </div>
                <div class="mb-3">
                    <label for="currency" class="form-label">Currency:</label>
                    <select id="editCurrency" name="currency" form="form3">
                      <option value="BYN">BYN</option>
                      <option value="USD">USD</option>
                      <option value="EUR">EUR</option>
                      <option value="PLN">PLN</option>
                      <option value="RUB">RUB</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="tag" class="form-label">Tag:</label>
                    <input type="text" class="form-control" id="editTag" placeholder="food" name="tag">
                </div>
                <div class="mb-3">
                    <label for="notes" class="form-label">Notes:</label>
                    <input type="text" class="form-control" id="editNotes" placeholder="bag of walnuts" name="notes">
                </div>
            </form>
            </div>

            <!-- Edit Modal footer -->
            <div class="modal-footer">
              <button type="button" class="btn btn-success" onclick="onEdit2()">Save</button>
              <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
            </div>

          </div>
        </div>
      </div>

      <br>
      <div class="row">
        <div id="table"></div>
      </div>
    </div>
  </body>
</html>
