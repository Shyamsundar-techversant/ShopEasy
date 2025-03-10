DELIMITER $$

USE shoppingcart $$

DROP PROCEDURE IF EXISTS spPlaceOrder $$

CREATE PROCEDURE spPlaceOrder(
    orderId VARCHAR(64),
	userId INT,
    addressId INT,
    cardPart VARCHAR(4),
    totalPrice DECIMAL(10,2),
    totalTax DECIMAL(10,2),
    productId INT,
    quantity INT,
    cartOrder TINYINT,
    unitPrice DECIMAL(10,2),
    unitTax DECIMAL(10,2)
)
BEGIN
	START TRANSACTION;
	INSERT INTO tblOrder(
		fldOrder_ID,
		fldUserId,
		fldAddressId,
		fldTotalPrice,
		fldTotalTax,
		fldCardPart,
		fldOrderedDate
	)VALUES(
		orderId,
        userId,
        addressId,
        totalPrice,
        totalTax,
        cardPart,
        NOW()
	);
	IF cartOrder = 0 THEN
		INSERT INTO tblOrderItems(
			fldOrderId,
			fldProductId,
			fldQuantity,
			fldUnitPrice,
			fldUnitTax
		)VALUES(
			orderId,
			productId,
			quantity,
			unitPrice,
			unitTax
		);
	ELSE 
		INSERT INTO tblOrderItems(
			fldOrderId,
			fldProductId,
			fldQuantity,
			fldUnitPrice,
			fldUnitTax
		)
		SELECT 
			orderId,
			TC.fldProductId,
			TC.fldQuantity,
			P.fldPrice,
			P.fldTax
		FROM
			tblCart AS TC
			INNER JOIN tblProduct AS P ON TC.fldProductId = P.fldProduct_ID
		WHERE
			TC.fldUserId = userId
			AND TC.fldQuantity > 0 ;
		DELETE FROM tblCart WHERE fldUserId = userId;
	END IF ;
    COMMIT ;
END $$
DELIMITER ;

