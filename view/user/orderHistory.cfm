<cfinclude template = "header.cfm">
<cfset variables.orderIds = application.orderModObj.getUniqueOrderId()>
<cfset variables.orderIdList = valueList(orderIds.fldOrder_ID,",")> 
<cfif structKeyExists(form, 'searchOrder')>
    <cfset session.orderId = trim(form.searchOrder)>
    <cflocation  url="orderedProductDetails.cfm" addToken = "false">
</cfif>
<!---  ORDER HISTORY SECTION    --->
    <section class = "order-history-section">
        <div class = "container order-history-container">
            <div class = "order-product-search mb-2 p-2">
                <div class = "order-history-search-title">
                    ORDER HISTORY
                </div>
                <div class = "order-history-search-contaier">
                    <form class = "order-search-form" method = "post">
                        <div class = "search-icon p-2">
                            <label for = "serach-order">
                                <i class="fa-solid fa-magnifying-glass"></i>
                            </label>
                        </div>
                        <div class = "search-text p-1">
                            <input type = "text" id = "serach-order" placeholder = "OrderID"
                                name = "searchOrder"
                            >
                        </div>
                    </form>
                </div>
            </div>
            <cfif structKeyExists(variables, 'orderIds')>     
                <cfoutput query = "variables.orderIds" >
                    <cfset variables.currentOrder = application.orderContObj.getOrderedProductsDetails(
                        variables.orderIds.fldOrder_ID
                    )> 
                    <div class = "order-history-details p-2 mb-2">   
                        <div class = "row  order-item-details-history align-items-center">
                            <div class = "col order-items-id">
                                    orderId : #variables.orderIds.fldOrder_ID#
                            </div>
                            <div class = "col d-flex justify-content-end align-items-center gap-3">
                                <div class = "order-pdf">
                                    <button class = "order-history-btn" title = "Download Pdf"
                                        onclick = "window.location.href='orderPdf.cfm?orderId=#variables.orderIds.fldOrder_ID#'"
                                    >
                                        PDF
                                    <button>
                                </div>
                                <div class = "order-date">Ordered In : #variables.currentOrder.fldOrderedDate#</div>
                            </div>
                        </div>
                        <cfif structKeyExists(variables, 'currentOrder')>
                            <cfloop query = "variables.currentOrder">
                                <div class = "row  ordered-products-history align-items-center p-2 mb-2">
                                    <div class = "col order-items-details">
                                        <div><img src = "/uploadImg/#variables.currentOrder.fldImageFileName#" alt = "prod-img" class = "ordered-image-details"></div>
                                        <div class = "order-items-content">
                                            <div class = "order-items-name-details">#variables.currentOrder.fldProductName#</div>
                                            <div class = "order-items-brand-name-details">Brand : #variables.currentOrder.fldBrandName#</div>
                                            <div class = "order-items-quantity-details">Quantity : #variables.currentOrder.fldQuantity#</div>
                                        </div>
                                    </div>
                                    <div class = "col d-flex justify-content-center align-items-center gap-3 flex-column">
                                        <div class = "order-actual-price">Actual Price : <span class = "order-actual-price-value">$#variables.currentOrder.fldUnitPrice#</span></div>
                                        <div class = "order-actual-tax">Tax: #variables.currentOrder.fldUnitTax#</div>
                                        <div class = "order-total-price">Total Price : <span class = "order-total-price-value">$#variables.currentOrder.totalPrice#</span></div>
                                    </div>
                                </div>
                            </cfloop>
                        </cfif>
                        <div class = "d-flex align-items-center order-data-footer p-3">
                            <div class = "final-price col">
                                Total Price : <span class = "order-total-price-value">$#variables.currentOrder.fldTotalPrice#</span>
                            </div>
                            <div class = "ship-adress col">
                                <h6>Shipping Address</h6> 
                                <div class = "ship-address-content">
                                    <span class = "order-user-name">#variables.currentOrder.fldFirstName&variables.currentOrder.fldLastName#</span>,<br>
                                    <span>#variables.currentOrder.fldAddressLine1#</span>,
                                    <span>#variables.currentOrder.fldAddressLine2#</span>,                       
                                    <span>#variables.currentOrder.fldCity#</span>,                       
                                    <span>#variables.currentOrder.fldState#</span>,                       
                                    <span>#variables.currentOrder.fldPincode#</span>,
                                    <span>#variables.currentOrder.fldPhoneNumber#</span>     
                                </div>               
                            </div>
                        </div>
                    </div>
                </cfoutput>
            <cfelseif variables.orderList EQ 'undefined' OR NOT structKeyExists(variables,'orderList')>
                <h4>No products ordered yet.</h4>
            </cfif> 
        </div>
    </section>
<cfinclude template = "footer.cfm">