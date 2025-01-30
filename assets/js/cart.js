$(document).ready(function(){
    // CHANGE QUANTITY
    let productId;
    $('.qty-decrease').on('click',function(){
        productId = $(this).data('id');
        let decreaseQuantity = 1;
        let formData = new FormData();
        formData.append('productId',productId);
        formData.append('decreaseQuantity',decreaseQuantity);
        $.ajax({
            url : "../../controller/cart.cfc?method=changeProductQuantity",
            method : 'POST' ,
            data : formData,
            processData : false,
            contentType : false ,
            success : function (response){
                console.log(response);
                location.reload();
            },
            error : function(){
                console.log("Request Failed");
            }

        });
    });
    $('.qty-increase').on('click',function(){
        productId = $(this).data('id');
        let increaseQuantity = 1;
        let formData = new FormData();
        formData.append('productId',productId);
        formData.append('increaseQuantity',increaseQuantity);
        $.ajax({
            url : "../../controller/cart.cfc?method=changeProductQuantity",
            method : 'POST' ,
            data : formData,
            processData : false,
            contentType : false ,
            success : function (response){
                console.log(response);
                location.reload();
            },
            error : function(){
                console.log("Request Failed");
            }

        });
    });
    //REMOVE PRODUCTS FROM CART
    $('.remove-from-cart-btn').on('click',function(){
        productId = $(this).data('id');
    });
    $('#productRemoveButton').on('click',function(){
        let formData = new FormData();
        let isRemoveProduct = 1;
        formData.append('productId',productId);
        formData.append('isRemoveProduct',isRemoveProduct);
        $.ajax({
            url : "../../controller/cart.cfc?method=changeProductQuantity",
            method : 'POST' ,
            data : formData,
            processData : false,
            contentType : false ,
            success : function (response){
                console.log(response);
                location.reload();
            },
            error : function(){
                console.log("Request Failed");
            }
        });
    });
});