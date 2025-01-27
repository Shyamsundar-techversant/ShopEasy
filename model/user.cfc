<cfcomponent>

    <!---  HASH PASSWORD  --->
    <cffunction name = "hashPassword" access = "private" returntype = "string">
        <cfargument name = "password" type = "string" required = "true" >
        <cfargument name = "saltString" type = "string" required = "true">
        <cfset local.saltedPass = arguments.password & arguments.saltString>
        <cfset local.hashedPassword = hash(local.saltedPass,"SHA-256","UTF-8")>
        <cfreturn local.hashedPassword>
    </cffunction>

    <!---   CHECK USER ALREADY EXIST   --->
    <cffunction name = "checkUserExist" access = "private" returntype = "any">
        <cfargument name = "userEmail" type = "string" required = "false" >
        <cfargument name = "userName" type = "string" required = "false">
        <cfargument name = "phone" type = "string" required = "false" >       
        <cftry>
            <cfquery name = "local.qryUserExist" datasource = "shoppingcart">
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
            <cfset local.checkUserExistResult = checkUserExist(
                                                                    userEmail = arguments.userEmail,
                                                                    phone = arguments.phone
                                                                )
            >
            <cfif local.checkUserExistResult.recordCount GT 0>
                <cfreturn "Email or Phone already exists">
            <cfelse>
                <cfset local.salt = generateSecretKey('AES')>
                <cfset local.hashedPassword = hashPassword(
                                                            password = arguments.password,
                                                            saltString = local.salt                 
                                                        )
            
                >
                <cfquery result = "local.qryUserRegister" datasource = "shoppingcart">
                    INSERT INTO 
                                tblUser(
                                            fldFirstName,
                                            fldLastName,
                                            fldEmail,
                                            fldPhone,
                                            fldRoleId,
                                            fldHashedPassword,
                                            fldUserSaltString,
                                            fldActive,
                                            fldUpdatedDate
                                        )
                    VALUES(
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
                    <cfset local.result = "LogIn Successful">
                    <cflocation url = 'logIn.cfm' addtoken = "false">
                <cfelse>
                    <cfset local.result = "Invalid data">
                </cfif>
                <cfreturn local.result >
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>





    <!---   USER LOGIN   614BBA2A2F0A2C5DE68C05C3AEA3DD0416B67C73BB49E0E85385FFFBFFD5FE48  
    DC4A2A5688F6393C40EB97AB7C6DB32726313E3A8262CA0FE630D69C9D9B3AB8 
   hxRUsV0kK6nZsGPLRRgXfw==  
   hxRUsV0kK6nZsGPLRRgXfw== --->
    <cffunction name = "userLogIn" access = "public" returntype = "any" >
        <cfargument name = "userName" type = "string" required = "true">
        <cfargument name = "password" type = "string" required = "true">
        
        <cftry>
            <cfset local.checkUserExistResult = checkUserExist(
                                                                    argumentCollection = arguments
                                                                )
            >                
            <cfif local.checkUserExistResult.recordCount EQ 1>
                <cfset local.salt = local.checkUserExistResult.fldUserSaltString >
                <cfset local.hashPass = hashPassword(
                                                        password = arguments.password,
                                                        saltString = local.salt                      
                                                    )
                
                >
<!---                 <cfdump var = "#local.hashPass#" abort> --->
                <cfif local.hashPass EQ local.checkUserExistResult.fldHashedPassword>
                    <cfset local.result = "LogIn Successful" >
                    <cfset session['roleId'] = local.checkUserExistResult.fldRoleId>
                    <cfif local.checkUserExistResult.fldRoleId EQ 1>
                        <cfset session['adminId'] = local.checkUserExistResult.fldUser_ID >
                        <cfif structKeyExists(session, "productId")>
                            <cfset local.addProductToCart = application.cartContObj.addProductToCart(
                                                                                                        productId = session.productId,
                                                                                                        userId = session.adminId                   
                                                                                                    )

                            >
                            <cfif local.addProductToCart.recordCount EQ 1>
                                <cflocation url = "./user/userCart.cfm" addtoken = "false">
                            </cfif> 
                        <cfelse>
                            <cflocation  url="./admin/adminDashBoard.cfm" addtoken = "false">
                        </cfif>                
                    <cfelse>
                        <cfset session['userId'] = local.checkUserExistResult.fldUser_ID >
                        <cfif structKeyExists(session, "productId")>
                            <cfset local.addProductToCart = application.cartContObj.addProductToCart(
                                                                                                        productId = session.productId,
                                                                                                        userId = session.userId                   
                                                                                                    )

                            > 
                            <cfif local.addProductToCart.recordCount EQ 1>
                                <cflocation url = "./user/userCart.cfm" addtoken = "false">
                            </cfif>
                        <cfelse>
                            <cflocation  url="./user/userHome.cfm" addtoken = "false">
                        </cfif>
                    </cfif>
                <cfelse>
                    <cfset local.result = "Invalid Data" >
                </cfif>     
            <cfelse>
                <cfset local.result = "Incorrect username or password">        
            </cfif>          
            <cfreturn local.result>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>



</cfcomponent>