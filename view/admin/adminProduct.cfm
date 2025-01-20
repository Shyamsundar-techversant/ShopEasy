<cfif structKeyExists(url,'productId') AND structKeyExists(url, "subCategID")>
    <cfset decryptedProductId = decrypt(
                                            url.productId,
                                            application.encryptionKey,
                                            "AES",
                                            "Hex"
                                        )
    >
    <cfset variables.getProductDataById = application.productContObj.getProduct(
                                                                                    productId = decryptedProductId,
                                                                                    subCategoryId = url.subCategID
                                                                                )
    >
    <cfset variables.getProductImage = application.productContObj.getDefaultProductImage(
                                                                                            productId = decryptedProductId 
                                                                                        )
    >
</cfif>

<cfinclude template = "header.cfm" >
    <section class = "category-section">
        <div class = "container category-container">
            <div class = "card">
                <cfoutput>
                    <div class = "card-head">                    
                        <div class = "cardhead-content">
                            <h3 class = "product-head">
                                #variables.getProductDataById[arrayLen(variables.getProductDataById)].productName#
                            </h3>
                        </div>
                    </div>
                    <div class = "card-body product-details-container">
                        <div class = "product-detials">
                            <div class = "row mb-2">
                                <h6>ProductPrice : $#variables.getProductDataById[arrayLen(variables.getProductDataById)].productPrice#</h6>
                            </div>
                            <div class = "row mb-2">
                                <h6> #variables.getProductDataById[arrayLen(variables.getProductDataById)].productDescription#</h6>
                            </div>
                        </div>
                        <div >
                            <img src = "../../uploadImg/#variables.getProductImage.fldImageFileName#" alt = "productImg" class = "product-image">
                        </div>
                    </div>
                </cfoutput>
            </div>
        </div>
    </section>

    <cfinclude  template = "footer.cfm">
    <script src = "../../assets/js/adminProduct.js"></script>
  </body>
</html>