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
                  url: '${BACKEND_HOST}/expense',
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
          document.getElementById('date').value=(new Date()).toISOString().substr(0,10);
          document.getElementById("alert-success").style.display = "none";
          document.getElementById("alert-danger").style.display = "none";
      }
  </script>
</head>
<body>
  <div class="container">
    <h1>Report expense</h1>
    <form id="form" action="${BACKEND_HOST}/expense" method="post">
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
