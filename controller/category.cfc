<cfcomponent>
    <!--- ENCRYPTION FUNCTION --->
    <cffunction name = "encryptionFunction" access = "public" returntype = "string">
        <cfargument name = 'objectId' type = "numeric" required = "true">
        <cfset local.secretKey = 'JeMW98F14GHPkpOV47jhaw=='>
        <cfset local.encryptedId = encrypt(
            arguments.objectId,
            application.encryptionKey,
            "AES",
            "Hex"
        )>
        <cfreturn local.encryptedId>
    </cffunction> 

    <!---  DECRYPTION FUNCTION    --->
    <cffunction name = "decryptionFunction" access = "public" returntype = "numeric">
        <cfargument name = "encryptedId" type = "any" required = "false">
<!---         <cfset local.secretKey = 'JeMW98F14GHPkpOV47jhaw=='> --->
        <cfif arguments.encryptedId NEQ "" AND len(arguments.encryptedId) MOD 16 EQ 0>
            <cfset local.decryptedId = decrypt(
                arguments.encryptedId,
                application.encryptionKey,
                "AES",
                "Hex"
            )>
            <cfreturn local.decryptedId>
        <cfelse>
            <cfreturn 0>
        </cfif>
    </cffunction>

    <!---  VALIDATE CATEGORY  --->
    <cffunction  name="validateCategoryName" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "categoryName" type = "string" required = "true">
        <cfargument name = "categoryId" type = "string" required = "false" >
            <cfset local.errors = [] >
            <!---      VALIDATE CATEGORY ID        --->
            <cfif structKeyExists(arguments,"categoryId")>
                <cfset local.decryptedCategoryId = decryptionFunction(arguments.categoryId)>
                <cfif local.decryptedCategoryId EQ 0 >
                    <cfset arrayAppend(local.errors, "*Invalid data") >
                </cfif>
            </cfif>
            <!---       VALIDATE CATEGORY NAME        --->
            <cfif structKeyExists(arguments, "categoryName")>
                <cfif len(trim(arguments.categoryName)) EQ 0>
                    <cfset arrayAppend(local.errors,"*Enter the category name")>
                </cfif>
                <cfset  local.categExist = application.categModObj.checkCategory(
                    categoryName = trim(arguments.categoryName)
                )>
                <cfif local.categExist EQ "true">
                    <cfset arrayAppend(local.errors,"*Category already exist")>
                </cfif>
            </cfif>
            <cfif arrayLen(local.errors) GT 0 >
                <cfreturn local.errors >
            <cfelse>
                <cfif structKeyExists(arguments, "categoryId") >
                    <cfset arguments.categoryId = local.decryptedCategoryId >
                </cfif>               
                <cfset local.categAddEditResult = application.categModObj.categoryAddEdit(
                    argumentCollection = arguments
                )>
                <cfif local.categAddEditResult EQ "Success">
                    <cfset local.result = "Success">
                    <cfreturn local.result>
                <cfelse>
                    <cfset arrayAppend(local.errors,"Invalid data") >
                    <cfreturn local.errors >
                </cfif>
            </cfif>
    </cffunction>

    <!---  GET CATEGORY  --->
    <cffunction name = "getCategory" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "categoryId" type = "string" required = "false">
        <cftry>
            <cfif structKeyExists(arguments, "categoryId")>
                <cfset local.decryptedCategoryId = decryptionFunction(arguments.categoryId)>
                <cfset local.categoryData = application.categModObj.getCategory(
                    categoryId = local.decryptedCategoryId
                )>
                <cfset local.categoryDataById = {
                    'fldCategoryName' = local.categoryData.fldCategoryName,
                    'fldCategory_ID' = local.categoryData.fldCategory_ID
                }>
                <cfreturn local.categoryDataById>
            <cfelse>
                <cfset local.categoryData = application.categModObj.getCategory()>
                <cfreturn local.categoryData >
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---  DELETE CATEGORY    --->
    <cffunction name = "categoryDelete" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "categoryId" type = "string" required = "true">
        <cfset local.result = " " >
        <cfset local.decryptedCategoryId = decryptionFunction(arguments.categoryId)>
        <cfset local.deleteResult = application.categModObj.deleteCategory(
            categoryId = local.decryptedCategoryId
        )>
        <cfif local.deleteResult EQ "Success">
            <cfset local.result = "Success">
        <cfelse>
            <cfset local.result = "Failed">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <!---  SUBCATEGORY VALIDATION   --->
    <cffunction  name="validateSubCategory" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "subCategoryName" type = "string" required = "true">
        <cfargument name = "subCategoryId" type = "string" required = "false" >
        <cfargument name = "categoryId" type = "string" required = "true" >       
        <cfset local.errors = [] >
        <!---    VALIDATE CATEGORY ID      --->
        <cfset local.decryptedCategoryId = decryptionFunction(
            arguments.categoryId
        )>
        <cfif local.decryptedCategoryId EQ 0>
            <cfset arrayAppend(local.errors, "*Invalid Category")>
        <cfelse>
            <cfset arguments.categoryId = local.decryptedCategoryId>
        </cfif>
        <!---     CATEGORY VALIDATION     --->
        <cfset local.allCategory = application.categModObj.getCategory()>
        <cfset local.categoryList = valueList(local.allCategory.fldCategory_ID) >
        <cfset local.categoryExist = listFind(local.categoryList,arguments.categoryId)>
        <cfif NOT local.categoryExist>
            <cfset arrayAppend(local.errors, "*Category does not exist")>
        </cfif>
        <!---    SUBCATEGORY NAME VALIDATION      --->
        <cfif structKeyExists(arguments, "subCategoryName")>
            <cfif len(trim(arguments.subCategoryName)) EQ 0>
                <cfset arrayAppend(local.errors,"*Enter the category name")>
            </cfif>
            <cfif local.decryptedCategoryId NEQ 0>
                <cfset  local.subCategExist = application.categModObj.checkSubCategory(
                    subCategoryName = trim(arguments.subCategoryName),
                    categoryId = arguments.categoryId
                )>
                <cfif local.subCategExist EQ "true">
                    <cfset arrayAppend(local.errors,"*SubCategory already exist")>
                </cfif>
            </cfif>
        </cfif>
        <cfif arrayLen(local.errors) GT 0 >
            <cfreturn local.errors >
        <cfelse>
            <cfif structKeyExists(arguments, "subCategoryId") >
                <cfset local.decryptedSubCategoryId = decryptionFunction(arguments.subCategoryId)>
                <cfset arguments.subCategoryId = local.decryptedSubCategoryId >

            </cfif>
            <cfset local.subCategAddEditResult = application.categModObj.subCategoryAddEdit(
                argumentCollection = arguments
            )> 
            <cfif local.subCategAddEditResult EQ "Success">
                <cfset local.result = "Success">
                <cfreturn local.result>
            <cfelse>
                <cfset arrayAppend(local.errors,"Invalid data") >
                <cfreturn local.errors >
            </cfif>
        </cfif>
    </cffunction>

    <!---  GET SUBCATEGORY    --->
    <cffunction name = "getSubCategory" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "subCategoryId" type = "string" required = "false" >
        <cfargument name = "categoryId" type = "string" required = "true" >
        <cfset arguments.categoryId = decryptionFunction(arguments.categoryId)>
        <cftry>
            <cfif structKeyExists(arguments, "subCategoryId")>
                <cfset local.decryptedSubCategoryId = decryptionFunction(arguments.subCategoryId)>
                <cfset local.subCategoryData = application.categModObj.getSubCategory(
                    subCategoryId = local.decryptedSubCategoryId,
                    categoryId = arguments.categoryId
                )>
                <cfset local.subCategoryDataById = {
                    'fldSubCategoryName' = local.subCategoryData.fldSubCategoryName,
                    'fldSubCategory_ID' = local.subCategoryData.fldSubCategory_ID
                }>
                <cfreturn local.subCategoryDataById>
            <cfelse>
                <cfset local.subCategoryData = application.categModObj.getSubCategory(
                    categoryId = arguments.categoryId
                )>
                <cfreturn local.subCategoryData >
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---   DELETE SUBCATEGORY   --->
    <cffunction name = "subCategoryDelete" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "subCategoryId" type = "string" required = "true">
        <cfset local.result = " " >
        <cfset local.decryptedSubCategoryId = decryptionFunction(arguments.subCategoryId)> 
        <cfset local.deleteResult = application.categModObj.deleteSubCategory(
            subCategoryId = local.decryptedSubCategoryId
        )>
        <cfif local.deleteResult EQ "Success">
            <cfset local.result = "Success">
        <cfelse>
            <cfset local.result = "Failed">
        </cfif>
        <cfreturn local.result>
    </cffunction>    

    <!---  GET CATEGORY AND SUBCATEGORY    --->
    <cffunction  name = "getCategoryAndSubCategory" access = "public" returntype = "any">
        <cfset local.getCategoryAndSubCategory = application.categModObj.getCategoryAndSubCategory()>  
        <cfif local.getCategoryAndSubCategory.recordCount GT 0>
            <cfreturn local.getCategoryAndSubCategory>
        <cfelse>
            <cfreturn "No category exist">
        </cfif>
    </cffunction>
    
</cfcomponent>