<cfcomponent>
    <!--- ORDER PRODUCT --->
    <cffunction name = "orderProduct" access = "remote" returntype = "string">
        <cfargument name = "cardNumber" type = "string" required = "true">
        <cfargument name = "cvv" type = "string" required = "true">
        <cfargument name = "productId" type = "numeric" required = "false">
        <cfargument name = "addressId" type = "numeric" required = "true">
        <cfargument  name = "quantity" type = "integer" required = "false">
        <cfargument name = "totalPrice" type = "numeric" required = "false">
        <cfargument name = "totalTax" type = "numeric" required = "false">     
        <cftry>
            <cfif structKeyExists(arguments, 'productId')>
                <cfset local.getProductDetails = application.productModObj.getProductsDetails(
                    productId = arguments.productId
                )>
                <cfif local.getProductDetails.recordCount GT 0>
                    <cfset arguments.unitPrice = local.getProductDetails.fldPrice>
                    <cfset arguments.unitTax = local.getProductDetails.fldTax>
                    <cfset arguments.totalPrice = arguments.quantity*(local.getProductDetails.fldPrice + (local.getProductDetails.fldPrice*local.getProductDetails.fldTax)/100)> 
                    <cfset arguments.totalTax = arguments.quantity*(local.getProductDetails.fldPrice*local.getProductDetails.fldTax)/100 > 
                </cfif>
                <cfset arguments.cartOrder = 0>
            <cfelse>
                <cfset arguments.cartOrder = 1>
                <cfset arguments.productId = -1 >
                <cfset arguments.quantity = -1 >
                <cfset arguments.unitPrice = -1>
                <cfset arguments.unitTax = -1>
            </cfif>
            <cfset local.orderId  = createUUID()>
            <cfset local.cardPart = right(arguments.cardNumber, 4) >
            <cfquery result="local.qryPlaceOrder" datasource="#application.datasource#">
                CALL spPlaceOrder(
                    <cfqueryparam value = "#local.orderId#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                    <cfqueryparam value = "#arguments.addressId#" cfsqltype = "integer">,
                    <cfqueryparam value = "#local.cardPart#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.totalPrice#" cfsqltype = "decimal">,
                    <cfqueryparam value = "#arguments.totalTax#" cfsqltype = "decimal">,
                    <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">,
                    <cfqueryparam value = "#arguments.quantity#" cfsqltype = "integer">,
                    <cfqueryparam value = "#arguments.cartOrder#" cfsqltype = "tinyint">,
                    <cfqueryparam value = "#arguments.unitPrice#" cfsqltype = "decimal">,
                    <cfqueryparam value = "#arguments.unitTax#" cfsqltype = "decimal">
                )
            </cfquery>
            <cfreturn 'Success'>
            <cfcatch type = "any">
                <!--- Log the error --->
                <cfset local.errorMessage = "Error occurred: " & cfcatch.message>
                <cflog file="payment_errors" type="error" text="#local.errorMessage#">
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!---  GET ORDER DETAILS    --->
    <cffunction name = "getOrderedProductsDetails" access = "public" returntype = "any">
        <cfargument name = "orderId" type = "string" required = "false">
        <cftry>
            <cfquery name = "local.qryGetOrderedProcutsDetails" datasource = "#application.datasource#">
                SELECT 
                    OI.fldOrderItem_ID,
                    OI.fldOrderId,
                    OI.fldProductId,
                    OI.fldQuantity,
                    OI.fldUnitPrice,
                    OI.fldUnitTax,
                    O.fldTotalPrice,
                    O.fldTotalTax,
                    O.fldOrderedDate,
                    P.fldProductName,
                    A.fldFirstName,
                    A.fldLastName,
                    A.fldAddressLine1,
                    A.fldAddressLine2,
                    A.fldCity,
                    A.fldState,
                    A.fldPincode,
                    A.fldPhoneNumber,
                    PI.fldImageFileName,
                    B.fldBrandName,
                    ROUND(SUM(OI.fldQuantity * (OI.fldUnitPrice + (OI.fldUnitPrice * OI.fldUnitTax) / 100)),2) AS totalPrice
                FROM 
                    tblOrderItems AS OI
                    INNER JOIN tblOrder AS O ON OI.fldOrderId = O.fldOrder_ID
                    INNER JOIN tblProduct AS P ON OI.fldProductId = P.fldProduct_ID
                    INNER JOIN tblAddress AS A ON O.fldAddressId = A.fldAddress_ID
                    INNER JOIN tblProductImages AS PI ON PI.fldProductId = P.fldProduct_ID 
                        AND PI.fldDefaultImage = 1 
                    INNER JOIN tblBrands AS B ON B.fldBrand_ID = P.fldBrandId
                WHERE         
                    O.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">     
                    <cfif structKeyExists(arguments, 'orderId')>
                        AND OI.fldOrderId = <cfqueryparam value = "#arguments.orderId#" cfsqltype = "varchar">
                    <cfelse>
                        AND 1 = 1
                    </cfif>
                GROUP BY
                    OI.fldOrderItem_ID,
                    OI.fldOrderId,
                    OI.fldProductId,
                    OI.fldQuantity,
                    OI.fldUnitPrice,
                    OI.fldOrderId,
                    OI.fldUnitTax,
                    O.fldTotalPrice,
                    O.fldTotalTax,
                    O.fldOrderedDate,
                    P.fldProductName,
                    A.fldFirstName,
                    A.fldLastName,
                    A.fldAddressLine1,
                    A.fldAddressLine2,
                    A.fldCity,
                    A.fldState,
                    A.fldPincode,
                    A.fldPhoneNumber,
                    PI.fldImageFileName,
                    B.fldBrandName
                ORDER BY 
                    O.fldOrderedDate DESC
            </cfquery>
            <cfreturn local.qryGetOrderedProcutsDetails>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>

    <!---   SEND MAIL TO USER   --->
    <cffunction name = "sendMailToUser" access = "public" returntype = "any">
        <cfargument name = "orderId" type = "string" required = "true">
        <cftry>
            <cfset local.orderInformation =getOrderedProductsDetails(
                orderId = arguments.orderId
            )>
            <!---     GET USER EMAIL     --->
            <cfquery name = "local.qryGetUserEmail" datasource = "#application.datasource#">
                SELECT 
                    fldEmail
                FROM 
                    tblUser 
                WHERE 
                    fldUser_ID = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfset local.userMail = local.qryGetUserEmail.fldEmail>
            <cfif local.orderInformation.recordCount GT 0>
                <cfset local.payableAmount = local.orderInformation.fldTotalPrice>
                <cfset local.orderTotal = local.orderInformation.fldUnitPrice>
                <cfset local.orderTax = local.orderInformation.fldUnitTax>
                <cfset local.emailBody = "<h2>Thank you for your purchase!</h2>">
                <cfset local.emailBody &= "<p>Order Date: <strong>#local.orderInformation.fldOrderedDate#</strong></p>">
                <cfset local.emailBody &= "<p>Your Order ID: <strong>#local.orderInformation.fldOrderId#</strong></p>">
                <cfset local.emailBody &= 
                    "<p>
                        Your Shipping Address: 
                        #local.orderInformation.fldAddressLine1#, 
                        #local.orderInformation.fldAddressLine2#, 
                        #local.orderInformation.fldCity#, 
                        #local.orderInformation.fldState#, 
                        #local.orderInformation.fldPincode#
                    </p>"
                >
                <cfset local.emailBody &= 
                    "<table border='1' cellpadding='5' cellspacing='0' style='border-collapse: collapse; width: 100%;'>
                        <tr>
                            <th>Product Name</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Tax</th>
                        </tr>"
                >
                <cfloop query="local.orderInformation">
                    <cfset local.emailBody &= 
                        "<tr>
                        <td>#local.orderInformation.fldProductName#</td>
                        <td>#local.orderInformation.fldQuantity#</td>
                        <td>#local.orderInformation.fldUnitPrice#</td>
                        <td>#local.orderInformation.fldUnitTax#</td>
                        </tr>"
                    >
                </cfloop>
                <cfset local.emailBody &= "</table>">
                <cfset local.emailBody &= "<p><strong>Total Price:</strong> #local.orderInformation.fldTotalPrice#</p>">
                <cfset local.emailBody &= "<p><strong>Total Tax:</strong> #local.orderInformation.fldTotalTax#</p>">
                <cfset local.emailBody &= "<p><strong>Payable Amount:</strong> #local.payableAmount#</p>">
                <cfset local.emailBody &= "<p>Stay Connected with us!</p>"> 
                <cfmail to="#local.userMail#" from="shyamsms466340@gmail.com" subject="Your Order Confirmation Details - #local.orderInformation.fldOrderId#" type="html">
                    #local.emailBody#
                </cfmail>
            </cfif>
            <cfreturn 'Success'>
        <cfcatch type="exception">
            <cfdump var = "#arguments#">
        </cfcatch>
        </cftry>
    </cffunction>
    
</cfcomponent>