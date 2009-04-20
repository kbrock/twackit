function initViz() {
  var data = new google.visualization.DataTable(vizData);
  debugger;

  var lineChart = new google.visualization.LineChart(document.getElementById('line_chart'));
  lineChart.draw(data, {
    width: 800,
    height: 450,
    title: 'Chart'
  });
  
  // var dataTable = new google.visualization.Table(document.getElementById('data_table'));
  // dataTable.draw(data, {
  //   width: 800,
  //   height: 450,
  //   title: 'Data'
  // });
}
