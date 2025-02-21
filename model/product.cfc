<cfcomponent>
    <!--- GET BRANDS --->
    <cffunction name = "getBrands" access = "public" returntype = "query">
        <cfargument  name="brandId" type = "integer" required = "false">
        <cftry>
            <cfquery name = "local.qryGetBrands" datasource = "#application.datasource#">
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
            <cfquery name = "local.qryCheckProduct" datasource = "#application.datasource#">
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
    <cffunction name = "productAddEdit" access = "public" returntype = "any">
        <cfargument name = "categoryId" type = "integer" required = "true" >
        <cfargument name = "subCategoryId" type = "integer" required = "true" >
        <cfargument name = "productId" type = "integer" required = "false" >
        <cfargument name = "productName" type = "string" required = "true">
        <cfargument name = "productBrand" type = "integer" required = "true">
        <cfargument name = "productDescription" type = "string" required = "true">
        <cfargument name = "productPrice" type = "numeric" required = "true">
        <cfargument name = "productTax" type = "numeric" required = "true" >
        <cfargument name = "productImages" type = "any" required = "false">
        <cfset local.result = "">
        <cfif NOT structKeyExists(arguments, "productId")>
            <cftry>          
                <cfquery datasource = "#application.datasource#" result = "local.qryAddProduct">
                    INSERT INTO tblProduct(
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
                    )VALUES(
                        <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#arguments.productName#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.productBrand#" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#arguments.productDescription#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.productPrice#" cfsqltype = "cf_sql_decimal">,
                        <cfqueryparam value = "#arguments.productTax#" cfsqltype = "cf_sql_decimal">,
                        <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                    )
                </cfquery>
                <cfif local.qryAddProduct.recordCount EQ 1>
                    <cfset local.imageAddResult = addImage(
                        productId = local.qryAddProduct.GENERATEDKEY,
                        productImages = arguments.productImages
                    )>
                    <cfif local.imageAddResult EQ "Success">
                        <cfset local.result = "Success">
                    <cfelseif local.imageAddResult EQ "Failed">
                        <cfset local.result = "Failed">
                    <cfelse>
                        <cfreturn local.imageAddResult>
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
                <cfquery result = "local.qryEditProduct" datasource = "#application.datasource#">
                    UPDATE
                        tblProduct
                    SET 
                        fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "cf_sql_varchar">,
                        fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">,
                        fldBrandId = <cfqueryparam value = "#arguments.productBrand#" cfsqltype = "cf_sql_integer">,
                        fldDescription = <cfqueryparam value = "#arguments.productDescription#" cfsqltype = "cf_sql_varchar">,
                        fldPrice = <cfqueryparam value = "#arguments.productPrice#" cfsqltype = "cf_sql_decimal">,
                        fldTax = <cfqueryparam value = "#arguments.productTax#" cfsqltype = "cf_sql_decimal">,
                        fldUpdatedById = <cfqueryparam value = "#session.userId#" cfsqltype ="cf_sql_integer" >,
                        fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date" >
                    WHERE 
                        fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                        AND fldCreatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfif local.qryEditProduct.recordCount EQ 1>
                    <cfif structKeyExists(arguments, 'productImages')>
                        <cfset local.newAddedImg = addImage(
                            productId = arguments.productId,
                            productImages = arguments.productImages                                                           
                        )>
                        <cfif isArray(local.newAddedImg)>
                            <cfreturn local.newAddedImg>
                        <cfelseif local.newAddedImg EQ "Success" >
                            <cfset local.result = "Success">
                        <cfelse>
                            <cfset local.result = "Failed">
                        </cfif>
                        <cfset local.result = "Success">
                        <cfreturn local.result>
                    </cfif>
                    <cfreturn "Success">
                <cfelse>
                    <cfset local.result = "Product Update Failed">
                    <cfreturn local.result>
                </cfif>
            <cfcatch type="exception">
                <cfdump var = "#cfcatch#">
            </cfcatch>
            </cftry>
        </cfif>
    </cffunction>

    <!---  GET PRODUCT IMAGE COUNT    --->
    <cffunction  name="getProductImageCount" access = "private" returntype = "any">
        <cfargument  name="productId" type = "integer" required = "true">
        <cftry>
            <cfquery name = "local.qryGetProductImageCount" datasource = "#application.datasource#">
                SELECT 
                    fldProductImage_ID
                FROM 
                    tblProductImages
                WHERE
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                    AND fldActive = 1
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
    <cffunction name = "addImage" access = "private" returntype = "any">
        <cfargument  name = "productId" type = "integer" required = "true">
        <cfargument name = "productImages" type = "any" required = "true">
        <cfset local.insertedCount = 0>
        <cftry>
            <cfset local.errors = []>
            <cfif structKeyExists(arguments, 'productImages')>
                <cfset local.maxImgSize = 5*1024*1024>
                <cfset local.allowedExtensions = "jpeg,jpg,png,gif">
                <cfset local.uploadedImagePath = [] >
                <cffile  
                    action = "uploadAll"
                    fileField = "arguments.productImages"
                    destination = "#application.imageSavePath#"
                    nameconflict = "makeunique"
                    result = "local.uploadedImage"
                >
                <cfloop array = "#local.uploadedImage#" index = "i" item = "image">
                    <cfif image.fileSize GT local.maxImgSize>
                        <cfset arrayAppend(local.errors, "*The size of  image #i# is greater")>
                    </cfif>
                    <cfif NOT listFindNoCase(local.allowedExtensions,"#image.CLIENTFILEEXT#")>
                        <cfset arrayAppend(local.errors,"*Image #image.CLIENTFILE# should be jpeg or png or gif format")>
                    </cfif>
                    <cfset arrayAppend(local.uploadedImagePath, image.SERVERFILE)>
                </cfloop>
                <cfset arguments.productImages = local.uploadedImagePath>
            </cfif>
            <cfif arrayLen(local.errors) GT 0>
                <cfreturn local.errors>
            <cfelse>
                <cfset local.productImageCount  = getProductImageCount(productId = arguments.productId) >
                <cfloop array = "#arguments.productImages#" index = "i" item = "image">
                    <cfquery datasource = "#application.datasource#" result = "local.qryAddImage">
                        INSERT INTO tblProductImages(
                            fldProductId,
                            fldImageFileName,
                            fldDefaultImage,
                            fldActive,
                            fldCreatedById
                        )VALUES(
                            <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#image#" cfsqltype = "cf_sql_varchar">,
                            <cfif #i# EQ 1 AND local.productImageCount LT 3>
                                <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">,
                            <cfelse>
                                <cfqueryparam value = "0" cfsqltype = "cf_sql_tinyint">,
                            </cfif>
                            <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">,
                            <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                        )
                    </cfquery>
                    <cfset local.insertedCount = local.insertedCount + 1>
                </cfloop>
                <cfif local.insertedCount GT 0 >
                    <cfreturn "Success">
                <cfelse>
                    <cfreturn "Failed">
                </cfif>
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
            <cfquery name = "local.qryGetProduct" datasource = "#application.datasource#">
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
                <cfif structKeyExists(arguments, 'productId')>
                    <cfset local.productImages = getProductImages(productId = arguments.productId)>
                    <cfset local.productArr = []>
                    <cfloop query = "local.productImages" >
                        <cfset local.imgData = {
                            'imageId' : local.productImages.fldProductImage_ID,
                            'imageFile' : local.productImages.fldImageFileName,
                            'defaultValue' : local.productImages.fldDefaultImage
                        }>
                        <cfset arrayAppend(local.productArr, local.imgData)>
                    </cfloop>               
                    <cfset local.productDataById = {
                        'productName' : local.qryGetProduct.fldProductName,
                        'productBrand' : local.qryGetProduct.fldBrandId,
                        'productDescription' : local.qryGetProduct.fldDescription,
                        'productPrice' : local.qryGetProduct.fldPrice,
                        'productTax' : local.qryGetProduct.fldTax
                    }>
                    <cfset arrayAppend(local.productArr, local.productDataById)>
                    <cfreturn local.productArr>
                <cfelse>
                    <cfreturn local.qryGetProduct>
                </cfif>
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
            <cfquery name = "local.qryGetProductImages" datasource = "#application.datasource#">
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

    <!--- CHANGE DEFAULT IMAGE --->
    <cffunction name = "changeDefaultImage" access = "remote" returntype = "any">
        <cfargument  name = "defaultImageId" type = "integer" required = "true">
        <cfargument name = "previousSelectedImageId" type = "integer" required = "true">
        <cftry>
            <cfquery result = "local.qryChangeDefaultImage" datasource = "#application.datasource#">
                UPDATE 
                    tblProductImages 
                SET 
                    fldDefaultImage = 1
                WHERE 
                    fldProductImage_ID = <cfqueryparam value = "#arguments.defaultImageId#" cfsqltype = "cf_sql_integer">
                    AND fldCreatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfquery result = "local.qryChangePreviousDefaultImage" datasource = "#application.datasource#">
                UPDATE 
                    tblProductImages 
                SET 
                    fldDefaultImage = 0
                WHERE 
                    fldProductImage_ID = <cfqueryparam value = "#arguments.previousSelectedImageId#" cfsqltype = "cf_sql_integer">
                    AND fldCreatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfreturn "Success">
        <cfcatch type="exception">
            <cfdump  var="#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>

    <!--- DELETE IMAGE SUB FUNCTION --->
    <cffunction  name="imageDeleteFunction" access = "private" returntype = "any">
        <cfargument name = "imageId" type = "integer" required = "true">
        <cftry>
            <cfquery result = "local.qryImageDelete" datasource = "#application.datasource#">
                UPDATE 
                    tblProductImages
                SET 
                    fldActive = 0,
                    fldDefaultImage = 0,
                    fldDeactivatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                    fldDeactivatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                WHERE 
                    fldProductImage_ID = <cfqueryparam value = "#arguments.imageId#" cfsqltype = "cf_sql_integer">
                    AND fldCreatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfquery name = "local.qryGetProductImageName" datasource = "#application.datasource#">
                SELECT
                    fldImageFileName
                FROM 
                    tblProductImages 
                WHERE
                    fldProductImage_ID = <cfqueryparam value = "#arguments.imageId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cffile  
                action="delete" 
                file = "#application.imageSavePath#\#local.qryGetProductImageName.fldImageFileName#"
            >
            <cfreturn local.qryImageDelete.recordCount >      
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---  DELETE IMAGE    --->
    <cffunction  name="deleteImage" access = "public" returntype = "any" returnformat = "json">
        <cfargument  name="imageId" type = "integer" required = "true">
        <cfargument  name="productId" type = "integer" required = "true">
        <cftry>
            <cfset local.productImageCount  = getProductImageCount(productId = arguments.productId) >
            <cfif local.productImageCount LE 3 >
                <cfreturn "*Atleast 3 Images required" >
            <cfelse>
                <cfquery name = "local.qryCheckDefaultImg" datasource = "#application.datasource#">
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
                        <cfquery name = "local.qryGetNextDefaultImage" datasource = "#application.datasource#">
                            SELECT 
                                fldProductImage_ID 
                            FROM    
                                tblProductImages
                            WHERE 
                                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                                AND fldActive = 1
                            ORDER BY 
                                fldProductImage_ID ASC 
                            LIMIT 1
                        </cfquery>
                        <cfquery name = "local.qryChangeDefaultImage" datasource = "#application.datasource#">
                            UPDATE 
                                tblProductImages 
                            SET 
                                fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                            WHERE
                                fldProductImage_ID = <cfqueryparam value = "#local.qryGetNextDefaultImage.fldProductImage_ID#" cfsqltype = "cf_sql_integer">
                                AND fldActive = 1
                                AND fldCreatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
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
            <cfquery result = "local.qryDeleteProduct" datasource = "#application.datasource#">
                UPDATE 
                    tblProduct
                SET 
                    fldActive = <cfqueryparam value = "0" cfsqltype = "cf_sql_tinyint">
                WHERE
                    fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                    AND fldCreatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfif local.qryDeleteProduct.recordCount EQ 1 >
                <cfquery name = "local.qryDeleteFromCart" datasource = "#application.datasource#">
                    UPDATE 
                        tblCart 
                    SET 
                        fldQuantity = 0
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfquery name = "local.qryDeleteProductImages" datasource = "#application.datasource#">
                    UPDATE 
                        tblProductImages 
                    SET 
                        fldActive = 0 ,
                        fldDefaultImage = 0,
                        fldDeactivatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                        fldDeactivatedDate  = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfreturn "Success">
            <cfelse>
                <cfreturn "Failed" >
            </cfif>
        <cfcatch type="exception">
            <cfdump  var="#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>

    <!--- GET RANDOM PRODUCTS   --->
    <cffunction name = "getRandomProducts" access = "public" returntype = "any">
        <cftry>
            <cfquery name = "local.qryGetRandomProducts" datasource = "#application.datasource#">
                SELECT 
                    P.fldProduct_ID AS idProduct,
                    P.fldProductName,
                    P.fldBrandId,
                    SC.fldSubCategoryName,
                    B.fldBrandName,
                    P.fldPrice,
                    IMG.fldDefaultImage,
                    IMG.fldImageFileName
                FROM
                    tblProduct AS P
                    INNER JOIN tblSubCategory AS SC ON SC.fldSubCategory_ID = P.fldSubCategoryId
                    INNER JOIN tblBrands AS B ON B.fldBrand_ID = P.fldBrandId
                    INNER JOIN tblProductImages AS IMG ON IMG.fldProductId = P.fldProduct_ID
                WHERE
                    P.fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                    AND IMG.fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                ORDER BY RAND()
                LIMIT 4
            </cfquery>
            <cfif local.qryGetRandomProducts.recordCount GT 0 >
                <cfreturn local.qryGetRandomProducts>
            <cfelse>
                <cfreturn "No product exist">
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry> 
    </cffunction>

    <!---  GET PRODUCT WITH DEFAULT IMAGE    --->
    <cffunction name = "getProductWithDefaultImage" access = "public" returntype = "any">
        <cfargument name = 'subCategoryID' type = "integer" required = "false">
        <cfargument name = "productId" type = "integer" required = "false">
        <cfargument name = "productOrder" type = "integer" required = "false">
        <cftry>
            <cfquery name = "local.qryGetProductWithDefaultImage" datasource = "#application.datasource#">
                SELECT 
                    p.fldProduct_ID AS idProduct,
                    p.fldProductName,
                    p.fldDescription,
                    p.fldBrandId,
                    sc.fldSubCategoryName,
                    b.fldBrandName,
                    p.fldPrice,
                    p.fldTax,
                    img.fldDefaultImage,
                    img.fldImageFileName
                FROM
                    tblProduct AS p
                    INNER JOIN tblSubCategory AS sc ON sc.fldSubCategory_ID = p.fldSubCategoryId
                    INNER JOIN tblBrands AS b ON b.fldBrand_ID = p.fldBrandId
                    INNER JOIN tblProductImages AS img ON img.fldProductId = p.fldProduct_ID
                WHERE
                    p.fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                    AND img.fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                    <cfif structKeyExists(arguments, 'subCategoryID')>
                        AND p.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryID#" cfsqltype = "cf_sql_integer">
                        <cfif structKeyExists(arguments, 'productOrder') AND arguments.productOrder EQ 1>
                            ORDER BY p.fldPrice DESC
                        <cfelseif structKeyExists(arguments, 'productOrder') AND arguments.productOrder EQ 0>
                            ORDER BY p.fldPrice ASC
                        </cfif>
                    <cfelseif structKeyExists(arguments, 'productId')>
                        AND p.fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                    </cfif>               
            </cfquery>
            <cfif local.qryGetProductWithDefaultImage.recordCount GT 0>
                <cfreturn local.qryGetProductWithDefaultImage>
            <cfelse>
                <cfreturn "No products exist">
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!--- PRODUCT SEARCH    --->
    <cffunction name = "getSearchedProduct" access = "public" returntype = "any">
        <cfargument name = "searchWord" type = "any" required = "true">
        <cftry>
            <cfquery name = "local.qrySearchProduct" datasource = "#application.datasource#">
                SELECT 
                    P.fldProduct_ID AS idProduct,
                    P.fldProductName,
                    P.fldDescription,
                    P.fldBrandId,
                    IMG.fldDefaultImage,
                    SC.fldSubCategoryName,
                    B.fldBrandName,
                    P.fldPrice,
                    IMG.fldImageFileName
                FROM
                    tblProduct AS P
                    INNER JOIN tblSubCategory AS SC ON SC.fldSubCategory_ID = P.fldSubCategoryId
                    INNER JOIN tblBrands AS B ON B.fldBrand_ID = P.fldBrandId
                    INNER JOIN tblProductImages AS IMG ON IMG.fldProductId = P.fldProduct_ID
                WHERE
                    P.fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                    AND IMG.fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                    AND P.fldProductName LIKE <cfqueryparam value = "%#lCase(arguments.searchWord)#%" cfsqltype = "cf_sql_varchar">
                    OR P.fldDescription LIKE <cfqueryparam value = "%#lCase(arguments.searchWord)#%" cfsqltype = "cf_sql_varchar">                
            </cfquery>
            <cfreturn local.qrySearchProduct>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>

    <!---   FILTER PRODUCTS  --->
    <cffunction name = "getFilteredProduct" access = "public" returntype = "any">
        <cfargument name = 'subCategoryID' type = "integer" required = "true">
        <cfargument name = "minPrice" type = "integer" required = "true">
        <cfargument name = "maxPrice" type = "integer" required = "true">
        <cftry>
            <cfquery name = "local.qryGetFilteredProduct" datasource = "#application.datasource#">
                SELECT 
                    P.fldProduct_ID AS idProduct,
                    P.fldProductName,
                    P.fldDescription,
                    P.fldBrandId,
                    SC.fldSubCategoryName,
                    B.fldBrandName,
                    P.fldPrice,
                    IMG.fldDefaultImage,
                    IMG.fldImageFileName
                FROM
                    tblProduct AS P
                    INNER JOIN tblSubCategory AS SC ON SC.fldSubCategory_ID = P.fldSubCategoryId
                    INNER JOIN tblBrands AS B ON B.fldBrand_ID = P.fldBrandId
                    INNER JOIN tblProductImages AS IMG ON IMG.fldProductId = P.fldProduct_ID
                WHERE
                    P.fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                    AND IMG.fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                    AND P.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryID#" cfsqltype = "cf_sql_integer">               
                    AND P.fldPrice BETWEEN <cfqueryparam value = "#arguments.minPrice#" cfsqltype = "cf_sql_decimal"> 
                        AND <cfqueryparam value = "#arguments.maxPrice#" cfsqltype = "cf_sql_decimal">
            </cfquery>
            <cfif local.qryGetFilteredProduct.recordCount GT 0>
                <cfreturn local.qryGetFilteredProduct>
            <cfelse>
                <cfreturn "No products exist">
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---    PRODUCTS --->
    <cffunction name = "getProuductsDetails" access = "public" returntype = "any">
        <cfargument  name = "categoryId" type = "numeric" required = "false">
        <cfargument name = 'subCategoryID' type = "numeric" required = "false">
        <cfargument name = "productId" type = "numeric" required = "false">
        <cfargument name = "productOrder" type = "numeric" required = "false">
        <cftry>
            <cfquery name = "local.qryGetProuductsDetails" datasource = "#application.datasource#">
                SELECT 
                    P.fldProduct_ID AS idProduct,
                    P.fldProductName,
                    P.fldDescription,
                    P.fldBrandId,
                    SC.fldSubCategoryName,
                    SC.fldSubCategory_ID,
                    B.fldBrandName,
                    P.fldPrice,
                    P.fldTax,
                    IMG.fldDefaultImage,
                    IMG.fldImageFileName,
                    C.fldCategory_ID,
                    C.fldCategoryName
                FROM
                    tblProduct AS P
                    INNER JOIN tblSubCategory AS SC ON SC.fldSubCategory_ID = P.fldSubCategoryId
                    INNER JOIN tblCategory AS C ON C.fldCategory_ID = SC.fldCategoryId
                    INNER JOIN tblBrands AS B ON B.fldBrand_ID = P.fldBrandId
                    INNER JOIN tblProductImages AS IMG ON IMG.fldProductId = P.fldProduct_ID
                WHERE
                    P.fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                    AND IMG.fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">
                    <cfif structKeyExists(arguments, 'categoryId')>
                        AND C.fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                    <cfelseif structKeyExists(arguments, 'subCategoryID')>
                        AND P.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryID#" cfsqltype = "cf_sql_integer">
                    <cfelseif structKeyExists(arguments, 'productId')>
                        AND P.fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">
                    </cfif>   
                ORDER BY SC.fldSubCategory_ID,idProduct           
            </cfquery>
            <cfreturn local.qryGetProuductsDetails>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>