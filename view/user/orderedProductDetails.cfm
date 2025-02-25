<cfinclude  template="header.cfm">
    <cfparam name = "form.searchOrder" default = "">
    <cfif form.searchOrder NEQ "">
        <cfset variables.orderProduct = application.orderContObj.getOrderedProductsDetails(
            orderId = trim(form.searchOrder)
        )>
    </cfif>
<!---  ORDER HISTORY SECTION    --->
    <section class = "order-history-section">
        <div class = "container order-history-container">
            <cfif structKeyExists(variables, 'orderProduct')>     
                <cfoutput query = "variables.orderProduct" >
                    <div class = "order-history-details p-2 mb-2">   
                        <div class = "row  order-item-details-history align-items-center">
                            <div class = "col order-items-id">
                                orderId : #variables.orderProduct.fldOrderId#
                            </div>
                            <div class = "col d-flex justify-content-end align-items-center gap-3">
                                <div class = "order-pdf">
                                    <button class = "order-history-btn" title = "Download Pdf">
                                        PDF
                                    <button>
                                </div>
                                <div class = "order-date">Ordered In : #variables.orderProduct.fldOrderedDate#</div>
                            </div>
                        </div>
                        <div class = "row  ordered-products-history align-items-center p-2 mb-2">
                            <div class = "col order-items-details">
                                <div><img src = "/uploadImg/#variables.orderProduct.fldImageFileName#" alt = "prod-img" class = "ordered-image-details"></div>
                                <div class = "order-items-content">
                                    <div class = "order-items-name-details">#variables.orderProduct.fldProductName#</div>
                                    <div class = "order-items-brand-name-details">Brand : #variables.orderProduct.fldBrandName#</div>
                                    <div class = "order-items-quantity-details">Quantity : #variables.orderProduct.fldQuantity#</div>
                                </div>
                            </div>
                            <div class = "col d-flex justify-content-center align-items-center gap-3 flex-column">
                                <div class = "order-actual-price">Actual Price : <span class = "order-actual-price-value">$#variables.orderProduct.fldUnitPrice#</span></div>
                                <div class = "order-actual-tax">Tax: #variables.orderProduct.fldUnitTax#</div>
                                <div class = "order-total-price">Total Price : <span class = "order-total-price-value">$#variables.orderProduct.totalPrice#</span></div>
                             </div>
                        </div>
                        <div class = "d-flex align-items-center order-data-footer p-3">
                            <div class = "final-price col">
                                Total Price : <span class = "order-total-price-value">$#variables.orderProduct.fldTotalPrice#</span>
                            </div>
                            <div class = "ship-adress col">
                                <h6>Shipping Address</h6> 
                                <div class = "ship-address-content">
                                    <span class = "order-user-name">#variables.orderProduct.fldFirstName&variables.orderProduct.fldLastName#</span>,<br>
                                    <span>#variables.orderProduct.fldAddressLine1#</span>,
                                    <span>#variables.orderProduct.fldAddressLine2#</span>,                       
                                    <span>#variables.orderProduct.fldCity#</span>,                       
                                    <span>#variables.orderProduct.fldState#</span>,                       
                                    <span>#variables.orderProduct.fldPincode#</span>,
                                    <span>#variables.orderProduct.fldPhoneNumber#</span>     
                                </div>               
                            </div>
                        </div>
                    </div>
                </cfoutput>
            <cfelse>
                <h4>Order does not exists</h4>
            </cfif> 
        </div>
    </section>
<cfinclude  template="footer.cfm">