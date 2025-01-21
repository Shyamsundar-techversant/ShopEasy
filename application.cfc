<cfcomponent>
    <cfset this.name = "ShoppingCart" >
    <cfset this.sessionManagement = "true" >
    <cfset this.sessionTimeOut = createTimespan(0, 0, 30, 0) >
    <cffunction  name = "onApplicationStart" returntype = "void">
        <cfset application.encryptionKey = generateSecretKey('AES') >
        <cfset application.userContObj = createObject("component","controller.user")>
        <cfset application.userModObj = createObject("component", "model.user") >
        <cfset application.cateContObj = createObject("component","controller.category")>
        <cfset application.categModObj  = createObject("component","model.category")> 
        <cfset application.productContObj = createObject("component","controller.product")>
        <cfset application.productModObj = createObject("component","model.product")>
        <cfset application.imageSavePath = "C:\ColdFusion2021\cfusion\wwwroot\ShopEazy\uploadImg">
    </cffunction>
    <cffunction  name = "onRequestStart" returntype = "void">
        <cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>
        <!---
        <cfset local.pages = ["signup.cfm","log.cfm"] >
        <cfset local.restrictedPages = [    "adminDashboard.cfm","adminCategory.cfm",
                                            "adminSubCategory.cfm","adminProduct.cfm"
                                        ]
        >     
        <cfif NOT structKeyExists(session,"roleId") 
                AND arrayFindNoCase(local.restrictedPages, listLast(CGI.SCRIPT_NAME,'/'))
        >
            <cflocation  url="../logIn.cfm" addToken = "false">
        <cfelseif structKeyExists(session, "roleId") 
            AND session.roleId NEQ 1
            AND arrayFindNoCase(local.restrictedPages, listLast(CGI.SCRIPT_NAME,'/'))
        >
            <cflocation url = "../logIn.cfm" addToken = "false">
        </cfif> --->
        <cfset local.adminPages = [
                                    "adminDashboard.cfm", "adminCategory.cfm", "adminSubCategory.cfm",
                                    "adminProduct.cfm"
                                  ]
        >
        <cfset local.userPages = ["userHome.cfm", "userProfile.cfm", "userOrders.cfm"]>
        <cfset local.authenticationPages = ["logIn.cfm","signup.cfm"]>


        <cfif NOT structKeyExists(session, "roleId") 
            AND (NOT structKeyExists(session, "adminId") 
            AND NOT structKeyExists(session, "userId"))
            AND NOT arrayFindNoCase(local.authenticationPages,  listLast(CGI.SCRIPT_NAME, '/'))
        >
            <cflocation url = "../logIn.cfm" addToken = "false">
        <cfelseif structKeyExists(session, "roleId") 
            AND session.roleId NEQ 1 
            AND arrayFindNoCase(local.adminPages, listLast(CGI.SCRIPT_NAME, '/'))
        >
            <cflocation url = "../logIn.cfm" addToken = "false">

        <cfelseif 
                structKeyExists(session, "roleId")
                AND session.roleId NEQ 0 
                AND session.roleId NEQ 1
                AND arrayFindNoCase(local.userPages, listLast(CGI.SCRIPT_NAME, '/'))
        >
            <cflocation url = "../logIn.cfm" addToken = "false">
        </cfif>
    </cffunction>
</cfcomponent>





