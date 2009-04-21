function initViz() {
  var data = new google.visualization.DataTable(vizData);
  
  var timeline = new google.visualization.AnnotatedTimeLine(document.getElementById('timeline'));
  var table = new google.visualization.Table(document.getElementById('data_table'));

  // google.visualization.events.addListener(timeline, 'ready', function(event) {
  //   alert('annotatedtimeline is ready, master!');
  // });

  timeline.draw(data, {
    displayAnnotations: true, 
    annotationsWidth: 30,
    displayZoomButtons: true,
    displayRangeSelector: true,
    });  
  table.draw(data, null);
  
}
