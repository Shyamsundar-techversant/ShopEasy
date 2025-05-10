<cfif structKeyExists(url, 'productId')>
    <cfset variables.productId = application.cateContObj.decryptionFunction(url.productId)>
    <cfif variables.productId>
        <cfset variables.addProductToCartResult = application.cartContObj.addProductToCart(
            productId = variables.productId
        )>
    <cfelse>
        <div class="alert alert-danger alertInfo" role = "alert">
            No product Exist.
        </div>        
    </cfif>
</cfif>
<cfif structKeyExists(form,'paymentDetailsForm')>
    <cfoutput>
        <cflocation  url = "paymentDetails.cfm?addressId=#form.selectedAddress#" addToken = "false">
    </cfoutput>
</cfif>
<cfinclude  template="header.cfm">
    <cfif NOT structKeyExists(variables, 'totalCartProducts')>
        <cfoutput>
            <div class="alert alert-danger alertInfo" role = "alert">
                Cart is empty.
            </div>
        </cfoutput>
    </cfif>
<!--- CART SECTION --->
    <section class = "cart-section">
        <div class = "container">
            <h5 class = "product-section-head">
                Cart
            </h5>
        </div>
        <div class = "container cart-container">
            <div class = "cart-product-add-section"> 
                <cfif structKeyExists(variables, 'totalCartProducts')>
                    <cfoutput query = "variables.totalCartProducts">
                        <cfset local.encryptedProductId = application.cateContObj.encryptionFunction(
                            variables.totalCartProducts.fldProductId
                        )>                           
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
                                    #variables.totalCartProducts.fldQuantity#
                                </div>
                            </div>
                            <div class = "col-md-3 cart-prod-details">
                                <div class = "total-prod-price">
                                    $#variables.totalCartProducts.totalPrice#
                                </div>  
                                <div class = "cart-prod-tax">Tax : #variables.totalCartProducts.fldTax# %</div>
                                <div class = "actual-price">Actual Price : $#variables.totalCartProducts.fldPrice#</div>
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
            <cfif structKeyExists(variables, 'totalCartProducts') AND variables.totalCartProducts.recordCount GT 0>
                <div class = "cart-total-price">
                    <cfoutput>
                        <div class = "totl-price-details">
                            <h6 class = "cart-product-total">Actual Price : <span class = "total-value">$#variables.totalCartProducts.entireCartActualPrice#</span></h6>
                            <h6 class = "cart-product-total">Total Tax : <span class = "total-value">$#variables.totalCartProducts.entireCartTax# </span></h6>
                            <h6 class = "cart-product-total">Total Price : <span class = "total-value">$#variables.totalCartProducts.entireCartTotal#</span></h6>
                        </div>
                    </cfoutput>
                    <button 
                        class = "bought-together-btn"
                        data-bs-toggle = "modal"
                        data-bs-target = "#addressSelectModal"
                    >
                        Bought Together
                    </button>
            </cfif>
            </div>
        </div>
    </section>
    <!--- PRODUCT REMOVAL MODAL     --->
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
<!--- ADDRESS SELECT MODAL --->
<cfif structKeyExists(session,'userId')>
    <div 
        class="modal fade" 
        id="addressSelectModal" 
        tabindex="-1" 
        aria-labelledby="addressSelectModalLabel" 
        aria-hidden="true"
        data-bs-backdrop="static" 
        data-bs-keyboard="false"
    >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" >Select Address</h5>
                    <button type="button" class="btn-close close-select-address-modal" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id = "address-select-container">
                    <form method = "post" name = "paymentForm">
                        <cfset variables.existingAddresses = application.cartContObj.getAddresses()>
                        <cfif structKeyExists(variables,'existingAddresses')>
                            <cfset index = 1>
                            <cfoutput query = "variables.existingAddresses">
                                <cfset encryptedAddressId = application.cateContObj.encryptionFunction(
                                    variables.existingAddresses.fldAddress_ID
                                )>
                                <div class = "row user-addresses mb-3">
                                    <div class = "col user-saved-address">
                                        <input 
                                            type = "radio" 
                                            id = "radio#index#" 
                                            name = "selectedAddress" 
                                            value="#encryptedAddressId #" 
                                            <cfif index EQ 1>checked</cfif>
                                        >
                                        <label for="radio#index#">
                                            <span class = "pb-2 order-user-name">#variables.existingAddresses.fldFirstName&variables.existingAddresses.fldLastName#</span><br>
                                            <span class = "order-user-address">#variables.existingAddresses.fldPhoneNumber#</span><br>
                                            <span class = "order-user-address">#variables.existingAddresses.fldAddressLine1#</span>,
                                            <span class = "order-user-address">#variables.existingAddresses.fldAddressLine2#</span>,
                                            <span class = "order-user-address">#variables.existingAddresses.fldCity#</span>,
                                            <span class = "order-user-address">#variables.existingAddresses.fldPincode#</span>,
                                            <span class = "order-user-address">#variables.existingAddresses.fldState#</span>
                                        </label>
                                    </div>
                                </div>
                                <cfset index = index +1>
                            </cfoutput>                       
                        </cfif>
                        <button type="button" class="btn modal-close-btn" data-bs-dismiss="modal" class = "close-select-address-modal">Close</button>
                        <button 
                            type="button" 
                            class="btn address-add-button select-address-button"
                            data-bs-toggle="modal" 
                            data-bs-target="#addressAddModal"
                        >
                            Add Address
                        </button>
                        <button 
                            type="submit" 
                            class="btn address-add-button"
                            name = "paymentDetailsForm"
                        >
                            Payment Details
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div> 
    <!--- ADDRESS ADD MODAL --->
    <div 
        class="modal fade" 
        id="addressAddModal" 
        tabindex="-1" 
        aria-labelledby="addressAddModalLabel" 
        aria-hidden="true"
    >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addressAddModalLabel">Add Address</h5>
                    <button type="button" class="btn-close add-address-modal-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class = "address-add-form" method = "post" id = "addressAddForm">
                        <div class = "row">
                            <div class = "form-error" id = "address-validation-error">

                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "firstname" class = "form-label">Firstname</label> 
                                <input 
                                    type = "text" 
                                    class = "form-control" 
                                    name = "firstName" 
                                    id = "firstname"
                                    placeholder = "Enter first name"
                                >
                            </div>
                        </div>                    
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "lastname" class = "form-label">Lastname</label> 
                                <input 
                                    type = "text" 
                                    class = "form-control" 
                                    name = "lastname" 
                                    id = "lastname"
                                    placeholder = "Enter last name"
                                >
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "addressLine1" class = "form-label">Address Line 1</label> 
                                <input 
                                    type = "text" 
                                    class = "form-control" 
                                    name = "addresLine_1" 
                                    id = "addressLine1"
                                    placeholder = "Enter Address Line 1"
                                >
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "addressLine2" class = "form-label">Address Line 2</label> 
                                <input 
                                    type = "text" 
                                    class = "form-control"
                                     name = "addresLine_2" 
                                     id = "addressLine2"
                                    placeholder = "Enter Address Line 2"
                                >
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "city" class = "form-label">City</label> 
                                <input 
                                    type = "text"
                                     class = "form-control" 
                                     name = "city" 
                                     id = "city"
                                    placeholder = "Enter city name"
                                >   
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "state" class = "form-label">State</label> 
                                <input 
                                    type = "text" 
                                    class = "form-control" 
                                    name = "state" 
                                    id = "state"
                                    placeholder = "Enter state name"
                                >
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "pincode" class = "form-label">Pincode</label> 
                                <input 
                                    type = "text" 
                                    class = "form-control" 
                                    name = "pincode" 
                                    id = "pincode"
                                    placeholder = "Enter your pincode"
                                >
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "phone" class = "form-label">Phone</label> 
                                <input 
                                    type = "text" 
                                    class = "form-control"
                                    name = "phone" 
                                    id = "phone"
                                    placeholder = "Enter your phone"
                                >
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <button type="button" class="btn modal-close-btn add-address-modal-close" data-bs-dismiss="modal">Close</button>
                                <button 
                                    type="button" 
                                    class="btn address-add-button" 
                                    name = "addressSubmit"
                                    id = "addAddressBtn"
                                >
                                    ADD
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</cfif>
<cfinclude  template="footer.cfm">
