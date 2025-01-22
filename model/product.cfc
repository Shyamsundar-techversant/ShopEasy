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
                    AND fldBrand_ID = <cfqueryparam value = "#arguments.brandId#" cfsqltype = "cf_sql_integer">
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
                    AND fldBrandId = <cfqueryparam value = "#arguments.brandId#" cfsqltype = "cf_sql_integer">
                    AND fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                    AND fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "cf_sql_varchar" >
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
        <cfargument name = "uploadedImgPath" type = "array" required = "false">
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
                <cfquery result = "local.qryEditProduct" datasource = "shoppingcart">
                    UPDATE
                        tblProduct
                    SET 
                        fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "cf_sql_varchar">,
                        fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">,
                        fldBrandId = <cfqueryparam value = "#arguments.productBrand#" cfsqltype = "cf_sql_integer">,
                        fldDescription = <cfqueryparam value = "#arguments.productDescription#" cfsqltype = "cf_sql_varchar">,
                        fldPrice = <cfqueryparam value = "#arguments.productPrice#" cfsqltype = "cf_sql_decimal">,
                        fldTax = <cfqueryparam value = "#arguments.productTax#" cfsqltype = "cf_sql_decimal">,
                        fldUpdatedById = <cfqueryparam value = "#session.adminId#" cfsqltype ="cf_sql_integer" >,
                        fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date" >
                    WHERE 
                        fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                        AND fldCreatedById = <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfif local.qryEditProduct.recordCount EQ 1>
                    <cfif structKeyExists(arguments, 'uploadedImgPath')>
                        <cfset local.newAddedImg = addImage(
                                                                productId = arguments.productId,
                                                                productImages = arguments.uploadedImgPath                                                           
                                                        )
                        >
                        <cfif local.newAddedImg EQ "Success">
                            <cfset local.result = "Success">
                        <cfelse>
                            <cfset local.result = "Failed">
                        </cfif>
                    <cfelse>
                        <cfset local.result = "Success">
                    </cfif>
                <cfelse>
                    <cfset local.result = "Product Update Faileld">
                </cfif>
                <cfreturn local.result>
            <cfcatch type="exception">
                <cfdump var = "#cfcatch#" >
            </cfcatch>
            </cftry>
        </cfif>
    </cffunction>

    <!---  GET PRODUCT IMAGE COUNT    --->
    <cffunction  name="getProductImageCount" access = "private" returntype = "any">
        <cfargument  name="productId" type = "integer" required = "true">
        <cftry>
            <cfquery name = "local.qryGetProductImageCount" datasource = "shoppingcart">
                SELECT 
                    fldProductImage_ID
                FROM 
                    tblProductImages
                WHERE
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfif local.qryGetProductImageCount.recordCount GT 0>
                <cfreturn local.qryGetProductImageCount.recordCount>
            <cfelse>
                <cfreturn 0>
            </cfif>
        <cfcatch type="exception">
            <cfdump  var="#cfcatch#">
        </cfcatch>
        </cftry>       
    </cffunction>


    <!---  ADD IMAGE  --->
    <cffunction name = "addImage" access = "private" returntype = "string">
        <cfargument  name = "productId" type = "integer" required = "true">
        <cfargument name = "productImages" type = "array" required = "true">
        <cfset local.insertedCount = 0>
        <cftry>
            <cfset local.productImageCount = getProductImageCount(productId = arguments.productId)>
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
                            <cfif #i# EQ 1 AND local.productImageCount LT 3>
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
            <cfif local.insertedCount GT 0 >
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
    <cffunction name = "getProduct" access = "public" returntype = "any">
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
                    AND fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                <cfif structKeyExists(arguments, "productId")>
                    AND fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer"> 
                </cfif>
            </cfquery>
            <cfif local.qryGetProduct.recordCount GT 0>
                <cfreturn local.qryGetProduct>
            <cfelse>
                <cfreturn "No products Exist">
            </cfif>
            <cfcatch type="exception">
                <cfdump var = "#cfcatch#" >
            </cfcatch>
        </cftry>
    </cffunction>

    <!---  GET IMAGES    --->
    <cffunction name = "getProductImages" access = "public" returntype = "any">
        <cfargument name = "productId" type = "integer" required = "true">
        <cfargument name = "defaultImg" type = "integer" required = "false" >   
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
                    AND fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                <cfif structKeyExists(arguments, "defaultImg") >
                    AND fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                </cfif>
            </cfquery>
            <cfif NOT structKeyExists(arguments, "defaultImg")>
                <cfif local.qryGetProductImages.recordCount GE 3>
                    <cfreturn local.qryGetProductImages>
                </cfif>
            <cfelse>
                <cfif local.qryGetProductImages.recordCount EQ 1>
                    <cfreturn local.qryGetProductImages>
                </cfif>              
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>


    <!--- DELETE IMAGE SUB FUNCTION --->
    <cffunction  name="imageDeleteFunction" access = "private" returntype = "any">
        <cfargument name = "imageId" type = "integer" required = "true">
        <cftry>
            <cfquery result = "local.qryImageDelete" datasource = "shoppingcart">
                DELETE FROM 
                    tblProductImages
                WHERE
                    fldProductImage_ID = <cfqueryparam value = "#arguments.imageId#" cfsqltype = "cf_sql_integer">
                AND fldCreatedById = <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">
            </cfquery> 
            <cfreturn local.qryImageDelete.recordCount >      
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---  DELETE IMAGE    --->
    <cffunction  name="deleteImage" access = "public" returntype = "string">
        <cfargument  name="imageId" type = "integer" required = "true">
        <cfargument  name="productId" type = "integer" required = "true">
        <cftry>
            <cfset local.productImageCount  = getProductImageCount(productId = arguments.productId) >
            <cfif local.productImageCount LE 3 >
                <cfreturn "*Atleast 3 Images required" >
            <cfelse>
                <cfquery name = "local.qryCheckDefaultImg" datasource = "shoppingcart">
                    SELECT
                        fldDefaultImage
                    FROM 
                        tblProductImages
                    WHERE
                        fldProductImage_ID = <cfqueryparam value = "#arguments.imageId#" cfsqltype = "cf_sql_varchar">
                </cfquery>
                <cfif local.qryCheckDefaultImg.fldDefaultImage EQ 1>
                    <cfset local.imageDeleteResult = imageDeleteFunction(imageId = arguments.imageId )>
                    <cfif local.imageDeleteResult EQ 1>
                        <cfset local.newDafaultImageId = arguments.imageId + 1 >
                        <cfquery name = "local.qryChangeDefaultImage" datasource = "shoppingcart">
                            UPDATE 
                                tblProductImages AS targetTable
                            INNER JOIN(
                                        SELECT fldProductImage_ID AS maxImgId
                                        FROM
                                            tblProductImages
                                        WHERE
                                            fldProductId =  <cfqueryparam 
                                                                value = "#arguments.productId#" 
                                                                cfsqltype = "cf_sql_integer"
                                                            >
                                        ORDER BY 
                                            fldProductImage_ID DESC 
                                        LIMIT 1                                   
                                    ) AS subQuery 
                            ON targetTable.fldProductImage_ID = subQuery.maxImgId
                            SET 
                                targetTable.fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                            WHERE
                                targetTable.fldCreatedById = <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">
                        </cfquery>  
                        <cfreturn "Success">                    
                    <cfelse>
                        <cfreturn  "Image edit Failed">
                    </cfif>
                <cfelse>
                    <cfset local.imageDeleteResult = imageDeleteFunction(imageId = arguments.imageId )>
                    <cfif local.imageDeleteResult EQ 1>
                        <cfreturn "Success">
                    <cfelse>
                        <cfreturn "Image edit Failed" >
                    </cfif>              
                </cfif>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>

    <!--- DELETE PRODUCT --->
    <cffunction  name="deleteProduct" access = "public" returntype = "string">
        <cfargument name = "productId" type = "integer" required = "true">
        <cftry>
            <cfquery result = "local.qryDeleteProduct" datasource = "shoppingcart">
                UPDATE 
                    tblProduct
                SET 
                    fldActive = <cfqueryparam value = "0" cfsqltype = "cf_sql_tinyint">
                WHERE
                    fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                    AND fldCreatedById = <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfif local.qryDeleteProduct.recordCount EQ 1 >
                <cfreturn "Success">
            <cfelse>
                <cfreturn "Failed" >
            </cfif>
        <cfcatch type="exception">
            <cfdump  var="#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>