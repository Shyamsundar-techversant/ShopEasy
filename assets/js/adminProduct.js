$(document).ready(function () {

    if (window.history.replaceState) {
        window.history.replaceState(null, null, window.location.href);
    }

    let subCategoryId, productId, imageId;
    let categorySelected = $('#categorySelect'),
        subCategorySelected = $('#subCategorySelect'),
        productName = $('#productName'),
        productBrand = $('#productBrand'),
        productDescription = $('#productDescription'),
        productPrice = $('#productPrice'),
        productTax = $('#productTax');



    // Error function 
    function addError(error) {
        let errorList = $('.error');
        errorList.html("") ;
        error.forEach((error) => {
            let li = document.createElement('li');
            li.textContent = error;
            errorList.append(li);
        });
    }

    //PRODUCT ADD
    $('#productButton').on('click', function () {
        $('#productAddBtn').show();
        $('#productEditBtn').hide();
        $('.error').text('');
        $('#productTitle').text('Add Product');
        $('#img-list').empty();
        $('#productAddForm').trigger('reset');
    });


    $('#productAddBtn').on('click', function () {
        $('#img-list').empty();
        let formData = new FormData();
        formData.append('categoryId', categorySelected.val());
        formData.append('subCategoryId', subCategorySelected.val());
        formData.append('productName', productName.val());
        formData.append('productBrand', productBrand.val());
        formData.append('productDescription', productDescription.val());
        formData.append('productPrice', productPrice.val());
        formData.append('productTax', productTax.val());

        let productImages = $('#productImages')[0].files;
        if (productImages.length < 3) {
            alert('Please select atleast 3 images for products');
        }
        else {
            for (i = 0; i < productImages.length; i++) {
                formData.append('productImages', productImages[i]);
            }
        }
        $.ajax({
            url: "../../controller/product.cfc?method=validateProduct",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    $('#productAddEditModal').modal('hide');
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

    //PRODUCT EDIT
    $('.product-edit-btn').on('click', function () {
        $('#img-list').empty();
        $('#productTitle').text('Edit Product');
        $('#productAddForm').trigger('reset');
        $('#productAddBtn').hide();
        $('#productEditBtn').show();
        productId = $(this).data('id');
        subCategoryId = $(this).attr('data-subCategId');
        let formData = new FormData();
        formData.append('productId', productId);
        formData.append('subCategoryId', subCategoryId);
        $.ajax({
            url: "../../controller/product.cfc?method=getProduct",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                productName.val(data[data.length - 1].productName);
                productBrand.val(data[data.length - 1].productBrand);
                productDescription.val(data[data.length - 1].productDescription);
                productPrice.val(data[data.length - 1].productPrice);
                productTax.val(data[data.length - 1].productTax);
                let imgList = $('#img-list');
                imgList.css({
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '10px'
                });
                for (let i = 0; i < data.length - 1; i++) {
                    var liItem = $('<li>').css({
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'center',
                    });
                    var spanImg = $('<span>', { class: 'image-container' }).append(
                        $('<img>', {
                            src: `../../uploadImg/${data[i].imageFile}`,
                            alt: 'prodimg',
                            width: 30,
                            height: 30
                        }
                        ),
                        $('<span>', {
                            text: data[i].imageFile,
                            class: [`image_${i}_name`, 'image_names'].join(' ')
                        })
                    );
                    var spanClose = $('<button>', { class: 'img-dlt-btn', img_id: data[i].imageId, type: 'button' }).append(
                        $('<i>', { class: 'fa-solid fa-x' })
                    );
                    liItem.append(spanImg).append(spanClose);
                    imgList.append(liItem);

                }
            },
            error: function () {
                console.log("Request failed");
            }
        });
    });

    $('#productEditBtn').on('click', function () {
        let formData = new FormData();
        formData.append('categoryId', categorySelected.val());
        formData.append('subCategoryId', subCategorySelected.val());
        formData.append('productName', productName.val());
        formData.append('productBrand', productBrand.val());
        formData.append('productDescription', productDescription.val());
        formData.append('productPrice', productPrice.val());
        formData.append('productTax', productTax.val());
        formData.append('productId', productId);
        let productImages = $('#productImages')[0].files;
        if (productImages.length > 0) {
            for (i = 0; i < productImages.length; i++) {
                formData.append('productImages', productImages[i]);
            }
        }
        $.ajax({
            url: "../../controller/product.cfc?method=validateProduct",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    $('#productAddEditModal').modal('hide');
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




    //IMAGE DELETE
    $('#img-list').on('click', '.img-dlt-btn', function () {
        imageId = $(this).attr('img_id');
        let button = $(this);
        let formData = new FormData();
        formData.append('imageId', imageId);
        formData.append('productId', productId)
        $.ajax({
            url: "../../controller/product.cfc?method=deleteImage",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    button.closest('li').remove();
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

    //DELETE PRODUCT
    $('.product-dlt-btn').on('click', function () {
        productId = $(this).data('id');
    })
    $('#productDeleteBtn').on('click', function () {
        $.ajax({
            url: "../../controller/product.cfc?method=deleteProduct",
            method: 'POST',
            data: { productId },
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    $('productDeleteModal').modal('hide');
                    location.reload();
                }
                else {
                    alert("Product deletion failed");
                }
            },
            error: function () {
                console.log("Request Failed");
            }
        });
    })
});