DROP SCHEMA IF EXISTS moviesData;
CREATE SCHEMA moviesData;
USE moviesData;

CREATE TABLE movie(
	id_movie INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    runtime INT NOT NULL,
    release_date DATE NOT NULL,
    popularity FLOAT,
    budget INT,
    revenue INT,
    vote_count INT,
    id_genre INT NOT NULL,
    id_country INT NOT NULL,
    id_company INT NOT NULL,
    id_language INT NOT NULL
    
)ENGINE=InnoDB;
CREATE TABLE genre(
	id_genre INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    genre VARCHAR(100) NOT NULL
)ENGINE=InnoDB;
CREATE TABLE country(
	id_country INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    country VARCHAR(100) NOT NULL
)ENGINE=InnoDB;
CREATE TABLE `language`(
	id_language INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `language` VARCHAR(100) NOT NULL
)ENGINE=InnoDB;
CREATE TABLE company(
	id_company INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL,
    id_country INT NOT NULL
)ENGINE=InnoDB;

ALTER TABLE movie ADD CONSTRAINT fk_idGenre_movie
	FOREIGN KEY (id_genre) REFERENCES genre (id_genre);
ALTER TABLE movie ADD CONSTRAINT fk_idCountry_movie
	FOREIGN KEY (id_country) REFERENCES country (id_country);
ALTER TABLE movie ADD CONSTRAINT fk_idCompany_movie
	FOREIGN KEY (id_company) REFERENCES company (id_company);
ALTER TABLE movie ADD CONSTRAINT fk_idLanguage_movie
	FOREIGN KEY (id_language) REFERENCES `language` (id_language);    
ALTER TABLE company ADD CONSTRAINT fk_idCountry_company
	FOREIGN KEY (id_country) REFERENCES country (id_country);    