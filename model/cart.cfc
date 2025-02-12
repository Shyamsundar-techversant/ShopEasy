<cfcomponent>
    <!---  CHECK PRODUCT ALREADY IN CART --->
    <cffunction  name = "checkProductExist" access = "private" returntype = "any">
        <cfargument name = "productId" type = "integer" required = "true">
        <cfargument name = "userId" type = "integer" required = "true">
        <cftry>
            <cfquery name = "local.qryCheckProductExist" datasource = "#application.datasource#">
                SELECT 
                    fldCart_ID,
                    fldQuantity 
                FROM 
                    tblCart 
                WHERE 
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                    AND fldUserId = <cfqueryparam value = "#arguments.userId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfreturn local.qryCheckProductExist>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    <!--- CHANGE PRODUCT QUANTITY --->
    <cffunction  name = "changeProductQuantity" access = "public" returntype = "any">
        <cfargument name="productId" type = "integer" required = "true">
        <cfargument name = "isDecreaseQuantity" type = "integer" required = "false">
        <cfargument name = "isIncreaseQuantity" type = "integer" required = "false">
        <cfargument name = "isRemoveProduct" type = "integer" required = "false">
        <cftry>
            <cfset local.isProductExist = checkProductExist(
                argumentCollection = arguments
            )>
            <cfif local.isProductExist.recordCount GT 0>
                <cfif structKeyExists(arguments, 'isDecreaseQuantity') >
                    <cfset local.updatedQuantity = local.isProductExist.fldQuantity - 1> 
                <cfelseif structKeyExists(arguments, 'isIncreaseQuantity')>
                    <cfset local.updatedQuantity = local.isProductExist.fldQuantity + 1> 
                <cfelseif structKeyExists(arguments, 'isRemoveProduct')>
                    <cfset local.updatedQuantity = 0> 
                </cfif>
                <cfquery name = "local.qryChangeProductQuantity" datasource = "#application.datasource#">
                    UPDATE 
                        tblCart
                    SET 
                        fldQuantity = <cfqueryparam value = "#local.updatedQuantity#" cfsqltype = "cf_sql_integer">
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                        AND fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfreturn 'Success'>
            <cfelse>
                <cfreturn 'Failed'>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    <!--- ADD PRODUCT TO CART --->
    <cffunction name = "addProductToCart" access = "public" returntype = "any">
        <cfargument  name="productId" type = "integer" required = "true">
        <cfargument name = "userId" type = "integer" required = "false">
        <cftry>
            <cfset local.isProductExist = checkProductExist(
                argumentCollection = arguments
            )>
            <cfif local.isProductExist.recordCount GT 0>
                <cfset local.updatedQuantity = local.isProductExist.fldQuantity + 1>
                <cfquery result = "local.qryUpdateProductQuantity" datasource = "#application.datasource#">
                    UPDATE 
                        tblCart 
                    SET 
                        fldQuantity = <cfqueryparam value = "#local.updatedQuantity#">
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                        AND fldUserId = <cfqueryparam value = "#arguments.userId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfreturn 'Success'>
            <cfelse>
                <cfquery result = "local.qryInsertToCart" datasource = '#application.datasource#'>
                    INSERT INTO tblCart(
                        fldUserId,
                        fldProductId,
                        fldQuantity
                    )VALUES(
                        <cfqueryparam value = "#arguments.userId#" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                    )
                </cfquery>
                <cfreturn 'Success'>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
     <!---   GET CART PRODUCTS   --->
    <cffunction name = "getCartProducts" access = "public" returntype = "any">
        <cftry>
            <cfquery name = "local.qryGetCartProducts" datasource = "#application.datasource#">
                SELECT
                    TC.fldCart_ID,
                    TC.fldProductId,
                    P.fldProductName,
                    B.fldBrandName,
                    P.fldPrice,
                    P.fldTax,
                    TC.fldQuantity,
                    IMG.fldImageFileName,
                    SUM(TC.fldQuantity*(P.fldPrice + (P.fldPrice*P.fldTax)/100)) AS totalPrice,
                    SUM(TC.fldQuantity*((P.fldPrice*P.fldTax)/100)) AS totalTax
                FROM       
                    tblCart AS TC
                    INNER JOIN tblProduct AS P ON TC.fldProductId = P.fldProduct_ID
                    INNER JOIN tblBrands AS B ON B.fldBrand_ID = P.fldBrandId
                    INNER JOIN tblProductImages AS IMG ON IMG.fldProductId = P.fldProduct_ID
                        AND IMG.fldDefaultImage = 1
                WHERE                 
                    TC.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer"> 
                    AND TC.fldQuantity > 0
                GROUP BY 
                    TC.fldCart_ID, 
                    TC.fldProductId,
                    P.fldProductName, 
                    B.fldBrandName, 
                    P.fldPrice, 
                    P.fldTax, 
                    TC.fldQuantity, 
                    IMG.fldImageFileName
            </cfquery>
            <cfreturn local.qryGetCartProducts>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    <!---   USER ADDRESS ADD      --->
    <cffunction name = "addUserAddress" access = "public" returntype = "any">
        <cfargument name = "firstName" type = "string" required = "true">
        <cfargument name = "lastName" type = "string" required = "true">
        <cfargument name = "addressLine1" type = "string" required = "true">
        <cfargument name = "addressLine2" type = "string" required = "true">
        <cfargument name = "city" type = "string" required = "true">
        <cfargument name = "state" type = "string" required = "true">
        <cfargument name = "pincode" type = "string" required = "true">
        <cfargument name = "phone" type = "string" required = "true">
        <cftry>
            <cfquery name = "local.qryAddUserAddress" datasource = "#application.datasource#">
                INSERT INTO tblAddress(
                    fldUserId,
                    fldFirstName,
                    fldLastName,
                    fldAddressLine1,
                    fldAddressLine2,
                    fldCity,
                    fldState,
                    fldPincode,
                    fldPhoneNumber,
                    fldActive,
                    fldCreatedDate
                )VALUES(
                    <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                    <cfqueryparam value  = "#arguments.firstName#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value  = "#arguments.lastName#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#arguments.addressLine1#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#arguments.addressLine2#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#arguments.city#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#arguments.state#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#arguments.pincode#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#arguments.phone#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">,
                    <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                )   
            </cfquery>
            <cfreturn 'Success'>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    <!---   GET USER ADDRESS   --->
    <cffunction name = "getUserAddress" access = "public" returntype = "query">
        <cfargument name = "addressId" type = "integer" required = "false">
        <cftry>
            <cfquery name = "local.qryGetUserAddress" datasource = "#application.datasource#">
                SELECT 
                    fldAddress_ID,
                    fldFirstName,
                    fldLastName,
                    fldAddressLine1,
                    fldAddressLine2,
                    fldCity,
                    fldState,
                    fldPincode,
                    fldPhoneNumber,
                    fldCreatedDate
                FROM 
                    tblAddress
                WHERE 
                    fldActive = 1
                    AND fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_tinyint">
                    <cfif structKeyExists(arguments, 'addressId')>
                        AND fldAddress_ID = <cfqueryparam value = "#arguments.addressId#" cfsqltype = "cf_sql_integer">
                    </cfif>
            </cfquery>
            <cfreturn local.qryGetUserAddress>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    <!---   REMOVE ADDRESS   --->
    <cffunction name = "removeUserAddress" access = "remote" returntype = "any">
        <cfargument name = "addressId" type = "string" required = "true">
        <cftry>
            <cfquery result = "local.qryRemoveAddress" datasource = "#application.datasource#">
                UPDATE 
                    tblAddress 
                SET 
                    fldActive = 0 
                WHERE 
                    fldAddress_ID = <cfqueryparam value ="#arguments.addressId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfif local.qryRemoveAddress.recordCount EQ 1>
                <cfreturn "Success">
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    <!---  GET USER DETAILS   --->
    <cffunction  name="getUserDetails" access = "remote" returntype = "any" returnformat = "json">
        <cfargument  name="userId" type = "string" required = "true">
        <cftry>
            <cfquery name = "local.qryGetUserDetails" datasource = "#application.datasource#">
                SELECT 
                    fldFirstName,
                    fldLastName,
                    fldPhone,
                    fldEmail
                FROM 
                    tblUser 
                WHERE 
                    fldUser_ID = <cfqueryparam value = "#arguments.userId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfreturn local.qryGetUserDetails>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    <!--- VALIDATE USER DETAILS --->
    <cffunction name = "updateUserDetails" access = "remote" returntype = "any">
        <cfargument name = "firstName" type = "string" required = "true">
        <cfargument name = "lastName" type = "string" required = "true">
        <cfargument name = "email" type = "string" required = "true">
        <cfargument name = "phone" type = "string" required = "true">
        <cftry>
            <cfquery result = "local.qryUpdateUser" datasource = "#application.datasource#">
                UPDATE 
                    tblUser
                SET 
                    fldFirstName = <cfqueryparam value = "#arguments.firstName#" cfsqltype = "cf_sql_varchar">,
                    fldLastName = <cfqueryparam value = "#arguments.lastName#" cfsqltype = "cf_sql_varchar">,
                    fldEmail = <cfqueryparam value = "#arguments.email#" cfsqltype = "cf_sql_varchar">,
                    fldPhone = <cfqueryparam value = "#arguments.phone#" cfsqltype = "cf_sql_varchar">,
                    fldUpdatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                    fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                WHERE 
                    fldUser_ID = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfif local.qryUpdateUser.recordCount EQ 1>
                <cfreturn 'Success'>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>