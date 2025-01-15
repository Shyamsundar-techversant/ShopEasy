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

    <!---   GET BRANDS   --->
    <cffunction name = "getBrands" access = "public" returntype = "query">
        <cfargument name = "brandId" type = "integer" required = "false">
        <cfif NOT structKeyExists(arguments, 'brandId')>
            <cfset local.brands = application.productModObj.getBrands()>
            <cfreturn local.brands >
        <cfelse>
            <cfset local.brands = application.productModObj.getBrands(brandId = arguments.brandId)>
            <cfreturn local.brands >           
        </cfif>
    </cffunction>

    <!---  PRODUCT VALIDATION    --->
    <cffunction  name = "validateProduct" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "categoryId" type = "integer" required = "true" >
        <cfargument name = "subCategoryId" type = "integer" required = "true" >
        <cfargument name = "productId" type = "integer" required = "false" >
        <cfargument name = "productName" type = "string" required = "true">
        <cfargument name = "productBrand" type = "integer" required = "true">
        <cfargument name = "productDescription" type = "string" required = "true">
        <cfargument name = "productPrice" type = "string" required = "true">
        <cfargument name = "productTax" type = "string" required = "true" >
        <cfargument name = "productImages" type = "any" required = "true">
       

        <cfset local.errors = [] >
        <cfset local.checkCategVar = 1>
        <cfset local.checkSubCategVar = 1>
        <cfset local.checkBrandVar = 1 >
        <!---     CATEGORY VALIDATION     --->
        <cfset local.allCategory = application.categModObj.getCategory()>
        <cfset local.categoryList = valueList(local.allCategory.fldCategory_ID) >
        <cfset local.categoryExist = listFind(local.categoryList,arguments.categoryId)>
        <cfif NOT local.categoryExist>
            <cfset arrayAppend(local.errors, "*Category does not exist")>
            <cfset local.checkCategVar = 0>
        </cfif>

        <!--- SUB CATEGORY VALIDATION --->
        <cfif local.checkCategVar NEQ 0>
            <cfset local.allSubCategory = application.categModObj.getSubCategory(
                                                                            categoryId = arguments.categoryId
                                                                        )
            >
            <cfset local.subCategoryList = valueList(local.allSubCategory.fldSubCategory_ID) >
            <cfset local.subCategoryExist = listFind(local.subCategoryList,arguments.subCategoryId) >
            <cfif NOT local.subCategoryExist >
                <cfset arrayAppend(local.errors, "*Subcateogry does not exist") >
                <cfset local.checkSubCategVar = 0>
            </cfif>
        </cfif>

        <!---     BRAND VALIDATION     --->
        <cfset local.getAllBrands = application.productModObj.getBrands()>
        <cfset local.brandList = valueList(local.getAllBrands.fldBrand_ID) >
        <cfset local.brandExist = listFind(local.brandList, arguments.productBrand) >
        <cfif NOT local.brandExist>
            <cfset arrayAppend(local.errors, "*Brand does not exist") >
            <cfset local.checkBrandVar = 0 >
        </cfif>

        <!---    PRODUCT NAME VALIDATION   ---> 
        <cfif structKeyExists(arguments, "productName")>
            <cfif len(trim(arguments.productName)) EQ 0>
		        <cfset arrayAppend(local.errors,"*Enter the category name")>
		    </cfif>
            <cfif local.checkSubCategVar NEQ 0 AND local.checkBrandVar NEQ 0>
                <cfset  local.productExist = application.productModObj.checkProductExist(
                                            subCategoryId= trim(arguments.subCategoryId),
                                            brandId = arguments.productBrand,
                                            productName = arguments.productName
                                        )

                >
                <cfif local.productExist EQ "true">
                    <cfset arrayAppend(local.errors,"*SubCategory already exist")>
                </cfif>
            </cfif>
        </cfif>

        <!---    VALIDATE PRODUCT DESCRIPTION      --->
		<cfif len(trim(arguments.productDescription)) EQ 0>
			<cfset arrayAppend(local.errors,"*Address is required")>
		</cfif>

        <!--- VALIDATE PRODUCT PRICE   --->
        <cfif NOT isNumeric(arguments.productPrice)>
            <cfset arrayAppend(local.errors,"*Entered price is not a type of number")>
        </cfif>
        <cfif arguments.productPrice LE 0 >
            <cfset arrayAppend(local.errors,"*Product price must be greater than 0")>
        </cfif>

        <!--- VALIDATE PRODUCT TAX --->
        <cfif NOT isNumeric(arguments.productTax)>
            <cfset arrayAppend(local.errors,"*Entered tax is not a type of number")>
        </cfif>
        <cfif arguments.productTax LT 0 >
            <cfset arrayAppend(local.errors,"*Product tax must be greater than or equal to zero")>
        </cfif>

        <!--- VALIDATE   PRODUCT IMAGES    --->
		<cfset local.maxImgSize = 5*1024*1024>
		<cfset local.allowedExtensions = "jpeg,jpg,png,gif">
        <cfset local.uploadedImagePath = [] >
        <cffile  action = "uploadAll"
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
        <cfset arguments['uploadedImgPath'] = local.uploadedImagePath>



        <cfif arrayLen(local.errors) GT 0 >
            <cfreturn local.errors >
        <cfelse>
            <!---     PRODUCT ADD EDIT FUNCTION CALL     --->
            <cfset local.subCategAddEditResult = application.productModObj.productAddEdit(
                                                argumentCollection = arguments
                                            )
            > 
            <cfif local.subCategAddEditResult EQ "Success">
                <cfset local.result = "Success">
                <cfreturn local.result>
            <cfelse>
                <cfset arrayAppend(local.errors,"Invalid data") >
                <cfreturn local.errors >
            </cfif> 
        </cfif> 
    </cffunction>

    <!--- GET PRODUCTS     --->
    <cffunction name = "getProduct" access = "public" returntype = "query">
        <cfargument name = "subCategoryId" type = "string" required = "true">
        <cfargument name = "productId" type = "integer" required = "false">
        <cfset arguments.subCategoryId = decryptionFunction(arguments.subCategoryId)>
        <cfif structKeyExists(arguments, "productId")>

        <cfelse>
            <cfset local.productData = application.productModObj.getProduct(
                                                                    subCategoryId = arguments.subCategoryId     
                                                                )
            >
            <cfreturn local.productData>
        </cfif>

    </cffunction>
</cfcomponent>