<cfif structKeyExists(url, 'orderId')>
    <cfset variables.orderPdf = application.orderContObj.getOrderedProductsDetails(orderId = url.orderId)>
</cfif>
<cfif structKeyExists(variables, "orderPdf")>
    <cfoutput>
        <cfheader name="Content-Disposition" value="attachment; filename=#url.orderId#.pdf">
    </cfoutput>
    <cfheader name="Content-Type" value="application/pdf">
        <cfcontent type="application/pdf" reset="true">
    <cfdocument format="PDF" orientation="portrait">
        <h1 style="text-align: center;">Order Details</h1>
        <cfoutput>
            <h2>Order ID: #variables.orderPdf.fldOrderId#</h2>
            <p>
                <strong>Ordered On:</strong> #DateFormat(variables.orderPdf.fldOrderedDate, "mmm d yyyy")#
            </p>
            <p>
                <strong>Shipping Address:</strong> 
                #variables.orderPdf.fldFirstName#, 
                #variables.orderPdf.fldAddressLine1#, 
                #variables.orderPdf.fldAddressLine2#, 
                #variables.orderPdf.fldCity#, #variables.orderPdf.fldState# - #variables.orderPdf.fldPincode#
            </p>
            <p>
                <strong>Contact:</strong> #variables.orderPdf.fldPhoneNumber#
            </p>
            <table border="1" cellpadding="5" cellspacing="0" width="100%">
                <thead style="background:##db4444;">
                    <tr>
                        <th style="color:##fff;">Product Name</th>
                        <th style="color:##fff;">Quantity</th>
                        <th style="color:##fff;">Price</th>
                        <th style="color:##fff;">Tax</th>
                        <th style="color:##fff;">Total Price</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="variables.orderPdf">
                        <tr>
                            <td>#variables.orderPdf.fldProductName#</td>
                            <td>#variables.orderPdf.fldQuantity#</td>
                            <td> $#variables.orderPdf.fldUnitPrice#</td>
                            <td>#variables.orderPdf.fldUnitTax#%</td>
                            <td> $#variables.orderPdf.totalPrice#</td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
            <h3>
                Total Cost: <span style="color:##ffa500;"> $#variables.orderPdf.fldTotalPrice# </span>
            </h3>
        </cfoutput>
    </cfdocument>
<cfelse>
    <p>No order exist.</p>
</cfif>

