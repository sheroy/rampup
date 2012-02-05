
var autoCompleteDropDownOptions;
$(function(){
        var sourceArray ;
        $("input.autoCompleteField").focus(function(){
            var elementID= $(this).attr("id")
            sourceArray = autoCompleteDropDownOptions[elementID];


        })   ;

        $("input.autoCompleteField").autocomplete({
            source:  function(request, response){
                var options= [];
                for (index= 0; index < sourceArray.length; index++){
                    var sourceItem = sourceArray[index].toLowerCase();
                    var enteredTerm  = request.term.replace(/^\s*/,"").toLowerCase();
                    if(sourceItem.indexOf(enteredTerm) != -1){
                        options.push(sourceArray[index]);
                    }
                }
                response (options)

            }

        });
    });