
<cfif structKeyExists(url,"subCategoryID")>
    <cfif structKeyExists(form, "filterProduct")>
        <cfset variables.getProducts = application.productContObj.getFilteredProduct(
            subCategoryID = url.subCategoryID,
            minPrice = form.minPrice,
            maxPrice = form.maxPrice
        )>
    <cfelseif NOT structKeyExists(url, "order")>
        <cfset variables.getProducts = application.productContObj.getProductWithDefaultImage(
            subCategoryID = url.subCategoryID
        )>
    <cfelseif structKeyExists(url, "order")>
        <cfset variables.getProducts = application.productContObj.getProductWithDefaultImage(
            subCategoryID = url.subCategoryID,
            productOrder = url.order
        )>       
    </cfif>
</cfif>
<cfif NOT isQuery(variables.getProducts)>
    <cfoutput>
        <div class="alert alert-danger alertInfo" role="alert">
            #variables.getProducts#
        </div>
    </cfoutput>
</cfif>
<cfinclude  template = "header.cfm">

    <section class = "subcategory-section">
        <div class = "container ">
            <div class = "row">            
                <cfif structKeyExists(variables, "getProducts") AND NOT structKeyExists(variables, 'searchResult')
                    AND isQuery(variables.getProducts)
                >
                    <div class = "filter p-4">
                        
                        <button 
                            class = "filter-btn" 
                            onclick = "window.location.href='userSubCategory.cfm?subCategoryID=<cfoutput>#url.subCategoryID#</cfoutput>&order=1'"                     
                        >                      
                            High To Low
                        </button>
                        <button class = "filter-btn"
                            onclick = "window.location.href='userSubCategory.cfm?subCategoryID=<cfoutput>#url.subCategoryID#</cfoutput>&order=0'"
                        >
                            Low To High
                        </button>
                        <button type="button" class="btn filter-btn" data-bs-toggle="modal" 
                                data-bs-target="#filterModal"
                        >
                            Filter
                        </button>
                    </div>                                       
                    <cfoutput query = "variables.getProducts">
                        <cfset encryptedProductId = encrypt(
                            variables.getProducts.idProduct,
                            application.encryptionKey,
                            "AES",
                            "Hex"
                        )>
                        <div class = "col-md-3" data-aos="zoom-in-down">
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
                                    <input type = "number" class = "form-control" placeholder = "MIN"
                                            id = "min-price" name = "minPrice" min = "0"
                                    >
                                </div>
                            </div>
                            <div class = "row mb-3">
                                <div class ="col">
                                    <input type = "number" class = "form-control" placeholder = "MAX"
                                            id = "max-price" name = "maxPrice" min = "0"
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
                                    <button type="submit" class="filter-btn" name = "filterProduct">
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
