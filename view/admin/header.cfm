<!DOCTYPE html>
<html lang = "en">
  <head>
    <meta charset = "UTF-8" />
    <meta name = "viewport" content= "width = device-width, initial-scale = 1.0" />
    <title>ShopEasy</title>
    <link rel = "stylesheet" href = "../../assets/css/style.css" />
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
            <div class = "sign-buttons">
              <cfif structKeyExists(session, 'userId')>
                <button class = "reg-btn btn" onclick = "window.location.href = '../../view/user/userHome.cfm'">Home</button>
                <button class = "reg-btn btn" onclick = "window.location.href = '../../view/logIn.cfm?logOut=1' ">LogOut</button>
              <cfelse>
                <button class = "reg-btn btn" onclick = "window.location.href = '../../view/logIn.cfm?logOut=1' ">LogIn</button>
              </cfif>
            </div>
          </div>
        </div>
      </header>
    </section>