-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Czas generowania: 08 Gru 2019, 22:17
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

DELIMITER $$
--
-- Funkcje
--
DROP FUNCTION IF EXISTS `project_list_percentage`$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `customer`
--

DROP TABLE IF EXISTS `customer`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `employee`
--

DROP TABLE IF EXISTS `employee`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `project_list`
--

DROP TABLE IF EXISTS `project_list`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `status`
--

DROP TABLE IF EXISTS `status`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `task_details`
--

DROP TABLE IF EXISTS `task_details`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `task_list`
--

DROP TABLE IF EXISTS `task_list`;

--
-- Wyzwalacze `task_list`
--
DROP TRIGGER IF EXISTS `task_list_trigger_ad`;
DROP TRIGGER IF EXISTS `task_list_trigger_ai`;
DROP TRIGGER IF EXISTS `task_list_trigger_au`;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

SELECT 'MySQL is happy :)';