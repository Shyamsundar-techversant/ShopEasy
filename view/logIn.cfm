<!--- SET DEFAULT VALUE FOR INPUT FIELDS  --->
<cfset variables.userName = "">
<cfset variables.password = "">
<!--- CLEAR SESSION VARIABELS  --->
<cfif structKeyExists(url, "logOut")>
  <cfset structClear(session)>
</cfif>
<!--- CHECK ALL INPUT FIELDS ARE IN FORM WHILE FORM SUBMISSION --->
<cfif structKeyExists(form,'userLogIn')>
  <cfif structKeyExists(form,"userName") AND structKeyExists(form, "userPassword")>
    <cfset variables.logInResult = application.userContObj.validateLogInForm(
      userName = form.userName,
      password = form.userPassword
    )>
    <!--- IF NO ERRORS --->
    <cfif structKeyExists(variables, 'logInResult')>
      <cfif arrayLen(variables.logInResult) EQ 0>
        <cfset variables.userLogInResult = application.userModObj.userLogIn(
          userName = form.userName,
          password = form.userPassword
        )>
      <cfelse>
        <cfset variables.userName = form.userName>
        <cfset variables.password = form.userPassword>
      </cfif>
    </cfif>
  <cfelse>
    <cfset variables.logInResult = ['*Username or password required']>
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
          <div class = "card user-reg-card">
            <h5 class = "card-head">LogIn</h5>
            <form action = "" class = "user-reg-form" method = "post">
              <cfoutput>
                <div class = "row error-container">
                  <cfset variables.logErrors = []>
                  <cfif structKeyExists(variables, "logInResult") AND arrayLen(logInResult) GT 0>                  
                    <cfloop array = "#variables.logInResult#" index = "error">
                      <span class = "errors" >#error#</span><br>
                    </cfloop>
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
                      value = "#variables.userName#"
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
                      value = "#variables.password#"
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
              </cfoutput>
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
