<cfif structKeyExists(url,'categId')>
    <cfset variables.getCategoryById = application.cateContObj.getCategory(
      categoryId = url.categId
    )>
    <cfset variables.getAllSubCategory = application.cateContObj.getSubCategory(
      categoryId = url.categId
    )>
</cfif>
<cfinclude template = "header.cfm" >
    <section class = "category-section">
      <div class = "container category-container">
        <div class = "card category-card" data-aos="fade-down" data-aos-easing="linear" data-aos-duration="300">
          <div class = "card-head">
            <div class = "cardhead-content">
                <span class = "category-head">
                    <cfoutput>#variables.getCategoryById.fldCategoryName#</cfoutput>
                </span>
                <span>
                    <button type="button" class="category-btn" data-bs-toggle="modal" 
                              data-bs-target="#subCategoryAddEditModal" id = "subCategoryButton"                              
                    >
                        +  
                    </button>
                </span> 
            </div>
          </div>
          <div class = "card-body">
            <table class="table">
              <tbody>
                <cfif structKeyExists(variables, "getAllSubCategory")  AND isQuery(variables.getAllSubCategory)>
                  <cfoutput query = "variables.getAllSubCategory">
                    <cfset encryptedId = encrypt(
                      variables.getAllSubCategory.fldSubCategory_ID,
                      application.encryptionKey,
                      "AES",
                      "Hex"
                    )>
                    <tr class = "table-light">
                      <td>#variables.getAllSubCategory.fldSubCategoryName#</td>
                      <td>
                        <button type = "button" 
                                  class = "categ-alt-btn subcategory-edit-btn"
                                  data-bs-toggle = "modal"
                                  data-bs-target = "##subCategoryAddEditModal"
                                  data-id = "#encryptedId#"
                                  data-categId = "#url.categId#"
                        >
                          EDIT
                        </button>
                      </td>
                      <td>
                        <button type = "button"
                                class = "categ-alt-btn subcategory-delete-btn"
                                data-bs-toggle = "modal"
                                data-bs-target = "##categoryDeleteModal"
                                data-id = "#encryptedId#"
                                data-categId = "#url.categId#"
                        >
                          DELETE
                        </button>
                      </td>
                      <td>
                        <button type = "button"
                                class = "categ-subCateg-btn product-btn"
                                data-id = "#encryptedId#"
                                onclick = 
                                "window.location.href = 'adminSubcategory.cfm?subCategID=#encryptedId#&categId=#url.categId#'"
                        >       
                          VIEW
                        </button>             
                      </td>
                    </tr>   
                  </cfoutput>                 
                </cfif>
              </tbody>
            </table>           
          </div>
        </div>
      </div>
    </section>

    <!--Sub Category Add Edit Modal -->
    <div class="modal fade" id="subCategoryAddEditModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header categAddModalHead">
            <h5 class="modal-title" id = "categoryTitle">Add SubCategory</h5>
          </div>
          <div class="modal-body">
            <form action = "" class = "categAddForm" method = "post" id = "categoryAddForm">
              <div class = "row mb-3 ">
                <div class = "error">

                </div>
              </div>
              <div class = "row mb-3">
                <div class = "col">
                  <cfset categoryValues = application.cateContObj.getCategory() >
                  <select class = "form-select" id = "categorySelect">
                    <cfoutput query = "categoryValues" >
                      <cfset encryptCategID = encrypt(
                        categoryValues.fldCategory_ID,
                        application.encryptionKey,
                        "AES",
                        "Hex"
                      )>
                      <option value = "#encryptCategID#"
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
                  <label for = "subCategName" class = "form-label">Enter Subcategory Name </label>
                  <input type = "text" class = "form-control" id = "subCategName" name = "subCategName"
                    placeholder = "Enter the subcategory name you want to add"
                  >
                </div>
              </div>

              <div class = "row mb-3 ">
                <div class = "col categ-add-btns">
                  <button type="button" class="btn btn-secondary close-modal-btn" data-bs-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary" name = "categSubmit" id = "subCategoryAddButton">Add </button>
                  <button type="button" class="btn btn-primary" name = "categSubmit" id = "subCategoryEditButton">Update</button>
                </div>
              </div>                         
            </form>
          </div>       
        </div>
      </div>
    </div>

    <!-- SubCategory Delete Modal -->
    <div class="modal fade" id="categoryDeleteModal" tabindex="-1" aria-labelledby="categoryDeleteModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header categDeleteModalHead">
            <h5 class="modal-title" id = "categTitle">Delete SubCategory</h5>
          </div>
          <div class="modal-body">
            Do you want to delete this sub category ?
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary close-modal-btn" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary delete-items" id = "subCategoryDeleteBtn">Delete</button>
          </div>      
        </div>
      </div>
    </div>
    <cfinclude  template = "footer.cfm">
    <script src = "../../assets/js/admin.js"></script>
  </body>
</html>