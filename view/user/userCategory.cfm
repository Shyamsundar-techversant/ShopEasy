<cfset variables.getSubCategoryData = application.productContObj.getProuductsDetails(
    categoryId = url.categoryId
)>
<cfif NOT isQuery(variables.getSubCategoryData)>
    <div class="alert alert-danger alertInfo" role="alert">
        No Product Exist.
    </div>   
</cfif>
<cfinclude template = "header.cfm">
    <cfif structKeyExists(variables, "getSubCategoryData") AND isQuery(variables.getSubCategoryData)>
        <cfset count = 1>
        <div class = "category-page-title product-section-head"><cfoutput>#variables.getSubCategoryData.fldCategoryName#</cfoutput></div>
        <cfoutput query = "variables.getSubCategoryData" group = "fldSubCategory_ID">
            <cfset encryptedSubCategoryId = encrypt(
                variables.getSubCategoryData.fldSubCategory_ID,
                application.encryptionKey,
                "AES",
                "Hex"
            )>
            <section class = "category-app-section app-section-#count#">            
                <div class = "container category-list-container">
                    <h5 class = "product-section-head">
                        #variables.getSubCategoryData.fldSubCategoryName#
                    </h5>
                    <div class = "row">
                        <cfoutput>
                            <cfset encryptedProductId = encrypt(
                                variables.getSubCategoryData.idProduct,
                                application.encryptionKey,
                                "AES",
                                "Hex"
                            )>
                            <div class = "col-md-3 mb-4" data-aos="zoom-in-down">
                                <div class = "product-card">
                                    <a class = "product-default-img" href = "userProduct.cfm?productId=#encryptedProductId#">
                                        <img 
                                            src = "/uploadImg/#variables.getSubCategoryData.fldImageFileName#" 
                                            alt = "ProductImage" 
                                            class = "product-image-default"
                                        >
                                    </a>
                                    <a class = "product-names" href = "userProduct.cfm?productId=#encryptedProductId#">
                                        #variables.getSubCategoryData.fldProductName#
                                    </a>
                                    <a href = "userProduct.cfm?productId=#encryptedProductId#" class = "product-price">
                                        <h6>$#variables.getSubCategoryData.fldPrice#</h6>
                                    </a>
                                </div>
                            </div>
                        </cfoutput>
                    </div>
                </div>
            </section>
            <cfset count = count+1>
        </cfoutput>
    </cfif>
<cfinclude  template = "footer.cfm">