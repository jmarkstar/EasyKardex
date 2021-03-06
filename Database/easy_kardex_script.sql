-- MySQL Script generated by MySQL Workbench
-- Tue Aug  6 00:38:36 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema easy_kardex_db
-- -----------------------------------------------------
-- Done by jmarkstar.
DROP SCHEMA IF EXISTS `easy_kardex_db` ;

-- -----------------------------------------------------
-- Schema easy_kardex_db
--
-- Done by jmarkstar.
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `easy_kardex_db` ;
USE `easy_kardex_db` ;

-- -----------------------------------------------------
-- Table `easy_kardex_db`.`product_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `easy_kardex_db`.`product_category` ;

CREATE TABLE IF NOT EXISTS `easy_kardex_db`.`product_category` (
  `id_category` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `creation_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` TINYINT NULL DEFAULT 1,
  PRIMARY KEY (`id_category`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `easy_kardex_db`.`product_brand`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `easy_kardex_db`.`product_brand` ;

CREATE TABLE IF NOT EXISTS `easy_kardex_db`.`product_brand` (
  `id_brand` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NULL,
  `creation_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` TINYINT NULL DEFAULT 1,
  PRIMARY KEY (`id_brand`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `easy_kardex_db`.`product_unit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `easy_kardex_db`.`product_unit` ;

