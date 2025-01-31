<cfif structKeyExists(form, 'addressSubmit')>
    <cfdump var = "#form#">
</cfif>
<cfinclude template = "header.cfm">
<section class = "user-profile-section">
    <div class = "container user-profile-contaier">
        <div class = "card profile-card">
            <div class = "profile-photo">
                <button class = "user-profile-btn profile-card-btn">
                    <i class="fa-regular fa-user"></i>
                </button>
            </div>
            <div class = "user-details">
                <div class = "intro">
                    Hello,
                </div>
                <div class = "user-name">
                    Shyam
                </div>
                <div class = "user-email">
                    email : shyam@gmail.com
                </div>
            </div>
        </div>
        <div class = "card profie-card-details">
            <div class = "card-title profile-card-title">
                Profile Information
            </div>
            <div class = "card-body profile-card-body">
                <div class = "row">
                    <div class = "col">

                    </div>
                </div>
            </div>
            <div class = "card-footer address-add">
                <button 
                    class = "address-add-btn profile-btn"
                    data-bs-toggle="modal" 
                    data-bs-target="#addressRemoveModal"
                >
                    Add New Address
                </button>
                <button class = "order-details-btn profile-btn">Order Details</button>
            </div>
        </div>
    </div>
</section>

<!--- ADDRESS ADD MODAL --->
<div 
    class="modal fade" 
    id="addressRemoveModal" 
    tabindex="-1" 
    aria-labelledby="addressRemoveModalLabel" 
    aria-hidden="true"
>
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addressRemoveModalLabel">Add Address</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form class = "address-add-form" method = "post">
                    <div class = "row">
                        <div class = "error">

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



<cfinclude template = "footer.cfm">



<!-- Button trigger modal -->
<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addressRemoveModal">
  Launch static backdrop modal
</button>
