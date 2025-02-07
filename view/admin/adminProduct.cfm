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
                        <div class = "product-details">
                            <div class = "row mb-2">
                                <h6>ProductPrice : $#variables.getProductDataById[arrayLen(variables.getProductDataById)].productPrice#</h6>
                            </div>
                            <div class = "row mb-2">
                                <h6> #variables.getProductDataById[arrayLen(variables.getProductDataById)].productDescription#</h6>
                            </div>
                        </div>
                        <!--- <div >
                            <img src = "../../uploadImg/#variables.getProductImage.fldImageFileName#" alt = "productImg" class = "product-image">
                        </div> --->
                        <div id = "productImageCarousel" class = "carousel slide" data-bs-ride = "carousel">
                            <div class="carousel-indicators">
                                <cfset count = 0>
                                <cfloop query = "variables.getProductImage">
                                    <button type="button" data-bs-target="##productImageCarousel" data-bs-slide-to="#count#" 
                                            <cfif variables.getProductImage.fldDefaultImage EQ 1 >class = "active" </cfif>
                                             aria-current="true" aria-label="Slide #count#"
                                    >
                                    </button>
                                    <cfset count = count +1 >
                                </cfloop>
                            </div>
                            <div class="carousel-inner">
                                <cfloop query = "variables.getProductImage">
                                    <div class="carousel-item product-img-container <cfif variables.getProductImage.fldDefaultImage EQ 1 >active</cfif> ">
                                        <img src="../../uploadImg/#variables.getProductImage.fldImageFileName#" class="d-block product-image" alt="...">
                                    </div>
                                </cfloop>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="##productImageCarousel" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="##productImageCarousel" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
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