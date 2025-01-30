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
</cfcomponent>