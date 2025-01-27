<cfcomponent>
    <!---  DECRYPTION FUNCTION    --->
    <cffunction name = "decryptionFunction" access = "private" returntype = "numeric">
        <cfargument name = "objId" type = "string" required = "false">
        <cfset local.testVar = 0 >
        <cfif arguments.objId NEQ "" AND len(arguments.objId) MOD 16 EQ 0>
            <cfset local.decryptedId = decrypt(
                                                arguments.objId,
                                                application.encryptionKey,
                                                "AES",
                                                "Hex"
                                            )       
            >
            <cfreturn local.decryptedId>
        <cfelse>
            <cfreturn local.testVar>
        </cfif>
    </cffunction>

    <!---   ADD PRODUCT TO CART  --->
    <cffunction name = "addProductToCart" access = "public" returntype = "any">
        <cfargument  name="productId" type = "string" required = "true">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfset arguments.productId = decryptionFunction(arguments.productId)>
        <cfset local.cartAddResult = application.cartModObj.addProductToCart(
                                                                                productId = arguments.productId,
                                                                                userId = arguments.userId
                                                                            )
        >
        <cfreturn local.cartAddResult>
    </cffunction>

    <!---   GET CART PRODUCTS   --->
    <cffunction name = "getCartProducts" access = "public" returntype = "any">
        <cfset local.getCartProductResult = application.cartModObj.getCartProducts()>
        <cfreturn local.getCartProductResult>
    </cffunction>
</cfcomponent>