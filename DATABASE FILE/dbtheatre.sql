-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 03, 2022 at 09:27 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbtheatre`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_old` ()  begin

	declare curdate date;
set curdate=curdate();

DELETE FROM shows 
WHERE datediff(Date,curdate)<0;

DELETE FROM shows 
WHERE movie_id IN 
(SELECT movie_id 
FROM movies
WHERE datediff(show_end,curdate)<0);

DELETE FROM movies 
WHERE datediff(show_end,curdate)<0;

end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `booked_tickets`
--

CREATE TABLE `booked_tickets` (
  `ticket_no` int(11) NOT NULL,
  `show_id` int(11) NOT NULL,
  `seat_no` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `booked_tickets`
--

INSERT INTO `booked_tickets` (`ticket_no`, `show_id`, `seat_no`) VALUES
(139289529, 1477914847, 1003),
(385923108, 709149699, 6),
(736770709, 600604545, 1015),
(835440263, 600604545, 22),
(1642941104, 1477914847, 6),
(1803819514, 709149699, 1003);

-- --------------------------------------------------------

--
-- Table structure for table `halls`
--

CREATE TABLE `halls` (
  `hall_id` int(11) NOT NULL,
  `class` varchar(10) NOT NULL,
  `no_of_seats` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `halls`
--

INSERT INTO `halls` (`hall_id`, `class`, `no_of_seats`) VALUES
(1, 'gold', 35),
(1, 'standard', 75),
(2, 'gold', 27),
(2, 'standard', 97),
(3, 'gold', 26),
(3, 'standard', 98);

--
-- Triggers `halls`
--
DELIMITER $$
CREATE TRIGGER `get_price` AFTER INSERT ON `halls` FOR EACH ROW begin

UPDATE shows s, price_listing p 
SET s.price_id=p.price_id 
WHERE p.price_id IN 
(SELECT price_id 
FROM price_listing p 
WHERE dayname(s.Date)=p.day AND s.type=p.type);

end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `movie_id` int(11) NOT NULL,
  `movie_name` varchar(64) DEFAULT NULL,
  `length` int(11) DEFAULT NULL,
  `language` varchar(10) DEFAULT NULL,
  `show_start` date DEFAULT NULL,
  `show_end` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`movie_id`, `movie_name`, `length`, `language`, `show_start`, `show_end`) VALUES
(107436081, 'Top Gun', 110, 'English', '2022-05-30', '2022-06-05'),
(559738927, 'La La Land', 128, 'English', '2022-05-31', '2022-06-05'),
(632339860, 'Morbius', 103, 'English', '2022-05-30', '2022-06-05'),
(1056908902, 'Dora and the Lost City of Gold', 102, 'English', '2022-05-30', '2022-06-05'),
(1212838661, 'Jurassic World: Fallen Kingdom', 128, 'English', '2022-05-30', '2022-06-05'),
(1451049280, 'Fantastic Beasts: The Secrets of Dumbledore', 148, 'English', '2022-05-31', '2022-06-05'),
(2010693340, 'Sonic the Hedgehog 2', 121, 'English', '2022-05-30', '2022-06-05'),
(2065731653, 'The Incredibles', 115, 'English', '2022-05-31', '2022-06-05'),
(2094959927, 'Spider-Man: No Way Home', 148, 'English', '2022-05-31', '2022-06-05'),
(2106368628, 'The Adam Project', 106, 'English', '2022-05-30', '2022-06-05');

-- --------------------------------------------------------

--
-- Table structure for table `price_listing`
--

CREATE TABLE `price_listing` (
  `price_id` int(11) NOT NULL,
  `type` varchar(4) DEFAULT NULL,
  `day` varchar(10) DEFAULT NULL,
  `price` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `price_listing`
--

INSERT INTO `price_listing` (`price_id`, `type`, `day`, `price`) VALUES
(1, '2D', 'Monday', 310),
(2, '3D', 'Monday', 450),
(3, 'IMAX', 'Monday', 670),
(4, '2D', 'Tuesday', 200),
(5, '3D', 'Tuesday', 450),
(6, 'IMAX', 'Tuesday', 670),
(7, '2D', 'Wednesday', 310),
(8, '3D', 'Wednesday', 450),
(9, 'IMAX', 'Wednesday', 670),
(10, '2D', 'Thursday', 310),
(11, '3D', 'Thursday', 450),
(12, 'IMAX', 'Thursday', 670),
(13, '2D', 'Friday', 310),
(14, '3D', 'Friday', 450),
(15, 'IMAX', 'Friday', 670),
(16, '2D', 'Saturday', 310),
(17, '3D', 'Saturday', 450),
(18, 'IMAX', 'Saturday', 670),
(19, '2D', 'Sunday', 310),
(20, '3D', 'Sunday', 450),
(21, 'IMAX', 'Sunday', 670);

-- --------------------------------------------------------

--
-- Table structure for table `shows`
--

CREATE TABLE `shows` (
  `show_id` int(11) NOT NULL,
  `movie_id` int(11) DEFAULT NULL,
  `hall_id` int(11) DEFAULT NULL,
  `type` varchar(4) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `price_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shows`
--

INSERT INTO `shows` (`show_id`, `movie_id`, `hall_id`, `type`, `time`, `Date`, `price_id`) VALUES
(600604545, 1451049280, 3, 'IMAX', 1200, '2022-05-31', 6),
(709149699, 2094959927, 1, '2D', 1000, '2022-05-31', 4),
(1477914847, 559738927, 1, '2D', 1300, '2022-05-31', 4);

-- --------------------------------------------------------

--
-- Table structure for table `types`
--

CREATE TABLE `types` (
  `movie_id` int(11) NOT NULL,
  `type1` varchar(3) DEFAULT NULL,
  `type2` varchar(3) DEFAULT NULL,
  `type3` varchar(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `types`
--

INSERT INTO `types` (`movie_id`, `type1`, `type2`, `type3`) VALUES
(107436081, '2D', '3D', 'IMAX'),
(559738927, '2D', '3D', 'IMAX'),
(632339860, '2D', 'NUL', 'NUL'),
(1056908902, '2D', '3D', 'IMAX'),
(1212838661, '2D', '3D', 'IMAX'),
(1451049280, '2D', '3D', 'IMAX'),
(2010693340, '2D', '3D', 'NUL'),
(2065731653, '2D', '3D', 'NUL'),
(2094959927, '2D', '3D', 'IMAX'),
(2106368628, '2D', '3D', 'IMAX');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `booked_tickets`
--
ALTER TABLE `booked_tickets`
  ADD PRIMARY KEY (`ticket_no`,`show_id`),
  ADD KEY `show_id` (`show_id`);

--
-- Indexes for table `halls`
--
ALTER TABLE `halls`
  ADD PRIMARY KEY (`hall_id`,`class`);

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`movie_id`);

--
-- Indexes for table `price_listing`
--
ALTER TABLE `price_listing`
  ADD PRIMARY KEY (`price_id`);

--
-- Indexes for table `shows`
--
ALTER TABLE `shows`
  ADD PRIMARY KEY (`show_id`),
  ADD KEY `movie_id` (`movie_id`),
  ADD KEY `hall_id` (`hall_id`),
  ADD KEY `price_id` (`price_id`);

--
-- Indexes for table `types`
--
ALTER TABLE `types`
  ADD PRIMARY KEY (`movie_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booked_tickets`
--
ALTER TABLE `booked_tickets`
  ADD CONSTRAINT `booked_tickets_ibfk_1` FOREIGN KEY (`show_id`) REFERENCES `shows` (`show_id`) ON DELETE CASCADE;

--
-- Constraints for table `shows`
--
ALTER TABLE `shows`
  ADD CONSTRAINT `shows_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`),
  ADD CONSTRAINT `shows_ibfk_2` FOREIGN KEY (`hall_id`) REFERENCES `halls` (`hall_id`),
  ADD CONSTRAINT `shows_ibfk_3` FOREIGN KEY (`price_id`) REFERENCES `price_listing` (`price_id`) ON UPDATE CASCADE;

--
-- Constraints for table `types`
--
ALTER TABLE `types`
  ADD CONSTRAINT `types_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
