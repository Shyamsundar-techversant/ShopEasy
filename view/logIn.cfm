<cfif structKeyExists(url, "logOut")>
  <cfset structDelete(session, "roleId","true")>
  <cfset structDelete(session, "adminId","true")>
  <cfset structDelete(session, "userId","true")>
  <cfset structDelete(session, "productId","true")>
  <cfset structDelete(session,"setOrder","true")>
  <cfset structDelete(session, 'orderId',"true")>
</cfif>
<cfif structKeyExists(form, "userLogIn")>
  <cfset variables.logResult = application.userContObj.validateUserForm(
    userName = form.userName,
    password = form.userPassword
  )>
</cfif>
<!DOCTYPE html>
<html lang = "en">
  <head>
    <meta charset = "UTF-8" />
    <meta name = "viewport" content= "width = device-width, initial-scale = 1.0" />
    <title>ShopEasy</title>
    <link rel = "stylesheet" href = "../assets/css/style.css" />
    <link rel = "stylesheet" href = "../assets/css/bootstrap.css" />
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
  </head>
  <body>
    <!-- Header -->
    <section class = "header-section">
      <header class = "header">
        <div class = "container">
          <div class = "header-content">
            <div class = "brand-name">ShopEasy</div>
            <div class = "sign-buttons">
              <button class = "reg-btn btn" onclick = "window.location.href = 'signup.cfm' ">SignUp</button>
            </div>
          </div>
        </div>
      </header>
    </section>
    <!--- LogIn Form --->
    <section class = "form-section">
      <div class = "container">
        <div class = "user-registration">         
          <div class = "card user-reg-card" data-aos="flip-left" data-aos-easing="ease-out-cubic"
                        data-aos-duration="1000"        
          >
            <h5 class = "card-head">LogIn</h5>
            <form action = "" class = "user-reg-form" method = "post">
              <div class = "row error-container">
                <cfif structKeyExists(variables, "logResult") AND arrayLen(logResult) GT 0>
                  <cfoutput>
                    <cfloop array = "#variables.logResult#" index = "error">
                      <span class = "errors" >#error#</span><br>
                    </cfloop>
                  </cfoutput>
                </cfif>
              </div>            
              <div class = "row mb-3">
                <div class = "col">
                  <label for = "username" class = "form-label">Username </label>
                  <input
                    type = "text"
                    class = "form-control"
                    placeholder = "Enter your email or Phone"
                    name = "userName"
                    id = "username"
                  />
                </div>
              </div>
              <div class = "row mb-5">
                <div class = "col">
                  <label for = "password" class = "form-label">Password </label>
                  <input
                    type = "password"
                    class = "form-control"
                    placeholder = "Enter your password"
                    name = "userPassword"
                    id = "password"
                  />
                </div>
              </div>
              <div class = "row mb-3">
                <div class = "col submit-log-form">
                  <button
                    class = "btn user-submit"
                    type = "submit"
                    name = "userLogIn"
                  >
                    Submit
                  </button>
                </div>
              </div>
              <div class = "row mb-3" >
                <a href = "signup.cfm" class = "sign-link"> Don't have any account? Please SignUp</a>
              </div>
            </form>
          </div>						
		    </div>
			</div>
		</section>
    <script src = "../assets/js/bootstrap.bundle.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init();
    </script>
  </body>
</html>
