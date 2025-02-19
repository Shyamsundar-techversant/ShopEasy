<cfif structKeyExists(url,'productId') AND structKeyExists(url, "subCategID")>
    <cfset decryptedProductId = decrypt(
        url.productId,
        application.encryptionKey,
        "AES",
        "Hex"
    )>
    <cfset variables.getProductDataById = application.productContObj.getProduct(
        productId = decryptedProductId,
        subCategoryId = url.subCategID
    )>
</cfif>
<cfinclude template = "header.cfm">
    <section class = "category-section">
        <div class = "container category-container">
            <div class = "card">
                <div class = "naviagate-back">
                    <cfoutput>
                        <button class = "page-back-btn" onclick = "window.location.href='adminSubCategory.cfm?categId=#url.categId#&subCategID=#url.subCategID#'">
                            <i class="fa-solid fa-arrow-left"></i>
                        </button>
                    </cfoutput>
                </div>
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
                        <div id = "productImageCarousel" class = "carousel slide" data-bs-ride = "carousel">
                            <div class="carousel-indicators">
                                <cfset count = 0>
                                <cfloop array = "#variables.getProductDataById#" index = "i" item = "image">
                                    <cfif i LT arrayLen(variables.getProductDataById)>
                                        <button type="button" data-bs-target="##productImageCarousel" data-bs-slide-to="#count#" 
                                                <cfif variables.getProductDataById[i].defaultValue EQ 1 >class = "active" </cfif>
                                                aria-current="true" aria-label="Slide #count#"
                                        >
                                        </button>
                                        <cfset count = count +1 >
                                    </cfif>
                                </cfloop>
                            </div>
                            <div class="carousel-inner">
                                <cfloop array = "#variables.getProductDataById#" index = "i" item = "image">
                                    <cfif i LT arrayLen(variables.getProductDataById)>
                                        <div class="carousel-item product-img-container <cfif variables.getProductDataById[i].defaultValue EQ 1 >active</cfif> ">
                                            <img src="/uploadImg/#variables.getProductDataById[i].imageFile#" class="d-block product-image" alt="...">
                                        </div>
                                    </cfif>
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