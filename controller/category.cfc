<cfcomponent>

    <cffunction  name="validateCategName" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "categName" type = "string" required = "true">
        <cfargument name = "categoryId" type = "string" required = "false" >

            <cfset local.errors = [] >
            <cfif structKeyExists(arguments, "categName")>
                <cfif len(trim(arguments.categName)) EQ 0>
		            <cfset arrayAppend(local.errors,"*Enter the category name")>
		        </cfif>
                <cfset  local.categExist = application.categModObj.checkCategory(
                                                categoryName = trim(arguments.categName)
                                            )

                >
                <cfif local.categExist EQ "true">
                    <cfset arrayAppend(local.errors,"*Category already exist")>
                </cfif>
            </cfif>
            <cfif arrayLen(local.errors) GT 0 >
                <cfreturn local.errors >
            <cfelse>
                <cfif structKeyExists(arguments, "categoryId") >
                    <cfset local.decryptedId = decrypt(
                                                        arguments.categoryId,
                                                        application.encryptionKey,
                                                        "AES",
                                                        "Hex"
                                                    )
                
                    >
                    <cfset arguments.categoryId = local.decryptedId >
                </cfif>
                
                <cfset local.categAddEditResult = application.categModObj.categoryAddEdit(
                                                    argumentCollection = arguments
                                                )
                >
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
        <cfargument name = "categoryId" type = "string" required = "false" >
        <cftry>
            <cfif structKeyExists(arguments, "categoryId")>
                <cfset local.decryptedId = decrypt(
                                                arguments.categoryId,
                                                application.encryptionKey,
                                                "AES",
                                                "Hex"
                                            ) 
                
                >

                <cfset local.categoryData = application.categModObj.getCategory(
                                                            categoryId = local.decryptedId
                                                        )
                >
                <cfset local.categoryDataById = {
                                                'fldCategoryName' = local.categoryData.fldCategoryName,
                                                'fldCategory_ID' = local.categoryData.fldCategory_ID
                                            }           
                >
                <cfreturn local.categoryDataById>
            <cfelse>
                <cfset local.categoryData = application.categModObj.getCategory()>
                <cfreturn local.categoryData >
            </cfif>

            <cfdump var = "#local.categoryData#" >
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---  DELETE CATEGORY    --->
    <cffunction name = "categoryDelete" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "categoryId" type = "string" required = "true">
        <cfset local.result = " " >
        <cfset local.decryptedId = decrypt(
                                        arguments.categoryId,
                                        application.encryptionKey,
                                        "AES",
                                        "Hex"
                                    )

        >
        <cfset local.deleteResult = application.categModObj.deleteCategory(
                                                                            categoryId = local.decryptedId
                                                                        )
        >
        <cfif local.deleteResult EQ "Success">
            <cfset local.result = "Success">
        <cfelse>
            <cfset local.result = "Failed">
        </cfif>
        <cfreturn local.result>
    </cffunction>


    <!---  SUBCATEGORY VALIDATION   --->
    <cffunction  name="validateSubCategoryName" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "subCategName" type = "string" required = "true">
        <cfargument name = "subCategoryId" type = "string" required = "false" >
        <cfargument name = "categoryId" type = "string" required = "true" >
            <cfset local.errors = [] >
            <cfset arguments.categoryId = decrypt(
                                                        arguments.categoryId, 
                                                        application.encryptionKey,
                                                        "AES",
                                                        "Hex"
                                                    )

            >
            <cfif structKeyExists(arguments, "subCategName")>
                <cfif len(trim(arguments.subCategName)) EQ 0>
		            <cfset arrayAppend(local.errors,"*Enter the category name")>
		        </cfif>
                <cfset  local.categExist = application.categModObj.checkSubCategory(
                                                subCategoryName = trim(arguments.subCategName),
                                                categoryId = arguments.categoryId
                                            )

                >
                <cfif local.categExist EQ "true">
                    <cfset arrayAppend(local.errors,"*SubCategory already exist")>
                </cfif>
            </cfif>
            <cfif arrayLen(local.errors) GT 0 >
                <cfreturn local.errors >
            <cfelse>
                <cfif structKeyExists(arguments, "subCategoryId") >
                    <cfset local.decryptedId = decrypt(
                                                        arguments.subCategoryId,
                                                        application.encryptionKey,
                                                        "AES",
                                                        "Hex"
                                                    )
                
                    >
                    <cfset arguments.subCategoryId = local.decryptedId >

                </cfif>
                <cfset local.subCategAddEditResult = application.categModObj.subCategoryAddEdit(
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

    <!---  GET SUBCATEGORY    --->
    <cffunction name = "getSubCategory" access = "remote" returntype = "any" returnformat = "json">
        <cfargument name = "subCategoryId" type = "string" required = "false" >
        <cfargument name = "categoryId" type = "string" required = "true" >

        <cfset arguments.categoryId = decrypt(
                                                    arguments.categoryId, 
                                                    application.encryptionKey,
                                                    "AES",
                                                    "Hex"
                                                )

        >
        <cftry>
            <cfif structKeyExists(arguments, "subCategoryId")>
                <cfset local.decryptedId = decrypt(
                                                arguments.subCategoryId,
                                                application.encryptionKey,
                                                "AES",
                                                "Hex"
                                            ) 
                
                >

                <cfset local.subCategoryData = application.categModObj.getSubCategory(
                                                            subCategoryId = local.decryptedId,
                                                            categoryId = arguments.categoryId
                                                        )
                >
                <cfset local.subCategoryDataById = {
                                                    'fldSubCategoryName' = local.subCategoryData.fldSubCategoryName,
                                                    'fldSubCategory_ID' = local.subCategoryData.fldSubCategory_ID
                                                }           
                >
                <cfreturn local.subCategoryDataById>
            <cfelse>
                <cfset local.subCategoryData = application.categModObj.getSubCategory(
                                                                categoryId = arguments.categoryId
                                                            )
                
                >
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
        <cfset local.decryptedId = decrypt(
                                        arguments.subCategoryId,
                                        application.encryptionKey,
                                        "AES",
                                        "Hex"
                                    )

        >
        <cfset local.deleteResult = application.categModObj.deleteSubCategory(
                                                                            subCategoryId = local.decryptedId
                                                                        )
        >
        <cfif local.deleteResult EQ "Success">
            <cfset local.result = "Success">
        <cfelse>
            <cfset local.result = "Failed">
        </cfif>
        <cfreturn local.result>
    </cffunction>  
</cfcomponent>