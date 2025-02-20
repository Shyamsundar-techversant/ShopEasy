<cfcomponent>
    <!--- VALIDATE SIGNUP FORM  --->
    <cffunction  name = "validateSignUpForm" access = "public" returntype = "array">
        <cfargument name = "firstName" type = "string" required = "true">
        <cfargument name = "lastName" type = "string" required = "true">
        <cfargument name = "userEmail" type = "string" required = "true">
        <cfargument name = "phone" type = "string" required = "true">
        <cfargument name = "password" type = "string" required = "true">   
        <cfset local.errors = [] >
        <!---  VALIDATE FIRST NAME   --->
        <cfif len(trim(arguments.firstName)) EQ 0>
            <cfset arrayAppend(local.errors,"*Firstname is required")>
        <cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)?$",arguments.firstName)>
            <cfset arrayAppend(local.errors,"*Enter a valid firstname")>
        <cfelseif len(trim(arguments.firstName)) GT 32 >
            <cfset arrayAppend(local.errors,"*Length of firstname exceeds the maximum value")>
        </cfif>	
        <!---  VALIDATE LAST NAME     --->
        <cfif len(trim(arguments.lastName)) EQ 0>
            <cfset arrayAppend(local.errors,"*Lastname is required")>
        <cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)?$",arguments.lastName)>
            <cfset arrayAppend(local.errors,"*Enter a valid lastname")>
        <cfelseif len(trim(arguments.lastName)) GT 32>
            <cfset arrayAppend(local.errors,"*Length of lastname exceeds the maximum value")>
        </cfif>	     
        <!---  VALIDATE EMAIL --->
        <cfif len(trim(arguments.userEmail)) EQ 0>
            <cfset arrayAppend(local.errors,"*Email is required")>
        <cfelseif NOT reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",arguments.userEmail)>
            <cfset arrayAppend(local.errors,"*Enter a valid email")>
        <cfelseif len(trim(arguments.userEmail)) GT 100>
            <cfset arrayAppend(local.errors,"*Length of email exceeds the maximum value")>
        <cfelse>
            <cfset local.checkUserExistResult = application.userModObj.checkUserExist(
                userName = arguments.userEmail
            )>
            <cfif local.checkUserExistResult.recordCount GT 0>
                <cfset arrayAppend(local.errors, '*Email already exist')>
            </cfif>           
        </cfif>
        <!---  VALIDATE PHONE   --->         
        <cfif len(trim(arguments.phone)) EQ 0>
            <cfset arrayAppend(local.errors,"*Phone number is required")>
        <cfelseif NOT reFindNoCase("^[6-9]\d{9}$",arguments.phone)>
            <cfset arrayAppend(local.errors,"*Enter a valid phone number")>
        </cfif>
        <!--- VALIDATE PASSWORD --->
        <cfif len(trim(arguments.password)) EQ 0>
            <cfset arrayAppend(local.errors,"*Please enter the password")>
        <cfelseif NOT reFindNoCase("^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",arguments.password)>
            <cfset arrayAppend(local.errors,"*Please enter a valid password")>
        <cfelseif len(trim(arguments.password)) GT 256>
            <cfset arrayAppend(local.errors,"*Password length exceeds the maximum value")>
        </cfif>
        <cfreturn local.errors>
    </cffunction>

    <!---  USER SIGNUP  --->
    <cffunction  name = "userRegister" access = "public" returntype = "any">
        <cfargument name = "firstName" type = "string" required = "true">
        <cfargument name = "lastName" type = "string" required = "true">
        <cfargument name = "userEmail" type = "string" required = "true">
        <cfargument name = "phone" type = "string" required = "true">
        <cfargument name = "password" type = "string" required = "true">  
        <cfset local.userRegisterResult = application.userModObj.userRegister(
            argumentCollection = arguments
        )>
    </cffunction>

    <!--- VALIDATE LOGIN FORM  --->
    <cffunction name = "validateLogInForm" access = "public" returntype = "array">
        <cfargument name = "userName" type = "string" required = "true">
        <cfargument name = "password" type = "string" required = "true">
        <cfset local.errors = []>
        <!---   CHECK USER EXIST --->
        <cfset local.checkUserExistResult = application.userModObj.checkUserExist(
            userName = arguments.userName
        )>  
        <!--- VALIDATE USERNAME --->
        <cfif len(trim(arguments.userName)) EQ 0>
            <cfset arrayAppend(local.errors,"*Enter your username")>
        <cfelseif len(trim(arguments.userName)) GT 100>
            <cfset arrayAppend(local.errors,"*Length of username exceeds the maximum value")>
        <cfelseif local.checkUserExistResult.recordCount NEQ 1>
            <cfset arrayAppend(local.errors, '*Incorrect username or password')>
        </cfif>
        <!---    VALIDATE PASSWORD      --->
        <cfif len(trim(arguments.password)) EQ 0>
            <cfset arrayAppend(local.errors,"*Please enter the password")>
        <cfelseif len(trim(arguments.password)) GT 256>   
            <cfset arrayAppend(local.errors,"*Password length exceeds the maximum value")>
        <cfelseif NOT reFindNoCase("^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",arguments.password)>
            <cfset arrayAppend(local.errors,"*Please enter a valid password")>
        <cfelseif local.checkUserExistResult.recordCount EQ 1>
            <cfset local.salt = local.checkUserExistResult.fldUserSaltString>
            <cfset local.hashPass = application.userModObj.hashPassword(
                password = arguments.password,
                saltString = local.salt                      
            )>
            <cfif local.hashPass NEQ local.checkUserExistResult.fldHashedPassword>
                <cfset arrayAppend(local.errors, '*Incorrect username or password')>
            </cfif>
        </cfif>  
        <cfreturn local.errors>     
    </cffunction>
    
    <!---  USER LOGIN    --->
    <cffunction name = "userLogIn" type = "string" required = "true" returntype = "any">
        <cfargument name = "userName" type = "string" required = "true">
        <cfargument name = "password" type = "string" required = "true">
        <cfset local.userLogInResult = application.userModObj.userLogIn(
            argumentCollection = arguments
        )> 
        <cfif structKeyExists(local, 'userLogInResult')>
            <cfreturn local.userLogInResult>
        </cfif>
    </cffunction>
    
</cfcomponent>