<cfif structKeyExists(form, "userLogIn")>
    <cfset variables.registerResult = application.userContObj.validateUserForm(
        firstName = form.firstName,
        lastName = form.lastName,
        userEmail = form.userEmail,
        phone = form.userPhoneNumber,
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
              <button class = "log-btn btn" onclick = "window.location.href = 'logIn.cfm' "
              >
                LogIn
              </button>
            </div>
          </div>
        </div>
      </header>
    </section>
    <!--- Register Form --->
    <section class = "form-section">
        <div class = "container">
            <div class = "user-registration">         
                <div class = "card user-reg-card"  data-aos="flip-right" data-aos-easing="ease-out-cubic"
                              data-aos-duration="1000"   
                >
                    <h5 class = "card-head mb-3">SignUp</h5>
                    <form action = "" class = "user-reg-form" method = "post">
                        <div class = "row">
                            <cfif structKeyExists(variables, "registerResult") AND arrayLen(registerResult) GT 0>
                                <cfoutput>
                                    <cfloop array = "#variables.registerResult#" index = "error">
                                        <span class = "errors" >#error#</span><br>
                                    </cfloop>
                                </cfoutput>
                            </cfif>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "Firstname" class = "form-label">Firstname </label>
                                <input
                                    type = "text"
                                    class = "form-control"
                                    placeholder = "Enter your firstname"
                                    name = "firstName"
                                    id = "Firstname"
                                />
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "Lastname" class = "form-label">Lastname </label>
                                <input
                                    type = "text"
                                    class = "form-control"
                                    placeholder = "Enter your lastsname"
                                    name = "LastName"
                                    id = "Lastname"
                                />
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "email" class = "form-label">Email </label>
                                <input
                                    type = "text"
                                    class = "form-control"
                                    placeholder = "Enter your email"
                                    name = "userEmail"
                                    id = "email"
                                />
                            </div>
                        </div>
                        <div class = "row mb-3">
                            <div class = "col">
                                <label for = "phone" class = "form-label">Phone </label>
                                <input
                                    type = "text"
                                    class = "form-control"
                                    placeholder = "Enter your phone number"
                                    name = "userPhoneNumber"
                                    id = "phone"
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
                            <a href = "logIn.cfm" class = "sign-link"> Already have an account? Please LogIn</a>
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
