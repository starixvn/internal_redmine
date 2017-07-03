$(document).ready(function() {
  var tabAll = $('a#tab-history-all'),
  	tabComment = $('a#tab-history-comments'),
  	tabDiff = $('a#tab-history-diff'),
  	tabComparison = $('a#tab-history-comparison');
  
  tabAll.on('click', function(e) {
  	tabComment.removeClass('selected');
    tabAll.addClass('selected');
    
    $('.journal').show();
  });
  
  tabComment.on('click', function(e) {
  	tabComment.addClass('selected');
  	tabAll.removeClass('selected');
  
  	$('.journal').hide();
  	$('.journal.has-notes').show();
  });
  
  tabDiff.on('click', function(e) {
  	tabComparison.removeClass('selected');
  	tabDiff.addClass('selected');
  	
  	$('.history .diff-content').show();
  	$('.history .diff-comparison-content').hide();
  });
  
  tabComparison.on('click', function(e) {
  	tabDiff.removeClass('selected');
  	tabComparison.addClass('selected');
  	
  	$('.history .diff-content').hide();
  	$('.history .diff-comparison-content').show();
  });
  
  tabComment.trigger('click');
});
