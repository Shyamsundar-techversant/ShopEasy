<cfcomponent>
    <!---   ADD PRODUCT TO CART  --->
    <cffunction name = "addProductToCart" access = "public" returntype = "any">
        <cfargument name="productId" type = "numeric" required = "true">
        <cfargument name = "userId" type = "integer" required = "false">
        <cfargument name = "isLogIn" type = "integer" required = "false">
        <cfset arguments['userId'] = session.userId>
        <cfset local.cartAddResult = application.cartModObj.addProductToCart(
            productId = arguments.productId,
            userId = arguments.userId
        )>
        <cfif local.cartAddResult EQ "Success">
            <cfif NOT structKeyExists(session, 'productId')>
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
        <cfargument name = "isDecreaseQuantity" type = "integer" required = "false">
        <cfargument name = "isIncreaseQuantity" type = "integer" required = "false">
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
        <cfargument name = "addressLine1" type = "string" required = "true">
        <cfargument name = "addressLine2" type = "string" required = "true">
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
        <cfif len(trim(arguments.addressLine1)) EQ 0>
            <cfset arrayAppend(local.errors,"*addressLine_1 is required")>
        </cfif>
        <!---  Validate Address Line 2     --->
        <cfif len(trim(arguments.addressLine2)) EQ 0>
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
        <!---     Validate Pincode   --->  
        <cfif len(trim(arguments.pincode)) EQ 0>
            <cfset  arrayAppend(local.errors,"*Pincode is required")>
        <cfelseif NOT reFindNoCase("^[1-9][0-9]{5}$",arguments.pincode)>
            <cfset arrayAppend(local.errors,"*Enter a valid pincode")>
        </cfif> 
        <!---    Validate Phone      --->    
        <cfif len(trim(arguments.phone)) EQ 0>
            <cfset arrayAppend(local.errors,"*Phone number is required")>
        <cfelseif NOT reFindNoCase("^[6-9]\d{9}$",arguments.phone)>
            <cfset arrayAppend(local.errors,"*Enter a valid phone number")>
        </cfif>
        <cfif arrayLen(local.errors) GT 0 >
            <cfreturn local.errors>
        <cfelse>
            <cfset local.addressAddResult = application.cartModObj.addUserAddress(
                argumentCollection = arguments
            )>
            <cfreturn local.addressAddResult>
        </cfif>
    </cffunction>

    <!---   GET ADDRESS   --->
    <cffunction name = "getAddresses" access = "remote" returntype = "query" returnformat = "json">
        <cfargument name = "addressId" type = "numeric" required = "false">
        <cfif structKeyExists(arguments, 'addressId')>
            <cfset local.userAddress = application.cartModObj.getUserAddress(
                addressId = arguments.addressId
            )>
        <cfelse>
            <cfset local.userAddress = application.cartModObj.getUserAddress()>
        </cfif>
        <cfreturn local.userAddress>
    </cffunction>

    <!---   REMOVE ADDRESS   --->
    <cffunction name = "removeUserAddress" access = "remote" returntype = "string" returnformat = "json">
        <cfargument name = "addressId" type = "string" required = "true">
        <cfset arguments.addressId = application.cateContObj.decryptionFunction(arguments.addressId)> 
        <cfset local.addressRemoveResult = application.cartModObj.removeUserAddress(
            addressId = arguments.addressId
        )>
        <cfif local.addressRemoveResult EQ 'Success'>
            <cfreturn local.addressRemoveResult>
        </cfif>
    </cffunction>

    <!---  GET USER DETAILS   --->
    <cffunction  name="getUserDetails" access = "remote" returntype = "any" returnformat = "json">
        <cfargument  name="userId" type = "string" required = "true">
        <cfset arguments.userId = application.cateContObj.decryptionFunction(arguments.userId)>
        <cfset local.userDetails = application.cartModObj.getUserDetails(
            userId = arguments.userId
        )>
        <cfreturn local.userDetails>
    </cffunction>

    <!--- VALIDATE USER DETAILS AND UPDATE --->
    <cffunction name = "validateUserDetails" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "userId" type = "string" required = "true">
        <cfargument name = "firstName" type = "string" required = "true">
        <cfargument name = "lastName" type = "string" required = "true">
        <cfargument name = "email" type = "string" required = "true">
        <cfargument name = "phone" type = "string" required = "true">
        <cfset arguments.userId = application.cateContObj.decryptionFunction(arguments.userId)>
        <cfset local.errors = []>
        <!---  VALIDATE FIRST NAME   --->
        <cfif len(trim(arguments.firstName)) EQ 0>
            <cfset arrayAppend(local.errors,"*Firstname is required")>
        <cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)?$",arguments.firstName)>
            <cfset arrayAppend(local.errors,"*Enter a valid firstname")>
        </cfif>	
        <!---  VALIDATE LAST NAME     --->
        <cfif len(trim(arguments.lastName)) EQ 0>
            <cfset arrayAppend(local.errors,"*Lastname is required")>
        <cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)?$",arguments.lastName)>
            <cfset arrayAppend(local.errors,"*Enter a valid lastname")>
        </cfif>	  
        <!---    VALIDATE EMAIL      --->
        <cfif len(trim(arguments.email)) EQ 0>
            <cfset arrayAppend(local.errors, '*Email is required')>
        <cfelseif NOT reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", arguments.email)>
            <cfset arrayAppend(local.errors, '*Enter a valid email')>
        <cfelse>
            <cfquery name="local.qryCheckUserEmail" datasource = "#application.datasource#">
                SELECT 
                    fldEmail
                FROM 
                    tblUser
                WHERE 
                    fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
                    AND fldUser_ID <> <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfif local.qryCheckUserEmail.recordCount GT 0>
                <cfset arrayAppend(local.errors, '*Email id already exists')>  
            </cfif>
        </cfif>
        
        <!---    VALIDATE PHONE    --->    
        <cfif len(trim(arguments.phone)) EQ 0>
            <cfset arrayAppend(local.errors,"*Phone number is required")>
        <cfelseif NOT reFindNoCase("^[6-9]\d{9}$",arguments.phone)>
            <cfset arrayAppend(local.errors,"*Enter a valid phone number")>
        </cfif>
        <cfif arrayLen(local.errors) GT 0>
            <cfreturn local.errors>
        <cfelse>
            <cfset local.updateResult = application.cartModObj.updateUserDetails(
                argumentCollection = arguments
            )>
            <cfif local.updateResult EQ 'Success'>
                <cfreturn 'Success'>
            <cfelse>
                <cfset arrayAppend(local.errors,"*Invalid data")>
            </cfif>
        </cfif>
    </cffunction>

    <!--- SET SESSION VALUE  --->
    <cffunction  name = "setSessionValue" access = "remote" returntype = "any" returnformat = "json">
        <cfargument  name = "setOrder" type = "numeric" required = "true">
        <cfargument name = "productId" type = "string" required = "true">
        <cfif structKeyExists(arguments, 'setOrder') >
            <cfset session.setOrder = arguments.setOrder>
        </cfif>
        <cfif structKeyExists(arguments, 'productId') >
            <cfset session.productId = arguments.productId>
        </cfif>
    </cffunction>
    
</cfcomponent>