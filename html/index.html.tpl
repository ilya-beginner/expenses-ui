<html>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  <!-- <style>
    .modal-dialog {
      width: 100%;
      height: 100%;
      margin: 0;
      padding: 0;
    }

    .modal-content {
      height: auto;
      min-height: 100%;
      border-radius: 0;
    }
  </style> -->
  <script>
    function formatValue(column, value) {
      if (column == 'sum') {
        return value.toFixed(2);
      }

      return value;
    }
  </script>
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
    async function onDelete(id) {
      document.getElementById('deleteId').value = id;
    }
  </script>
  <script>
    async function onDelete2(id) {
      id = document.getElementById('deleteId').value;

      await deleteExpense(id);
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

      columns = ["sum", "currency", "tag", "notes"];

      content = '<table id="tmp-table" class="table table-striped table-hover table-fit"><thead><tr>';
      columns.forEach((column) => {
        content += '<th>' + capitalizeFirstLetter(column) + '</th>';
      });
      content += '<th style="width:1px; white-space:nowrap;"></th>';
      content += "</tr></thead>";

      date = null;
      totals_income = {
        'BYN': 0,
        'USD': 0,
        'EUR': 0,
        'PLN': 0,
        'RUB': 0
      };
      totals_expenses = {
        'BYN': 0,
        'USD': 0,
        'EUR': 0,
        'PLN': 0,
        'RUB': 0
      };
      totals = {
        'BYN': 0,
        'USD': 0,
        'EUR': 0,
        'PLN': 0,
        'RUB': 0
      };
      data.forEach((expense) => {
        if (expense['date'] != date) {
          content += '<tr class="table-secondary"><td colspan="6"><h3><span class="badge bg-secondary">' + expense['date'] + '</span></h3></td></tr>';
          date = expense['date'];
        }

        if (expense['sum'] > 0) {
          totals_income[expense['currency']] += expense['sum'];
        }
        else {
          totals_expenses[expense['currency']] += Math.abs(expense['sum']);
        }

        totals[expense['currency']] += expense['sum'];

        content += '<tr>';

        columns.forEach((column) => {
          content += '<td>' + formatValue(column, expense[column]) + '</td>';
        });
        content += '<td style="width:1px; white-space:nowrap;">';
        content += '<div class="btn-group">';
        content += '<button type="button" class="btn btn-warning me-1" data-bs-toggle="modal" data-bs-target="#editModal" onclick="onEdit(' + expense["id"] + ')">Edit</button>';
        content += '<button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" onclick="onDelete(' + expense["id"] + ')">Delete</button>';
        content += '</div>';
        content += '</td>';
        content += '</tr>';
      });
      content += "</table>";

      document.getElementById('table').innerHTML = content;

      period_days = (Math.abs(new Date(document.getElementById('to').value) - new Date(document.getElementById('from').value)) + 86400000) / 86400000;

      totals_html = "<h3>Totals</h3>";
      totals_html += '<table class="table table-striped table-hover table-sm">';
      totals_html += "<thead><th>Currency</th><th>Income</th><th>Income/day</th><th>Expenses</th><th>Expenses/day</th><th>Total</th><th>Total/day</th></thead>";

      currencies = ['BYN', 'USD', 'EUR', 'PLN', 'RUB'];
      currencies.forEach((currency) => {
        if (totals_income[currency] != 0 || totals_expenses[currency] != 0) {
          totals_html += "<tr>";
          totals_html += "<td>" + currency + "</td>";
          totals_html += "<td>" + totals_income[currency].toFixed(2) + "</td>";
          totals_html += "<td>" + (totals_income[currency] / period_days).toFixed(2) + "</td>";
          totals_html += "<td>" + totals_expenses[currency].toFixed(2) + "</td>";
          totals_html += "<td>" + (totals_expenses[currency] / period_days).toFixed(2) + "</td>";
          totals_html += "<td>" + totals[currency].toFixed(2) + "</td>";
          totals_html += "<td>" + (totals[currency] / period_days).toFixed(2) + "</td>";
          totals_html += "</tr>";
        }
      });

      totals_html += "</table>";

      document.getElementById('totals').innerHTML = totals_html;
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
    <div class="container-fluid">
      <br>

      <form id="form" action="${EXPENSES_UI_BACKEND_HOST}/expenses" method="get">
        <div class="input-group input-group-lg mb-3">
          <span class="input-group-text">From</span>
          <input type="date" class="form-control" id="from" name="from" onchange="enumerate()">
        </div>
        <div class="input-group input-group-lg mb-3">
          <span class="input-group-text">To</span>
          <input type="date" class="form-control" id="to" name="to" onchange="enumerate()">
        </div>
      </form>

      <br>

      <div id="totals"></div>

      <br>

      <h3 style="display:inline;">Expenses</h3>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal" style="display:inline;">Add</button>

      <!-- The Add Modal -->
      <div class="modal" id="addModal">
        <div class="modal-dialog modal-xl">
          <div class="modal-content">

            <!-- Add Modal Header -->
            <div class="modal-header">
              <h4 class="modal-title">Add expense</h4>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Add Modal body -->
            <div class="modal-body">
              <form id="form2" action="${EXPENSES_UI_BACKEND_HOST}/expenses" method="post">
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Date</span>
                  <input type="date" class="form-control" id="newDate" name="date">
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Sum</span>
                  <input type="number" class="form-control" id="newSum" placeholder="-1.00" name="sum">
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Currency</span>
                  <select id="newCurrency" name="currency" form="form2" class="form-select form-select-lg" aria-label=".form-select-lg example">
                    <option value="BYN">BYN</option>
                    <option value="USD">USD</option>
                    <option value="EUR">EUR</option>
                    <option value="PLN">PLN</option>
                    <option value="RUB">RUB</option>
                  </select>
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Tag</span>
                  <input type="text" class="form-control" id="newTag" placeholder="food" name="tag">
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Notes</span>
                  <input type="text" class="form-control" id="newNotes" placeholder="bag of walnuts" name="notes">
                </div>
              </form>
            </div>

            <!-- Add Modal footer -->
            <div class="modal-footer">
              <button type="button" class="btn btn-success" onclick="onAdd()">Save</button>
              <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
            </div>

          </div></div>
        </div>
      </div>

      <!-- The Edit Modal -->
      <div class="modal" id="editModal">
        <div class="modal-dialog modal-xl">
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
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Date</span>
                  <input type="date" class="form-control" id="editDate" name="date">
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Sum</span>
                  <input type="number" class="form-control" id="editSum" placeholder="-1.00" name="sum">
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Currency</span>
                  <select id="editCurrency" name="currency" form="form3" class="form-select form-select-lg" aria-label=".form-select-lg example">
                    <option value="BYN">BYN</option>
                    <option value="USD">USD</option>
                    <option value="EUR">EUR</option>
                    <option value="PLN">PLN</option>
                    <option value="RUB">RUB</option>
                  </select>
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Tag</span>
                  <input type="text" class="form-control" id="editTag" placeholder="food" name="tag">
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Notes</span>
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

      <!-- The Delete Modal -->
      <div class="modal" id="deleteModal">
        <div class="modal-dialog modal-xl">
          <div class="modal-content">

            <!-- Delete Modal Header -->
            <div class="modal-header">
              <h4 class="modal-title">Delete expense</h4>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Delete Modal body -->
            <div class="modal-body">
              <div id="deleteId"></div>
              <h3>Are you sure? You cannot recover deleted expense</h3>
            </div>

            <!-- Delete Modal footer -->
            <div class="modal-footer">
              <button type="button" class="btn btn-danger" onclick="onDelete2()">Yes, I want to remove this expense</button>
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
