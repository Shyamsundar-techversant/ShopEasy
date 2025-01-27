
<cfinclude  template="header.cfm">

<!--- CART SECTION --->
    <section class = "cart-section">
        <h5 class = "product-section-head">
            Cart
        </h5>
        <div class = "container cart-container">
            <div class = "cart-product-add-section">        
                <cfif structKeyExists(variables, 'totalCartProducts')>
                    <cfoutput query = "variables.totalCartProducts">
                        <div class = "row cart-products">
                            <div class = "col-md-2">
                                <img src = "" alt = "Product Image">
                            </div>
                            <div class = "col-md-3 cart-prod-details">
                                <div class = 'cart-prod-name'>#variables.totalCartProducts.fldProductName#</div>
                                <div class = "cart-prod-brand-name">
                                    #variables.totalCartProducts.fldBrandName#
                                </div>
                                <div class = "cart-prod-qty p-3">
                                    <div class = "prod-qty-btns">
                                        <button class = "prod-qty-btn">-</button>
                                            <span>Quantity</span>
                                        <button class = "prod-qty-btn">+</button>
                                    </div>
                                </div>
                            </div>
                            <div class = "col-md-3 cart-prod-details">
                                <div class = "total-prod-price">$#variables.totalCartProducts.fldPrice+(variables.totalCartProducts.fldPrice*variables.totalCartProducts.fldTax/100)#</div>
                                <div class = "cart-prod-tax">Tax : $#variables.totalCartProducts.fldTax# %</div>
                                <div class = "actual-price">Actual Price : #variables.totalCartProducts.fldPrice#</div>
                            </div>
                        </div> 
                    </cfoutput>
                </cfif>
            </div>
            <div class = "cart-total-price">

            </div>
        </div>
    </section>

<cfinclude  template="footer.cfm">
