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

<!DOCTYPE html>
<html lang = "en">
  <head>
    <meta charset = "UTF-8" />
    <meta name = "viewport" content= "width = device-width, initial-scale = 1.0" />
    <title>ShopEasy</title>
    <link rel = "stylesheet" href = "../../assets/css/style.css" />
    <link rel = "stylesheet" href = "../../assets/css/bootstrap.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" 
          integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" 
          crossorigin="anonymous" referrerpolicy="no-referrer"
    />
  </head>
  <body>

    <!-- Header -->
    <section class = "header-section">
      <header class = "header">
        <div class = "container">
          <div class = "header-content">
            <div class = "brand-name">ShopEasy</div>
            <div></div>
          </div>
        </div>
      </header>
    </section>

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



    <script src = "../../assets/js/bootstrap.bundle.js"></script>
    <script src = "../../assets/js/jquery-3.7.1.min.js"></script>
    <script src = "../../assets/js/adminProduct.js"></script>
  </body>
</html>