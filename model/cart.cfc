<cfcomponent>
    <!--- ADD PRODUCT TO CART --->
    <cffunction name = "addProductToCart" access = "public" returntype = "any">
        <cfargument  name="productId" type = "integer" required = "true">
        <cfargument name = "userId" type = "integer" required = "true">
        <cftry>
            <cfquery result = "local.qryInsertToCart" datasource = 'shoppingcart'>
                INSERT INTO tblCart(
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
            <cfquery name = "local.qryGetCartProducts" datasource = "shoppingcart">
                SELECT
                    tc.fldCart_ID,
                    p.fldProductName,
                    b.fldBrandName,
                    p.fldPrice,
                    p.fldTax,
                    tc.fldQuantity,
                    img.fldImageFileName
                FROM       
                    tblCart AS tc
                INNER JOIN tblProduct AS p
                ON tc.fldProductId = p.fldProduct_ID
                INNER JOIN tblBrands AS b
                ON b.fldBrand_ID = p.fldBrandId
                INNER JOIN tblProductImages AS img
                ON img.fldProductId = p.fldProduct_ID
                WHERE 
                    img.fldDefaultImage = 1
                <cfif structKeyExists(session, 'userId')>
                    AND tc.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer"> 
                </cfif>
            </cfquery>
            <cfreturn local.qryGetCartProducts>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>