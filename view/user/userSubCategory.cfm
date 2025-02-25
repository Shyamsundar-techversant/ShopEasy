<cfif structKeyExists(url, 'subCategoryID')>
    <cfset variables.arguments = {}>
    <cfif structKeyExists(form, 'filterProduct')>
        <cfif structKeyExists(form, 'minPrice') AND structKeyExists(form, 'maxPrice')>         
           <cfset variables.filterFormValidationResult = application.productContObj.validateFilterForm(
                minPrice = form.minPrice,
                maxPrice = form.maxPrice
            )>
            <cfif arrayLen(variables.filterFormValidationResult) GT 0>
                <div class="alert alert-danger alertInfo" role="alert">
                    <cfoutput>
                        <cfloop array = "#variables.filterFormValidationResult#" index = "error">
                            <span>#error#</span><br>
                        </cfloop>
                    </cfoutput>
                </div>  
            <cfelse>
                <cfset variables.arguments = {
                    subCategoryID : url.subCategoryID,
                    minPrice : form.minPrice,
                    maxPrice : form.maxPrice
                }>
            </cfif>
        <cfelse>
            <div class="alert alert-danger alertInfo" role = "alert">
                Required values are missing...
            </div>            
        </cfif>
    <cfelseif structKeyExists(url, 'asc')>
        <cfset variables.arguments = {
            subCategoryID : url.subCategoryID,
            isAscending : 1
        }>
    <cfelseif structKeyExists(url, 'desc')>
        <cfset variables.arguments = {
            subCategoryID : url.subCategoryID,
            isDescending : 1
        }>
    <cfelse>
        <cfset variables.arguments = {
            subCategoryID : url.subCategoryID
        }>  
    </cfif>
    <cfset variables.getProducts = application.productContObj.getProductsDetails(
        argumentCollection = variables.arguments
    )> 
</cfif>
<cfif NOT structKeyExists(variables, 'getProducts') OR NOT isQuery(variables.getProducts)>
    <div class="alert alert-danger alertInfo" role="alert">
        NO product exist
    </div> 
</cfif>
<cfinclude  template = "header.cfm">
    <section class = "subcategory-section">
        <div class = "container ">
            <div class = "row">            
                <div class = "filter p-4">                        
                    <button 
                        class = "filter-btn" 
                        onclick = "window.location.href='userSubCategory.cfm?subCategoryID=<cfoutput>#url.subCategoryID#</cfoutput>&desc=1'"                     
                    >                      
                        High To Low
                    </button>
                    <button class = "filter-btn"
                        onclick = "window.location.href='userSubCategory.cfm?subCategoryID=<cfoutput>#url.subCategoryID#</cfoutput>&asc=1'"
                    >
                        Low To High
                    </button>
                    <button type="button" class="btn filter-btn" data-bs-toggle="modal" 
                        data-bs-target="#filterModal"
                    >
                        Filter
                    </button>
                </div>
                <cfif structKeyExists(variables, "getProducts") AND NOT structKeyExists(variables, 'searchResult')
                    AND isQuery(variables.getProducts)
                >  
                    <div class = "category-page-title product-section-head">
                        <cfoutput>#variables.getProducts.fldSubCategoryName#</cfoutput>
                    </div>                                     
                    <cfoutput query = "variables.getProducts">
                        <cfset encryptedProductId = application.cateContObj.encryptionFunction(
                            variables.getProducts.idProduct
                        )>
                        <div class = "col-md-3 mb-3" data-aos="zoom-in-down">
                            <div class = "product-card">
                                <a class = "product-default-img" href = "userProduct.cfm?productId=#encryptedProductId#">
                                    <img src = "/uploadImg/#variables.getProducts.fldImageFileName#" alt = "ProductImage" 
                                        class = "product-image-default"
                                    >
                                </a>
                                <a class = "product-names" href = "userProduct.cfm?productId=#encryptedProductId#">
                                    #variables.getProducts.fldProductName#
                                </a>
                                <a href = "userProduct.cfm?productId=#encryptedProductId#" class = "product-price">
                                    <h6>$#variables.getProducts.fldPrice#</h6>
                                </a>
                            </div>
                        </div>
                    </cfoutput>
                </cfif>
            </div>
        </div>
    </section>

    <!---  FILTER MODAL    --->
    <div class="modal fade" id="filterModal" tabindex="-1" aria-labelledby="filterModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="filterModalLabel">Modal title</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class = "filter-container">
                        <form class = "filter-form" method = "post">
                            <div class = "row mb-3">
                                <div class ="col">
                                    <input type = "text" class = "form-control" placeholder = "MIN"
                                            id = "min-price" name = "minPrice" value = ""
                                    >
                                </div>
                            </div>
                            <div class = "row mb-3">
                                <div class ="col">
                                    <input type = "text" class = "form-control" placeholder = "MAX"
                                            id = "max-price" name = "maxPrice"  value = ""
                                    >
                                </div>
                            </div>
                            <div class = "row mb-3">
                                <div class ="error">

                                </div>
                            </div>
                            <div class = "row">
                                <div class = "col d-flex gap-2">
                                    <button type="button" class="filter-btn modal-close-btn" data-bs-dismiss="modal">
                                        Close
                                    </button>
                                    <button type="submit" class="filter-btn apply-filter" name = "filterProduct">
                                        Apply
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>  
                </div>
            </div>
        </div>
    </div>
<cfinclude  template = "footer.cfm">
