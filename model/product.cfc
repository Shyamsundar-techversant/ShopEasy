<cfcomponent>
    <!--- GET BRANDS --->
    <cffunction name = "getBrands" access = "public" returntype = "query">
        <cfargument  name="brandId" type = "integer" required = "false">
        <cftry>
            <cfquery name = "local.qryGetBrands" datasource = "shoppingcart">
                SELECT
                    fldBrand_ID,
                    fldBrandName
                FROM 
                    tblBrands
                WHERE
                    fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                <cfif structKeyExists(arguments, 'brandId')>
                    AND 
                        fldBrand_ID = <cfqueryparam value = "#arguments.brandId#" cfsqltype = "cf_sql_integer">
                </cfif>
            </cfquery>
            <cfreturn local.qryGetBrands>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#"> 
        </cfcatch>
        </cftry>
    </cffunction>

    <!---   CHECK PRODUCT EXIST   --->
    <cffunction name = "checkProductExist" access = "public" returntype = "string">
        <cfargument name = "subCategoryId" type = "integer" required = "true" >
        <cfargument name = "brandId" type = "integer" required = "true" >
        <cfargument name = "productName" type = "string" required = "true" >
        <cftry>
            <cfquery name = "local.qryCheckProduct" datasource = "shoppingcart">
                SELECT 
                    fldProduct_ID
                FROM
                    tblProduct
                WHERE 
                    fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">
                AND 
                    fldBrandId = <cfqueryparam value = "#arguments.brandId#" cfsqltype = "cf_sql_integer">
                AND 
                    fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                AND  
                    fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "cf_sql_varchar" >
            </cfquery>
            <cfif local.qryCheckProduct.recordCount GT 0 >
                <cfreturn "true">
            <cfelse>
                <cfreturn "false" >
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---    PRODUCT ADD EDIT FUNCTION  --->
    <cffunction name = "productAddEdit" access = "public" returntype = "string">
        <cfargument name = "categoryId" type = "integer" required = "true" >
        <cfargument name = "subCategoryId" type = "integer" required = "true" >
        <cfargument name = "productId" type = "integer" required = "false" >
        <cfargument name = "productName" type = "string" required = "true">
        <cfargument name = "productBrand" type = "integer" required = "true">
        <cfargument name = "productDescription" type = "string" required = "true">
        <cfargument name = "productPrice" type = "numeric" required = "true">
        <cfargument name = "productTax" type = "numeric" required = "true" >
        <cfargument name = "uploadedImgPath" type = "array" required = "true">

        <cfset local.result = "">
        <cfif NOT structKeyExists(arguments, "productId")>
            <cftry>          
                <cfquery datasource = "shoppingcart" result ="local.qryAddProduct">
                    INSERT INTO 
                            tblProduct(
                                        fldSubCategoryId,
                                        fldProductName,
                                        fldBrandId,
                                        fldDescription,
                                        fldPrice,
                                        fldTax,
                                        fldActive,
                                        fldCreatedById,
                                        fldUpdatedById,
                                        fldUpdatedDate
                            )
                    VALUES(
                            <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#arguments.productName#" cfsqltype = "cf_sql_varchar">,
                            <cfqueryparam value = "#arguments.productBrand#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#arguments.productDescription#" cfsqltype = "cf_sql_varchar">,
                            <cfqueryparam value = "#arguments.productPrice#" cfsqltype = "cf_sql_decimal">,
                            <cfqueryparam value = "#arguments.productTax#" cfsqltype = "cf_sql_decimal">,
                            <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                        )
                </cfquery>
                <cfif local.qryAddProduct.recordCount EQ 1>
                    <cfset local.imageAddResult = addImage(
                                                        productId = local.qryAddProduct.GENERATEDKEY,
                                                        productImages = arguments.uploadedImgPath
                                                 )
                    >
                    <cfif local.imageAddResult EQ "Success">
                        <cfset local.result = "Success">
                    <cfelse>
                        <cfset local.result = "Failed">
                    </cfif>
                <cfelse>
                    <cfset local.result = "Failed">
                </cfif>
                <cfreturn local.result>
            <cfcatch type="exception">
                <cfdump var = "#cfcatch#">
            </cfcatch>
            </cftry>
        <cfelse>
            <cftry>
                <cfquery result = "local.editCateg" datasource = "shoppingcart">
                    UPDATE
                        tblCategory
                    SET 
                        fldCategoryName = <cfqueryparam value = "#arguments.categName#" cfsqltype = "cf_sql_varchar">,
                        fldUpdatedById = <cfqueryparam value = "#session.adminId#" cfsqltype ="cf_sql_integer" >,
                        fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date" >
                    WHERE 
                        fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">
                    AND 
                        fldCreatedById = <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfif local.editCateg.recordCount EQ 1>
                    <cfset local.result = "Success">
                <cfelse>
                    <cfset local.result = "Faileld">
                </cfif>
                <cfreturn local.result>
            <cfcatch type="exception">
                <cfdump var = "#cfcatch#" >
            </cfcatch>
            </cftry>
        </cfif>
    </cffunction>

    <!---   ADD IMAGE   --->
    <cffunction name = "addImage" access = "private" returntype = "string">
        <cfargument  name = "productId" type = "integer" required = "true">
        <cfargument name = "productImages" type = "array" required = "true">
        <cfset local.insertedCount = 0>
        <cftry>
            <cfloop array = "#arguments.productImages#" index = "i" item = "image">
                <cfquery datasource = "shoppingcart" result = "local.qryAddImage">
                    INSERT INTO
                        tblProductImages(
                                            fldProductId,
                                            fldImageFileName,
                                            fldDefaultImage,
                                            fldActive,
                                            fldCreatedById,
                                            fldDeactivatedById,
                                            fldDeactivatedDate
                                        )
                    VALUES(
                            <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#image#" cfsqltype = "cf_sql_varchar">,
                            <cfif #i# EQ 1>
                                <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">,
                            <cfelse>
                                <cfqueryparam value = "0" cfsqltype = "cf_sql_tinyint">,
                            </cfif>
                            <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">,
                            <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                        )
                </cfquery>
                <cfset local.insertedCount = local.insertedCount + 1>
            </cfloop>
            <cfif local.insertedCount EQ 3 >
                <cfreturn "Success">
            <cfelse>
                <cfreturn "Failed">
            </cfif>
        <cfcatch type="exception">
            <cfdump  var="#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>

        <!--- GET PRODUCTS     --->
    <cffunction name = "getProduct" access = "public" returntype = "query">
        <cfargument name = "subCategoryId" type = "integer" required = "true">
        <cfargument name = "productId" type = "integer" required = "false">
        <cftry>
            <cfquery name = "local.qryGetProduct" datasource = "shoppingcart">
                SELECT
                    <cfif NOT structKeyExists(arguments, "productId") >
                        fldProduct_ID,
                    </cfif>
                    fldProductName,
                    fldBrandId,
                    fldDescription,
                    fldPrice,
                    fldTax
                FROM 
                    tblProduct
                WHERE
                    fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">
                <cfif structKeyExists(arguments, "productId")>
                    AND fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer"> 
                </cfif>
            </cfquery>
            <cfif local.qryGetProduct.recordCount GT 0>
                <cfreturn local.qryGetProduct>
            </cfif>
            <cfcatch type="exception">
                <cfdump var = "#cfcatch#" >
            </cfcatch>
        </cftry>
    </cffunction>

    <!---  GET IMAGES    --->
    <cffunction name = "getProductImages" access = "public" returntype = "any">
        <cfargument name = "productId" type = "integer" required = "true">
        <cfargument name = "productImgId" type = "integer" required = "false" >

        <cftry>
            <cfquery name = "local.qryGetProductImages" datasource = "shoppingcart">
                SELECT 
                    fldProductImage_ID,
                    fldImageFileName,
                    fldDefaultImage
                FROM 
                    tblProductImages
                WHERE
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                AND 
                    fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
            </cfquery>
            <cfif local.qryGetProductImages.recordCount EQ 3>
                <cfreturn local.qryGetProductImages>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>

    </cffunction>
</cfcomponent>