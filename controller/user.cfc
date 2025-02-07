<cfcomponent>
    <!--- Validate LogIn form  --->
    <cffunction  name = "validateUserForm" access = "public" returntype = "any">
        <cfargument name = "firstName" type = "string" required = "false" >
        <cfargument name = "lastName" type = "string" required = "false" >
        <cfargument name = "userEmail" type = "string" required = "false" >
        <cfargument name = "phone" type = "string" required = "false" >
        <cfargument name = "userName" type = "string" required = "false" >
        <cfargument name = "password" type = "string" required = "true" >
        
        <cfset local.errors = [] >

        <!---  Validate First name   --->
        <cfif structKeyExists(arguments, "firstName")>
            <cfif len(trim(arguments.firstName)) EQ 0>
		    	<cfset arrayAppend(local.errors,"*Firstname is required")>
	    	<cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)?$",arguments.firstName)>
		    	<cfset arrayAppend(local.errors,"*Enter a valid firstname")>
		    </cfif>	
        </cfif>

        <!---  Validate Last Name     --->
        <cfif structKeyExists(arguments, "lastName") >
            <cfif len(trim(arguments.lastName)) EQ 0>
			    <cfset arrayAppend(local.errors,"*Lastname is required")>
		    <cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)?$",arguments.lastName)>
			    <cfset arrayAppend(local.errors,"*Enter a valid lastname")>
		    </cfif>	     
        </cfif>  

        <!---   Validate Email       --->
        <cfif structKeyExists(arguments,"email")>
            <cfif len(trim(arguments.userEmail)) EQ 0>
			    <cfset arrayAppend(local.errors,"*Email is required")>
		    <cfelseif NOT reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",arguments.userEmail)>
		    	<cfset arrayAppend(local.errors,"*Enter a valid email")>
		    </cfif>
        </cfif>

          <!---    Validate Phone      --->
        <cfif structKeyExists(arguments,"phone")>         
            <cfif len(trim(arguments.phone)) EQ 0>
			    <cfset arrayAppend(local.errors,"*Phone number is required")>
		    <cfelseif NOT reFindNoCase("^[6-9]\d{9}$",arguments.phone)>
		    	<cfset arrayAppend(local.errors,"*Enter a valid phone number")>
		    </cfif>
        </cfif>

        <!--- Validate UserName --->
        <cfif structKeyExists(arguments, "userName")>
            <cfif len(trim(arguments.userName)) EQ 0>
		        <cfset arrayAppend(local.errors,"*Enter your username")>
		    </cfif>
        </cfif>

        <!--- Validate Password --->
		<cfif len(trim(arguments.password)) EQ 0>
			<cfset arrayAppend(local.errors,"*Please enter the password")>
		<cfelseif NOT reFindNoCase("^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",arguments.password)>
			<cfset arrayAppend(local.errors,"*Please enter a valid password")>
		</cfif>

        <cfif arrayLen(local.errors) GT 0>
            <cfreturn local.errors>
        <cfelse>
            <cfif structKeyExists(arguments, "userName")>
                <cfset local.userLogInResult = application.userModObj.userLogIn(
                                                                            argumentCollection = arguments
                                                                        )
                >
            <cfelse>
                <cfset local.userRegisterResult = application.userModObj.userRegister(
                                                                                        argumentCollection = arguments
                                                                                    )
                >
            </cfif>
        </cfif>      
    </cffunction>
</cfcomponent>