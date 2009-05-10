document.observe("dom:loaded", function() {
  // Links with class 'feedback' should show UserVoice popup when clicked.
  $$('a.feedback').each(function(element) {
    element.observe('click', function(e) { e.stop(); UserVoice.Popin.show(); });
  });
});
