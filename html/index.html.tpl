<html>
<head>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
      $(document).ready(function(){
          $("#submit").on('click', function(){
              document.getElementById("date").disabled = true;
              document.getElementById("sum").disabled = true;
              document.getElementById("tag").disabled = true;
              document.getElementById("notes").disabled = true;
              document.getElementById("submit").disabled = true;

              $.ajax({
                  url: '${EXPENSES_UI_BACKEND_HOST}/expenses',
                  type : "POST",
                  dataType : 'json',
                  data: JSON.stringify({
                      date: $("#date").val(),
                      sum: $("#sum").val(),
                      tag: $("#tag").val(),
                      notes: $("#notes").val()
                  }),
                  contentType: 'application/json;charset=UTF-8',
                  success : function(result) {
                      document.getElementById("sum").value = "";
                      document.getElementById("tag").value = "";
                      document.getElementById("notes").value = "";

                      document.getElementById("date").disabled = false;
                      document.getElementById("sum").disabled = false;
                      document.getElementById("tag").disabled = false;
                      document.getElementById("notes").disabled = false;
                      document.getElementById("submit").disabled = false;

                      document.getElementById("alert-success").style.display = "block";
                      $("#alert-success").hide(1500);
                  },
                  error: function(xhr, resp, text) {
                      document.getElementById("alert-danger").style.display = "block";
                      $("#alert-danger").hide(5000);

                      document.getElementById("date").disabled = false;
                      document.getElementById("sum").disabled = false;
                      document.getElementById("tag").disabled = false;
                      document.getElementById("notes").disabled = false;
                      document.getElementById("submit").disabled = false;
                  }
              })
          });
      });
  </script>
  <script>
      window.onload= function() {
          tzoffset = (new Date()).getTimezoneOffset() * 60000;
          localISOTime = (new Date(Date.now() - tzoffset)).toISOString().slice(0, 10);
          document.getElementById('date').value = localISOTime;
          document.getElementById("alert-success").style.display = "none";
          document.getElementById("alert-danger").style.display = "none";
      }
  </script>
</head>
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
    <h1>Report expense</h1>
    <form id="form" action="${EXPENSES_UI_BACKEND_HOST}/expenses" method="post">
        <div class="mb-3 mt-3">
            <label for="date" class="form-label">Date:</label>
            <input type="date" class="form-control" id="date" name="date">
        </div>
        <div class="mb-3">
            <label for="sum" class="form-label">Sum:</label>
            <input type="number" class="form-control" id="sum" placeholder="1.00" name="sum">
        </div>
        <div class="mb-3">
            <label for="tag" class="form-label">Tag:</label>
            <input type="text" class="form-control" id="tag" placeholder="food" name="tag">
        </div>
        <div class="mb-3">
            <label for="notes" class="form-label">Notes:</label>
            <input type="text" class="form-control" id="notes" placeholder="bag of walnuts" name="notes">
        </div>
    </form>
    <div class="row">
      <div class="col">
        <button id="submit" type="submit" class="btn btn-primary">Submit</button>
      </div>
      <div class="col alert alert-success" id="alert-success">
        <strong>Success!</strong>
      </div>
      <div class="col alert alert-danger" id="alert-danger">
          <strong>Error!</strong> Please re-check your input
      </div>
    </div>
  </div>
</body>
</html>