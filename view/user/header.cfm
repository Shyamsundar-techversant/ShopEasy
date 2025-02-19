<cfset variables.getCategoryAndSubCategory = application.cateContObj.getCategoryAndSubCategory()>
<cfset categoryArray = []>
<cfset categoryWithSubCategory = structNew()>
<cfloop query = "variables.getCategoryAndSubCategory">
  <cfset categoryId = variables.getCategoryAndSubCategory.fldCategory_ID>
  <cfset categoryName = variables.getCategoryAndSubCategory.fldCategoryName>
  <cfset subCategoryId = variables.getCategoryAndSubCategory.fldSubCategory_ID>
  <cfset subCategoryName = variables.getCategoryAndSubCategory.fldSubCategoryName>
  <cfif NOT structKeyExists(categoryWithSubCategory, categoryId)>
    <cfset categoryStruct = {
      'categoryId' : categoryId,
      'categoryName' : categoryName,
      'subCategories' : []    
    }>
    <cfset categoryWithSubCategory[categoryId] = categoryStruct>
    <cfset arrayAppend(categoryArray, categoryStruct)>
  </cfif>
    <cfset arrayAppend(categoryWithSubCategory[categoryId]['subCategories'],{
        'subCategoryId' : subCategoryId,
        'subCategoryName' : subCategoryName
    })>
</cfloop>
<cfif structKeyExists(session, 'userId')>
    <cfset variables.totalCartProducts = application.cartContObj.getCartProducts()>
</cfif>
<!DOCTYPE html>
<html lang = "en">
    <head>
        <meta charset = "UTF-8" />
        <meta name = "viewport" content= "width = device-width, initial-scale = 1.0" />
        <title>ShopEasy</title>
        <link rel = "stylesheet" href = "../../assets/css/user.css" />
        <link rel = "stylesheet" href = "../../assets/css/order.css" />
        <link rel = "stylesheet" href = "../../assets/css/bootstrap.css" />
        <link rel="stylesheet" href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" 
            integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" 
            crossorigin="anonymous" referrerpolicy="no-referrer"
        />  
        <link href = "https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">  
    </head>
    <body>
    <!-- Header -->
        <cfoutput>
            <section class = "header-section">
                <header class = "header">
                    <div class = "container">
                        <div class = "header-content">
                            <div class = "brand-name">ShopEasy</div>
                            <div class = "user-content">
                                <div class = "search-container">
                                    <form class = "prdouct-search-form" method = "post" action = 'searchProductResult.cfm'>
                                        <div class = "search-icon">
                                            <label for = "serach-product">
                                                <i class="fa-solid fa-magnifying-glass"></i>
                                            </label>
                                        </div>
                                        <div class = "search-text">
                                            <input type = "text" id = "serach-product" placeholder = "search products"
                                                name = "searchProduct"
                                            >
                                        </div>
                                    </form>
                                </div>
                                <cfif structKeyExists(variables, 'totalCartProducts')>
                                    <div class = "user-cart">
                                        <cfif variables.totalCartProducts.recordCount GT 0>
                                            <button type="button" class="btn  position-relative cart-nav-btn" onclick = "window.location.href='userCart.cfm'">
                                                <i class="fa-solid fa-cart-shopping"></i>
                                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                                    #variables.totalCartProducts.recordCount#
                                                    <span class="visually-hidden">unread messages</span>
                                                </span>          
                                            </button>
                                        </cfif>
                                    </div>
                                </cfif>
                                <div class = "user-profile" title = "user">
                                    <cfif structKeyExists(session, 'userId')>
                                        <button class = "user-profile-btn" onclick = "window.location.href='userProfile.cfm'">
                                            <i class="fa-regular fa-user"></i>
                                        </button>
                                    </cfif>
                                </div>
                                <div class = "sign-buttons">
                                    <cfif structKeyExists(session, 'roleId') AND session.roleId EQ 1>
                                        <button class = "reg-btn btn" onclick = "window.location.href = '../../view/admin/adminDashboard.cfm'">Admin</button>
                                    </cfif>
                                    <cfif structKeyExists(session, 'userId')>
                                        <button class = "reg-btn btn" onclick = "window.location.href = '../logIn.cfm?logOut=1' ">LogOut</button>
                                    <cfelse>
                                        <button class = "reg-btn btn" onclick = "window.location.href = '../logIn.cfm?logOut=1' ">LogIn</button>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                    </div>
                </header>
            </section>        
            <section class = "app-section category-navigation-section">
                <div class = "container">
                    <nav class = "category-navigation">
                        <div class = "home-page">
                            <button class = "category-list-btn" onclick = "window.location.href ='userHome.cfm'">
                                <i class="fa-solid fa-house"></i>
                            </button>
                        </div>
                        <div class="dropdown">
                            <button class="btn category-list-btn dropdown-toggle" type="button" id="dropdownMenuBtn" data-bs-toggle="dropdown" aria-expanded="false">
                                Menu
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuBtn">
                                <cfif structKeyExists(variables, "categoryArray")>
                                    <cfloop array = "#variables.categoryArray#" index = "category">
                                        <cfset encryptedCategoryId_1 = encrypt(
                                            variables.category.categoryId,
                                            application.encryptionKey,
                                            "AES",
                                            "Hex"
                                        )>
                                        <li>
                                            <a 
                                                class="dropdown-item subcategory-link" 
                                                href="userCategory.cfm?categoryID=#encryptedCategoryId_1#"
                                            >
                                                #variables.category.categoryName#
                                            </a>                                   
                                        </li>                               
                                    </cfloop>
                                </cfif>
                            </ul>
                        </div>
                        <cfset count = 1>
                        <cfif structKeyExists(variables, "categoryArray")>
                            <cfloop array = "#variables.categoryArray#" index = "category">
                                <div class="dropdown">
                                    <button 
                                        class="btn category-list-btn dropdown-toggle" 
                                        type="button" 
                                        id="dropdownMenuButton#count#"
                                        data-bs-toggle="dropdown" aria-expanded="false" 
                                        data-id = "#variables.category.categoryId#"
                                    >
                                        #variables.category.categoryName#
                                    </button>
                                    <cfset encryptedCategoryId = encrypt(
                                        variables.category.categoryId,
                                        application.encryptionKey,
                                        "AES",
                                        "Hex"
                                    )>
                                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                                        <cfloop array = "#category.subCategories#" index = "subCategory">
                                            <cfset encryptedSubCategoryId = encrypt(
                                                variables.subCategory.subCategoryId,
                                                application.encryptionKey,
                                                "AES",
                                                "Hex"
                                            )>
                                            <li>
                                                <a 
                                                    class="dropdown-item subcategory-link" 
                                                    href="userSubCategory.cfm?subCategoryID=#encryptedSubCategoryId#"
                                                >
                                                    #variables.subCategory.subCategoryName#
                                                </a>
                                            </li>
                                        </cfloop>
                                    </ul>
                                </div> 
                                <cfset count  = count + 1 >
                            </cfloop>   
                        </cfif>                   
                    </nav>
                </div>
            </section>
        </cfoutput>