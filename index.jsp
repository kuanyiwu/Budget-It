<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<!-- CSS -->

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<title>Budget</title>

<style>
	body{
		text-align: center;
	}
	.mid{
		font-weight: bold;
		font-size: 40px;
		margin-top: 40px;
	}
	input{
		margin-top: 20px;
	}
	#chart_div{
		padding-left: 150px;
	}
	.btn{
		margin-left: 10px;
		margin-top: 10px;
	}
</style>

<%
	boolean budgetyes = true;
	int b = -1;
	try{
		String bud = request.getParameter("budget");
		b = Integer.parseInt(bud);
	}catch(Exception e){
		budgetyes = false;
	}
	
	boolean expenseyes = true;
	
	String exp = "";
	String type = "";
	
	try{
		exp = request.getParameter("expenses");
		type = request.getParameter("type");
	}catch(Exception d){
		expenseyes = false;
	}
	

%>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

    
    
    <script src="https://www.gstatic.com/firebasejs/4.10.0/firebase.js"></script>
<script src="https://www.gstatic.com/firebasejs/4.9.1/firebase-firestore.js"></script>
<script>
	// Initialize Firebase, authorize yourself.
	var config = {
	  apiKey: //
	  authDomain: //
	  databaseURL: //
	  projectId: //
	  storageBucket: //
	  messagingSenderId: //
	};
	firebase.initializeApp(config);

	var db = firebase.firestore();
	
	if(<%=budgetyes%>){

		db.collection("users").doc("Tom").update({
			 budget: <%=b %>,
		});
	}
	
	  
	if(<%=expenseyes%>){
		
		var prev;
		
			var docRef = db.collection("users").doc("Tom");

			var a = docRef.get().then(function(doc) {
			    if (doc.exists) {
			        console.log("Document data:", doc.data());
			        prev = doc.data().<%=type%>;
			        return prev;
			    } else {
			        console.log("No such document!");
			    }
			}).catch(function(error) {
			    console.log("Error getting document:", error);
			});
			
			a.then(function(b){
				b = b + parseInt(<%=exp%>);
				db.collection("users").doc("Tom").update({
				 	  <%=exp%>: b,
				});

			})

		
	}
</script>

    <!-- Expense -->
    <script type="text/javascript">

      google.charts.load('current', {'packages':['corechart']});

      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {

        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Spending Type');
        data.addColumn('number', '$');
        data.addRows([
          ['Food', 3],
          ['Transportation', 1],
          ['Clothes', 1],
          ['Groceries', 1],
          ['Entertainment', 2],
          ['Other', 1]
        ]);

        // Set chart options
        var options = {'width':600,
                       'height':350,
                       'colors': ['#e0440e', '#e6693e', '#ec8f6e', '#f3b49f', '#f6c7b6','#f9ddd9']};

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>

	<!-- Budget -->
	<script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Budget', 'Fill'],
          ['Spent',   11],
          ['Budget',  2],

        ]);

        var options = {
          pieHole: 0.6,
          colors: ['#cccdce', '#81ea89']
        
        };

        var chart = new google.visualization.PieChart(document.getElementById('donutchart'));
        chart.draw(data, options);
      }
    </script>

</head>
<body>
	<div class="mid"> Budget </div>
	<div> Track and manage your expenses with Alexa </div>
	
	<form name="expenseForm" method="GET" onsubmit="">
	
		<input style="width: 40%" type="text" name="expenses" placeholder="Expenses $"> <br>
		<button class="btn btn-danger" name = "type" value = "food"> <span class="glyphicon glyphicon-cutlery"></span> Food </button>
		<button class="btn btn-warning" name = "type" value = "clothes"> <span class="glyphicon glyphicon-asterisk"></span> Clothes </button>
		<button class="btn btn-success" name = "type" value = "groceries" > <span class="glyphicon glyphicon-shopping-cart"></span> Groceries </button>
		<button class="btn btn-info" name = "type" value = "entertainment"> <span class="glyphicon glyphicon-headphones"></span> Entertainment </button>
		<button class="btn btn-primary" name = "type" value = "transportation"><span class="glyphicon glyphicon-plane"></span> Transportation </button>
		<button class="btn btn-standard" name = "type" value = "other"><span class="glyphicon glyphicon-tree-conifer"></span> Other </button>
	</form>
	
	<div id="chart_div" class="col-lg-6"></div>
	<div id="donutchart" style="width: 600px; height: 350px;" class="col-lg-6"></div>

	<form name="budgetForm" method="GET" onsubmit="updateBudget();">
		<input type="text" name="budget" placeholder="Budget $" =>
		<input type="submit" class="btn-sm btn-info" style="margin-left: 4px;">
	</form>
</body>



</html>


