<cfparam name = "form.searchProduct" default = "">
<cfif form.searchProduct NEQ "">
    <cfset variables.searchResult = application.productContObj.getSearchedProduct(
        searchText = form.searchProduct
    )>
</cfif>
<cfinclude  template="header.cfm">
    <section class = "subcategory-section">
        <div class = "container">
            <cfif structKeyExists(session,'searchText') AND NOT isQuery(variables.searchResult)>
                <cfoutput>
                    <h6>Showing Result for '#session.searchText#'</h6>
                    <div class="alert alert-danger alertInfo" role="alert">
                        #variables.searchResult#
                    </div>
                </cfoutput>
            <cfelse>
                <cfoutput><h6 class = "product-section-head">Showing Result for '#session.searchText#'</h6></cfoutput>
            </cfif>
            <div class = "row">              
                <cfif structKeyExists(variables, "searchResult") AND isQuery(variables.searchResult) >
                    <cfoutput query = "variables.searchResult">
                        <cfif variables.searchResult.fldDefaultImage EQ 1>
                            <cfset encryptedProductId = application.cateContObj.encryptionFunction(
                                variables.searchResult.idProduct
                            )>
                            <div class = "col-md-3 pb-3" data-aos="zoom-in-down">  
                                <div class = "product-card">
                                    <a class = "product-default-img" href = "userProduct.cfm?productId=#encryptedProductId#">
                                        <img 
                                            src = "/uploadImg/#variables.searchResult.fldImageFileName#" 
                                            alt = "ProductImage" 
                                            class = "product-image-default"
                                        >
                                    </a>
                                    <a class = "product-names" href = "userProduct.cfm?productId=#encryptedProductId#">
                                        #variables.searchResult.fldProductName#
                                    </a>
                                    <a href = "userProduct.cfm?productId=#encryptedProductId#" class = "product-price">
                                        <h6>$#variables.searchResult.fldPrice#</h6>
                                    </a>
                                </div>
                            </div>
                        </cfif>
                    </cfoutput>
                </cfif>
            </div>
        </div>
    </section>
<cfinclude template = "footer.cfm">