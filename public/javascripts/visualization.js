// Initializes Google Visualization components.
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


document.observe("dom:loaded", function() {
  if (backgroundSearch) {
    new Ajax.Request('/import', {
      method: 'get',
      parameters: {
        'u': twitterer,
        't': hashtag
      },
      onSuccess: function(transport) {
        var count = transport.responseJSON;
        if (count > 0) {
          // new tweets were imported, prompt to refresh page
          var pronoun = (count > 1) ? 'them' : 'it';
          var count_label = count + ' new tweet';
          if (count > 1) { count_label += 's'; }
          
          var prompt = $('refresh_prompt');
          prompt.down('.count').update(count_label);
          prompt.down('.pronoun').update(pronoun);
          prompt.show();
          new Effect.Highlight('refresh_prompt', { keepBackgroundImage: true });
        }
        else {
          // just show the timestamp
          $('updated_at').show();
        }
      },
      onComplete: function() {
        // hide background process indicator
        $('updating').hide();
      }
    });
  }
});
