<cfset variables.minPrice = "">
<cfset variables.maxPrice = "">
<cfset variables.sort = "">
<cfif structKeyExists(url, "minPrice") AND isNumeric(url.minPrice)>
    <cfset variables.minPrice = url.minPrice>
</cfif>
<cfif structKeyExists(url, "maxPrice") AND isNumeric(url.maxPrice)>
    <cfset variables.maxPrice = url.maxPrice>
</cfif>
<cfif structKeyExists(url, "sort") AND isNumeric(url.sort) AND listFind("1,2", url.sort)>
    <cfset variables.sort = url.sort>
</cfif>
<cfif structKeyExists(url, 'subCategoryID')>
    <cfset variables.subCategoryID = application.cateContObj.decryptionFunction(url.subCategoryID)>
    <cfif variables.subCategoryID>
        <cfset variables.getProducts = application.productContObj.getProductsDetails(
            minPrice = variables.minPrice,
            maxPrice = variables.maxPrice,
            sort = variables.sort,
            subCategoryID = variables.subCategoryID
        )> 
    <cfelse>
        <div class="alert alert-danger alertInfo" role="alert">
            NO product exist
        </div>
    </cfif>
<cfelse>
    <div class="alert alert-danger alertInfo" role="alert">
        NO product exist
    </div>
</cfif>


<cfinclude  template = "header.cfm">
    <section class = "subcategory-section">
        <div class = "container">
            <div class = "row">            
                <div class = "filter p-4">   
                    <cfoutput>                     
                        <button 
                            class = "filter-btn" 
                            onclick ="window.location.href='userSubCategory.cfm?subCategoryID=#url.subCategoryID#&sort=1<cfif structKeyExists(url,'minPrice') AND structKeyExists(url,'maxPrice')>&minPrice=#url.minPrice#&maxPrice=#url.maxPrice#</cfif>'"                     
                        >                      
                            High To Low
                        </button>                    
                        <button class = "filter-btn"
                            onclick = "window.location.href='userSubCategory.cfm?subCategoryID=#url.subCategoryID#&sort=2<cfif structKeyExists(url,'minPrice') AND structKeyExists(url,'maxPrice')>&minPrice=#url.minPrice#&maxPrice=#url.maxPrice#</cfif>'"
                        >
                            Low To High
                        </button>
                        <button type="button" class="btn filter-btn" data-bs-toggle="modal" 
                            data-bs-target="##filterModal"
                        >
                            Filter
                        </button>
                    </cfoutput>
                </div>
                <cfif structKeyExists(variables, "getProducts") AND isQuery(variables.getProducts)>  
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
                <cfelse>
                    <div class="alert alert-danger alertInfo" role="alert">
                        NO product exist
                    </div> 
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
                        <cfoutput>
                            <form class = "filter-form" method = "get" action = "userSubCategory.cfm">
                                <div class = "row mb-3">
                                    <div class ="col">
                                        <input type = "hidden" name = "subCategoryID" value = "#url.subCategoryID#">
                                        <input type = "text" class = "form-control" placeholder = "MIN"
                                                id = "min-price" name = "minPrice" value = "#variables.minPrice#"
                                        >
                                        <cfif structKeyExists(url, 'sort')>
                                            <cfif url.sort EQ 1>
                                                <input type = "hidden" name = "sort" value = "1">
                                            <cfelseif url.sort EQ 2>
                                                <input type = "hidden" name = "sort" value = "2">
                                            </cfif>                                           
                                        </cfif>
                                    </div>
                                </div>
                                <div class = "row mb-3">
                                    <div class ="col">
                                        <input type = "text" class = "form-control" placeholder = "MAX"
                                                id = "max-price" name = "maxPrice"  value = "#variables.maxPrice#"
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
                                        <button type="submit" class="filter-btn apply-filter">
                                            Apply
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </cfoutput>
                    </div>  
                </div>
            </div>
        </div>
    </div>
<cfinclude  template = "footer.cfm">
