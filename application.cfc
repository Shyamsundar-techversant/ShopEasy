<cfcomponent>
    <cfset this.name = "ShoppingCart" >
    <cfset this.sessionManagement = "true" >
    <cfset this.sessionTimeOut = createTimespan(0, 0, 30, 0) >
    <cffunction  name = "onApplicationStart" returntype = "void">
        <cfset application.datasource = "shoppingcart">
        <cfset application.encryptionKey = generateSecretKey('AES') >
        <cfset application.userContObj = createObject("component","controller.user")>
        <cfset application.userModObj = createObject("component", "model.user") >
        <cfset application.cateContObj = createObject("component","controller.category")>
        <cfset application.categModObj  = createObject("component","model.category")> 
        <cfset application.productContObj = createObject("component","controller.product")>
        <cfset application.productModObj = createObject("component","model.product")>
        <cfset application.imageSavePath = "C:\ColdFusion2021\cfusion\wwwroot\uploadImg">
        <cfset application.cartContObj = createObject("component","controller.cart")>
        <cfset application.cartModObj = createObject("component","model.cart")>
        <cfset application.orderContObj = createObject("component","controller.order")>
        <cfset application.orderModObj = createObject("component","model.order")>
    </cffunction>
    <cffunction  name = "onRequestStart" returntype = "void">
        <cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>
        <cfset local.adminPages = [
            "adminDashboard.cfm", "adminCategory.cfm", "adminSubCategory.cfm","adminProduct.cfm"
        ]>
        <cfset local.userPages = [
            'userCart.cfm','userOrder.cfm','userProfile.cfm','userOrder.cfm','paymentDetails.cfm','orderHistory.cfm'
        ]>
        <cfset local.currentPage = listLast(CGI.SCRIPT_NAME, '/')>
        <cfset local.hasRole = structKeyExists(session, 'roleId')>
        <cfset local.productId = structKeyExists(url,"productId") ? url.productId : "">
        <cfif 
            (
                !local.hasRole 
                AND 
                (
                    arrayFindNoCase(local.adminPages, local.currentPage) 
                    OR arrayFindNoCase(local.userPages, local.currentPage)
                )
            ) 
            OR (local.hasRole AND session.roleId NEQ 1 AND arrayFindNoCase(local.adminPages, local.currentPage))
        >
            <cfif len(local.productId)>
                <cfset session.productId = local.productId>
            </cfif>
            <cflocation url = "../logIn.cfm" addToken = "false">
        </cfif>
    </cffunction>
</cfcomponent>



