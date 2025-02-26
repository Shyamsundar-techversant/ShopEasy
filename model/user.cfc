<cfcomponent>
    <!---  HASH PASSWORD  --->
    <cffunction name = "hashPassword" access = "public" returntype = "string">
        <cfargument name = "password" type = "string" required = "true" >
        <cfargument name = "saltString" type = "string" required = "true">
        <cfset local.saltedPass = arguments.password & arguments.saltString>
        <cfset local.hashedPassword = hash(local.saltedPass,"SHA-256","UTF-8")>
        <cfreturn local.hashedPassword>
    </cffunction>

    <!---   CHECK USER ALREADY EXIST   --->
    <cffunction name = "checkUserExist" access = "public" returntype = "any">
        <cfargument name = "userEmail" type = "string" required = "false" >
        <cfargument name = "userName" type = "string" required = "false">
        <cfargument name = "phone" type = "string" required = "false" >       
        <cftry>
            <cfquery name = "local.qryUserExist" datasource = "#application.datasource#">
                SELECT 
                    fldUser_ID,
                    fldEmail,
                    fldPhone,
                    fldUserSaltString,
                    fldHashedPassword,
                    fldRoleId
                FROM
                    tblUser
                WHERE
                    <cfif structKeyExists(arguments, "userEmail") AND structKeyExists(arguments, "phone")>
                        fldPhone = <cfqueryparam value = "#arguments.phone#" cfsqltype = "cf_sql_varchar">                   
                        OR fldEmail = <cfqueryparam value = "#arguments.userEmail#" cfsqltype = "cf_sql_varchar">
                    <cfelseif structKeyExists(arguments, "userName")>
                        fldPhone = <cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">
                        OR fldEmail = <cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">
                    </cfif>
            </cfquery>
            <cfreturn local.qryUserExist>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#" >
        </cfcatch>
        </cftry>
    </cffunction>

    <!--- REGISTER USER --->
    <cffunction name = "userRegister" access = "public" returntype = "any">
        <cfargument name = "firstName" type = "string" required = "true" >
        <cfargument name = "lastName" type = "string" required = "true" >
        <cfargument name = "userEmail" type = "string" required = "true" >
        <cfargument name = "phone" type = "string" required = "true" >
        <cfargument name = "password" type = "string" required = "true" >   
        <cftry>
            <cfset local.salt = generateSecretKey('AES')>
            <cfset local.hashedPassword = hashPassword(
                password = arguments.password,
                saltString = local.salt                 
            )>
            <cfquery result = "local.qryUserRegister" datasource = "#application.datasource#">
                INSERT INTO tblUser(
                    fldFirstName,
                    fldLastName,
                    fldEmail,
                    fldPhone,
                    fldRoleId,
                    fldHashedPassword,
                    fldUserSaltString,
                    fldActive,
                    fldUpdatedDate
                )VALUES(
                    <cfqueryparam value = "#arguments.firstName#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#arguments.lastName#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#arguments.userEmail#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#arguments.phone#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "0" cfsqltype = "cf_sql_tinyint">,
                    <cfqueryparam value = "#local.hashedPassword#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#local.salt#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">,
                    <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date">
                )
            </cfquery>
            <cfif local.qryUserRegister.recordCount EQ 1>
                <cflocation url = 'logIn.cfm' addtoken = "false">
            <cfelse>
                <cfset local.result = "Invalid data">
            </cfif>
            <cfreturn local.result >
        <cfcatch type = "exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
    
    <!---   USER LOGIN  --->
    <cffunction name = "userLogIn" access = "public" returntype = "any" >
        <cfargument name = "userName" type = "string" required = "true">
        <cfargument name = "password" type = "string" required = "true">
        <cftry>
            <cfset local.checkUserExistResult = checkUserExist(
                userName = arguments.userName
            )>  
            <cfset session['roleId'] = local.checkUserExistResult.fldRoleId>                 
            <cfset session['userId'] = local.checkUserExistResult.fldUser_ID >
            <!--- IF USER REDIRECTED TO LOGIN WITHOUT LOGIN AND ADD PRODUCT FROM  'userProduct.cfm'  --->
            <cfif structKeyExists(session, "productId") AND NOT structKeyExists(session, 'setOrder')>
                <cfset variables.productId = application.cateContObj.decryptionFunction(session.productId)>
                <cfif variables.productId>
                    <cfset local.addProductToCart = application.cartContObj.addProductToCart(
                        productId = variables.productId            
                    )>
                    <cfif local.addProductToCart EQ 'Success'>
                        <cflocation url = "user/userCart.cfm" addtoken = "false">
                    </cfif>
                </cfif> 
                <!--- ORDER NOW WITHOUT LOGIN --->
            <cfelseif structKeyExists(session, 'setOrder') AND structKeyExists(session, "productId")>
                <cfoutput>
                    <cflocation  url="user/userProduct.cfm" addtoken = "false">
                </cfoutput>    
            <cfelse>
                <cfif local.checkUserExistResult.fldRoleId EQ 1>
                    <cflocation  url="./admin/adminDashBoard.cfm" addtoken = "false">
                <cfelse>
                    <cflocation  url="./user/userHome.cfm" addtoken = "false">
                </cfif>
            </cfif>                        
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>