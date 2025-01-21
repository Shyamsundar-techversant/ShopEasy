
<cfset variables.getCategory = application.cateContObj.getCategory()>
<!---  
<cfset variables.categoryList = valueList(variables.getCategory.fldCategory_ID)>
<cfset a = 67>
<cfset categoryExistCheck = listFind(variables.categoryList, a)>

<cfif NOT categoryExistCheck>
  <cfoutput>
    Haii
  </cfoutput>
</cfif> --->

<cfinclude template = "header.cfm" >
    <section class = "category-section">
      <div class = "container category-container">
        <div class = "card category-card" data-aos="fade-down" data-aos-easing="linear" data-aos-duration="300">
          <div class = "card-head">
            <div class = "cardhead-content">
              <span class = "category-head">Categories</span>
              <span>
                <button type="button" class="category-btn" data-bs-toggle="modal" 
                              data-bs-target="#categoryAddModal" id = "categoryButton"
                >
                  +  
                </button>
              </span> 
            </div>
          </div>
          <div class = "card-body">
            <table class="table">
              <tbody>
                <cfif structKeyExists(variables, "getCategory")>
                  <cfoutput query = "variables.getCategory">
                    <cfset encryptedId = encrypt(
                                            getCategory.fldCategory_ID,
                                            application.encryptionKey,
                                            "AES",
                                            "Hex"
                                          )
                    >
                    <tr class = "table-light">
                      <td>#variables.getCategory.fldCategoryName#</td>
                      <td>
                        <button type = "button" 
                                  class = "categ-alt-btn categoryEditBtn"
                                  data-bs-toggle = "modal"
                                  data-bs-target = "##categoryAddModal"
                                  data-id = "#encryptedId#"
                        >
                          EDIT
                        </button>
                      </td>
                      <td>
                        <button type = "button"
                                class = "categ-alt-btn categoryDeleteBtn"
                                data-bs-toggle = "modal"
                                data-bs-target = "##categoryDeleteModal"
                                data-id = "#encryptedId#"
                        >
                          DELETE
                        </button>
                      </td>
                      <td>
                        <button type = "button"
                                class = "categ-subCateg-btn"
                                data-id = "#encryptedId#"
                                onclick = 
                                "window.location.href = 'adminCategory.cfm?categId=#encryptedId#' "
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

    <!-- Category Add Edit Modal -->
    <div class="modal fade" id="categoryAddModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header categAddModalHead">
            <h5 class="modal-title" id = "categoryTitle">Add Category</h5>
          </div>
          <div class="modal-body">
            <form action = "" class = "categAddForm" method = "post" id = "categoryAddForm">
              <div class = "row mb-3 ">
                <div class = "error">

                </div>
              </div>
              <div class = "row mb-3">
                <div class = "col">
                  <label for = "categoryName" class = "form-label">Enter category Name </label>
                  <input type = "text" class = "form-control" id = "categoryName" name = "categoryName"
                    placeholder = "Enter the category name you want to add"
                  >
                </div>
              </div>
              <div class = "row mb-3 ">
                <div class = "col categ-add-btns">
                  <button type="button" class="btn btn-secondary close-modal-btn" data-bs-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary" name = "categSubmit" id = "categoryAddBtn">Add</button>
                  <button type="button" class="btn btn-primary" name = "categSubmit" id = "categoryEditButton">Update</button>
                </div>
              </div>                     
           </form>
          </div>       
        </div>
      </div>
    </div>
    <!-- Category Delete Modal -->
    <div class="modal fade" id="categoryDeleteModal" tabindex="-1" aria-labelledby="categoryDeleteModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header categDeleteModalHead">
            <h5 class="modal-title" id = "categTitle">Delete Category</h5>
          </div>
          <div class="modal-body">
            Do you want to delete this category ?
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary close-modal-btn" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary delete-items" id = "categoryDeleteBtn">Delete</button>
          </div>      
        </div>
      </div>
    </div>

    <cfinclude  template = "footer.cfm">
    <script src = "../../assets/js/admin.js"></script>
  </body>
</html>