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
        <cftry>
            <cfset local.orderId  = createUUID()>
            <cfset local.cardPart = right(arguments.cardNumber, 4) >
           <cftransaction action = "begin">
                <cfquery name = "local.qryOrder" datasource = "#application.datasource#">
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
            <cftransaction action = "commit">
        <cfcatch type="exception">
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>