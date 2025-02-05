<cfcomponent>
    <cffunction name = "validateCardAndOrder" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "cardNumber" type = "string" required = "true">
        <cfargument name = "cvv" type = "string" required = "true">
        <cfargument name = "productId" type = "string" required = "false">
        <cfargument name = "addressId" type = "string" required = "true">
        <cfargument name = "totalPrice" type = "float" required = "true">
        <cfargument name = "totalTax" type = "float" required = "true">
        <cfargument  name = "unitPrice" type = "float" required = "true">
        <cfargument  name = "unitTax" type = "float" required = "true">
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
            <cfif  arguments.productId NEQ 'undefined'>
                <cfset arguments.productId = application.cateContObj.decryptionFunction(arguments.productId)>
                <cfset arguments.addressId = application.cateContObj.decryptionFunction(arguments.addressId)>
                <cfset local.orderResult = application.orderModObj.orderProduct(
                    argumentCollection = arguments
                )>
            <cfelse>

            </cfif>
        </cfif>
    </cffunction>
</cfcomponent>