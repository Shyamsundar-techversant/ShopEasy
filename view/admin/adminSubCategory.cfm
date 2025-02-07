<cfif structKeyExists(url,'categId')>
    <cfset variables.getSubCategoryById = application.cateContObj.getSubCategory(

                                                                            subCategoryId = url.subCategID,
                                                                            categoryId = url.categId
                                                                        )

    >
    <cfset variables.getCategoryById = application.cateContObj.getCategory(categoryId = url.categId)>
    <cfset variables.allProducts = application.productContObj.getProduct(
                                                                          subCategoryId = url.subCategID
                                                                        )
    > 
</cfif>
<cfinclude template = "header.cfm" >
    <section class = "category-section">
      <div class = "container category-container">
        <div class = "card category-card" data-aos="fade-down" data-aos-easing="linear" data-aos-duration="300">
          <div class = "card-head">
            <div class = "cardhead-content">
                <span class = "category-head">
                    <cfoutput>#variables.getSubCategoryById.fldSubcategoryName#</cfoutput>
                </span>
                <span>
                    <button type="button" class="category-btn" data-bs-toggle="modal" 
                              data-bs-target="#productAddEditModal" id = "productButton"                              
                    >
                        +  
                    </button>
                </span> 
            </div>
          </div>
          <div class = "card-body">
            <table class="table">
              <tbody>
                <cfif structKeyExists(variables, 'allProducts') AND isQuery(variables.allProducts)>
                  <cfoutput query = "variables.allProducts">
                    <cfset encryptedId = encrypt(
                                                  variables.allProducts.fldProduct_ID,
                                                  application.encryptionKey,
                                                  "AES",
                                                  "Hex"
                                                )
                    >
                    <tr class = "table-light">
                      <td>
                        <div class = "product-name">
                          <h5>#variables.allProducts.fldProductName#</h5>
                          <cfset brandName = application.productContObj.getBrands(
                                                                   
                                                                    brandId = variables.allProducts.fldBrandId
                                                                    
                                                                  )
                          >
                          <h6>#brandName.fldBrandName#</h6>
                        </div>
                  
                      </td>
                      <td>
                        <button  type = "button" 
                                class = "categ-alt-btn product-edit-btn"
                                data-bs-toggle = "modal"
                                data-bs-target = "##productAddEditModal"
                                data-id = "#variables.allProducts.fldProduct_ID#"
                                data-subCategId = "#url.subCategID#"
                        >
                          EDIT
                        </button>
                      </td>
                      <td>
                        <button type = "button"
                                class = "categ-alt-btn product-dlt-btn"
                                data-bs-toggle = "modal"
                                data-bs-target = "##productDeleteModal"
                                data-id = "#variables.allProducts.fldProduct_ID#"
                                data-subCategId = "#url.subCategID#"
                        >
                          DELETE
                        </button>
                      </td>
                      <td>
                        <button type = "button"
                                class = "categ-subCateg-btn categ-dlt-btn"
                                data-id = "#variables.allProducts.fldProduct_ID#"
                                onclick = "window.location.href = 'adminProduct.cfm?productId=#encryptedId#&subCategID=#url.subCategID#' "
                        >       
                          VIEW
                        </button>             
                      </td>
                    </tr>  
                  </cfoutput> 
                <cfelse>
                    <cfdump var = "#variables.allProducts#">
                </cfif>
              </tbody>
            </table>           
          </div>
        </div>
      </div>
    </section>

    <!-- Product Add Edit Modal -->
    <div class="modal fade" id="productAddEditModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header categAddModalHead">
            <h5 class="modal-title" id = "productTitle">Add Product</h5>
          </div>
          <div class="modal-body">
            <form action = "" class = "categAddForm" method = "post" id = "productAddForm">
              <div class = "row mb-3 ">
                <div class = "error">

                </div>
              </div> 
              <div class = "row mb-2">
                <div class = "col">
                  <cfset categoryValues = application.cateContObj.getCategory() >
                  <lablel for = "categorySelect" class = "form-label">Category Name </label>
                  <select class = "form-select" id = "categorySelect">
                    <cfoutput query = "categoryValues" >
                      <option value = "#categoryValues.fldCategory_ID#"
                        <cfif categoryValues.fldCategory_ID EQ variables.getCategoryById.fldCategory_ID>
                          selected
                        </cfif> 
                      >
                        #categoryValues.fldCategoryName#  
                      </option>
                    </cfoutput> 
                  </select>
                </div>
              </div>
              <div class = "row mb-3">
                <div class = "col">
                  <cfset subCategoryValues = application.cateContObj.getSubCategory(
                                                                                      categoryId = url.categId
                                                                                    ) 
                  >
                  <lablel for = "subCategorySelect" class = "form-label">SubCategory Name</label>
                  <select class = "form-select" id = "subCategorySelect">
                    <cfoutput query = "subCategoryValues" >
                      <option value = "#subCategoryValues.fldSubCategory_ID#"
                        <cfif subCategoryValues.fldSubCategory_ID EQ variables.getSubCategoryById.fldSubCategory_ID>
                          selected
                        </cfif>
                      >
                        #subCategoryValues.fldSubCategoryName#  
                      </option>
                    </cfoutput> 
                  </select>
                </div>
              </div>

              <div class = "row mb-3">
                <div class = "col">
                  <label for = "productName" class = "form-label">Product Name </label>
                  <input type = "text" class = "form-control" id = "productName" name = "productName"
                    placeholder = "Enter the product name you want to add"
                  >
                </div>
              </div>
              <div class = "row mb-3">
                <div class = "col">
                  <cfset brandValues = application.productContObj.getBrands()>
                  <label for = "productBrand" class = "form-label">Product Brand </label>
                  <select class = "form-select" id = "productBrand">
                    <cfoutput query = "brandValues" >
                      <option value = "#brandValues.fldBrand_ID#">
                        #brandValues.fldBrandName#  
                      </option>
                    </cfoutput> 
                  </select>
                </div>
              </div>
              <div class = "row mb-3">
                <div class = "col">
                  <label for = "productDescription" class = "form-label">Product Description </label>
                  <input type = "text" class = "form-control" id = "productDescription" name = "productDescription"
                    placeholder = "Description about the product"
                  >
                </div>
              </div>
              <div class = "row mb-3">
                <div class = "col">
                  <label for = "productPrice" class = "form-label">Product Price </label>
                  <input type = "number" class = "form-control" id = "productPrice" name = "productPrice"
                    placeholder = "Enter the price of the product" min = "0"
                  >
                </div>
              </div>
              <div class = "row mb-3">
                <div class = "col">
                  <label for = "productTax" class = "form-label">Product Tax </label>
                  <input type = "number" class = "form-control" id = "productTax" name = "productTax"
                    placeholder = "Enter the product name you want to add" min = "0"
                  >
                </div>
              </div>
              <div class = "row mb-3">
                <div class = "col">
                  <label for = "productImages" class = "form-label">Product Images </label>
                  <input type = "file" class = "form-control" id = "productImages" name = "productImages"
                                multiple
                  >                 
                </div>
              </div>
              <div class = "row mb-3" id = "product-img-container">
                <ul class ='product-image-list' id = "img-list">
                </ul>
              </div>
              <div class = "row mb-3 ">
                <div class = "col categ-add-btns">
                  <button type="button" class="btn btn-secondary close-modal-btn" data-bs-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary" name = "categSubmit" id = "productAddBtn">Add </button>
                  <button type="button" class="btn btn-primary" name = "categSubmit" id = "productEditBtn">Update</button>
                </div>
              </div>                       
            </form>
          </div>       
        </div>
      </div>
    </div>

    <!-- SubCategory Delete Modal -->
    <div class="modal fade" id="productDeleteModal" tabindex="-1" aria-labelledby="productDeleteModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header categDeleteModalHead">
            <h5 class="modal-title" id = "categTitle">Delete Product</h5>
          </div>
          <div class="modal-body">
            Do you want to delete this product ?
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary close-modal-btn" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary delete-items" id = "productDeleteBtn">Delete</button>
          </div>      
        </div>
      </div>
    </div>

    <cfinclude  template = "footer.cfm">
    <script src = "../../assets/js/adminProduct.js"></script>
  </body>
</html>