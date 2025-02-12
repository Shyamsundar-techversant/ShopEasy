DELIMITER $$

USE shoppingcart $$

DROP PROCEDURE IF EXISTS spDeleteCartProduct $$ 

CREATE PROCEDURE spDeleteCartProduct(userId INT)
BEGIN
	DELETE FROM 
		tblCart 
	WHERE 
		fldUserId = userId ;
END $$

DELIMITER ;