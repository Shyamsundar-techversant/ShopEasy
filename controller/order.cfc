<cfcomponent>
    <cffunction name = "validateCardAndOrder" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "cardNumber" type = "string" required = "true">
        <cfargument name = "cvv" type = "string" required = "true">
        <cfargument name = "productId" type = "string" required = "false">
        <cfargument name = "addressId" type = "string" required = "true">
        <cfargument name = "totalPrice" type = "float" required = "false">
        <cfargument name = "totalTax" type = "float" required = "false">
        <cfargument  name = "unitPrice" type = "float" required = "false">
        <cfargument  name = "unitTax" type = "float" required = "false">
        <cfargument  name = "quantity" type = "integer" required = "false">
        <cfset local.errors = []>
        <!---    VALIDATE CARD NUMBER      --->
        <cfset local.cardNumber = 12345678901>
        <cfif len(trim(arguments.cardNumber)) EQ 0>
			<cfset arrayAppend(local.errors,"*card number is required")>
		<cfelseif NOT reFindNoCase("\d{11}$",arguments.cardNumber)>
		    <cfset arrayAppend(local.errors,"*Enter a valid card number")>
        <cfelseif arguments.cardNumber NEQ local.cardNumber>
            <cfset arrayAppend(local.errors,"*Incorrect card Number")>
		</cfif>
        <!---    VALIDATE CVV      --->
        <cfset local.cvv = 1234>
        <cfif len(trim(arguments.cvv)) EQ 0>
			<cfset arrayAppend(local.errors,"*cvv number is required")>
		<cfelseif NOT reFindNoCase("\d{4}",arguments.cvv)>
		    <cfset arrayAppend(local.errors,"*Enter a valid cvv")>
        <cfelseif arguments.cvv NEQ local.cvv>
            <cfset arrayAppend(local.errors,"*Incorrect cvv")>
		</cfif>
        <cfif arrayLen(local.errors) GT 0>
            <cfreturn local.errors>
        <cfelse>
            <cfif arguments.productId NEQ 'undefined' AND structKeyExists(arguments, 'quantity')>
                <cfset arguments.productId = application.cateContObj.decryptionFunction(arguments.productId)>
                <cfset arguments.addressId = application.cateContObj.decryptionFunction(arguments.addressId)>
                <cfset local.orderResult = application.orderModObj.orderProduct(
                    argumentCollection = arguments
                )>
            <cfelse>
                <cfset arguments.addressId = application.cateContObj.decryptionFunction(arguments.addressId)>
                <cfset arguments.totalPrice = 0>
                <cfset arguments.totalTax = 0>
                <cfset arguments['cartProducts'] = application.cartModObj.getCartProducts()>
                <cfloop query = "arguments.cartProducts">
                    <cfset arguments.totalPrice = arguments.totalPrice + arguments.cartProducts.totalPrice>
                    <cfset arguments.totalTax = arguments.totalTax + arguments.cartProducts.totalTax>
                </cfloop>
                <cfset local.orderResult = application.orderModObj.orderProduct(
                    argumentCollection = arguments
                )>
            </cfif>
            <cfreturn local.orderResult>
        </cfif>
    </cffunction>
    <!--- GET ORDER DETAILS     --->
        <cffunction name = "getOrderedProductsDetails" access = "public" returntype = "any">
        <cfargument name = "orderId" type = "string" required = "false">
        <cftry>
            <cfif structKeyExists(arguments, 'orderId')>
                <cfset local.orderResult = application.orderModObj.getOrderedProductsDetails(
                    orderId = arguments.orderId
                )>
            <cfelse>
                <cfset local.orderResult = application.orderModObj.getOrderedProductsDetails( )>
            </cfif>
            <cfreturn local.orderResult>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>