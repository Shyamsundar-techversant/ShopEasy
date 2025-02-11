DELIMITER $$
CREATE PROCEDURE deleteCartProduct(IN userId INT)
BEGIN
	DELETE FROM 
		tblCart 
	WHERE 
	fldUserId = userId ;
END $$
DELIMITER ;