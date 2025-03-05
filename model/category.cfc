<cfcomponent>
    <!---  CATEGORY CHECK    --->
    <cffunction  name="checkCategory" access = "public" returntype = "string">
        <cfargument name = "categoryName" type = "string" required = "true" >
        <cftry>
            <cfquery name = "local.qryCheckCategory" datasource = "#application.datasource#">
                SELECT 
                    fldCategoryName                             
                FROM 
                    tblCategory
                WHERE 
                    fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "cf_sql_varchar" >
                    AND fldActive = 1
            </cfquery>
            <cfreturn local.qryCheckCategory.recordCount GT 0 ? "true" : "false">
            <cfif local.qryCheckCategory.recordCount GT 0 >
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
        <cfargument name = "categoryName" type = "string" required = "true" >
        <cfargument name = "categoryId" type = "integer" required = "false">
        <cfset local.result = "">
        <cftry>
            <cfif NOT structKeyExists(arguments, "categoryId")>                      
                <cfquery datasource = "#application.datasource#" result ="local.qryAddCategory">
                    INSERT INTO tblCategory(
                        fldCategoryName,
                        fldActive,
                        fldCreatedById,
                        fldUpdatedById,
                        fldUpdatedDate
                    )VALUES(
                        <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                        NOW()
                    )
                </cfquery>
                <cfif local.qryAddCategory.recordCount EQ 1>
                    <cfset local.result = "Success">
                <cfelse>
                    <cfset local.result = "Failed">
                </cfif>
                <cfreturn local.result>
            <cfelse>
                <cfquery result = "local.qryEditCategory" datasource = "#application.datasource#">
                    UPDATE
                        tblCategory
                    SET 
                        fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "cf_sql_varchar">,
                        fldUpdatedById = <cfqueryparam value = "#session.userId#" cfsqltype ="cf_sql_integer" >,
                        fldUpdatedDate = NOW()
                    WHERE 
                        fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">
                        AND fldCreatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfif local.qryEditCategory.recordCount EQ 1>
                    <cfset local.result = "Success">
                <cfelse>
                    <cfset local.result = "Faileld">
                </cfif>
                <cfreturn local.result>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---  GET  CATEGORY    --->
    <cffunction name = "getCategory" access = "public" returntype = "any">
        <cfargument  name="categoryId" type = "integer" required = "false">
        <cftry>
            <cfquery name = "local.qryGetCategory" datasource = "#application.datasource#">
                SELECT 
                    fldCategory_ID,
                    fldCategoryName
                FROM 
                    tblCategory
                WHERE 
                    fldActive = 1
                    <cfif structKeyExists(arguments, "categoryId")>
                        AND fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">              
                    </cfif>
            </cfquery>
            <cfreturn local.qryGetCategory>
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
            <cfquery result = "local.qryCategoryDelete" datasource = "#application.datasource#">
                UPDATE 
                    tblCategory
                SET 
                    fldActive = 0,
                    fldUpdatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_varchar">,
                    fldUpdatedDate = NOW()
                WHERE 
                    fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer" >
                    AND fldCreatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer" >
                    AND fldActive = 1
            </cfquery>
            <cfif local.qryCategoryDelete.recordCount EQ 1>
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
            <cfquery name = "local.qryCheckSubCategory" datasource = "#application.datasource#">
                SELECT 
                    fldSubCategoryName                             
                FROM 
                    tblSubCategory
                WHERE 
                    fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "cf_sql_varchar" >
                    AND fldActive = 1
                    AND fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfif local.qryCheckSubCategory.recordCount GT 0 >
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
        <cfargument name = "subCategoryName" type = "string" required = "true" >
        <cfargument name = "subCategoryId" type = "integer" required = "false">
        <cfargument name = "categoryId" type = "integer" required = "true">
        <cfset local.result = "">
        <cftry>
            <cfif NOT structKeyExists(arguments, "subCategoryId")>                     
                <cfquery datasource = "#application.datasource#" result ="local.qryAddSubCategory">
                    INSERT INTO tblSubCategory(
                        fldCategoryId,
                        fldSubCategoryName,
                        fldActive,
                        fldCreatedById,
                        fldUpdatedById,
                        fldUpdatedDate                               
                    )VALUES(
                        <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                        NOW()
                    )
                </cfquery>
                <cfif local.qryAddSubCategory.recordCount EQ 1>
                    <cfset local.result = "Success">
                <cfelse>
                    <cfset local.result = "Failed">
                </cfif>
                <cfreturn local.result>
            <cfelse>
                <cfquery result = "local.qryEditSubCategory" datasource = "#application.datasource#">
                    UPDATE
                        tblSubCategory
                    SET 
                        fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">,
                        fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "cf_sql_varchar">,
                        fldUpdatedById = <cfqueryparam value = "#session.userId#" cfsqltype ="cf_sql_integer" >,
                        fldUpdatedDate = NOW()
                    WHERE 
                        fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">
                        AND fldCreatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                </cfquery>
                <cfif local.qryEditSubCategory.recordCount EQ 1>
                    <cfset local.result = "Success">
                <cfelse>
                    <cfset local.result = "Faileld">
                </cfif>
                <cfreturn local.result>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!---  GET SUB CATEGORY    --->
    <cffunction name = "getSubCategory" access = "public" returntype = "any">
        <cfargument name ="subCategoryId" type = "integer" required = "false">
        <cfargument name = "categoryId" type = "integer" required = "true" >
        <cftry>
            <cfquery name = "local.qryGetSubCategory" datasource = "#application.datasource#">
                SELECT 
                    fldSubCategory_ID,
                    fldSubCategoryName
                FROM 
                    tblSubCategory
                WHERE
                    fldActive = 1
                    AND fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">                
                    <cfif structKeyExists(arguments, "subCategoryId")>
                        AND fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">               
                    </cfif>
            </cfquery>
            <cfreturn local.qryGetSubCategory>
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
            <cfquery result = "local.qrySubCategoryDelete" datasource = "#application.datasource#">
                UPDATE 
                    tblSubCategory
                SET 
                    fldActive = 0,
                    fldUpdatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_varchar">,
                    fldUpdatedDate = NOW()
                WHERE 
                    fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer" >
                    AND fldCreatedById = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer" >
            </cfquery>
            <cfif local.qrySubCategoryDelete.recordCount EQ 1>
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

    <!---  GET CATEGORY AND SUBCATEGORY    --->
    <cffunction  name = "getCategoryAndSubCategory" access = "public" returntype = "any">
        <cfargument name ="subCategoryId" type = "integer" required = "false">
        <cfargument name = "categoryId" type = "integer" required = "false">
        <cftry>
            <cfquery name = "local.qryGetCategoryAndSubCategory" datasource = "#application.datasource#">
                SELECT
                    SUB.fldSubCategory_ID,
                    SUB.fldSubCategoryName,
                    CAT.fldCategoryName,
                    CAT.fldCategory_ID
                FROM 
                    tblSubCategory AS SUB
                    INNER JOIN tblCategory AS CAT ON SUB.fldCategoryId = CAT.fldCategory_ID
                        AND CAT.fldActive = 1
                        AND SUB.fldActive = 1  
                <cfif structKeyExists(arguments, 'categoryId') OR structKeyExists(arguments, 'subCategoryId')>
                    WHERE 
                        1 = 1
                        <cfif structKeyExists(arguments, 'categoryId')>
                            AND SUB.fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">
                        </cfif>
                        <cfif structKeyExists(arguments, 'subCategoryId')>
                            AND SUB.fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "cf_sql_integer">
                        </cfif>
                </cfif>
                ORDER BY CAT.fldCategory_ID,SUB.fldSubCategory_ID
            </cfquery>
            <cfreturn local.qryGetCategoryAndSubCategory>
        <cfcatch type="exception">
            <cfdump  var="#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>