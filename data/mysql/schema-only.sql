-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Czas generowania: 09 Gru 2019, 11:34
-- Wersja serwera: 5.7.28-0ubuntu0.18.04.4
-- Wersja PHP: 7.1.33-1+ubuntu18.04.1+deb.sury.org+1

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `tmsneek`
--
CREATE DATABASE IF NOT EXISTS `tmsneek` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `tmsneek`;

DELIMITER $$
--
-- Funkcje
--
DROP FUNCTION IF EXISTS `project_list_percentage`$$
CREATE DEFINER=`tmsneek`@`%` FUNCTION `project_list_percentage` (`project_list` INT) RETURNS INT(11) BEGIN
SET @atl_count = (SELECT COUNT(ptl.id) AS count FROM task_list ptl INNER JOIN status ps ON ptl.status = ps.id WHERE ptl.project_list = project_list);
SET @ctl_count = (SELECT COUNT(ptl.id) AS count FROM task_list ptl INNER JOIN status ps ON ptl.status = ps.id WHERE ptl.project_list = project_list AND ps.name='Zamknięte');
UPDATE project_list SET percentage=(SELECT IF(@atl_count>0,(@ctl_count/@atl_count)*100, 0)) WHERE id=project_list;
RETURN project_list;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `customer`
--

DROP TABLE IF EXISTS `customer`;
CREATE TABLE IF NOT EXISTS `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_name_index` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `employee`
--

DROP TABLE IF EXISTS `employee`;
CREATE TABLE IF NOT EXISTS `employee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `surname` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_surname_index` (`surname`),
  KEY `employee_email_index` (`email`),
  KEY `employee_name_index` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `project_list`
--

DROP TABLE IF EXISTS `project_list`;
CREATE TABLE IF NOT EXISTS `project_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer` int(11) NOT NULL,
  `project_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_list_customer_index` (`customer`) USING BTREE,
  KEY `project_list_project_name_index` (`project_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `status`
--

DROP TABLE IF EXISTS `status`;
CREATE TABLE IF NOT EXISTS `status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status_name_index` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `task_details`
--

DROP TABLE IF EXISTS `task_details`;
CREATE TABLE IF NOT EXISTS `task_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_list` int(11) NOT NULL,
  `employee` int(11) NOT NULL,
  `name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `task_details_employee_index` (`employee`),
  KEY `task_details_name_index` (`name`),
  KEY `task_details_task_list_index` (`task_list`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `task_list`
--

DROP TABLE IF EXISTS `task_list`;
CREATE TABLE IF NOT EXISTS `task_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_list` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `priority` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `task_list_name_index` (`name`),
  KEY `task_list_project_list_index` (`project_list`),
  KEY `task_list_status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Wyzwalacze `task_list`
--
DROP TRIGGER IF EXISTS `task_list_trigger_ad`;
DELIMITER $$
CREATE TRIGGER `task_list_trigger_ad` AFTER DELETE ON `task_list` FOR EACH ROW BEGIN
SET @project_list = (SELECT project_list_percentage(old.project_list)) ;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `task_list_trigger_ai`;
DELIMITER $$
CREATE TRIGGER `task_list_trigger_ai` AFTER INSERT ON `task_list` FOR EACH ROW BEGIN
SET @project_list = (SELECT project_list_percentage(new.project_list)) ;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `task_list_trigger_au`;
DELIMITER $$
CREATE TRIGGER `task_list_trigger_au` AFTER UPDATE ON `task_list` FOR EACH ROW BEGIN
SET @project_list = (SELECT project_list_percentage(new.project_list)) ;
END
$$
DELIMITER ;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `project_list`
--
ALTER TABLE `project_list`
  ADD CONSTRAINT `project_list_customer_fkey` FOREIGN KEY (`customer`) REFERENCES `customer` (`id`) ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `task_details`
--
ALTER TABLE `task_details`
  ADD CONSTRAINT `task_details_employee_fkey` FOREIGN KEY (`employee`) REFERENCES `employee` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `task_details_task_list_fkey` FOREIGN KEY (`task_list`) REFERENCES `task_list` (`id`) ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `task_list`
--
ALTER TABLE `task_list`
  ADD CONSTRAINT `task_list_project_list_fkey` FOREIGN KEY (`project_list`) REFERENCES `project_list` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `task_list_status_fkey` FOREIGN KEY (`status`) REFERENCES `status` (`id`) ON UPDATE CASCADE;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
