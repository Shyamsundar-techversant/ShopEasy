<cfcomponent>
    <!---  CATEGORY CHECK    --->
    <cffunction  name="checkCategory" access = "public" returntype = "string">
        <cfargument name = "categoryName" type = "string" required = "true" >
        <cftry>
            <cfquery name = "local.checkCategory" datasource = "shoppingcart">
                SELECT 
                    fldCategoryName                             
                FROM 
                    tblCategory
                WHERE 
                    fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "cf_sql_varchar" >
                AND 
                    fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer" >
            </cfquery>
            <cfif local.checkCategory.recordCount GT 0 >
                <cfreturn "true">
            <cfelse>
                <cfreturn "false">
            </cfif>
        <cfcatch>
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---  ADD EDIT CATEGORY    --->
    <cffunction  name="categoryAddEdit" access = "public" returntype = "any">
        <cfargument name = "categName" type = "string" required = "true" >
        <cfargument name = "categoryId" type = "integer" required = "false">
        <cfset local.result = "">
        <cfif NOT structKeyExists(arguments, "categoryId")>
            <cftry>          
                <cfquery datasource = "shoppingcart" result ="local.addCategory">
                    INSERT INTO 
                            tblCategory(
                                fldCategoryName,
                                fldActive,
                                fldCreatedById,
                                fldUpdatedById,
                                fldUpdatedDate
                            )
                    VALUES(
                            <cfqueryparam value = "#arguments.categName#" cfsqltype = "cf_sql_varchar">,
                            <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                        )

                </cfquery>
                <cfif local.addCategory.recordCount EQ 1>
                    <cfset local.result = "Success">
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

    <!---  GET  CATEGORY    --->
    <cffunction name = "getCategory" access = "public" returntype = "any">
        <cfargument  name="categoryId" type = "integer" required = "false">

        <cftry>
            <cfquery name = "local.getCategory" datasource = "shoppingcart">
                SELECT 
                    fldCategory_ID,
                    fldCategoryName
                FROM 
                    tblCategory
                <cfif structKeyExists(arguments, "categoryId")>
                    WHERE
                        fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">
                    AND
                        fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                <cfelse>
                    WHERE
                        fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">                
                </cfif>
            </cfquery>
            <cfreturn local.getCategory>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---  DELETE CATEGORY    --->
    <cffunction name = "deleteCategory" access = "remote" returntype = "any">
        <cfargument name = "categoryId" type = "integer" required = "true">
        <cfset local.result = " " >
        <cftry>
            <cfquery result = "local.categoryDelete" datasource = "shoppingcart">
                UPDATE 
                    tblCategory
                SET 
                    fldActive = <cfqueryparam value = "0" cfsqltype ="cf_sql_integer" >,
                    fldUpdatedById = <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_varchar">,
                    fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                WHERE 
                    fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer" >
                AND
                    fldCreatedById = <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer" >
            </cfquery>
            <cfif local.categoryDelete.recordCount EQ 1>
                <cfset local.result = "Success">
            <cfelse>
                <cfset local.result = "Failed" >
            </cfif>
            <cfreturn local.result >
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>


    <!---   SUB CATEGORY CHECK   --->
    <cffunction  name="checkSubCategory" access = "public" returntype = "string">
        <cfargument name = "subCategoryName" type = "string" required = "true" >
        <cfargument name = "categoryId" type = "integer" required = "true" >

        <cftry>
            <cfquery name = "local.checkSubCategory" datasource = "shoppingcart">
                SELECT 
                    fldSubCategoryName                             
                FROM 
                    tblSubCategory
                WHERE 
                    fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "cf_sql_varchar" >
                AND 
                    fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer" >
                AND
                    fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfif local.checkSubCategory.recordCount GT 0 >
                <cfreturn "true">
            <cfelse>
                <cfreturn "false">
            </cfif>
        <cfcatch>
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---   SUBCATEGORY ADD EDIT   --->
    <cffunction  name="subCategoryAddEdit" access = "public" returntype = "any">
        <cfargument name = "subCategName" type = "string" required = "true" >
        <cfargument name = "subCategoryId" type = "integer" required = "false">
        <cfargument name = "categoryId" type = "integer" required = "true">
        <cfset local.result = "">
        <cfif NOT structKeyExists(arguments, "subCategoryId")>
            <cftry>          
                <cfquery datasource = "shoppingcart" result ="local.addSubCategory">
                    INSERT INTO 
                            tblSubCategory(
                                fldCategoryId,
                                fldSubCategoryName,
                                fldActive,
                                fldCreatedById,
                                fldUpdatedById,
                                fldUpdatedDate
                                
                            )
                    VALUES(
                            <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_varchar">,
                            <cfqueryparam value = "#arguments.subCategName#" cfsqltype = "cf_sql_varchar">,
                            <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                        )

                </cfquery>
                <cfif local.addSubCategory.recordCount EQ 1>
                    <cfset local.result = "Success">
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
                <cfquery result = "local.editSubCateg" datasource = "shoppingcart">
                    UPDATE
                        tblSubCategory
                    SET 
                        fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">,
                        fldSubCategoryName = <cfqueryparam value = "#arguments.subCategName#" cfsqltype = "cf_sql_varchar">,
                        fldUpdatedById = <cfqueryparam value = "#session.adminId#" cfsqltype ="cf_sql_integer" >,
                        fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date" >
                    WHERE 
                        fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">
                    AND 
                        fldCreatedById = <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfif local.editSubCateg.recordCount EQ 1>
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

    <!---  GET SUB CATEGORY    --->
    <cffunction name = "getSubCategory" access = "public" returntype = "any">
        <cfargument name ="subCategoryId" type = "integer" required = "false">
        <cfargument name = "categoryId" type = "integer" required = "true" >
        <cftry>
            <cfquery name = "local.getSubCategory" datasource = "shoppingcart">
                SELECT 
                    fldSubCategory_ID,
                    fldSubCategoryName
                FROM 
                    tblSubCategory
                <cfif structKeyExists(arguments, "subCategoryId")>
                    WHERE
                        fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">
                    AND
                        fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                    AND
                        fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">
                <cfelse>
                    WHERE
                        fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                    AND
                        fldCategoryId =<cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">                
                </cfif>
            </cfquery>
            <cfreturn local.getSubCategory>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>   

    <!---   DELETE SUBCATEGORY   --->
    <cffunction name = "deleteSubCategory" access = "remote" returntype = "any">
        <cfargument name = "subCategoryId" type = "integer" required = "true">
        <cfset local.result = " " >
        <cftry>
            <cfquery result = "local.subCategoryDelete" datasource = "shoppingcart">
                UPDATE 
                    tblSubCategory
                SET 
                    fldActive = <cfqueryparam value = "0" cfsqltype ="cf_sql_integer" >,
                    fldUpdatedById = <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_varchar">,
                    fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                WHERE 
                    fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer" >
                AND
                    fldCreatedById = <cfqueryparam value = "#session.adminId#" cfsqltype = "cf_sql_integer" >
            </cfquery>
            <cfif local.subCategoryDelete.recordCount EQ 1>
                <cfset local.result = "Success">
            <cfelse>
                <cfset local.result = "Failed" >
            </cfif>
            <cfreturn local.result >
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>