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
        <cfargument name="productId" type = "string" required = "true">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfargument name = "decreaseQuantity" type = "integer" required = "false">
        <cfargument name = "increaseQuantity" type = "integer" required = "false">
        <cfargument name = "isRemoveProduct" type = "integer" required = "false">
        <cftry>
            <cfset local.isProductExist = checkProductExist(
                argumentCollection = arguments
            )>
            <cfif local.isProductExist.recordCount GT 0>
                <cfquery name = "local.qryChangeProductQuantity" datasource = "#application.datasource#">
                    UPDATE 
                        tblCart
                    SET 
                        <cfif structKeyExists(arguments, 'decreaseQuantity') >
                            <cfset local.updatedQuantity = local.isProductExist.fldQuantity - 1> 
                            fldQuantity = <cfqueryparam value = "#local.updatedQuantity#" cfsqltype = "cf_sql_integer">
                        <cfelseif structKeyExists(arguments, 'increaseQuantity')>
                            <cfset local.updatedQuantity = local.isProductExist.fldQuantity + 1> 
                            fldQuantity = <cfqueryparam value = "#local.updatedQuantity#" cfsqltype = "cf_sql_integer">
                        <cfelseif structKeyExists(arguments, 'isRemoveProduct')>
                            fldQuantity = 0
                        </cfif>
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                    AND fldUserId = <cfqueryparam value = "#arguments.userId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfreturn 'Success'>
            <cfelse>
                <cfreturn 'Failed'>
            </cfif>
        <cfcatch type="exception">
        </cfcatch>
        </cftry>
    </cffunction>

    <!--- ADD PRODUCT TO CART --->
    <cffunction name = "addProductToCart" access = "public" returntype = "any">
        <cfargument  name="productId" type = "integer" required = "true">
        <cfargument name = "userId" type = "integer" required = "true">
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
                    IMG.fldImageFileName
                FROM       
                    tblCart AS TC
                INNER JOIN tblProduct AS P
                ON TC.fldProductId = P.fldProduct_ID
                INNER JOIN tblBrands AS B
                ON B.fldBrand_ID = P.fldBrandId
                INNER JOIN tblProductImages AS IMG
                ON IMG.fldProductId = P.fldProduct_ID
                WHERE 
                    IMG.fldDefaultImage = 1
                AND TC.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer"> 
                AND TC.fldQuantity > 0
            </cfquery>
            <cfreturn local.qryGetCartProducts>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>