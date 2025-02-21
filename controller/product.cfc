<cfcomponent>
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
        <cfargument name = "categoryId" type = "numeric" required = "true" >
        <cfargument name = "subCategoryId" type = "numeric" required = "true" >
        <cfargument name = "productId" type = "numeric" required = "false" >
        <cfargument name = "productName" type = "string" required = "true">
        <cfargument name = "productBrand" type = "numeric" required = "true">
        <cfargument name = "productDescription" type = "string" required = "true">
        <cfargument name = "productPrice" type = "string" required = "true">
        <cfargument name = "productTax" type = "string" required = "true" >
        <cfargument name = "productImages" type = "any" required = "false">
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
            )>
            <cfset local.subCategoryList = valueList(local.allSubCategory.fldSubCategory_ID) >
            <cfset local.subCategoryExist = listFind(local.subCategoryList,arguments.subCategoryId) >
            <cfif NOT local.subCategoryExist >
                <cfset arrayAppend(local.errors, "*Subcateogry does not exist") >
                <cfset local.checkSubCategVar = 0>
            </cfif>
        </cfif>
        <!---    PRODUCT NAME VALIDATION   ---> 
        <cfif structKeyExists(arguments, "productName")>
            <cfif len(trim(arguments.productName)) EQ 0>
                <cfset arrayAppend(local.errors,"*Enter the product name")>
            </cfif>
            <cfif local.checkSubCategVar NEQ 0 AND local.checkBrandVar NEQ 0>
                <cfset  local.productExist = application.productModObj.checkProductExist(
                    subCategoryId= trim(arguments.subCategoryId),
                    brandId = arguments.productBrand,
                    productName = arguments.productName
                )>
                <cfif local.productExist EQ "true">
                    <cfif NOT structKeyExists(arguments, "productId")>
                        <cfset arrayAppend(local.errors,"*Product with this subCategory already exist")>
                    </cfif>
                </cfif>
            </cfif>
        </cfif>
        <!---    VALIDATE PRODUCT DESCRIPTION      --->
        <cfif len(trim(arguments.productDescription)) EQ 0>
            <cfset arrayAppend(local.errors,"*Product description is required")>
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
        <cfif arrayLen(local.errors) GT 0 >
            <cfreturn local.errors >
        <cfelse>
            <!---     PRODUCT ADD EDIT FUNCTION CALL     --->
            <cfset local.productAddEditResult = application.productModObj.productAddEdit(
                argumentCollection = arguments
            )> 
            <cfif isArray(local.productAddEditResult)>
                <cfreturn local.productAddEditResult>
            <cfelseif local.productAddEditResult EQ "Success">
                <cfset local.result = "Success">
                <cfreturn local.result>
            <cfelse>
                <cfset arrayAppend(local.errors,local.productAddEditResult) >
                <cfreturn local.errors >
            </cfif> 
        </cfif> 
    </cffunction>

    <!--- GET PRODUCTS     --->
    <cffunction name = "getProduct" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "subCategoryId" type = "string" required = "true">
        <cfargument name = "productId" type = "integer" required = "false">
        <cfset arguments.subCategoryId = application.cateContObj.decryptionFunction(arguments.subCategoryId)>
        <cfif structKeyExists(arguments, "productId")>
            <cfset local.productData = application.productModObj.getProduct(
                subCategoryId = arguments.subCategoryId,
                productId = arguments.productId   
            )>
            <cfreturn local.productData>
        <cfelse>
            <cfset local.productData = application.productModObj.getProduct(
                subCategoryId = arguments.subCategoryId     
            )>
            <cfreturn local.productData> 
        </cfif>
    </cffunction>

    <!--- CHANGE DEFAULT IMAGE --->
    <cffunction name = "changeDefaultImage" access = "remote" returntype = "any">
        <cfargument name = "defaultImageId" type = "integer" required = "true">
        <cfargument name = "previousSelectedImageId" type = "integer" required = "true">
        <cfset local.defaultImageChangeResult = application.productModObj.changeDefaultImage(
            argumentCollection = arguments
        )>
        <cfif local.defaultImageChangeResult EQ "Success">
            <cfreturn "Success">
        </cfif>
    </cffunction>

    <!---  DELETE IMAGE    --->
    <cffunction  name = "deleteImage" access = "remote" returntype = "any" returnformat = "json">
        <cfargument  name = "imageId" type = "integer" required = "true">
        <cfargument  name = "productId" type = "integer" required = "true">        
        <cfset local.errors = []>
        <cfset local.deleteImageResult = application.productModObj.deleteImage(
            imageId = arguments.imageId,
            productId = arguments.productId
        )>
        <cfif local.deleteImageResult EQ "Success">
            <cfreturn "Success">
        <cfelse>
            <cfset arrayAppend(local.errors, local.deleteImageResult)>
            <cfreturn local.errors>
        </cfif>
    </cffunction>

    <!--- DELETE PRODUCT --->
    <cffunction  name="deleteProduct" access = "remote" returntype = "string" returnformat = "json">
        <cfargument name = "productId" type = "integer" required = "true">
        <cfset local.productDeleteResult = application.productModObj.deleteProduct(
            productId = arguments.productId
        )>
        <cfif local.productDeleteResult EQ "Success">
            <cfreturn "Success">
        <cfelse>
            <cfreturn "Failed">
        </cfif>
    </cffunction>

    <!--- GET RANDOM PRODUCTS   --->
    <cffunction name = "getRandomProducts" access = "public" returntype = "any">
        <cfset local.randomProducts = application.productModObj.getRandomProducts()>
        <cfreturn local.randomProducts >
    </cffunction>

    <!---  GET PRODUCT WITH DEFAULT IMAGE    --->
    <cffunction name = "getProductWithDefaultImage" access = "public" returntype = "any">
        <cfargument name = 'subCategoryID' type = "string" required = "false">
        <cfargument name = "productId" type = "string" requird = "false">
        <cfargument name = "productOrder" type = "integer" required = "false">
        <cfif structKeyExists(arguments,'subCategoryID')>
            <cfset arguments.subCategoryID = application.cateContObj.decryptionFunction(arguments.subCategoryID)>
            <cfif NOT structKeyExists(arguments, 'productOrder')>
                <cfset local.getProduct = application.productModObj.getProductWithDefaultImage(
                    subCategoryID = arguments.subCategoryID
                )>
            <cfelse>
                <cfset local.getProduct = application.productModObj.getProductWithDefaultImage(
                    subCategoryID = arguments.subCategoryID,
                    productOrder = arguments.productOrder
                )>
            </cfif>
        <cfelseif structKeyExists(arguments,"productId")>
            <cfset arguments.productId = application.cateContObj.decryptionFunction(arguments.productId)>
            <cfset local.getProduct = application.productModObj.getProductWithDefaultImage(
                productId = arguments.productId
            )>           
        </cfif>
        <cfreturn local.getProduct>
    </cffunction>

    <!--- PRODUCT SEARCH    --->
    <cffunction name = "getSearchedProduct" access = "public">
        <cfargument name = "searchText" type = "string" required = "true">
        <cfset local.searchResult = application.productModObj.getSearchedProduct(
            searchWord = arguments.searchText
        )>
        <cfset session['searchText'] = arguments.searchText>
        <cfif local.searchResult.recordCount GT 0>
            <cfreturn local.searchResult>
        <cfelse>
            <cfreturn "No product Exist">
        </cfif>
    </cffunction>

    <!---   FILTER PRODUCTS  --->
    <cffunction name = "getFilteredProduct" access = "public" returntype = "any">
        <cfargument name = 'subCategoryID' type = "string" required = "true">
        <cfargument name = "minPrice" type = "integer" required = "true">
        <cfargument name = "maxPrice" type = "integer" required = "true">
        <cfset arguments.subCategoryID = application.cateContObj.decryptionFunction(arguments.subCategoryID)>
        <cfif arguments.maxPrice LT arguments.minPrice>
            <cfreturn "Max price must be greater than Min price">
        <cfelseif arguments.maxPrice LT 0 OR arguments.minPrice LT 0>
            <cfreturn "Max and Min price must not equal to zero">
        </cfif>
        <cfset local.productFilterResult = application.productModObj.getFilteredProduct(
            subCategoryID = arguments.subCategoryID,
            minPrice = arguments.minPrice,
            maxPrice = arguments.maxPrice
        )>
        <cfreturn local.productFilterResult>
    </cffunction>
    
    <!---    PRODUCT LIST  --->
    <cffunction name = "getProuductsDetails" access = "public" returntype = "any">
        <cfargument  name = "categoryId" type = "string" required = "false">
        <cfargument name = 'subCategoryID' type = "string" required = "false">
        <cfargument name = "productId" type = "string" required = "false">
        <cfif structKeyExists(arguments,'categoryId')>
            <cfset arguments.categoryId =  application.cateContObj.decryptionFunction(
                arguments.categoryId
            )>
        <cfelseif structKeyExists(arguments,'subCategoryID')>
            <cfset arguments.subCategoryID =  application.cateContObj.decryptionFunction(
                arguments.subCategoryID
            )>
        <cfelseif structKeyExists(arguments,'productId')>
            <cfset arguments.productId =  application.cateContObj.decryptionFunction(
                arguments.productId
            )>
        </cfif>
        <cfset local.productDetails = application.productModObj.getProuductsDetails(
            argumentCollection = arguments
        )>
        <cfif local.productDetails.recordCount GT 0>
            <cfreturn local.productDetails>
        <cfelse>
            <cfreturn "No productExist">
        </cfif>
    </cffunction>

</cfcomponent>
