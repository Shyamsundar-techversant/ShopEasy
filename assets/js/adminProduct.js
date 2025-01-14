$(document).ready(function(){

    if(window.history.replaceState){
		window.history.replaceState(null,null,window.location.href);
	}
    
    // Error function 

        function addError(error){
            let errorList = $('.error');
            errorList.innerHTML = "" ;
            error.forEach((error) => {
                let li= document.createElement('li');
                li.textContent=error;
                errorList.append(li);               
            });
        }

});