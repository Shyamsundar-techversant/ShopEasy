$(document).ready(function(){

    if(window.history.replaceState){
		window.history.replaceState(null,null,window.location.href);
	}
    
    let categoryId,subCategoryId,productId;
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

    $('#productEditButton').on('click',function(){
        $('#productTitle').text('Edit Product');
        $('#productAddEditModal').trigger('reset');
        $('#productAddBtn').hide();
        $('#productEditBtn').show();       
        productId = $(this).data('id');
        subCategoryId = $(this).attr('data-subCategId');
        let formData = new FormData();
        formData.append('productId',productId);
        formData.append('subCategoryId',subCategoryId);
        $.ajax({
            url : "../../controller/product.cfc?method=getProduct",
            method : 'POST' ,
            data : formData ,
            processData : false,
            contentType : false,
            success : function(response){
                    let data = JSON.parse(response);
                    productName.val(data[3].productName);
                    productBrand.val(data[3].productBrand);
                    productDescription.val(data[3].productDescription);
                    productPrice.val(data[3].productPrice);
                    productTax.val(data[3].productTax);
                    let row = $('#product-img-container');
                    var ulList = $('<ul>', { class: 'product-img-list' }).css({
                        display: 'flex',
                        flexDirection: 'column',
                        gap: '10px'   
                    });
                    for (let i = 0 ;i<data.length - 1; i++){                       
                        var liItem = $('<li>').css({
                            display: 'flex',
                            justifyContent: 'space-between', 
                            alignItems: 'center',
                        });
                        var spanImg = $('<span>', { class: 'image-container' }).append(
                            $('<img>', { 
                                        src: `../../uploadImg/${data[i].imageFile}`, 
                                        alt: 'prodimg' ,
                                        width : 30,
                                        height : 30
                                    }
                            ),
                            $('<span>', {  
                                text: data[i].imageFile,
                                class: [`image_${i}_name`, 'image_names'].join(' ')  
                            })
                        );
                        var spanClose = $('<span>').append(
                            $('<i>', { class: 'fa-solid fa-x' })  // Font Awesome 'X' icon
                        );
                        liItem.append(spanImg).append(spanClose);
                        ulList.append(liItem);
                    }
                    row.append(ulList);

            },
            error : function(){
                console.log("Request failed") ;
            }
        });
    })
});