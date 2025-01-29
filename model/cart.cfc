<cfcomponent>
    <!--- ADD PRODUCT TO CART --->
    <cffunction name = "addProductToCart" access = "public" returntype = "any">
        <cfargument  name="productId" type = "integer" required = "true">
        <cfargument name = "userId" type = "integer" required = "true">
        <cftry>
            <cfquery result = "local.qryInsertToCart" datasource = '#application.datasource#'>
                INSERT INTO 
                        tblCart(
                            fldUserId,
                            fldProductId,
                            fldQuantity
                        )
                VALUES(
                    <cfqueryparam value = "#arguments.userId#" cfsqltype = "cf_sql_integer">,
                    <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">,
                    <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                )
            </cfquery>
            <cfreturn local.qryInsertToCart>
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
                <cfif structKeyExists(session, 'userId')>
                    AND TC.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer"> 
                </cfif>
            </cfquery>
            <cfreturn local.qryGetCartProducts>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>