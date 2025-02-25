<cfinclude template = "header.cfm">
<cfset variables.orderDetails = application.orderContObj.getOrderedProductsDetails()>
<!---  ORDER HISTORY SECTION    --->
    <section class = "order-history-section">
        <div class = "container order-history-container">
            <div class = "order-product-search mb-2 p-2">
                <div class = "order-history-search-title">
                    ORDER HISTORY
                </div>
                <div class = "order-history-search-contaier">
                    <form class = "order-search-form" method = "post" action = "orderedProductDetails.cfm">
                        <div class = "search-icon p-2">
                            <label for = "serach-order">
                                <i class="fa-solid fa-magnifying-glass"></i>
                            </label>
                        </div>
                        <div class = "search-text p-1">
                            <input 
                                type = "text" 
                                id = "serach-order" 
                                placeholder = "OrderID"
                                name = "searchOrder"
                            >
                        </div>
                    </form>
                </div>
            </div>
            <cfif structKeyExists(variables, 'orderDetails')>     
                <cfoutput query = "variables.orderDetails"  group = "fldOrderId">
                    <div class = "order-history-details p-2 mb-2">   
                        <div class = "row  order-item-details-history align-items-center">
                            <div class = "col order-items-id">
                                    orderId : #variables.orderDetails.fldOrderId#
                            </div>
                            <div class = "col d-flex justify-content-end align-items-center gap-3">
                                <div class = "order-pdf">
                                    <button 
                                        class = "order-history-btn" 
                                        title = "Download Pdf"
                                        onclick = "window.location.href='orderPdf.cfm?orderId=#variables.orderDetails.fldOrderId#'"
                                    >
                                        PDF
                                    <button>
                                </div>
                                <div class = "order-date">Ordered In : #variables.orderDetails.fldOrderedDate#</div>
                            </div>
                        </div>
                        <cfoutput>
                            <div class = "row  ordered-products-history align-items-center p-2 mb-2">
                                <div class = "col order-items-details">
                                    <div><img src = "/uploadImg/#variables.orderDetails.fldImageFileName#" alt = "prod-img" class = "ordered-image-details"></div>
                                    <div class = "order-items-content">
                                        <div class = "order-items-name-details">#variables.orderDetails.fldProductName#</div>
                                        <div class = "order-items-brand-name-details">Brand : #variables.orderDetails.fldBrandName#</div>
                                        <div class = "order-items-quantity-details">Quantity : #variables.orderDetails.fldQuantity#</div>
                                    </div>
                                </div>
                                <div class = "col d-flex justify-content-center align-items-center gap-3 flex-column">
                                    <div class = "order-actual-price">Actual Price : <span class = "order-actual-price-value">$#variables.orderDetails.fldUnitPrice#</span></div>
                                    <div class = "order-actual-tax">Tax: #variables.orderDetails.fldUnitTax#</div>
                                    <div class = "order-total-price">Total Price : <span class = "order-total-price-value">$#variables.orderDetails.totalPrice#</span></div>
                                </div>
                            </div>
                        </cfoutput>
                        <div class = "d-flex align-items-center order-data-footer p-3">
                            <div class = "final-price col">
                                Total Price : <span class = "order-total-price-value">$#variables.orderDetails.fldTotalPrice#</span>
                            </div>
                            <div class = "ship-adress col">
                                <h6>Shipping Address</h6> 
                                <div class = "ship-address-content">
                                    <span class = "order-user-name">#variables.orderDetails.fldFirstName&variables.orderDetails.fldLastName#</span>,<br>
                                    <span>#variables.orderDetails.fldAddressLine1#</span>,
                                    <span>#variables.orderDetails.fldAddressLine2#</span>,                       
                                    <span>#variables.orderDetails.fldCity#</span>,                       
                                    <span>#variables.orderDetails.fldState#</span>,                       
                                    <span>#variables.orderDetails.fldPincode#</span>,
                                    <span>#variables.orderDetails.fldPhoneNumber#</span>     
                                </div>               
                            </div>
                        </div>
                    </div>
                </cfoutput>
            <cfelseif variables.orderDetails EQ 'undefined' OR NOT structKeyExists(variables,'orderDetails')>
                <h4>No products ordered yet.</h4>
            </cfif> 
        </div>
    </section>
<cfinclude template = "footer.cfm">