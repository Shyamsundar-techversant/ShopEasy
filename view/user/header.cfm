<cfset variables.getCategory = application.cateContObj.getCategory()>
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
                                    <button type="button" class="btn  position-relative cart-nav-btn" onclick = "window.location.href='userCart.cfm'">
                                        <i class="fa-solid fa-cart-shopping"></i>
                                        <cfif variables.totalCartProducts.recordCount GT 0>
                                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                                <cfoutput>#variables.totalCartProducts.recordCount#</cfoutput>
                                                <span class="visually-hidden">unread messages</span>
                                            </span>  
                                        </cfif>      
                                    </button>
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
                            <cfif structKeyExists(variables, "getCategory")>
                                <cfoutput query = "variables.getCategory">
                                    <cfset encryptedCategoryId_1 = encrypt(
                                                                            variables.getCategory.fldCategory_ID,
                                                                            application.encryptionKey,
                                                                            "AES",
                                                                            "Hex"
                                                                        )
                                    >
                                    <li>
                                        <a class="dropdown-item subcategory-link" 
                                            href="userCategory.cfm?categoryID=#encryptedCategoryId_1#"
                                        >
                                            #variables.getCategory.fldCategoryName#
                                        </a>                                   
                                    </li>                               
                                </cfoutput>
                            </cfif>
                        </ul>
                    </div>
                    <cfset count = 1>
                    <cfif structKeyExists(variables, "getCategory")>
                        <cfoutput query = "variables.getCategory">
                            <div class="dropdown">
                                <button class="btn category-list-btn dropdown-toggle" type="button" 
                                        id="dropdownMenuButton#count#"
                                        data-bs-toggle="dropdown" aria-expanded="false" 
                                        data-id = "#variables.getCategory.fldCategory_ID#"
                                >
                                    #variables.getCategory.fldCategoryName#
                                </button>
                                <cfset encryptedCategoryId = encrypt(
                                                                        variables.getCategory.fldCategory_ID,
                                                                        application.encryptionKey,
                                                                        "AES",
                                                                        "Hex"
                                                                    )
                                >
                                <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                                    <cfset variables.getSubCategory = application.cateContObj.getSubCategory(categoryId = encryptedCategoryId )>
                                    <cfif structKeyExists(variables,"getSubCategory")>
                                        <cfloop query = "variables.getSubCategory">
                                            <cfset encryptedSubCategoryId = encrypt(
                                                                                    variables.getSubCategory.fldSubCategory_ID,
                                                                                    application.encryptionKey,
                                                                                    "AES",
                                                                                    "Hex"
                                                                                )
                                            >
                                            <li>
                                                <a class="dropdown-item subcategory-link" 
                                                    href="userSubCategory.cfm?subCategoryID=#encryptedSubCategoryId#"
                                                >
                                                    #variables.getSubCategory.fldSubCategoryName#
                                                </a>
                                            </li>
                                        </cfloop>
                                    </cfif>
                                </ul>
                            </div> 
                            <cfset count  = count + 1 >
                        </cfoutput>   
                    </cfif>                   
                </nav>
            </div>
        </section>