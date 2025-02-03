<cfif structKeyExists(url,"productId")>
    <cfset variables.productData = application.productContObj.getProductWithDefaultImage(
                                                                                            productId = url.productId
                                                                                        )
    >
<cfelseif structKeyExists(session, 'setOrder') AND structKeyExists(session, 'productId')>
    <cfset variables.productData = application.productContObj.getProductWithDefaultImage(
                                                                                            productId = session.productId
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
                                    <button 
                                        class = "add-to-cart" 
                                        onclick = 
                                            <cfif structKeyExists(url,"productId")>
                                                "window.location.href='userCart.cfm?productId=#url.productId#'"
                                            <cfelseif structKeyExists(session,"productId")>
                                                "window.location.href='userCart.cfm?productId=#session.productId#'"
                                            </cfif>
                                    >
                                        Add to Cart
                                    </button>
                                    <button 
                                        class = "order-product"

                                        <cfif structKeyExists(url,"productId") AND NOT structKeyExists(session, 'userId') >
                                            id = "order-now-btn"
                                            onclick = "window.location.href='userOrder.cfm'"
                                        <cfelse>
                                            id = "order-product-btn"
                                        </cfif>                                       
                                        data-id = 
                                            <cfif structKeyExists(url,"productId") >
                                                "#url.productId#"
                                            <cfelseif structKeyExists(session,"productId")>
                                                "#session.productId#"
                                            </cfif>
                                        <cfif structKeyExists(session, 'userId')>
                                            data-bs-toggle="modal" 
                                            data-bs-target="##addressSelectModal"
                                        </cfif>
                                    >
                                        Order Now
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfoutput>
            </cfif>
        </div>
    </section>

<!--- ADDRESS SELECT MODAL ---> 
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
                <cfset variables.existingAddresses = application.cartContObj.getAddresses()>
                <cfif structKeyExists(variables,'existingAddresses')>
                    <cfset index = 1>
                    <cfoutput query = "variables.existingAddresses">
                        <cfset encryptedAddressId = encrypt(
                            variables.existingAddresses.fldAddress_ID,
                            application.encryptionKey,
                            "AES",
                            "Hex"
                        )>
                        <div class = "row user-addresses">
                            <div class = "col">
                                <input type="radio" id="radio#index#" name="selectedAddress" value="#variables.existingAddresses.fldAddress_ID#" 
                                    <cfif index EQ 1>checked</cfif>
                                >
                                <label for="radio#index#">
                                    <span class = "pb-2">#variables.existingAddresses.fldFirstName&variables.existingAddresses.fldLastName#</span><br>
                                    <span>#variables.existingAddresses.fldPhoneNumber#</span><br>
                                    <span>#variables.existingAddresses.fldAddressLine1#</span>,
                                    <span>#variables.existingAddresses.fldAddressLine2#</span>,
                                    <span>#variables.existingAddresses.fldCity#</span>,
                                    <span>#variables.existingAddresses.fldPincode#</span>,
                                    <span>#variables.existingAddresses.fldState#</span>
                                </label>
                            </div>
                        </div>
                        <cfset index = index +1>
                    </cfoutput>
                </cfif>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn modal-close-btn" data-bs-dismiss="modal" class = "close-select-address-modal">Close</button>
                <button 
                    type="button" 
                    class="btn address-add-button select-address-button"
                    data-bs-toggle="modal" 
                    data-bs-target="##addressAddModal"
                >
                    Add Address
                </button>
                <button type="button" class="btn address-add-button">Payment Details</button>
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
                        <div class = "form-error">

                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "firstname" class = "form-label">Firstname</label> 
                            <input type = "text" class = "form-control" name = "firstName" id = "firstname"
                                placeholder = "Enter first name"
                            >
                        </div>
                    </div>                    
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "lastname" class = "form-label">Lastname</label> 
                            <input type = "text" class = "form-control" name = "lastname" id = "lastname"
                                placeholder = "Enter last name"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "addressLine1" class = "form-label">Address Line 1</label> 
                            <input type = "text" class = "form-control" name = "addresLine_1" id = "addressLine1"
                                placeholder = "Enter Address Line 1"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "addressLine2" class = "form-label">Address Line 2</label> 
                            <input type = "text" class = "form-control" name = "addresLine_2" id = "addressLine2"
                                placeholder = "Enter Address Line 2"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "city" class = "form-label">City</label> 
                            <input type = "text" class = "form-control" name = "city" id = "city"
                                placeholder = "Enter city name"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "state" class = "form-label">State</label> 
                            <input type = "text" class = "form-control" name = "state" id = "state"
                                placeholder = "Enter state name"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "pincode" class = "form-label">Pincode</label> 
                            <input type = "text" class = "form-control" name = "pincode" id = "pincode"
                                placeholder = "Enter your pincode"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "phone" class = "form-label">Phone</label> 
                            <input type = "text" class = "form-control" name = "phone" id = "phone"
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
<cfinclude  template="footer.cfm">