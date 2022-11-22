-- create-db.sql

DROP DATABASE IF EXISTS ocp6;
CREATE DATABASE ocp6;
USE ocp6;

CREATE TABLE address(
    `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `label` VARCHAR(30) NOT NULL,
    `name` VARCHAR(30) NOT NULL,
    `line1` VARCHAR(30) NOT NULL,
    `line2` VARCHAR(20),
    `zip` VARCHAR(5) NOT NULL,
    `city` VARCHAR(20) NOT NULL
) ENGINE=INNODB;

CREATE TABLE ingredient(
    `id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `label` VARCHAR(30) NOT NULL,
    `unit` VARCHAR(10) NOT NULL
) ENGINE=INNODB;

CREATE TABLE payment_solution(
    `id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `label` VARCHAR(10) NOT NULL
) ENGINE=INNODB;

CREATE TABLE pizza(
    `id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(10) NOT NULL,
    `unit_price_ex_tax` DECIMAL(6,2),
    `tax_rate100` DECIMAL(6,2)
) ENGINE=INNODB;

CREATE TABLE phone(
    `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `number` VARCHAR(10) NOT NULL
) ENGINE=INNODB;

CREATE TABLE client(
    `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `delivery_address_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_client_delivery_address`
        FOREIGN KEY(delivery_address_id)
        REFERENCES address(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `billing_address_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_client_billing_address`
        FOREIGN KEY(billing_address_id)
        REFERENCES address(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `phone_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_client_phone`
        FOREIGN KEY(phone_id)
        REFERENCES phone(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `1st_name` VARCHAR(30) NOT NULL,
    `name` VARCHAR(30) NOT NULL,
    `mail` VARCHAR(40) NOT NULL,
    `login` VARCHAR(30) NOT NULL,
    `password_sha2bin` BINARY(32) NOT NULL
) ENGINE=INNODB;

CREATE TABLE composition(
    `pizza_id` TINYINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_composition_pizza`
        FOREIGN KEY (pizza_id)
        REFERENCES pizza(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `ingredient_id` TINYINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_composition_ingredient`
        FOREIGN KEY(ingredient_id)
        REFERENCES ingredient(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `composition_pfk` PRIMARY KEY(pizza_id, ingredient_id),
    `quantity` TINYINT UNSIGNED NOT NULL
) ENGINE=INNODB;

CREATE TABLE employee(
    `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `address_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_employee_address`
        FOREIGN KEY(address_id)
        REFERENCES address(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `phone_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_phone_employee`
        FOREIGN KEY (phone_id)
        REFERENCES  phone(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `1st_name` VARCHAR(30) NOT NULL,
    `name` VARCHAR(30) NOT NULL,
    `mail` VARCHAR(40) NOT NULL,
    `login` VARCHAR(30) NOT NULL,
    `password_sha2bin` BINARY(32) NOT NULL
) ENGINE=INNODB;

CREATE TABLE restaurant(
    `id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `address_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_restaurant_address`
        FOREIGN KEY (address_id)
        REFERENCES  address(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `phone_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_restaurant_hone`
        FOREIGN KEY(phone_id)
        REFERENCES phone(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `name` VARCHAR(10) NOT NULL
) ENGINE=INNODB;

CREATE TABLE basket(
    `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `employee_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_basket_employee`
        FOREIGN KEY(employee_id)
        REFERENCES employee(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `client_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_basket_client`
        FOREIGN KEY(client_id)
        REFERENCES client(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `restaurant_id` TINYINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_basket_restaurant`
        FOREIGN KEY(restaurant_id)
        REFERENCES restaurant(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `invoice_num` VARCHAR(10) NOT NULL,
    `date` DATE NOT NULL,
    `status` VARCHAR(10) NOT NULL
) ENGINE=INNODB;

CREATE TABLE line_basket(
    `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `basket_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_line_basket_basket`
        FOREIGN KEY(basket_id)
        REFERENCES basket(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `pizza_id` TINYINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_line_basket_pizza`
        FOREIGN KEY(pizza_id)
        REFERENCES pizza(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `quantity` TINYINT UNSIGNED NOT NULL,
    `tax_rate100` DECIMAL(6,2) NOT NULL,
    `unit_price_ex_tax` DECIMAL(6,2) NOT NULL
) ENGINE=INNODB;

CREATE TABLE payment_history(
    `payment_solution_id` TINYINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_payment_history_payment_solution`
        FOREIGN KEY(payment_solution_id)
        REFERENCES payment_solution(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `basket_id` MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_payment_history_basket`
        FOREIGN KEY(basket_id)
        REFERENCES basket(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `composition_pfk` PRIMARY KEY(payment_solution_id, basket_id),
    `amount` DECIMAL(6,2) NOT NULL,
    `date` DATE NOT NULL
) ENGINE=INNODB;

CREATE TABLE stock(
    `ingredient_id` TINYINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_stock_ingredient`
        FOREIGN KEY(ingredient_id)
        REFERENCES ingredient(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    `restaurant_id` TINYINT UNSIGNED NOT NULL,
    CONSTRAINT `fk_stock_restaurant`
        FOREIGN KEY(restaurant_id)
        REFERENCES restaurant(id)
        ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT `pfk_composition` PRIMARY KEY(ingredient_id, restaurant_id),
    `quantity` TINYINT UNSIGNED NOT NULL
) ENGINE=INNODB;
