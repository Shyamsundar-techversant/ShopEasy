
<cfif structKeyExists(url, 'productId')>
    <cfset variables.addProductToCartResult = application.cartContObj.addProductToCart(
        productId = url.productId,
        userId = session.userId
    )>
    
</cfif>

<cfinclude  template="header.cfm">
<!--- CART SECTION --->
    <section class = "cart-section">
        <div class = "container">
            <h5 class = "product-section-head">
                Cart
            </h5>
        </div>
        <div class = "container cart-container">
            <div class = "cart-product-add-section"> 
                <cfset variables.totalActualPrice = 0>
                <cfset variables.totalTax = 0>    
                <cfset variables.totalCartProductsPrice = 0>   
                <cfif structKeyExists(variables, 'totalCartProducts')>
                    <cfoutput query = "variables.totalCartProducts">
                        <cfset local.encryptedProductId = encrypt(
                            variables.totalCartProducts.fldProductId,
                            application.encryptionKey,
                            "AES",
                            "Hex"
                        )>
                        <cfset variables.totalActualPrice = variables.totalActualPrice + variables.totalCartProducts.fldQuantity*(variables.totalCartProducts.fldPrice)>
                        <cfset variables.totalTax = (variables.totalTax +  variables.totalCartProducts.fldQuantity*(variables.totalCartProducts.fldPrice*variables.totalCartProducts.fldTax))/100>                            
                        <div class = "row cart-products">
                            <div class = "col-md-2 p-2">
                                <img src = "/uploadImg/#variables.totalCartProducts.fldImageFileName#" alt = "Product Image" class = "cart-product-image">
                            </div>
                            <div class = "col-md-3 cart-prod-details">
                                <div class = 'cart-prod-name'>#variables.totalCartProducts.fldProductName#</div>
                                <div class = "cart-prod-brand-name">
                                    #variables.totalCartProducts.fldBrandName#
                                </div>
                                <div class = "cart-prod-qty">
                                    <div class = "prod-qty-btns">
                                        <button class = "prod-qty-btn qty-decrease" data-id = "#local.encryptedProductId#">-</button>
                                            <span>Quantity</span>
                                        <button class = "prod-qty-btn qty-increase" data-id = "#local.encryptedProductId#">+</button>
                                    </div>
                                </div>
                                <div class = "card-product-count">
                                    <input type = "text" class = "card-product-count-input" value = "#variables.totalCartProducts.fldQuantity#">
                                </div>
                            </div>
                            <div class = "col-md-3 cart-prod-details">
                                <div class = "total-prod-price">
                                    $#variables.totalCartProducts.fldQuantity*(variables.totalCartProducts.fldPrice+(variables.totalCartProducts.fldPrice*variables.totalCartProducts.fldTax/100))#
                                </div>
                                <cfset variables.totalCartProductsPrice = variables.totalCartProductsPrice + variables.totalCartProducts.fldQuantity*(variables.totalCartProducts.fldPrice+(variables.totalCartProducts.fldPrice*variables.totalCartProducts.fldTax/100))>  
                                <div class = "cart-prod-tax">Tax : $#variables.totalCartProducts.fldTax# %</div>
                                <div class = "actual-price">Actual Price : #variables.totalCartProducts.fldPrice#</div>
                                <button 
                                    class = "remove-from-cart-btn" 
                                    data-id = "#local.encryptedProductId#"
                                    data-bs-toggle = "modal"
                                    data-bs-target = "##productRemoveModal"
                                >
                                    Remove
                                </button>
                            </div>
                        </div> 
                    </cfoutput>
                </cfif>
            </div>
            <div class = "cart-total-price">
                <cfoutput>
                    <div class = "totl-price-details">
                        <h6>Actual Price : $#variables.totalActualPrice# <br></h6>
                        <h6>Total Tax : $#variables.totalTax# <br></h6>
                        <h6>Total Price : $#variables.totalCartProductsPrice#</h6>
                    </div>
                </cfoutput>
                <button class = "bought-together-btn">Bought Together</button>
            </div>
        </div>
    </section>
    <div class="modal fade" id="productRemoveModal" tabindex="-1" aria-labelledby="productRemoveModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header productRemoveModalHead">
            <h5 class="modal-title" id = "productRemoveModalTitle">Remove Product</h5>
          </div>
          <div class="modal-body product-remove-modal-body">
            Do you want to remove this product from cart ?
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary modal-close-btn " data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary delete-items" id = "productRemoveButton">Remove</button>
          </div>      
        </div>
      </div>
    </div>
<cfinclude  template="footer.cfm">
