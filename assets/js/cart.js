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
        let isDecreaseQuantity = 1;
        let closestDiv = $(this).closest(".cart-prod-details");
        let inputField = closestDiv.find(".card-product-count-input");
        let currentQuantity = parseInt(inputField.val(), 10);
        if (currentQuantity > 1) {
            $.ajax({
                url: "../../controller/cart.cfc?method=changeProductQuantity",
                method: 'POST',
                data: {
                    productId: productId,
                    isDecreaseQuantity: isDecreaseQuantity
                },
                success: function (response) {
                    location.reload();
                },
                error: function () {
                    alert("Request failed");
                }
            });
        }
    });
    $('.qty-increase').on('click', function () {
        productId = $(this).data('id');
        let isIncreaseQuantity = 1;
        let formData = new FormData();
        $.ajax({
            url: "../../controller/cart.cfc?method=changeProductQuantity",
            method: 'POST',
            data: {
                productId: productId,
                isIncreaseQuantity: isIncreaseQuantity
            },
            success: function (response) {
                location.reload();
            },
            error: function () {
                alert("Request failed");;
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
            data: {
                productId: productId,
                isRemoveProduct: isRemoveProduct
            },
            success: function (response) {
                location.reload();
            },
            error: function () {
                alert("Request failed");
            }
        });
    });
    //USER PROFILE
    $('.address-add-btn').on('click', function () {
        $('#addressAddForm').trigger('reset');
        $('.form-error').text('');
    });
    $('#addAddressBtn').on('click', function () {
        $.ajax({
            url: "../../controller/cart.cfc?method=addUserAddress",
            method: 'POST',
            data: {
                firstName: $('#firstname').val(),
                lastName: $('#lastname').val(),
                addressLine1: $('#addressLine1').val(),
                addressLine2: $('#addressLine2').val(),
                city: $('#city').val(),
                state: $('#state').val(),
                pincode: $('#pincode').val(),
                phone: $('#phone').val()
            },
            success: function (response) {
                let data = JSON.parse(response);
                if (data === 'Success') {
                    $('#addressAddModal').modal('hide');
                    location.reload();
                }
                else {
                    addError(data);
                    let errorDiv = document.getElementById("address-validation-error");
                    if (errorDiv) {
                        errorDiv.scrollIntoView({ behavior: "smooth", block: "center" });
                    }
                }
            },
            error: function () {
                alert("Request failed");
            }
        })
    });
    // REMOVE ADDRESS
    let addressId;
    $('.address-remove-btn').on('click', function () {
        addressId = $(this).data('id');
    });
    $('#addressRemoveBtn').on('click', function () {
        $.ajax({
            url: "../../controller/cart.cfc?method=removeUserAddress",
            method: 'POST',
            data: { addressId: addressId },
            success: function (response) {
                let data = JSON.parse(response);
                if (data === 'Success') {
                    $('#addressRemoveModal').modal('hide');
                    location.reload();
                }
            },
            error: function () {
                alert("Request failed");
            }
        });
    });
    // EDIT USER DETAIS
    let userId;
    $('.edit-user-detail-btn').on('click', function () {
        $('#editUserModalForm').trigger('reset');
        $('.form-error').text('');
        userId = $(this).data('id');
        $.ajax({
            url: "../../controller/cart.cfc?method=getUserDetails",
            method: 'POST',
            data: { userId: userId },
            success: function (response) {
                let data = JSON.parse(response);
                $('#userFirstname').val(data.DATA[0][0]);
                $('#userLastname').val(data.DATA[0][1]);
                $('#emailId').val(data.DATA[0][3]);
                $('#phoneNumber').val(data.DATA[0][2]);
            },
            error: function () {
                alert("Request failed");
            }
        });
    });
    $('#editUserModalBtn').on('click', function () {
        $.ajax({
            url: "../../controller/cart.cfc?method=validateUserDetails",
            method: 'POST',
            data: {
                userId: userId,
                firstName: $('#userFirstname').val(),
                lastName: $('#userLastname').val(),
                email: $('#emailId').val(),
                phone: $('#phoneNumber').val()
            },
            success: function (response) {
                let data = JSON.parse(response);
                if (data === 'Success') {
                    $('#addressRemoveModal').modal('hide');
                    location.reload();
                }
                else {
                    addError(data);
                    let errorDiv = document.getElementById("user-details-validation-error");
                    if (errorDiv) {
                        errorDiv.scrollIntoView({ behavior: "smooth", block: "center" });
                    }
                }
            },
            error: function () {
                alert("Request failed");
            }
        });
    });
    // SET SESSION VARIABLE FOR ORDER NOW
    $('#order-now-btn').on('click', function () {
        productId = $(this).data('id');
        $.ajax({
            url: "../../controller/cart.cfc?method=setSessionValue",
            method: 'POST',
            data: {
                setOrder: 1,
                productId: productId
            }
        });
    });
    $('#order-product-btn').on('click', function () {
        $('#addressAddModal').modal('hide');
        $('#addressSelectModal').modal('show');
        $('.form-error').text('');
    });
    $('.select-address-button').on('click', function () {
        $('#addressSelectModal').modal('hide');
        $('#addressAddModal').modal('show');
    });
    $('.close-select-address-modal').on('click', function () {
        $('#addressSelectModal').modal('hide');
        $('#addressAddModal').modal('hide');
    });
    $('.add-address-modal-close').on('click', function () {
        $('#addressSelectModal').modal('show');
        $('#addressAddModal').modal('hide');
        $('.form-error').text('');
    });
    // ORDER SUMMARY
    let productQuantity = parseInt($('#orderQuantity').val(), 10) || 0;
    let unitPrice = parseFloat($('.payable-order-price').text());
    let unitTax = parseFloat($('.actual-order-tax').text());
    let totalCalculatedAmount = unitPrice;
    let totalTax = (unitTax * unitPrice) / 100;
    $('.qty-add-btn').on('click', function () {
        productQuantity += 1;
        $('#orderQuantity').val(productQuantity);
        totalCalculatedAmount = productQuantity * unitPrice;
        $('.payable-order-price').text(totalCalculatedAmount);
        totalTax = (productQuantity * unitPrice * unitTax) / 100;
    });
    $('.qty-remove-btn').on('click', function () {
        productQuantity -= 1;
        $('#orderQuantity').val(productQuantity);
        productId = $(this).data('id');
        totalCalculatedAmount = productQuantity * unitPrice;
        totalTax = (productQuantity * unitTax * unitPrice) / 100;
        $('.payable-order-price').text(totalCalculatedAmount);
        if (productQuantity <= 0) {
            window.location.href = `userProduct.cfm?productId=${productId}`;
        }
    });
    // ORDER PAYMENT
    $('.place-order-btn').on('click', function () {
        $('#order-place-form').trigger('reset');
        $('.form-error').empty();
    });
    $('.pay-btn').on('click', function () {
        let formData = new FormData();
        productId = $('.selected-order-product').data('id');
        addressId = $('.order-address-summary').data('id');
        formData.append('cardNumber', $('#card-number').val());
        formData.append('cvv', $('#cvv').val());
        formData.append('productId', productId);
        formData.append('addressId', addressId);
        formData.append('unitPrice', unitPrice);
        formData.append('unitTax', unitTax);
        formData.append('totalPrice', totalCalculatedAmount);
        formData.append('totalTax', totalTax);
        formData.append('quantity', productQuantity);
        $.ajax({
            url: "../../controller/order.cfc?method=validateCardAndOrder",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                if (data === 'Success') {
                    $('#orderPlaceModal').modal('hide');
                    Swal.fire({
                        title: "Payment Successful",
                        icon: "success"
                    }).then(() => {
                        window.location.href = 'orderHistory.cfm';
                    });
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
});

