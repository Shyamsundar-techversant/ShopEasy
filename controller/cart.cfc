<cfcomponent>
    <!---   ADD PRODUCT TO CART  --->
    <cffunction name = "addProductToCart" access = "public" returntype = "any">
        <cfargument name="productId" type = "string" required = "true">
        <cfargument name = "userId" type = "integer" required = "false">
        <cfargument name = "isLogIn" type = "integer" required = "false">
        <cfargument name = "decreaseQuantity" type = "integer" required = "false">
        <cfargument name = "increaseQuantity" type = "integer" required = "false">
        <cfset arguments.productId = application.cateContObj.decryptionFunction(arguments.productId)>
        <cfif structKeyExists(arguments, 'userId')>
            <cfset arguments['userId'] = session.userId>
        </cfif>
        <cfif NOT structKeyExists(arguments, 'decreaseQuantity') AND NOT structKeyExists(arguments, 'increaseQuantity') >
            <cfset local.cartAddResult = application.cartModObj.addProductToCart(
                productId = arguments.productId,
                userId = arguments.userId
            )>
        <cfelseif structKeyExists(arguments, 'decreaseQuantity')>
            <cfset local.cartAddResult = application.cartModObj.changeProductQuantity(
                argumentCollection = arguments
            )>
        <cfelseif structKeyExists(arguments, 'increaseQuantity')>
            <cfset local.cartAddResult = application.cartModObj.changeProductQuantity(
                argumentCollection = arguments
            )>
        </cfif>
        <cfif local.cartAddResult EQ "Success">
            <cfif NOT structKeyExists(arguments, 'isLogIn')>
                <cflocation url = "userCart.cfm" addToken = "false">
            <cfelse>
                <cfreturn 'Success'>
            </cfif>
        <cfelse>
            <cfreturn local.cartAddResult>
        </cfif>
    </cffunction>
    <!---  CHANGE PRODUCT QUANTITY    --->
    <cffunction name = "changeProductQuantity" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name="productId" type = "string" required = "true">
        <cfargument name = "decreaseQuantity" type = "integer" required = "false">
        <cfargument name = "increaseQuantity" type = "integer" required = "false">
        <cfargument name = "isRemoveProduct" type = "integer" required = "false">
        <cfset arguments.productId = application.cateContObj.decryptionFunction(arguments.productId)>
        <cfset arguments['userId'] = session.userId>
        <cfset local.result = application.cartModObj.changeProductQuantity(
            argumentCollection = arguments
         )>
        <cfreturn local.result>
    </cffunction>
    <!---   GET CART PRODUCTS   --->
    <cffunction name = "getCartProducts" access = "public" returntype = "any">
        <cfset local.getCartProductResult = application.cartModObj.getCartProducts()>
        <cfreturn local.getCartProductResult>
    </cffunction>

    <!---   USER ADDRESS ADD      --->
    <cffunction name = "addUserAddress" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "firstName" type = "string" required = "true">
        <cfargument name = "lastName" type = "string" required = "true">
        <cfargument name = "addressLine_1" type = "string" required = "true">
        <cfargument name = "addressLine_2" type = "string" required = "true">
        <cfargument name = "city" type = "string" required = "true">
        <cfargument name = "state" type = "string" required = "true">
        <cfargument name = "pincode" type = "string" required = "true">
        <cfargument name = "phone" type = "string" required = "true">
        <cfset local.errors = [] >
        <!---  Validate First name   --->
        <cfif len(trim(arguments.firstName)) EQ 0>
		    <cfset arrayAppend(local.errors,"*Firstname is required")>
	    <cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)?$",arguments.firstName)>
		    <cfset arrayAppend(local.errors,"*Enter a valid firstname")>
		</cfif>	
        <!---  Validate Last Name     --->
        <cfif len(trim(arguments.lastName)) EQ 0>
			<cfset arrayAppend(local.errors,"*Lastname is required")>
		<cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)?$",arguments.lastName)>
			<cfset arrayAppend(local.errors,"*Enter a valid lastname")>
		</cfif>	     
        <!---  Validate Address Line 1     --->
        <cfif len(trim(arguments.addressLine_1)) EQ 0>
			<cfset arrayAppend(local.errors,"*addressLine_1 is required")>
        </cfif>
        <!---  Validate Address Line 2     --->
        <cfif len(trim(arguments.addressLine_2)) EQ 0>
			<cfset arrayAppend(local.errors,"*addressLine_2 is required")>
        </cfif>
        <!---  Validate Address City  --->
        <cfif len(trim(arguments.city)) EQ 0>
			<cfset arrayAppend(local.errors,"*city is required")>
        </cfif>
        <!---  Validate State    --->
        <cfif len(trim(arguments.state)) EQ 0>
			<cfset arrayAppend(local.errors,"*state is required")>
        </cfif>

        <!---    Validate Phone      --->    
        <cfif len(trim(arguments.phone)) EQ 0>
			<cfset arrayAppend(local.errors,"*Phone number is required")>
		<cfelseif NOT reFindNoCase("^[6-9]\d{9}$",arguments.phone)>
		    <cfset arrayAppend(local.errors,"*Enter a valid phone number")>
		</cfif>
    </cffunction>
</cfcomponent>