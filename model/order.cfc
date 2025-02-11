<cfcomponent>
    <cffunction name = "orderProduct" access = "remote" returntype = "any">
        <cfargument name = "cardNumber" type = "string" required = "true">
        <cfargument name = "cvv" type = "string" required = "true">
        <cfargument name = "productId" type = "string" required = "false">
        <cfargument name = "addressId" type = "string" required = "true">
        <cfargument name = "totalPrice" type = "float" required = "true">
        <cfargument name = "totalTax" type = "float" required = "true">
        <cfargument  name = "unitPrice" type = "float" required = "true">
        <cfargument  name = "unitTax" type = "float" required = "true">
        <cfargument  name = "quantity" type = "integer" required = "false">
        <cfargument name = "cartProducts" type = "any" required = "false">
        <cftry>
            <cfset local.orderId  = createUUID()>
            <cfset local.cardPart = right(arguments.cardNumber, 4) >
            <cftransaction action = "begin">
                <cfquery result = "local.qryOrder" datasource = "#application.datasource#">
                    INSERT INTO tblOrder(
                        fldOrder_ID,
                        fldUserId,
                        fldAddressId,
                        fldTotalPrice,
                        fldTotalTax,
                        fldCardPart,
                        fldOrderedDate
                    )VALUES(
                        <cfqueryparam value = "#local.orderId#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#arguments.addressId#" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#arguments.totalPrice#" cfsqltype = "cf_sql_decimal">,
                        <cfqueryparam value = "#arguments.totalTax#" cfsqltype = "cf_sql_decimal">,
                        <cfqueryparam value = "#local.cardPart#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                    )      
                </cfquery>
                <cfset arguments['orderId'] = local.orderId>
                <cfif local.qryOrder.recordCount EQ 1>
                    <cfset local.OrderItemResult = addOrderItems(
                            argumentCollection = arguments
                    )>
                    <cfreturn local.OrderItemResult>
                </cfif>
            <cftransaction action = "commit">
        <cfcatch type="exception">
            <cftransaction action = "rollback">
            <cfset local.errorMessage = "Error occurred: " & cfcatch.message>
            <cflog file="payment_errors" type="error" text="#local.errorMessage#">
        </cfcatch>
        </cftry>
    </cffunction>
    <!---  INSERT DETAILS INTO ORDER ITEMS    --->
    <cffunction name = "addOrderItems" access = "public" returntype = "any">
        <cfargument name = "orderId" type = "string" required = "true">
        <cfargument name = "productId" type = "string" required = "false">
        <cfargument name = "cartProducts" type = "any" required = "false">
        <cfargument name = "quantity" type = "integer" required = "false">
        <cfargument  name = "unitPrice" type = "float" required = "true">
        <cfargument  name = "unitTax" type = "float" required = "true">
        <cftry>
            <cfif arguments.productId NEQ 'undefined'>
                <cfquery result = "local.qryAddOrderItems" datasource = "#application.datasource#">               
                    INSERT INTO tblOrderItems(
                        fldOrderId,
                        fldProductId,
                        fldQuantity,
                        fldUnitPrice,
                        fldUnitTax
                    )VALUES(
                        <cfqueryparam value = "#arguments.orderId#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">,
                        <cfqueryparam value = "#arguments.quantity#" cfsqltype = "integer">,
                        <cfqueryparam value = "#arguments.unitPrice#" cfsqltype = "decimal">,
                        <cfqueryparam value = "#arguments.unitTax#" cfsqltype = "decimal"> 
                    )
                </cfquery>
            <cfelse>
                <cfloop query = "arguments.cartProducts">
                    <cfquery result = "local.qryCartOrderItems" datasource = "#application.datasource#">
                        INSERT INTO tblOrderItems(
                            fldOrderId,
                            fldProductId,
                            fldQuantity,
                            fldUnitPrice,
                            fldUnitTax
                        )VALUES(
                            <cfqueryparam value = "#arguments.orderId#" cfsqltype = "varchar">,
                            <cfqueryparam value = "#arguments.cartProducts.fldProductId#" cfsqltype = "integer">,
                            <cfqueryparam value = "#arguments.cartProducts.fldQuantity#" cfsqltype = "integer">,
                            <cfqueryparam value = "#arguments.cartProducts.fldPrice#" cfsqltype = "decimal">,
                            <cfqueryparam value = "#arguments.cartProducts.fldTax#" cfsqltype = "decimal"> 
                        )
                    </cfquery>
                </cfloop>               
            </cfif>
            <cfif structKeyExists(local,'qryAddOrderItems') >
                <cfif local.qryAddOrderItems.recordCount GT 0>
                    <cfreturn 'Success'>
                </cfif>
               <cfset local.sendMail = sendMailToUser(
                    orderId = arguments.orderId
                )>
            <cfelseif structKeyExists(local,'qryCartOrderItems') >
                <cfif local.qryCartOrderItems.recordCount GT 0>
                    <cfset local.deleteCartItems = deleteCartProducts()>
                    <cfreturn 'Success'>
                </cfif>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    <!---   DELETE CART ITEMS   --->
    <cffunction  name = "deleteCartProducts" access = "private" returntype = "string">
        <cftry>
            <cfloop list = "arguments.productId" item = "local.productId" delimiters=",">
                <cfquery result = "local.qryDeleteCartItems" datasource = "#application.datasource#">
                    DELETE FROM tblCart 
                    WHERE fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                </cfquery>
            </cfloop>
            <cfif local.qryDeleteCartItems.recordCount GT 0>
                <cfreturn 'Success'>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    <!---  GET ORDER DETAILS    --->
    <cffunction name = "getOrderedProductsDetails" access = "public" returntype = "any">
        <cfargument name = "orderId" type = "string" required = "true">
        <cftry>
            <cfquery name = "local.qryGetOrderedProcutsDetails" datasource = "#application.datasource#">
                SELECT 
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
                    PI.fldImageFileName
                FROM tblOrderItems AS OI
                INNER JOIN tblOrder AS O
                ON OI.fldOrderId = O.fldOrder_ID
                INNER JOIN tblProduct AS P
                ON OI.fldProductId = P.fldProduct_ID
                INNER JOIN tblAddress AS A
                ON O.fldAddressId = A.fldAddress_ID
                INNER JOIN tblProductImages AS PI 
                ON PI.fldProductId = P.fldProduct_ID
                WHERE 
                    PI.fldDefaultImage = 1
            </cfquery>
            <cfreturn local.qryGetOrderedProcutsDetails>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>


    <!---   SEND MAIL TO USER   --->
    <cffunction name = "sendMailToUser" access = "private" returntype = "any">
        <cfargument name = "orderId" type = "string" required = "true">
        <cftry>
            <cfset local.displayOrderedItems = application.orderModObj.getOrderedProductsDetails(
                orderId = arguments.orderId
            )>
            <!---     GET USER EMAIL     --->
            <cfquery name = "local.qryGetUserEmail" datasource = "#application.datasource#">
                SELECT 
                    fldEmail
                FROM tblUser 
                WHERE 
                    fldUser_ID = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfset local.userMail = local.qryGetUserEmail.fldEmail>
            <cfif local.orderInformation.recordCount GT 0>
                <cfset local.payableAmount = local.orderInformation.fldTotalPrice>
                <cfset local.orderTotal = local.orderInformation.fldUnitPrice>
                <cfset local.orderTax = local.orderInformation.fldUnitTax>
                <cfset local.emailBody = "<h2>Thank you for purchasing from us.</h2>">
                <cfset local.emailBody &= "<p>Order Date: <strong>#local.orderInformation.fldOrderDate#</strong></p>">
                <cfset local.emailBody &= "<p>Your Order ID: <strong>#local.orderInformation.fldOrderId#</strong></p>">
                <cfset local.emailBody &= 
                    "<p>Your Shipping Address: 
                    #local.orderInformation.fldAddressLine1#, 
                    #local.orderInformation.fldAddressLine2#, 
                    #local.orderInformation.fldCity#, 
                    #local.orderInformation.fldState#, 
                    #local.orderInformations.fldPincode#</p>"
                >
                <cfset local.emailBody &= "<p>Your Account Details: <strong>*******#local.orderInformation.fldCardPart#</strong></p>">
                <cfset local.emailBody &= "<table border='1' cellpadding='5' cellspacing='0' style='border-collapse: collapse; width: 100%;'>
                                            <tr>
                                                <th>Product Name</th>
                                                <th>Quantity</th>
                                                <th>Price</th>
                                                <th>Tax</th>
                                            </tr>">
            
                <cfloop query="local.orderInformation">
                    <cfset local.emailBody &= "<tr>
                                                <td>#local.orderInformation.fldProductName#</td>
                                                <td>#local.orderInformation.fldQuantity#</td>
                                                <td>#local.orderInformation.fldPrice#</td>
                                                <td>#local.orderInformation.fldTax#</td>
                                            </tr>">
                </cfloop>
                <cfset local.emailBody &= "</table>">
                <cfset local.emailBody &= "<p><strong>Total Price:</strong> #local.orderInformation.fldTotalPrice#</p>">
                <cfset local.emailBody &= "<p><strong>Total Tax:</strong> #local.orderInformation.fldTotalTax#</p>">
                <cfset local.emailBody &= "<p><strong>Payable Amount:</strong> #local.payableAmount#</p>">
                <cfset local.emailBody &= "<p>We appreciate your business!</p>"> 
                <cfmail to="#local.userMail#" from="shyamsms466340@gmail.com" subject="Your Order Confirmation Details - #local.orderInformation.fldOrderId#" type="html">
                    #local.emailBody#
                </cfmail>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#arguments#">
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>