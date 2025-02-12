<cfif structKeyExists(url,"categoryID")>
    <cfset variables.getSubCategoryByCategoryId = application.cateContObj.getSubCategory(
        categoryId = url.categoryID 
    )>
</cfif>
<cfinclude template = "header.cfm">
    <cfif structKeyExists(variables, "getSubCategoryByCategoryId")>
        <cfset count = 1>
        <cfoutput query = "variables.getSubCategoryByCategoryId">
            <cfset encryptedSubCategoryId = encrypt(
                variables.getSubCategoryByCategoryId.fldSubCategory_ID,
                application.encryptionKey,
                "AES",
                "Hex"
            )>
            <section class = "category-app-section app-section-#count#">            
                <div class = "container category-list-container">
                    <h5 class = "product-section-head">
                        #variables.getSubCategoryByCategoryId.fldSubCategoryName#
                    </h5>
                    <div class = "row">
                        <cfset variables.getProductsBySubCategoryId = application.productContObj.getProductWithDefaultImage(
                            subCategoryID = encryptedSubCategoryId
                        )>
                        <cfif structKeyExists(variables, 'getProductsBySubCategoryId')>
                            <cfloop query = "variables.getProductsBySubCategoryId" >
                                <cfset encryptedProductId = encrypt(
                                    variables.getProductsBySubCategoryId.idProduct,
                                    application.encryptionKey,
                                    "AES",
                                    "Hex"
                                )>
                                <div class = "col-md-3 mb-4" data-aos="zoom-in-down">
                                    <div class = "product-card">
                                        <a class = "product-default-img" href = "userProduct.cfm?productId=#encryptedProductId#">
                                            <img 
                                                src = "/uploadImg/#variables.getProductsBySubCategoryId.fldImageFileName#" 
                                                alt = "ProductImage" 
                                                class = "product-image-default"
                                            >
                                        </a>
                                        <a class = "product-names" href = "userProduct.cfm?productId=#encryptedProductId#">
                                            #variables.getProductsBySubCategoryId.fldProductName#
                                        </a>
                                        <a href = "userProduct.cfm?productId=#encryptedProductId#" class = "product-price">
                                            <h6>$#variables.getProductsBySubCategoryId.fldPrice#</h6>
                                        </a>
                                    </div>
                                </div>
                            </cfloop>
                        </cfif>
                    </div>
                </div>
            </section>
            <cfset count = count+1>
        </cfoutput>
    </cfif>
<cfinclude  template = "footer.cfm">