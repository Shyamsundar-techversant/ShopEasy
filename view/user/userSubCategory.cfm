
<cfif structKeyExists(url,"subCategoryID")>

    <cfset variables.getProducts = application.productContObj.getProductWithDefaultImage(
                                                                                            subCategoryID = url.subCategoryID
                                                                                        )
    >

</cfif>
<cfinclude  template = "header.cfm">

    <section class = "subcategory-section">
        <div class = "container ">
            <div class = "row">              
                <cfif structKeyExists(variables, "getProducts")>
                    <cfoutput query = "variables.getProducts">
                        <cfset encryptedProductId = encrypt(
                                                                variables.getProducts.idProduct,
                                                                application.encryptionKey,
                                                                "AES",
                                                                "Hex"
                                                            )
                        >
                        <div class = "col-md-3" data-aos="zoom-in-down">
                            <div class = "product-card">
                                <a class = "product-default-img" href = "userProduct.cfm?productId=#encryptedProductId#">
                                    <img src = "../../uploadImg/#variables.getProducts.fldImageFileName#" alt = "ProductImage" 
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
        
<cfinclude  template = "footer.cfm">