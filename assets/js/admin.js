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
    $('#categoryAddBtn').on('click', function () {
        $.ajax({
            url: '../../controller/category.cfc?method=validateCategoryName',
            type: 'POST',
            data: {
                categoryName: $('#categoryName').val()
            },
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
                alert("Request failed");
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
        $.ajax({
            url: "../../controller/category.cfc?method=getCategory",
            method: 'POST',
            data: {
                categoryId: categoryId
            },
            success: function (response) {
                let data = JSON.parse(response);
                $('#categoryName').val(data.fldCategoryName);
            },
            error: function () {
                alert("Request failed");
            }
        });
    })
    $('#categoryEditButton').on('click', function () {
        $.ajax({
            url: "../../controller/category.cfc?method=validateCategoryName",
            method: 'POST',
            data: {
                categoryName: $('#categoryName').val(),
                categoryId: categoryId
            },
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
                alert("Request failed");
            }
        });
    });
    //DELETE
    $('.categoryDeleteBtn').on('click', function () {
        categoryId = $(this).data('id');
    })
    $('#categoryDeleteBtn').on('click', function () {
        $.ajax({
            url: "../../controller/category.cfc?method=categoryDelete",
            method: 'POST',
            data: {
                categoryId: categoryId
            },
            success: function (response) {
                let data = JSON.parse(response);
                if (data === "Success") {
                    $('#categoryDeleteModal').modal('hide');
                    location.reload();
                }
            },
            error: function () {
                alert("Request failed");
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
        $.ajax({
            url: "../../controller/category.cfc?method=validateSubCategory",
            method: 'POST',
            data: {
                subCategoryName: $('#subCategName').val(),
                categoryId: $('#categorySelect').val()
            },
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
                alert("Request failed");
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
        $.ajax({
            url: "../../controller/category.cfc?method=getSubCategory",
            method: 'POST',
            data: {
                subCategoryId: subCategoryId,
                categoryId: categoryId
            },
            success: function (response) {
                let data = JSON.parse(response);
                $('#subCategName').val(data.fldSubCategoryName);
            },
            error: function () {
                alert("Request failed");
            }
        });
    });
    $('#subCategoryEditButton').on('click', function () {
        $.ajax({
            url: "../../controller/category.cfc?method=validateSubCategory",
            method: 'POST',
            data: {
                subCategoryId: subCategoryId,
                categoryId: $('#categorySelect').val(),
                subCategoryName: $('#subCategName').val()
            },
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
                alert("Request failed");
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
                alert("Request failed");
            }
        });
    })
});