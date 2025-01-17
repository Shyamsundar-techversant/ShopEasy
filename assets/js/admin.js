$(document).ready(function () {

    if (window.history.replaceState) {
        window.history.replaceState(null, null, window.location.href);
    }

    // Error function 
    function addError(error) {
        let errorList = $('.error');
        errorList.innerHTML = "";
        error.forEach((error) => {
            let li = document.createElement('li');
            li.textContent = error;
            errorList.append(li);
        });
    }


    // CATEGORY

    // ADD
    $('#categoryButton').on('click', function () {
        $("#categoryAddForm").trigger('reset');
        $('.error').text('');
        $('#categoryTitle').text('Add Category');
        $('#categoryAddBtn').show();
        $('#categoryEditButton').hide();
    });

    $('#categoryAddBtn').on('click', function (event) {
        let formData = new FormData();
        let categoryName = $('#categoryName').val();
        formData.append('categoryName', categoryName);
        $.ajax({
            url: '../../controller/category.cfc?method=validateCategoryName',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    $('#categoryAddModal').modal('hide');
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

    // EDIT

    let categoryId;
    $('.categoryEditBtn').on('click', function () {
        $("#categoryAddForm").trigger('reset');
        $('.error').text('');
        $('#categoryTitle').text('Edit Category');
        $('#categoryAddBtn').hide();
        $('#categoryEditButton').show();

        categoryId = $(this).data('id');
        let formData = new FormData();
        formData.append('categoryId', categoryId);
        $.ajax({
            url: "../../controller/category.cfc?method=getCategory",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                $('#categoryName').val(data.fldCategoryName);
            },
            error: function () {
                console.log("Request failed");
            }
        });
    })

    $('#categoryEditButton').on('click', function () {
        let formData = new FormData();
        let categoryName = $('#categoryName').val();
        formData.append('categoryName', categoryName);
        formData.append('categoryId', categoryId);
        $.ajax({
            url: "../../controller/category.cfc?method=validateCategoryName",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    $('#categoryAddModal').modal('hide');
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

    })

    //DELETE
    $('.categoryDeleteBtn').on('click', function () {
        categoryId = $(this).data('id');
    })

    $('#categoryDeleteBtn').on('click', function () {
        let formData = new FormData();
        formData.append('categoryId', categoryId);
        $.ajax({
            url: "../../controller/category.cfc?method=categoryDelete",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    $('#categoryDeleteModal').modal('hide');
                    location.reload();
                }
            },
            error: function () {
                console.log("Request Failed");
            }
        });
    });

    //SUB CATEGORY

    //ADD
    $('#subCategoryButton').on('click', function () {
        $("#categoryAddForm").trigger('reset');
        $('.error').text('');
        $('#categoryTitle').text('Add SubCategory');
        $('#subCategoryAddButton').show();
        $('#subCategoryEditButton').hide();
    });

    $('#subCategoryAddButton').on('click', function () {
        let formData = new FormData();
        let subCategoryName = $('#subCategName').val();
        let categoryId = $('#categorySelect').val();
        formData.append('subCategoryName', subCategoryName);
        formData.append('categoryId', categoryId);
        console.log(categoryId);
        $.ajax({
            url: "../../controller/category.cfc?method=validateSubCategory",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    $('#subCategoryAddEditModal').modal('hide');
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

    //EDIT
    let subCategoryId;
    $('.subcategory-edit-btn').on('click', function () {
        $("#categoryAddForm").trigger('reset');
        $('.error').text('');
        $('#categTitle').text('Edit SubCategory');
        $('#subCategoryAddButton').hide();
        $('#subCategoryEditButton').show();
        subCategoryId = $(this).data('id');
        categoryId = $(this).attr('data-categId');
        let formData = new FormData();
        formData.append('subcategoryId', subCategoryId);
        formData.append('categoryId', categoryId);
        $.ajax({
            url: "../../controller/category.cfc?method=getSubCategory",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                $('#subCategName').val(data.fldSubCategoryName);
            },
            error: function () {
                console.log("Request failed");
            }
        });
    });

    $('#subCategoryEditButton').on('click', function () {
        let subCategoryName = $('#subCategName').val();
        let categoryId = $('#categorySelect').val();
        let formData = new FormData();
        formData.append('subcategoryId', subCategoryId);
        formData.append('categoryId', categoryId);
        formData.append('subCategoryName', subCategoryName);

        $.ajax({
            url: "../../controller/category.cfc?method=validateSubCategory",
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    $('#subCategoryAddEditModal').modal('hide');
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

    //DELETE

    $('.subcategory-delete-btn').on('click', function () {
        subCategoryId = $(this).data('id');
    });
    $('#subCategoryDeleteBtn').on('click', function () {
        $.ajax({
            url: "../../controller/category.cfc?method=subCategoryDelete",
            method: 'POST',
            data: { subCategoryId: subCategoryId },
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    $('#categoryDeleteModal').modal('hide');
                    location.reload();
                }
            },
            error: function () {
                console.log("Request Failed");
            }
        });
    })
});