$(document).ready(function(){

    if(window.history.replaceState){
		window.history.replaceState(null,null,window.location.href);
	}
    
    let categoryId,subCategoryId;
    let categorySelected = $('#categorySelect'),
        subCategorySelected = $('#subCategorySelect'),
        productName = $('#productName'),
        productBrand = $('#productBrand'),
        productDescription = $('#productDescription'),
        productPrice = $('#productPrice'),
        productTax = $('#productTax');



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

    $('#productButton').on('click',function(){
        $('#productAddBtn').show();
        $('#productEditBtn').hide();
        $('.error').text('');
        $('#productTitle').text('Add Product');
    });

    $('#productAddBtn').on('click',function(){
        let formData = new FormData();
        formData.append('categoryId',categorySelected.val());
        formData.append('subCategoryId',subCategorySelected.val());
        formData.append('productName',productName.val());
        formData.append('productBrand',productBrand.val());
        formData.append('productDescription',productDescription.val());
        formData.append('productPrice',productPrice.val());
        formData.append('productTax',productTax.val());

        let productImages = $('#productImages')[0].files;
        if(productImages.length < 3){
            alert('Please select atleast 3 images for products');
        }
        else{
            for(i=0 ; i<productImages.length;i++){
                formData.append('productImages',productImages[i]);
            }          
        }       
        $.ajax({
            url : "../../controller/product.cfc?method=validateProduct",
            method : 'POST' ,
            data : formData ,
            processData : false,
            contentType : false,
            success : function(response){
                    let data = JSON.parse(response);
                    if(data === "Success"){
                        $('#productAddEditModal').modal('hide');
                        location.reload();
                    }
                    else{
                        addError(data);
                    }
            },
            error : function(){
                console.log("Request failed") ;
            }
        });
    })

});