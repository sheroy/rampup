$('li a').click(function(e){
  var answer = confirm("Any changes you might have made will not be saved.\nWould you like to continue without saving?");
  return answer;
});