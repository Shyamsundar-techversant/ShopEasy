-- -----------------------------------------------------
-- Table `shoppingcart`.`tblProduct`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shoppingcart`.`tblProduct` (
  `fldProduct_ID` INT NOT NULL,
  `fldSubCategoryId` INT NULL,
  `fldProductName` VARCHAR(100) NULL,
  `fldBrandId` INT NULL,
  `fldDescription` TEXT NULL,
  `fldPrice` DECIMAL(10,2) NULL,
  `fldTax` DECIMAL(10,2) NULL,
  `fldActive` TINYINT(1) NULL,
  `fldCreatedById` INT NOT NULL,
  `fldCreatedDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fldUpdatedById` INT NULL,
  `fldUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`fldProduct_ID`),
  INDEX `ProductCreatedBy_idx` (`fldCreatedById` ASC) VISIBLE,
  INDEX `ProductCategoryId_idx` (`fldSubCategoryId` ASC) VISIBLE,
  INDEX `ProductUpdatedById_idx` (`fldUpdatedById` ASC) VISIBLE,
  INDEX `ProductBrandId_idx` (`fldBrandId` ASC) VISIBLE,
  CONSTRAINT `fldCategoryId`
    FOREIGN KEY (`fldSubCategoryId`)
    REFERENCES `shoppingcart`.`tblCategory` (`fldCategory_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `prodCreatedById`
    FOREIGN KEY (`fldCreatedById`)
    REFERENCES `shoppingcart`.`tblUser` (`fldUser_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `prodUpdatedById`
    FOREIGN KEY (`fldUpdatedById`)
    REFERENCES `shoppingcart`.`tblUser` (`fldUser_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fldBrandId`
    FOREIGN KEY (`fldBrandId`)
    REFERENCES `shoppingcart`.`tblBrands` (`fldBrand_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `shoppingcart`.`tblOrderItems` (
  `fldOrderItem_ID` INT NOT NULL,
  `fldOrderId` VARCHAR(64) NULL,
  `fldProductId` INT NULL,
  `fldQuantity` INT NULL,
  `fldUnitPrice` DECIMAL(10,2) NULL,
  `fldUnitTax` DECIMAL(10,2) NULL,
  PRIMARY KEY (`fldOrderItem_ID`),
  INDEX `orderId_idx` (`fldOrderId` ASC) VISIBLE,
  INDEX `OrdItemsproductId_idx` (`fldProductId` ASC) VISIBLE,
  CONSTRAINT `fldOrderId`
    FOREIGN KEY (`fldOrderId`)
    REFERENCES `shoppingcart`.`tblOrder` (`fldOrder_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fldProductId`
    FOREIGN KEY (`fldProductId`)
    REFERENCES `shoppingcart`.`tblProduct` (`fldProduct_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `shoppingcart`.`tblSubCategory` (
  `fldSubCategory_ID` INT NOT NULL,
  `fldCategoryId` INT NULL,
  `fldSubCategoryName` VARCHAR(64) NULL,
  `fldActive` TINYINT(1) NULL,
  `fldCreatedById` INT NOT NULL,
  `fldCreatedDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fldUpdatedById` INT NULL,
  `fldUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`fldSubCategory_ID`),
  INDEX `SubCategoryId_idx` (`fldCategoryId` ASC) VISIBLE,
  INDEX `SubCreatedby_idx` (`fldCreatedById` ASC) VISIBLE,
  INDEX `SubUpdatedById_idx` (`fldUpdatedById` ASC) VISIBLE,
  CONSTRAINT `subCategoryId`
    FOREIGN KEY (`fldCategoryId`)
    REFERENCES `shoppingcart`.`tblCategory` (`fldCategory_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `subCatCreatedbyId`
    FOREIGN KEY (`fldCreatedById`)
    REFERENCES `shoppingcart`.`tblUser` (`fldUser_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `subCatUpdatedById`
    FOREIGN KEY (`fldUpdatedById`)
    REFERENCES `shoppingcart`.`tblUser` (`fldUser_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `shoppingcart`.`tblProductImages` (
  `fldProductImage_ID` INT NOT NULL,
  `fldProductId` INT NULL,
  `fldImageFileName` VARCHAR(128) NULL,
  `fldDefaultImage` TINYINT(1) NULL,
  `fldActive` TINYINT(1) NULL,
  `fldCreatedById` INT NOT NULL,
  `fldCreatedDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fldDeactivatedById` INT NULL,
  `fldDeactivatedDate` DATETIME NULL,
  PRIMARY KEY (`fldProductImage_ID`),
  INDEX `ImagesProductId_idx` (`fldProductId` ASC) VISIBLE,
  INDEX `ImagesCreatedById_idx` (`fldCreatedById` ASC) VISIBLE,
  INDEX `ImagesDeletedById_idx` (`fldDeactivatedById` ASC) VISIBLE,
  CONSTRAINT `imgProductId`
    FOREIGN KEY (`fldProductId`)
    REFERENCES `shoppingcart`.`tblProduct` (`fldProduct_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `prodImgfldCreatedById`
    FOREIGN KEY (`fldCreatedById`)
    REFERENCES `shoppingcart`.`tblUser` (`fldUser_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `prodImgfldDeletedById`
    FOREIGN KEY (`fldDeactivatedById`)
    REFERENCES `shoppingcart`.`tblUser` (`fldUser_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `shoppingcart`.`tblCart` (
  `fldCart_ID` INT NOT NULL,
  `fldUserId` INT NOT NULL,
  `fldProductId` INT NULL,
  `fldQuantity` INT NULL,
  `fldCreatedDate` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`fldCart_ID`),
  INDEX `CartCreatedBy_idx` (`fldUserId` ASC) VISIBLE,
  INDEX `CartProductId_idx` (`fldProductId` ASC) VISIBLE,
  CONSTRAINT `cartfldUserId`
    FOREIGN KEY (`fldUserId`)
    REFERENCES `shoppingcart`.`tblUser` (`fldUser_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cartfldProductId`
    FOREIGN KEY (`fldProductId`)
    REFERENCES `shoppingcart`.`tblProduct` (`fldProduct_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
