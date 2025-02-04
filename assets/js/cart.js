$(document).ready(function () {
    // Error function 
    function addError(error) {
        let errorList = $('.form-error');
        errorList.html("");
        error.forEach((error) => {
            let li = document.createElement('li');
            li.textContent = error;
            errorList.append(li);
        });
    }
    // CHANGE QUANTITY
    let productId;
    $('.qty-decrease').on('click', function () {
        productId = $(this).data('id');
        let decreaseQuantity = 1;
        let formData = new FormData();
        formData.append('productId', productId);
        formData.append('decreaseQuantity', decreaseQuantity);
        $.ajax({
            url: "../../controller/cart.cfc?method=changeProductQuantity",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                console.log(response);
                location.reload();
            },
            error: function () {
                console.log("Request Failed");
            }

        });
    });
    $('.qty-increase').on('click', function () {
        productId = $(this).data('id');
        let increaseQuantity = 1;
        let formData = new FormData();
        formData.append('productId', productId);
        formData.append('increaseQuantity', increaseQuantity);
        $.ajax({
            url: "../../controller/cart.cfc?method=changeProductQuantity",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                console.log(response);
                location.reload();
            },
            error: function () {
                console.log("Request Failed");
            }

        });
    });
    //REMOVE PRODUCTS FROM CART
    $('.remove-from-cart-btn').on('click', function () {
        productId = $(this).data('id');
    });
    $('#productRemoveButton').on('click', function () {
        let formData = new FormData();
        let isRemoveProduct = 1;
        formData.append('productId', productId);
        formData.append('isRemoveProduct', isRemoveProduct);
        $.ajax({
            url: "../../controller/cart.cfc?method=changeProductQuantity",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                console.log(response);
                location.reload();
            },
            error: function () {
                console.log("Request Failed");
            }
        });
    });

    //USER PROFILE
    $('.address-add-btn').on('click', function () {
        $('#addressAddForm').trigger('reset');
        $('.form-error').text('');
    });

    $('#addAddressBtn').on('click', function () {
        let formData = new FormData();
        formData.append('firstName', $('#firstname').val());
        formData.append('lastName', $('#lastname').val());
        formData.append('addressLine_1', $('#addressLine1').val());
        formData.append('addressLine_2', $('#addressLine2').val());
        formData.append('city', $('#city').val());
        formData.append('state', $('#state').val());
        formData.append('pincode', $('#pincode').val());
        formData.append('phone', $('#phone').val());
        $.ajax({
            url: "../../controller/cart.cfc?method=addUserAddress",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                console.log(response);
                let data = JSON.parse(response);
                if (data === 'Success') {
                    $('#addressAddModal').modal('hide');
                    location.reload();
                }
                else {
                    addError(data);
                }

            },
            error: function () {
                console.log("Request failed");
            }
        })
    });
    // REMOVE ADDRESS
    let addressId;
    $('.address-remove-btn').on('click', function () {
        addressId = $(this).data('id');
    });
    $('#addressRemoveBtn').on('click', function () {
        let formData = new FormData();
        formData.append('addressId', addressId);
        $.ajax({
            url: "../../controller/cart.cfc?method=removeUserAddress",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                console.log(response);
                let data = JSON.parse(response);
                if (data === 'Success') {
                    $('#addressRemoveModal').modal('hide');
                    location.reload();
                }
            },
            error: function () {
                console.log("Request failed");
            }
        });
    });

    // EDIT USER DETAIS
    let userId;
    $('.edit-user-detail-btn').on('click', function () {
        $('#editUserModalForm').trigger('reset');
        $('.form-error').text('');
        userId = $(this).data('id');
        let formData = new FormData();
        formData.append('userId', userId);
        $.ajax({
            url: "../../controller/cart.cfc?method=getUserDetails",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                $('#userFirstname').val(data.DATA[0][0]);
                $('#userLastname').val(data.DATA[0][1]);
                $('#emailId').val(data.DATA[0][3]);
                $('#phoneNumber').val(data.DATA[0][2]);
            },
            error: function () {
                console.log("Request failed");
            }
        });
    });
    $('#editUserModalBtn').on('click', function () {
        let formData = new FormData();
        formData.append('userId', userId);
        formData.append('firstName', $('#userFirstname').val());
        formData.append('lastName', $('#userLastname').val());
        formData.append('email', $('#emailId').val());
        formData.append('phone', $('#phoneNumber').val());
        $.ajax({
            url: "../../controller/cart.cfc?method=validateUserDetails",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                if (data === 'Success') {
                    $('#addressRemoveModal').modal('hide');
                    location.reload();
                }
                else {
                    addError(data);
                }
            },
            error: function () {
                console.log("Request failed");
            }
        });
    });

    // SET SESSION VARIABLE FOR ORDER NOW
    $('#order-now-btn').on('click', function () {
        let formData = new FormData();
        productId = $(this).data('id');
        formData.append('setOrder', 1);
        formData.append('productId', productId);
        $.ajax({
            url: "../../controller/cart.cfc?method=setSessionValue",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                console.log('hhh');
            },
            error: function () {
                console.log("Request failed");
            }
        });
    });
    $('#order-product-btn').on('click',function(){
        $('#addressAddModal').modal('hide');
        $('#addressSelectModal').modal('show');
        $('.form-error').text('');
    });
    $('.select-address-button').on('click',function(){
        $('#addressSelectModal').modal('hide');
        $('#addressAddModal').modal('show');
    });
    $('.close-select-address-modal').on('click',function(){
        $('#addressSelectModal').modal('hide');
        $('#addressAddModal').modal('hide');
    });
    $('.add-address-modal-close').on('click',function(){
        $('#addressSelectModal').modal('show');
        $('#addressAddModal').modal('hide');
        $('.form-error').text('');
    });

    // ORDER SUMMARY
    let productQuantity = parseInt($('#orderQuantity').val(), 10) || 0;
    let totalPrice = parseFloat($('.payable-order-price').text());
    let totalCalculatedAmount;
    $('.qty-add-btn').on('click',function(){
        productQuantity += 1;
        $('#orderQuantity').val(productQuantity); 
        totalCalculatedAmount = productQuantity*totalPrice;
        $('.payable-order-price').text(totalCalculatedAmount);
    });
    $('.qty-remove-btn').on('click',function(){
        productQuantity -= 1;
        $('#orderQuantity').val(productQuantity);
        productId = $(this).data('id');
        totalCalculatedAmount = productQuantity*totalPrice;
        $('.payable-order-price').text(totalCalculatedAmount);
        if(productQuantity <= 0){
            window.location.href = `userProduct.cfm?productId=${productId}`;
        }
    });
});

