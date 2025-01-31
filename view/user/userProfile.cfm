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
                        <div class = "col">
                            
                        </div>
                    </div>
                    <div class = "row">
                        <div class = "col">

                        </div>
                    </div>
                    <div class = "row">
                        <div class = "col">

                        </div>
                    </div>
                    <div class = "row">
                        <div class = "col">

                        </div>
                    </div>
                    <div class = "row">
                        <div class = "col">

                        </div>
                    </div>
                    <div class = "row">
                        <div class = "col">

                        </div>
                    </div>
                    <div class = "row">
                        <div class = "col">

                        </div>
                    </div>
                    <div class = "row">
                        <div class = "col">

                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Understood</button>
            </div>
        </div>
    </div>
</div>



<cfinclude template = "footer.cfm">



<!-- Button trigger modal -->
<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addressRemoveModal">
  Launch static backdrop modal
</button>
