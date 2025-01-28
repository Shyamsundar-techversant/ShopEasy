<cfcomponent>
    <!---   ADD PRODUCT TO CART  --->
    <cffunction name = "addProductToCart" access = "public" returntype = "any">
        <cfargument  name="productId" type = "string" required = "true">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfset arguments.productId = application.cateContObj.decryptionFunction(arguments.productId)>
        <cfset local.cartAddResult = application.cartModObj.addProductToCart(
            productId = arguments.productId,
            userId = arguments.userId
        )>
        <cfreturn local.cartAddResult>
    </cffunction>

    <!---   GET CART PRODUCTS   --->
    <cffunction name = "getCartProducts" access = "public" returntype = "any">
        <cfset local.getCartProductResult = application.cartModObj.getCartProducts()>
        <cfreturn local.getCartProductResult>
    </cffunction>
</cfcomponent>