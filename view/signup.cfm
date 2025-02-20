<!--- SET DEFAULT VALUE FOR INPUT FIELDS --->
<cfset variables.firstName = "">
<cfset variables.lastName = "">
<cfset variables.userEmail = "">
<cfset variables.userPhone = "">
<cfset variables.userPassword = "">

<!--- CHECK ALL INPUT FIELDS ARE IN FORM WHILE FORM SUBMISSION --->
<cfif structKeyExists(form, "userLogIn")>
    <cfif 
        structKeyExists(form, 'firstName') 
        AND structKeyExists(form, 'lastName')
        AND structKeyExists(form, 'userEmail')
        AND structKeyExists(form, 'userPhoneNumber')
        AND structKeyExists(form, 'userPassword')
    >
        <cfset variables.arguments = {
            'firstName' : form.firstName,
            'lastName' : form.lastName,
            'userEmail' : form.userEmail,
            'phone' : form.userPhoneNumber,
            'password' : form.userPassword 
        }>
        <cfset variables.registerResult = application.userContObj.validateSignUpForm(
            argumentCollection = variables.arguments
        )>
                <!--- IF NO ERRORS --->
        <cfif structKeyExists(variables, 'registerResult')>
            <cfif arrayLen(variables.registerResult) EQ 0>
                <cfset variables.userRegisterResult = application.userContObj.userRegister(
                    argumentCollection = variables.arguments
                )>
            <cfelse>
                <cfset variables.firstName = form.firstName>
                <cfset variables.lastName = form.lastName>
                <cfset variables.userEmail = form.userEmail>
                <cfset variables.userPhone = form.userPhoneNumber>
                <cfset variables.userPassword = form.userPassword>
            </cfif>
        </cfif>   
    <cfelse>
        <cfset variables.registerResult = ['*Required input field is missing']>
    </cfif>
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
                <div class = "card user-reg-card">
                    <h5 class = "card-head mb-3">SignUp</h5>
                    <form action = "" class = "user-reg-form" method = "post">
                        <cfoutput>
                            <div class = "row error-container" id = "sign-up-validation-error">
                                <cfif structKeyExists(variables, "registerResult") AND arrayLen(registerResult) GT 0>
                                    <cfloop array = "#variables.registerResult#" index = "error">
                                        <span class = "errors" >#error#</span><br>
                                    </cfloop>
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
                                        value = "#variables.firstName#"
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
                                        value = "#variables.lastName#"
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
                                        value = "#variables.userEmail#"
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
                                        value = "#variables.userPhone#"
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
                                        value = "#variables.userPassword#"
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
                        </cfoutput>
                    </form>
                </div>						
            </div>
        </div>
	</section>
    <cfif structKeyExists(variables, "registerResult") AND arrayLen(registerResult) GT 0>
        <script>
            let errorDiv = document.getElementById("sign-up-validation-error");
            if(errorDiv){
                errorDiv.scrollIntoView({ behavior: "smooth", block: "center" });
            } 
        </script>
    </cfif>
    <script src = "../assets/js/bootstrap.bundle.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init();
    </script>
  </body>
</html>
