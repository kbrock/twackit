document.observe("dom:loaded", function() {
  // Links with class 'feedback' should show UserVoice popup when clicked.
  $$('a.feedback').each(function(element) {
    element.observe('click', function(e) { e.stop(); UserVoice.Popin.show(); });
  });

  // Dismiss message bar.
  $$('#message a.close').each(function(element) {
    element.observe('click', function(e) { e.stop(); $('message').hide(); })
  });
  $$('a[data-popup]').each(function(element) {
    element.observe('click', function(e) { e.stop(); window.open($(e.target).href); });
  });
});
