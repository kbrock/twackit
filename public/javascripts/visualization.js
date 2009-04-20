function initViz() {
  var query = new google.visualization.Query(vizQueryUrl);
  query.send(handleQueryResponse);
}

function handleQueryResponse(response) {
  if (response.isError()) {
    alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
    return;
  }

  var data = response.getDataTable();
  var chart = new google.visualization.PieChart(document.getElementById('chart_container'));
  chart.draw(data, {width: 400, height: 240, is3D: true});
}
