<cfinclude template = "header.cfm">
<section class = "user-profile-section">
    <div class = "container user-profile-contaier">
        <div class = "card profile-card">
            <div class = "profile-photo">
                <button class = "user-profile-btn profile-card-btn">
                    <i class="fa-regular fa-user"></i>
                </button>
            </div>
            <cfset variables.encryptedUserId = encrypt(
                session.userId,
                application.encryptionKey,
                "AES",
                "Hex"
            )>
            <cfset variables.userData = application.cartContObj.getUserDetails(
                userId = variables.encryptedUserId
            )>
            <div class = "user-details">
                <div class = "intro">
                    Hello,
                </div>
                <cfif structKeyExists(variables, 'userData')>
                    <cfoutput>
                         <div class = "user-name">
                           #variables.userData.fldFirstName&variables.userData.fldLastName#
                        </div>
                        <div class = "user-email">
                            #variables.userData.fldEmail#
                        </div>
                    </cfoutput>
                </cfif>
            </div>
            <div class = "edit-user-detail">
                <button 
                    class = "edit-user-detail-btn"
                    data-bs-toggle="modal" 
                    data-bs-target="#editUserModal"
                    data-id = <cfoutput>"#variables.encryptedUserId#"</cfoutput>
                >
                    <i class="fa-solid fa-pen-to-square"></i>
                </button>
            </div>
        </div>
        <div class = "card profie-card-details">
            <div class = "card-title profile-card-title">
                Profile Information
            </div>
            <div class = "card-body profile-card-body">
                <cfset variables.existingAddresses = application.cartContObj.getAddresses()>
                <cfif structKeyExists(variables,'existingAddresses')>
                    <cfoutput query = "variables.existingAddresses">
                        <cfset encryptedAddressId = encrypt(
                            variables.existingAddresses.fldAddress_ID,
                            application.encryptionKey,
                            "AES",
                            "Hex"
                        )>
                        <div class = "row user-addresses">
                            <div class = "col">
                                <span class = "pb-2">#variables.existingAddresses.fldFirstName&variables.existingAddresses.fldLastName#</span><br>
                                <span>#variables.existingAddresses.fldPhoneNumber#</span><br>
                                <span>#variables.existingAddresses.fldAddressLine1#</span>,
                                <span>#variables.existingAddresses.fldAddressLine2#</span>,
                                <span>#variables.existingAddresses.fldCity#</span>,
                                <span>#variables.existingAddresses.fldPincode#</span>,
                                <span>#variables.existingAddresses.fldState#</span>
                            </div>
                            <div class = "col address-removal">
                                <button 
                                    class = "address-remove-btn"
                                    data-id = #encryptedAddressId#
                                    data-bs-toggle="modal" 
                                    data-bs-target="##addressRemoveModal"
                            >
                                Remove
                            </button>
                            </div>
                        </div>
                    </cfoutput>
                <cfelse>
                    No Address Added Yet.
                </cfif>
            </div>
            <div class = "card-footer address-add">
                <button 
                    class = "address-add-btn profile-btn"
                    data-bs-toggle="modal" 
                    data-bs-target="#addressAddModal"
                >
                    Add New Address
                </button>
                <button class = "order-details-btn profile-btn">Order Details</button>
            </div>
        </div>
    </div>
</section>

<!--- EDIT USER DETAILS --->
<div 
    class="modal fade" 
    id="editUserModal" 
    tabindex="-1" 
    aria-labelledby="addressAddModalLabel" 
    aria-hidden="true"
>
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit User Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form class = "address-add-form" method = "post" id = "editUserModalForm">
                    <div class = "row">
                        <div class = "form-error">

                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "userFirstname" class = "form-label">Firstname</label> 
                            <input type = "text" class = "form-control" name = "firstName" id = "userFirstname"
                                placeholder = "Enter first name"
                            >
                        </div>
                    </div>                    
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "userLastname" class = "form-label">Lastname</label> 
                            <input type = "text" class = "form-control" name = "lastname" id = "userLastname"
                                placeholder = "Enter last name"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "emailId" class = "form-label">Email</label> 
                            <input type = "email" class = "form-control" name = "userEmail" id = "emailId"
                                placeholder = "Enter user email"
                            >
                        </div>
                    </div>    
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "phoneNumber" class = "form-label">Phone</label> 
                            <input type = "text" class = "form-control" name = "phone" id = "phoneNumber"
                                placeholder = "Enter your phone"
                            >
                        </div>
                    </div>                
                    <div class = "row mb-3">
                        <div class = "col">
                            <button type="button" class="btn modal-close-btn" data-bs-dismiss="modal">Close</button>
                            <button 
                                type="button" 
                                class="btn address-add-button" 
                                id = "editUserModalBtn"
                            >
                               UPDATE
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!--- ADDRESS ADD MODAL --->
<div 
    class="modal fade" 
    id="addressAddModal" 
    tabindex="-1" 
    aria-labelledby="addressAddModalLabel" 
    aria-hidden="true"
>
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addressAddModalLabel">Add Address</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form class = "address-add-form" method = "post" id = "addressAddForm">
                    <div class = "row">
                        <div class = "form-error">

                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "firstname" class = "form-label">Firstname</label> 
                            <input type = "text" class = "form-control" name = "firstName" id = "firstname"
                                placeholder = "Enter first name"
                            >
                        </div>
                    </div>                    
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "lastname" class = "form-label">Lastname</label> 
                            <input type = "text" class = "form-control" name = "lastname" id = "lastname"
                                placeholder = "Enter last name"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "addressLine1" class = "form-label">Address Line 1</label> 
                            <input type = "text" class = "form-control" name = "addresLine_1" id = "addressLine1"
                                placeholder = "Enter Address Line 1"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "addressLine2" class = "form-label">Address Line 2</label> 
                            <input type = "text" class = "form-control" name = "addresLine_2" id = "addressLine2"
                                placeholder = "Enter Address Line 2"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "city" class = "form-label">City</label> 
                            <input type = "text" class = "form-control" name = "city" id = "city"
                                placeholder = "Enter city name"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "state" class = "form-label">State</label> 
                            <input type = "text" class = "form-control" name = "state" id = "state"
                                placeholder = "Enter state name"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "pincode" class = "form-label">Pincode</label> 
                            <input type = "text" class = "form-control" name = "pincode" id = "pincode"
                                placeholder = "Enter your pincode"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <label for = "phone" class = "form-label">Phone</label> 
                            <input type = "text" class = "form-control" name = "phone" id = "phone"
                                placeholder = "Enter your phone"
                            >
                        </div>
                    </div>
                    <div class = "row mb-3">
                        <div class = "col">
                            <button type="button" class="btn modal-close-btn" data-bs-dismiss="modal">Close</button>
                            <button 
                                type="button" 
                                class="btn address-add-button" 
                                name = "addressSubmit"
                                id = "addAddressBtn"
                            >
                                ADD
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!--- ADDRESS REMOVE MODAL  --->
<div class="modal fade" id="addressRemoveModal" tabindex="-1" aria-labelledby="addressRemoveModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header addressRemoveModalHead">
                <h5 class="modal-title" id = "addressRemoveModalTitle">Remove Address</h5>
            </div>
            <div class="modal-body">
                Do you want to remove this address ?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary modal-close-btn" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary delete-items" id = "addressRemoveBtn">Remove</button>
            </div>      
        </div>
    </div>
</div>
<cfinclude template = "footer.cfm">

