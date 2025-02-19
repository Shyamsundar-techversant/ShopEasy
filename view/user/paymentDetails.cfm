<cfif structKeyExists(url, 'addressId') AND structKeyExists(url, 'productId')>
    <cfset variables.selectedAddress = application.cartContObj.getAddresses(
        addressId = url.addressId
    )>
    <cfset variables.selectedProduct = application.productContObj.getProductWithDefaultImage(
        productId = url.productId
    )>
<cfelseif structKeyExists(url,'addressId') AND NOT structKeyExists(url, 'productId')>
    <cfset variables.selectedAddress = application.cartContObj.getAddresses(
        addressId = url.addressId
    )>
</cfif>
<cfinclude  template="header.cfm">
    <section class = "product-section">
        <div class = "container order-summary-container">
            <div class = "order-summary-card">
                <div class = "summary-card-title pt-2">
                    <h4 class = "card-title">Order Summary</h4>
                </div>
                <cfoutput>
                    <div class = "summary-card-body">
                        <div class = "order-address-summary p-2" data-id = "#url.addressId#">
                            <h6 class = "select-address-title">Selected Address</h6>
                            <cfif structKeyExists(variables, 'selectedAddress') AND variables.selectedAddress.recordCount GT 0>
                                <span class = "pb-2 order-user-name">#variables.selectedAddress.fldFirstName&variables.selectedAddress.fldLastName#</span><br>
                                <span class = "order-user-address">#variables.selectedAddress.fldPhoneNumber#</span><br>
                                <span class = "order-user-address">#variables.selectedAddress.fldAddressLine1#</span>,
                                <span class = "order-user-address">#variables.selectedAddress.fldAddressLine2#</span>,
                                <span class = "order-user-address">#variables.selectedAddress.fldCity#</span>,
                                <span class = "order-user-address">#variables.selectedAddress.fldPincode#</span>,
                                <span class = "order-user-address">#variables.selectedAddress.fldState#</span>
                            <cfelse>
                                <div class="alert alert-danger alertInfo" role="alert">
                                    No Address Exists.
                                </div>                             
                            </cfif>
                        </div>
                        <div class = "order-product-summary p-2">
                            <h6 class = "pb-1 product-details-title">Product Details</h6>
                            <cfif structKeyExists(variables, 'selectedProduct') AND isQuery(variables.selectedProduct)>
                                <cfloop query = "variables.selectedProduct">
                                    <div class = "row selected-order-product" data-id = "#url.productId#">
                                        <div class = "order-product-img">
                                            <img 
                                                src = "/uploadImg/#variables.selectedProduct.fldImageFileName#" 
                                                alt = "prod-img" class = "order-product-image"
                                            >
                                        </div>
                                        <div class = "order-product-details">
                                            <div class = "product-details-content">
                                                <span class = "order-product-name">#variables.selectedProduct.fldProductName#</span>
                                                <span class = "order-product-brand-name">#variables.selectedProduct.fldbrandName#</span>
                                                <span class = "order-product-price">Actual Price :<span class = "order-product-price-value actual-order-price p-1">$#variables.selectedProduct.fldPrice#</span></span>
                                                <span class = "order-product-tax">Tax :<span class = "p-1 actual-order-tax">#variables.selectedProduct.fldTax#</span></span>
                                                <span class = "order-product-pay-price">Payable amount : 
                                                    <span class = "order-product-pay-price-value">$</span>
                                                    <span class = "payable-order-price order-product-pay-price-value">
                                                        #(variables.selectedProduct.fldPrice)+
                                                        (variables.selectedProduct.fldPrice)*(variables.selectedProduct.fldTax/100)#
                                                    </span>
                                                </span>
                                            </div>
                                            <div class = "order-product-qty">
                                                <button class = "prod-qty-btn qty-remove-btn" data-id = "#url.productId#">-</button>
                                                <span><input type = "text" class = "form-control order-product-quantity" id="orderQuantity" value = "1"></span>
                                                <button class = "prod-qty-btn qty-add-btn" data-id = "#url.productId#">+</button>
                                            </div>
                                        </div>
                                    </div>
                                </cfloop>
                                <div class = "pt-3 d-flex align-items-end justify-content-end">
                                    <button 
                                        class = "p-2 order-place-btn place-order-btn"
                                        data-bs-toggle="modal" 
                                        data-bs-target="##orderPlaceModal"
                                    >
                                        Place Order
                                    </button>
                                </div>
                            <cfelseif structKeyExists(variables, 'selectedProduct') AND NOT isQuery(variables.selectedProduct)>
                                <div class="alert alert-danger alertInfo" role="alert">
                                    No Product Exists.
                                </div>                          
                            <cfelse>
                                <cfloop query = "variables.totalCartProducts">
                                    <div class = "row selected-order-product mb-2 p-1">
                                        <div class = "order-product-img">
                                            <img 
                                                src = "/uploadImg/#variables.totalCartProducts.fldImageFileName#" 
                                                alt = "prod-img" class = "order-product-image"
                                            >
                                        </div>
                                        <div class = "order-product-details">
                                            <div class = "product-details-content">
                                                <span>#variables.totalCartProducts.fldProductName#</span>
                                                <span>#variables.totalCartProducts.fldbrandName#</span>
                                                <span>Actual Price :<span class = "">#variables.totalCartProducts.fldPrice#</span></span>
                                                <span>Tax :<span class = "">#variables.totalCartProducts.fldTax#</span></span>
                                                <span>Payable amount : 
                                                    <span class = "">
                                                        #(variables.totalCartProducts.fldPrice)+
                                                        (variables.totalCartProducts.fldPrice)*(variables.totalCartProducts.fldTax/100)#
                                                    </span>
                                                </span>
                                            </div>
                                            <div class = "order-product-qty">
                                                <span><input type = "text" class = "form-control order-product-quantity" id="orderQuantity" value = "#variables.totalCartProducts.fldQuantity#"></span>
                                            </div>
                                        </div>
                                    </div>
                                </cfloop>
                                <div class = "pt-3 d-flex align-items-end justify-content-end">
                                    <button 
                                        class = "p-2 order-place-btn place-order-btn"
                                        data-bs-toggle="modal" 
                                        data-bs-target="##orderPlaceModal"
                                    >
                                        Place Order
                                    </button>
                                </div>
                            </cfif>
                        </div>
                    </div>
                </cfoutput>
            </div>
        </div>
    </section> 
    <!-- PLACE ORDER MODAL -->
    <div class="modal fade" id="orderPlaceModal" tabindex="-1" aria-labelledby="orderPlaceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header order-place-modal-head">
                    <h5 class="modal-title">Place Order</h5>
                </div>
                <div class="modal-body">
                    <form method = "post" class = "order-place-form" id= "order-place-form">
                        <div class = "row">
                            <div class = "form-error">
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "card-number" class = "form-label">Card Number</label> 
                                <input 
                                    type = "text" 
                                    class = "form-control" 
                                    name = "cardNumber" 
                                    id = "card-number"
                                    placeholder = "000-000-000-00"
                                >
                            </div>
                        </div>                    
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "cvv" class = "form-label">CVV</label> 
                                <input 
                                    type = "text" 
                                    class = "form-control" 
                                    name = "cvv" 
                                    id = "cvv"
                                    placeholder = "000"
                                >
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <button type="button" class="btn btn-secondary modal-close-btn" data-bs-dismiss="modal">Close</button>
                                <button 
                                    type="button"
                                    class = "btn order-place-btn pay-btn"
                                >
                                    Pay
                                </button>
                            </div>
                        </div>
                    </form> 
                </div>      
            </div>
        </div>
    </div>
<cfinclude  template="footer.cfm">