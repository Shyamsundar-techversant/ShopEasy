
<cfinclude  template="header.cfm">
    <section class = "subcategory-section">
        <div class = "container">
            <cfif structKeyExists(session,'searchText') AND structKeyExists(session, "searchResult")
               AND NOT structKeyExists(variables, 'searchResult')
            >
                <cfoutput><h6>Showing Result for '#session.searchText#'</h6></cfoutput>
            </cfif>
            <div class = "row">              
                <cfif structKeyExists(session, "searchResult") AND isQuery(session.searchResult)
                    AND NOT structKeyExists(variables, 'searchResult')
                >
                    <cfoutput query = "session.searchResult">
                        <cfif session.searchResult.fldDefaultImage EQ 1>
                            <cfset encryptedProductId = encrypt(
                                                                    session.searchResult.idProduct,
                                                                    application.encryptionKey,
                                                                    "AES",
                                                                    "Hex"
                                                                )
                            >
                            <div class = "col-md-3 pb-3" data-aos="zoom-in-down">
                                <div class = "product-card">
                                    <a class = "product-default-img" href = "userProduct.cfm?productId=#encryptedProductId#">
                                        <img src = "../../uploadImg/#session.searchResult.fldImageFileName#" alt = "ProductImage" 
                                            class = "product-image-default"
                                        >
                                    </a>
                                    <a class = "product-names" href = "userProduct.cfm?productId=#encryptedProductId#">
                                        #session.searchResult.fldProductName#
                                    </a>
                                    <a href = "userProduct.cfm?productId=#encryptedProductId#" class = "product-price">
                                        <h6>$#session.searchResult.fldPrice#</h6>
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