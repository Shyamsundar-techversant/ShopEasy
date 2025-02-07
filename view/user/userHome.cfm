<!--- <cfset variables.getCategory = application.cateContObj.getCategory()> --->

<cfinclude template = "header.cfm">
    <!---   BANNER-SECTION   --->
    <section class = "banner-section">
        <div class = "container banner-container">
            <div class = "banner-content">
                <h5 class = "online-shopping">Shop Online</h5>
                <h2 class = "product-qlty">Discover New Collection</h2>
                <h6 class = "info-head" data-text = "Your Wishlist, Now on Sale – Don’t Wait!">
                    Your Wishlist, Now on Sale – Don’t Wait!
                </h6>
            </div>
            <div class = "banner-image">
                <img src = "../../assets/images/bannerimg1" alt = "Banner Image"
                    class = "banner-img"
                >
            </div>
        </div>
    </section>
    <!---  RANDOM PRODUCTS    --->
    <section class = "random-product-section">
        <div class = "container random-products-container">
            <h5 class = "product-section-head pb-2">Random Products</h5>
            <div class = "row">
                <cfset randomProducts = application.productContObj.getRandomProducts()>
                <cfoutput query = "randomProducts">
                    <cfset encryptedProductId = encrypt(
                                                            randomProducts.idProduct,
                                                            application.encryptionKey,
                                                            "AES",
                                                            "Hex"
                                                        )
                    >
                    <div class = "col-md-3" data-aos="zoom-in-down">
                        <div class = "product-card">
                            <a class = "product-default-img" href = "userProduct.cfm?productId=#encryptedProductId#">
                                <img src = "../../uploadImg/#randomProducts.fldImageFileName#" alt = "ProductImage" 
                                    class = "product-image-default"
                                >
                            </a>
                            <a class = "product-names" href = "userProduct.cfm?productId=#encryptedProductId#">
                                #randomProducts.fldProductName#
                            </a>
                            <a href = "userProduct.cfm?productId=#encryptedProductId#" class = "product-price">
                                <h6>$#randomProducts.fldPrice#</h6>
                            </a>
                        </div>
                    </div>
                </cfoutput>
            </div>
        </div>
    </section>
<cfinclude template = "footer.cfm">