CREATE TABLE IF NOT EXISTS `easy_kardex_db`.`product_unit` (
  `id_unit` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `creation_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` TINYINT NULL DEFAULT 1,
  PRIMARY KEY (`id_unit`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `easy_kardex_db`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `easy_kardex_db`.`product` ;

CREATE TABLE IF NOT EXISTS `easy_kardex_db`.`product` (
  `id_prod` INT NOT NULL AUTO_INCREMENT,
  `id_brand` INT NOT NULL,
  `id_category` INT NOT NULL,
  `id_unit` INT NULL,
  `name` VARCHAR(85) NOT NULL,
  `image` VARCHAR(250) NULL,
  `thumb` VARCHAR(250) NULL,
  `description` VARCHAR(250) NULL,
  `creation_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` TINYINT NULL DEFAULT 1,
  PRIMARY KEY (`id_prod`),
  INDEX `fk_product_category_idx` (`id_category` ASC),
  INDEX `fk_product_brand_idx` (`id_brand` ASC),
  INDEX `fk_product_unit_idx` (`id_unit` ASC),
  CONSTRAINT `fk_product_category`
    FOREIGN KEY (`id_category`)
    REFERENCES `easy_kardex_db`.`product_category` (`id_category`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_brand`
    FOREIGN KEY (`id_brand`)
    REFERENCES `easy_kardex_db`.`product_brand` (`id_brand`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_unit`
    FOREIGN KEY (`id_unit`)
    REFERENCES `easy_kardex_db`.`product_unit` (`id_unit`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `easy_kardex_db`.`provider`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `easy_kardex_db`.`provider` ;

CREATE TABLE IF NOT EXISTS `easy_kardex_db`.`provider` (
  `id_provider` INT NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(100) NULL,
  `contact_name` VARCHAR(100) NULL,
  `contact_phone` VARCHAR(15) NULL,
  `creation_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` TINYINT NULL DEFAULT 1,
  PRIMARY KEY (`id_provider`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `easy_kardex_db`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `easy_kardex_db`.`role` ;

CREATE TABLE IF NOT EXISTS `easy_kardex_db`.`role` (
  `id_role` INT NOT NULL AUTO_INCREMENT COMMENT 'Rol id',
  `name` VARCHAR(45) NULL COMMENT 'Name',
  PRIMARY KEY (`id_role`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `easy_kardex_db`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `easy_kardex_db`.`user` ;

CREATE TABLE IF NOT EXISTS `easy_kardex_db`.`user` (
  `id_user` INT NOT NULL AUTO_INCREMENT,
  `id_role` INT NULL,
  `username` VARCHAR(150) NULL,
  `password` VARCHAR(100) NULL,
  `fullname` VARCHAR(150) NULL,
  `creation_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` TINYINT NULL DEFAULT 1,
  PRIMARY KEY (`id_user`),
  INDEX `fk_user_rol_idx` (`id_role` ASC),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  CONSTRAINT `fk_user_rol`
    FOREIGN KEY (`id_role`)
    REFERENCES `easy_kardex_db`.`role` (`id_role`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `easy_kardex_db`.`product_input`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `easy_kardex_db`.`product_input` ;

CREATE TABLE IF NOT EXISTS `easy_kardex_db`.`product_input` (
  `id_input` INT NOT NULL AUTO_INCREMENT,
  `id_prod` INT NULL,
  `id_provider` INT NULL,
  `purchase_price` FLOAT NULL,
  `expiration_date` DATE NULL,
  `quantity` INT NULL DEFAULT 0,
  `creation_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `creation_user_id` INT NULL,
  `last_update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` TINYINT NULL DEFAULT 1,
  PRIMARY KEY (`id_input`),
  INDEX `fk_input_product_idx` (`id_prod` ASC),
  INDEX `fk_input_provider_idx` (`id_provider` ASC),
  INDEX `fk_product_input_1_idx` (`creation_user_id` ASC),
  CONSTRAINT `fk_input_product`
    FOREIGN KEY (`id_prod`)
    REFERENCES `easy_kardex_db`.`product` (`id_prod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_input_provider`
    FOREIGN KEY (`id_provider`)
    REFERENCES `easy_kardex_db`.`provider` (`id_provider`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_input_creator`
    FOREIGN KEY (`creation_user_id`)
    REFERENCES `easy_kardex_db`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `easy_kardex_db`.`product_output`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `easy_kardex_db`.`product_output` ;

CREATE TABLE IF NOT EXISTS `easy_kardex_db`.`product_output` (
  `id_output` INT NOT NULL AUTO_INCREMENT,
  `id_product_input` INT NULL,
  `quantity` INT NULL,
  `creation_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `creation_user_id` INT NULL,
  `last_update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` TINYINT NULL DEFAULT 1,
  PRIMARY KEY (`id_output`),
  INDEX `fk_product_output_idx` (`id_product_input` ASC),
  INDEX `fk_product_output_creator_idx` (`creation_user_id` ASC),
  CONSTRAINT `fk_product_output_input`
    FOREIGN KEY (`id_product_input`)
    REFERENCES `easy_kardex_db`.`product_input` (`id_input`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_output_creator`
    FOREIGN KEY (`creation_user_id`)
    REFERENCES `easy_kardex_db`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `easy_kardex_db`.`user_token`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `easy_kardex_db`.`user_token` ;

CREATE TABLE IF NOT EXISTS `easy_kardex_db`.`user_token` (
  `id_token` INT NOT NULL AUTO_INCREMENT,
  `string` VARCHAR(100) NULL,
  `id_user` INT NULL,
  PRIMARY KEY (`id_token`),
  INDEX `fk_user_token_idx` (`id_user` ASC),
  CONSTRAINT `fk_user_token`
    FOREIGN KEY (`id_user`)
    REFERENCES `easy_kardex_db`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `easy_kardex_db`.`product_category`
-- -----------------------------------------------------
START TRANSACTION;
USE `easy_kardex_db`;
INSERT INTO `easy_kardex_db`.`product_category` (`id_category`, `name`, `creation_date`, `last_update_date`, `status`) VALUES (1, 'Golosinas', now() , now() , 1);
INSERT INTO `easy_kardex_db`.`product_category` (`id_category`, `name`, `creation_date`, `last_update_date`, `status`) VALUES (2, 'Gaseosas', now() , now() , 1);
INSERT INTO `easy_kardex_db`.`product_category` (`id_category`, `name`, `creation_date`, `last_update_date`, `status`) VALUES (3, 'Licores', now() , now() , 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `easy_kardex_db`.`product_brand`
-- -----------------------------------------------------
START TRANSACTION;
USE `easy_kardex_db`;
INSERT INTO `easy_kardex_db`.`product_brand` (`id_brand`, `name`, `creation_date`, `last_update_date`, `status`) VALUES (1, 'Alicorp', now() , now() , 1);
INSERT INTO `easy_kardex_db`.`product_brand` (`id_brand`, `name`, `creation_date`, `last_update_date`, `status`) VALUES (2, 'Arcor', now() , now() , 1);
INSERT INTO `easy_kardex_db`.`product_brand` (`id_brand`, `name`, `creation_date`, `last_update_date`, `status`) VALUES (3, 'Ambrosoli', now() , now() , 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `easy_kardex_db`.`product_unit`
-- -----------------------------------------------------
START TRANSACTION;
USE `easy_kardex_db`;
INSERT INTO `easy_kardex_db`.`product_unit` (`id_unit`, `name`, `creation_date`, `last_update_date`, `status`) VALUES (1, 'Litro', now() , now() , 1);
INSERT INTO `easy_kardex_db`.`product_unit` (`id_unit`, `name`, `creation_date`, `last_update_date`, `status`) VALUES (2, 'Kilo', now() , now() , 1);
INSERT INTO `easy_kardex_db`.`product_unit` (`id_unit`, `name`, `creation_date`, `last_update_date`, `status`) VALUES (3, 'Pack x 6', now() , now() , 1);
INSERT INTO `easy_kardex_db`.`product_unit` (`id_unit`, `name`, `creation_date`, `last_update_date`, `status`) VALUES (4, 'Pack x 12', now() , now() , 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `easy_kardex_db`.`product`
-- -----------------------------------------------------
START TRANSACTION;
USE `easy_kardex_db`;
INSERT INTO `easy_kardex_db`.`product` (`id_prod`, `id_brand`, `id_category`, `id_unit`, `name`, `image`, `thumb`, `description`, `creation_date`, `last_update_date`, `status`) VALUES (1, 1, 1, NULL, 'Casino', 'https://img.gestion.pe/files/article_content_ge_fotos/files/crop/uploads/2019/03/24/5c97c54cee8b3.r_1553648458233.0-0-568-318.jpeg', 'https://www.alicorp.com.pe/alicorp/userfiles/cms/pagina/imagen/marca/item/galletas_casino_coco.jpg', 'Es una galleta muy rica xD', now() , now() , 1);
INSERT INTO `easy_kardex_db`.`product` (`id_prod`, `id_brand`, `id_category`, `id_unit`, `name`, `image`, `thumb`, `description`, `creation_date`, `last_update_date`, `status`) VALUES (2, 3, 1, NULL, 'Mentitas', 'https://www.elparana.com/wp-content/uploads/2016/05/mentitas-de-ambrosoli.jpg', '', 'Son caramelos de menta', now() , now() , 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `easy_kardex_db`.`provider`
-- -----------------------------------------------------
START TRANSACTION;
USE `easy_kardex_db`;
INSERT INTO `easy_kardex_db`.`provider` (`id_provider`, `company_name`, `contact_name`, `contact_phone`, `creation_date`, `last_update_date`, `status`) VALUES (1, 'Ambrosoli', 'Jorge Perez', '999555333', now() , now() , 1);
INSERT INTO `easy_kardex_db`.`provider` (`id_provider`, `company_name`, `contact_name`, `contact_phone`, `creation_date`, `last_update_date`, `status`) VALUES (2, 'Arcor', 'Maria Perea', '987412523', now() , now() , 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `easy_kardex_db`.`role`
-- -----------------------------------------------------
START TRANSACTION;
USE `easy_kardex_db`;
INSERT INTO `easy_kardex_db`.`role` (`id_role`, `name`) VALUES (1, 'ADMIN');
INSERT INTO `easy_kardex_db`.`role` (`id_role`, `name`) VALUES (2, 'OPERATOR');

COMMIT;

