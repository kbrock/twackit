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
        if (transport.responseJSON != null) {
          // new tweets were imported, prompt to refresh page
          var count = transport.responseJSON + ' new tweet';
          var pronoun = 'it';

          if (transport.responseJSON > 1) { 
            // pluralize
            count += 's';
            pronoun = 'them';
          }
      
          $$('#refresh_prompt .count')[0].update(count);
          $$('#refresh_prompt .pronoun')[0].update(pronoun);
          $('refresh_prompt').show();
          new Effect.Highlight('refresh_prompt');
        }
        else {
          $('updated_at').show();
        }
      },
      onComplete: function() {
        $('updating').hide();
      }
    });
  }
});
