<cfif structKeyExists(url,"productId")>
    <cfset variables.productData = application.productContObj.getProductWithDefaultImage(
                                                                                            productId = url.productId
                                                                                        )
    >
    
</cfif>
<cfinclude  template="header.cfm">

    <section class = "product-section">
        <div class = "container">
            <cfif structKeyExists(variables, "productData") AND NOT structKeyExists(variables, 'searchResult') AND isQuery(variables.productData)>
                <cfoutput query = "variables.productData">
                    <div class = "row justify-content-center align-items-center">
                        <div class = "col d-flex justify-content-center align-items-center">
                            <div class  = "product-container">
                                <div class = "product-page-image-container">
                                    <img src = "/uploadImg/#variables.productData.fldImageFileName#" alt = "productImage" class = "product-page-image" >
                                </div>
                                <div class = "product-page-content">
                                    <div class = "product-name-information">
                                        <span class = "prod-name">#variables.productData.fldProductName#</span>
                                        <span class = "prod-branch-name">#variables.productData.fldBrandName#</span>               
                                    </div>                                       
                                    <h5 class = "product-information">#variables.productData.fldDescription# </h5>
                                    <h5 class = "product-information product-price-info">$#variables.productData.fldPrice#</h5>
                                    <button class = "add-to-cart" onclick = "window.location.href='userCart.cfm?productId=#url.productId#'">
                                        Add to Cart
                                    </button>
                                    <button class = "order-product">Order Now</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfoutput>
            </cfif>
        </div>
    </section>

<cfinclude  template="footer.cfm">