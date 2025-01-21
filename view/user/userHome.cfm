<cfset variables.getCategory = application.cateContObj.getCategory()>

<!DOCTYPE html>
<html lang = "en">
    <head>
        <meta charset = "UTF-8" />
        <meta name = "viewport" content= "width = device-width, initial-scale = 1.0" />
        <title>ShopEasy</title>
        <link rel = "stylesheet" href = "../../assets/css/user.css" />
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
                                <form class = "prdouct-search-form">
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
                            <div class = "user-profile">
                                sdfhsdh
                            </div>
                            <div class = "sign-buttons">
                                <button class = "reg-btn btn" onclick = "window.location.href = '../logIn.cfm?logOut=1' ">LogOut</button>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
        </section>

        <section class = "app-section category-navigation-section">
            <div class = "container">
                <nav class = "category-navigation">
                    <cfset count = 1>
                    <cfoutput query = "variables.getCategory">
                        <div class="dropdown">
                            <button class="btn category-list-btn dropdown-toggle" type="button" id="dropdownMenuButton#count#"
                                    data-bs-toggle="dropdown" aria-expanded="false" 
                                    data-id = "#variables.getCategory.fldCategory_ID#"
                            >
                                #variables.getCategory.fldCategoryName#
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                                <li><a class="dropdown-item subcategory-link" href="##">Action</a></li>
                                <li><a class="dropdown-item subcategory-link" href="##">Another action</a></li>
                                <li><a class="dropdown-item subcategory-link" href="##">Something else here</a></li>
                            </ul>
                        </div> 
                        <cfset count  = count + 1 >
                    </cfoutput>                      
                </nav>
            </div>
        </section>
        <section class = "banner-section">
            <div class = "banner-content">
                <h5>Online Shopping</h5>
                <h2>Quality Products</h2>
            </div>
            <div class = "container">
                <img src = "../../assets/images/hero_endframe__cvklg0xk3w6e_large 2.png" alt = "Banner Image"
                    class = "banner-img"
                >
            </div>
        </section>
        <script src = "../../assets/js/bootstrap.bundle.js"></script>
        <script src = "../../assets/js/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            AOS.init();
        </script>
    </body>
</html>


