<html>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  <style>
    .btn-square-md {
      /* width: 50px !important; */
      max-width: 100% !important;
      max-height: 100% !important;
      height: 50px !important;
      text-align: center;
      padding: 0px;
      font-size:12px;
    }
  </style>
  <script>
    function formatSum(number) {
      return Math.abs(number).toFixed(2);
    }

    function formatDate(iso_date) {
      return new Date(iso_date).toLocaleDateString()
    }

    function formatType(sum) {
      if (sum < 0) {
        return "&#x1F4B8";
      }
      else {
        return "&#x1F4B0";
      }
    }

    function formatType2(sum) {
      if (sum < 0) {
        return "expense";
      }
      else {
        return "income";
      }
    }

    async function deleteExpense(id) {
      response = await fetch("${EXPENSES_UI_BACKEND_HOST}/expenses/" + id.toString(), {method: "DELETE"});

      return response.status;
    }

    async function addExpense(date, sum, currency, tag, notes) {
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

      return response.status;
    }

    async function editExpense(id, date, sum, currency, tag, notes) {
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

      return response.status;
    }

    async function onAdd() {
      date = document.getElementById('newDate').value;
      type = document.getElementById('newType').value;
      sum = document.getElementById('newSum').value;
      currency = document.getElementById('newCurrency').value;
      tag = document.getElementById('newTag').value;
      notes = document.getElementById('newNotes').value;

      if (type == "expense") {
        sum =  -1.00 * sum;
      }

      status = await addExpense(date, sum, currency, tag, notes);

      if (status == 201) {
        document.getElementById('add-alert').innerHTML = '<div class="alert alert-success alert-dismissible fade show"><button id="add-alert-button" type="button" class="btn-close" data-bs-dismiss="alert"></button><strong>Success!</strong> Expense added</div>';
        setTimeout(function() {
          CloseAlert("add-alert-button")
        }, 3000);

        from = new Date(document.getElementById('from').value);
        to = new Date(document.getElementById('to').value);

        new_from = new Date(Math.min(from, new Date(date)));
        new_to = new Date(Math.max(to, new Date(date)));

        if (new_from != from || new_to != to) {
          tzoffset = (new Date()).getTimezoneOffset() * 60000;

          new_from_localISOTime = (new Date(new_from - tzoffset)).toISOString().slice(0, 10);
          new_to_localISOTime = (new Date(new_to - tzoffset)).toISOString().slice(0, 10);

          document.getElementById('from').value = new_from_localISOTime;
          document.getElementById('to').value = new_to_localISOTime;
        }

        await enumerate();

        document.getElementById('newType').value = 'expense';
        document.getElementById('newSum').value = '';
        document.getElementById('newCurrency').value = 'BYN';
        document.getElementById('newTag').value = '';
        document.getElementById('newNotes').value = '';
      }
      else {
        document.getElementById('add-alert').innerHTML = '<div class="alert alert-danger alert-dismissible fade show"><button id="add-alert-button" type="button" class="btn-close" data-bs-dismiss="alert"></button><strong>Error!</strong> Failed to add expense</div>';
        setTimeout(function() {
          CloseAlert("add-alert-button")
        }, 3000);
      }
    }

    async function CloseAlert(id) {
      add_alert_button = document.getElementById(id);
      if (add_alert_button !== null) {
        add_alert_button.click();
      }
    }

    async function onEdit(id) {
      response = await fetch("${EXPENSES_UI_BACKEND_HOST}/expenses/" + id);
      data = await response.json();

      document.getElementById('editId').value = id;
      document.getElementById('editDate').value = data[0]['date'];
      document.getElementById('editType').value = formatType2(data[0]['sum']);
      document.getElementById('editSum').value = formatSum(data[0]['sum']);
      document.getElementById('editCurrency').value = data[0]['currency'];
      document.getElementById('editTag').value = data[0]['tag'];
      document.getElementById('editNotes').value = data[0]['notes'];
    }

    async function onEdit2() {
      id = document.getElementById('editId').value;
      type = document.getElementById('editType').value;
      date = document.getElementById('editDate').value;
      sum = document.getElementById('editSum').value;
      currency = document.getElementById('editCurrency').value;
      tag = document.getElementById('editTag').value;
      notes = document.getElementById('editNotes').value;

      if (type == "expense") {
        sum =  -1.00 * sum;
      }

      status = await editExpense(id, date, sum, currency, tag, notes);

      if (status == 204) {
        document.getElementById('edit-alert').innerHTML = '<div class="alert alert-success alert-dismissible fade show"><button id="edit-alert-button" type="button" class="btn-close" data-bs-dismiss="alert"></button><strong>Success!</strong> Expense modified</div>';
        setTimeout(function() {
          CloseAlert("edit-alert-button")
        }, 3000);
        await enumerate();
      }
      else {
        document.getElementById('edit-alert').innerHTML = '<div class="alert alert-danger alert-dismissible fade show"><button id="edit-alert-button" type="button" class="btn-close" data-bs-dismiss="alert"></button><strong>Error!</strong> Failed to modify expense</div>';
        setTimeout(function() {
          CloseAlert("edit-alert-button")
        }, 3000);
      }
    }

    async function onDelete(id) {
      response = await fetch("${EXPENSES_UI_BACKEND_HOST}/expenses/" + id);
      data = await response.json();

      document.getElementById('deleteId').value = id;
      document.getElementById('deleteDate').value = data[0]['date'];
      document.getElementById('deleteType').value = formatType2(data[0]['sum']);
      document.getElementById('deleteSum').value = formatSum(data[0]['sum']);
      document.getElementById('deleteCurrency').value = data[0]['currency'];
      document.getElementById('deleteTag').value = data[0]['tag'];
      document.getElementById('deleteNotes').value = data[0]['notes'];
    }

    async function onDelete2() {
      id = document.getElementById('deleteId').value;

      status = await deleteExpense(id);

      if (status == 200) {
        await enumerate();
        document.getElementById('closeDeleteModal').click();
      }
      else {
        document.getElementById('delete-alert').innerHTML = '<div class="alert alert-danger alert-dismissible fade show"><button id="delete-alert-button" type="button" class="btn-close" data-bs-dismiss="alert"></button><strong>Error!</strong> Failed to delete expense</div>';
        setTimeout(function() {
          CloseAlert("delete-alert-button")
        }, 3000);
      }
    }

    async function enumerate() {
      from = document.getElementById('from').value;
      to = document.getElementById('to').value;
      response = await fetch("${EXPENSES_UI_BACKEND_HOST}/expenses?from=" + from + "&to=" + to);
      data = await response.json();

      columns = ["Date", "Type", "Sum", "Currency", "Tag", "Notes"];

      content = '<table id="tmp-table" class="table table-striped table-hover table-responsive"><thead><tr>';
      columns.forEach((column) => {
        content += '<th>' + column + '</th>';
      });
      content += '<th style="width:1px; white-space:nowrap;"></th>';
      content += "</tr></thead>";

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
        if (expense['sum'] > 0) {
          totals_income[expense['currency']] += expense['sum'];
        }
        else {
          totals_expenses[expense['currency']] += Math.abs(expense['sum']);
        }

        totals[expense['currency']] += expense['sum'];

        content += '<tr>';

        content += '<td>' + formatDate(expense['date']) + '</td>';
        content += '<td>' + formatType(expense['sum']) + '</td>';
        content += '<td>' + formatSum(expense['sum']) + '</td>';
        content += '<td>' + expense['currency'] + '</td>';
        content += '<td>' + expense['tag'] + '</td>';
        content += '<td>' + expense['notes'] + '</td>';

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

      totals_html = '<table class="table table-striped table-hover table-responsive">';
      totals_html += "<thead><th>Currency</th><th>Total</th><th>Total/day</th><th>Income</th><th>Income/day</th><th>Expenses</th><th>Expenses/day</th></thead>";

      currencies = ['BYN', 'USD', 'EUR', 'PLN', 'RUB'];
      currencies.forEach((currency) => {
        if (totals_income[currency] != 0 || totals_expenses[currency] != 0) {
          totals_html += "<tr>";
          totals_html += "<td>" + currency + "</td>";
          totals_html += "<td>" + totals[currency].toFixed(2) + "</td>";
          totals_html += "<td>" + (totals[currency] / period_days).toFixed(2) + "</td>";
          totals_html += "<td>" + totals_income[currency].toFixed(2) + "</td>";
          totals_html += "<td>" + (totals_income[currency] / period_days).toFixed(2) + "</td>";
          totals_html += "<td>" + totals_expenses[currency].toFixed(2) + "</td>";
          totals_html += "<td>" + (totals_expenses[currency] / period_days).toFixed(2) + "</td>";
          totals_html += "</tr>";
        }
      });

      totals_html += "</table>";

      document.getElementById('totals').innerHTML = totals_html;
    }

    window.onload=function() {
        tzoffset = (new Date()).getTimezoneOffset() * 60000;
        localISOTime = (new Date(Date.now() - tzoffset)).toISOString().slice(0, 10);
        document.getElementById('from').value = localISOTime;
        document.getElementById('to').value = localISOTime;
        document.getElementById('newDate').value = localISOTime;
        enumerate();
    }
  </script>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <body>
    <nav class="navbar navbar-expand-sm bg-dark navbar-dark">

      <div class="container-fluid">
        <a class="navbar-brand" href="#">Expense Tracker</a>
            <div class="input-group input-group-lg">
              <span class="input-group-text">From</span>
              <input type="date" class="form-control" id="from" name="from">
            </div>

            <div class="input-group input-group-lg">
              <span class="input-group-text">To</span>
              <input type="date" class="form-control" id="to" name="to">
            </div>

            <button type="button" class="btn btn-light btn-lg btn-square-md w-100" onclick="enumerate()">
              <svg xmlns="http://www.w3.org/2000/svg" width="45" height="45" fill="currentColor" class="bi bi-check" viewBox="0 0 16 16">
                <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>
              </svg>
            </button>
      </div>
    </nav>

    <div class="container-fluid">

      <br>

      <h3 style="display:inline;">Totals</h3>

      <div class="table-responsive">
        <div class="table-responsive" id="totals"></div>
      </div>

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
                  <span class="input-group-text">Type</span>
                  <select id="newType" name="type" form="form2" class="form-select form-select-lg">
                    <option value="expense">&#x1F4B8 Expense</option>
                    <option value="income">&#x1F4B0 Income</option>
                  </select>
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Sum</span>
                  <input type="number" class="form-control" id="newSum" placeholder="(mandatory field)" name="sum">
                  <select id="newCurrency" name="currency" form="form2" class="form-select form-select-lg">
                    <option value="BYN">BYN</option>
                    <option value="USD">USD</option>
                    <option value="EUR">EUR</option>
                    <option value="PLN">PLN</option>
                    <option value="RUB">RUB</option>
                  </select>
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Tag</span>
                  <input type="text" class="form-control" id="newTag" placeholder="(optional field)" name="tag">
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Notes</span>
                  <input type="text" class="form-control" id="newNotes" placeholder="(optional field)" name="notes">
                </div>
              </form>
            </div>

            <!-- Add Modal footer -->
            <div class="modal-footer">
              <div id="add-alert"></div>
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
                  <span class="input-group-text">Type</span>
                  <select id="editType" name="type" form="form3" class="form-select form-select-lg">
                    <option value="expense">&#x1F4B8 Expense</option>
                    <option value="income">&#x1F4B0 Income</option>
                  </select>
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Sum</span>
                  <input type="number" class="form-control" id="editSum" placeholder="(mandatory field)" name="sum">
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
                  <input type="text" class="form-control" id="editTag" placeholder="(optional field)" name="tag">
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Notes</span>
                  <input type="text" class="form-control" id="editNotes" placeholder="(optional field)" name="notes">
                </div>
            </form>
            </div>

            <!-- Edit Modal footer -->
            <div class="modal-footer">
              <div id="edit-alert"></div>
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
              <form id="form3" action="${EXPENSES_UI_BACKEND_HOST}/expenses" method="post">
                <div id="deleteId"></div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Date</span>
                  <input type="date" disabled class="form-control" id="deleteDate" name="date">
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Type</span>
                  <select id="deleteType" name="type" form="form3" disabled class="form-select form-select-lg">
                    <option value="expense">&#x1F4B8 Expense</option>
                    <option value="income">&#x1F4B0 Income</option>
                  </select>
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Sum</span>
                  <input type="number" disabled class="form-control" id="deleteSum" name="sum">
                  <select id="deleteCurrency" name="currency" form="form3" disabled class="form-select form-select-lg" aria-label=".form-select-lg example">
                    <option value="BYN">BYN</option>
                    <option value="USD">USD</option>
                    <option value="EUR">EUR</option>
                    <option value="PLN">PLN</option>
                    <option value="RUB">RUB</option>
                  </select>
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Tag</span>
                  <input type="text" disabled class="form-control" id="deleteTag" name="tag">
                </div>
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text">Notes</span>
                  <input type="text" disabled class="form-control" id="deleteNotes" name="notes">
                </div>
            </form>
            </div>

            <!-- Delete Modal footer -->
            <div class="modal-footer">
              <h3>Are you sure? You cannot recover deleted expense</h3>
              <div id="delete-alert"></div>
              <button type="button" class="btn btn-danger" onclick="onDelete2()">Yes, I want to remove this expense</button>
              <button type="button" class="btn btn-danger" data-bs-dismiss="modal" id="closeDeleteModal">Close</button>
            </div>

          </div>
        </div>
      </div>

      <br>

      <div class="table-responsive">
        <div class="table-responsive" id="table"></div>
      </div>

    </div>
  </body>
</html>
