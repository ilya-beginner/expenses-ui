<html>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    $(document).ready(function(){
      document.getElementById("submit").onclick=async ()=>{
        from = document.getElementById('from').value;
        to = document.getElementById('to').value;
        data = await(await fetch("http://localhost:5265/expenses?from=" + from + "&to=" + to)).json()

        function capitalizeFirstLetter(string) {
          return string.charAt(0).toUpperCase() + string.slice(1);
        }

        content = "<table class=\"table table-striped table-hover table-sm\" border==\"1\"><thead><tr>";
        for (key in data[0]) {
          content += '<th data-field="' + key + '" data-sortable="true" data-sort-order="desc">' + capitalizeFirstLetter(key) + '</th>';
        }
        content += "</tr></thead>";
        for (var i = 0; i < data.length; i++) {
          content += '<tr>';
          for (key in data[i]) {
            content += '<td>' + data[i][key] + '</td>';
          }
          content += '</tr>';
        }
        content += "</table>";

        document.getElementById('table').innerHTML = content;
      };
    });
  </script>
  <script>
    window.onload=function() {
        tzoffset = (new Date()).getTimezoneOffset() * 60000;
        localISOTime = (new Date(Date.now() - tzoffset)).toISOString().slice(0, 10);
        document.getElementById('from').value = localISOTime;
        document.getElementById('to').value = localISOTime;
    }
  </script>
  <body>
    <nav class="navbar navbar-expand-sm bg-light">
      <div class="container-fluid">
        <ul class="navbar-nav">
          <li class="nav-item">
            <a class="nav-link" href="index.html">Report</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="view.html">View</a>
          </li>
        </ul>
      </div>
    </nav>
    <div class="container">
      <div class="row">
        <h1>View expenses</h1>
        <form id="form" action="${EXPENSES_UI_BACKEND_HOST}/expenses" method="get">
            <div class="mb-3 mt-3">
                <label for="from" class="form-label">From:</label>
                <input type="date" class="form-control" id="from" name="from">
            </div>
            <div class="mb-3 mt-3">
              <label for="to" class="form-label">To:</label>
              <input type="date" class="form-control" id="to" name="to">
          </div>
        </form>
        <button id="submit" type="submit" class="btn btn-primary">View</button>
      </div>
      <br>
      <div class="row">
        <div id="table"></div>
      </div>
    </div>
  </body>
</html>
