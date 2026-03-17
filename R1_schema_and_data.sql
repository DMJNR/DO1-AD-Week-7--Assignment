-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 12, 2026 at 07:52 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- ======================================================
-- Aston University
-- Database Development (Summative assessment 2)
-- Student: David I Moses
-- Database: software_pm
-- File: R1 Schema and Data
-- ======================================================

CREATE DATABASE IF NOT EXISTS `software_pm` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `software_pm`;

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `client_id` int(11) NOT NULL,
  `organisation_name` varchar(150) NOT NULL,
  `contact_first_name` varchar(60) NOT NULL,
  `contact_last_name` varchar(60) NOT NULL,
  `email` varchar(120) NOT NULL,
  `address` varchar(255) NOT NULL,
  `contact_method_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`client_id`, `organisation_name`, `contact_first_name`, `contact_last_name`, `email`, `address`, `contact_method_id`, `created_at`) VALUES
(1, 'Northbridge Retail Ltd', 'Sarah', 'Khan', 'sarah.khan@northbridge-retail.com', '10 High Street, Birmingham, UK', 2, '2026-03-11 17:16:38'),
(2, 'Apex FinTech Partners', 'Daniel', 'Reed', 'daniel.reed@apex-fintech.com', '22 River Road, London, UK', 1, '2026-03-11 17:16:38'),
(3, 'Vertex Digital Solutions', 'Olivia', 'Bennett', 'olivia.bennett@vertexdigital.co.uk', '85 Innovation Park, Manchester, UK', 2, '2026-03-11 18:59:24');

-- --------------------------------------------------------

--
-- Table structure for table `lu_contact_method`
--

CREATE TABLE `lu_contact_method` (
  `contact_method_id` int(11) NOT NULL,
  `method_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lu_contact_method`
--

INSERT INTO `lu_contact_method` (`contact_method_id`, `method_name`) VALUES
(2, 'email'),
(1, 'post');

-- --------------------------------------------------------

--
-- Table structure for table `lu_experience_level`
--

CREATE TABLE `lu_experience_level` (
  `experience_level_id` int(11) NOT NULL,
  `level_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lu_experience_level`
--

INSERT INTO `lu_experience_level` (`experience_level_id`, `level_name`) VALUES
(4, 'Expert'),
(2, 'Intermediate'),
(1, 'Junior'),
(3, 'Senior');

-- --------------------------------------------------------

--
-- Table structure for table `lu_project_phase`
--

CREATE TABLE `lu_project_phase` (
  `phase_id` int(11) NOT NULL,
  `phase_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lu_project_phase`
--

INSERT INTO `lu_project_phase` (`phase_id`, `phase_name`) VALUES
(5, 'Closure'),
(3, 'Execution'),
(1, 'Initiation'),
(4, 'Monitoring and Controlling'),
(2, 'Planning');

-- --------------------------------------------------------

--
-- Table structure for table `pool_member`
--

CREATE TABLE `pool_member` (
  `pool_member_id` int(11) NOT NULL,
  `first_name` varchar(60) NOT NULL,
  `last_name` varchar(60) NOT NULL,
  `email` varchar(120) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `work_address` varchar(255) NOT NULL,
  `home_address` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pool_member`
--

INSERT INTO `pool_member` (`pool_member_id`, `first_name`, `last_name`, `email`, `phone`, `work_address`, `home_address`, `created_at`) VALUES
(1, 'Joyce', 'Moses', 'joyce.moses@softwareco.com', '07765 742236', '1 Innovation Way, Coventry, UK', '15 Park Lane, Coventry, UK', '2026-03-11 17:19:44'),
(2, 'Jean', 'Dubois', 'jean.dubois@softwareco.com', '07236 828952', '1 Innovation Way, Coventry, UK', '28 Meadow Close, Rugby, UK', '2026-03-11 17:19:44'),
(3, 'Michael', 'Turner', 'michael.turner@softwareco.com', '07881 253386', '1 Innovation Way, Coventry, UK', '7 Oak Road, Leicester, UK', '2026-03-11 18:36:39'),
(4, 'Priya', 'Patel', 'priya.patel@softwareco.com', '07070 764438', '1 Innovation Way, Coventry, UK', '22 Station Road, Birmingham, UK', '2026-03-11 18:36:39'),
(5, 'Liam', 'Owen', 'liam.owen@softwareco.com', '07185 353437', '1 Innovation Way, Coventry, UK', '5 River Close, Nottingham, UK', '2026-03-11 18:36:39'),
(6, 'Sophie', 'Clarke', 'sophie.clarke@softwareco.com', '07952 811309', '1 Innovation Way, Coventry, UK', '18 Green Lane, Derby, UK', '2026-03-11 18:36:39');

-- --------------------------------------------------------

--
-- Table structure for table `pool_member_skill`
--

CREATE TABLE `pool_member_skill` (
  `pool_member_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL,
  `experience_level_id` int(11) NOT NULL,
  `years_experience` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pool_member_skill`
--

INSERT INTO `pool_member_skill` (`pool_member_id`, `skill_id`, `experience_level_id`, `years_experience`) VALUES
(1, 1, 4, 5),
(1, 2, 3, 4),
(1, 4, 2, 2),
(2, 3, 2, 3),
(2, 4, 1, 1),
(2, 6, 2, 2),
(3, 1, 3, 5),
(3, 2, 2, 3),
(3, 4, 3, 4),
(4, 3, 3, 5),
(4, 5, 2, 3),
(4, 6, 3, 4),
(5, 1, 2, 2),
(5, 4, 4, 6),
(5, 7, 3, 4),
(6, 3, 2, 3),
(6, 4, 2, 2),
(6, 6, 3, 4);

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

CREATE TABLE `project` (
  `project_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `budget` decimal(12,2) NOT NULL,
  `short_description` varchar(400) NOT NULL,
  `phase_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`project_id`, `client_id`, `title`, `start_date`, `end_date`, `budget`, `short_description`, `phase_id`, `created_at`) VALUES
(1, 1, 'Inventory Tracker v2', '2026-03-01', NULL, 25000.00, 'Build a web-based inventory tracker with reporting and audit trails.', 3, '2026-03-11 17:46:06'),
(2, 1, 'Retail Analytics Dashboard', '2026-04-10', NULL, 42000.00, 'Develop a business intelligence dashboard to analyse retail sales and inventory performance.', 2, '2026-03-11 17:46:06'),
(3, 2, 'Secure Payment Gateway', '2026-05-01', NULL, 60000.00, 'Develop a secure payment processing system with fraud detection and reporting.', 4, '2026-03-11 17:46:06'),
(4, 3, 'Corporate Marketing Website', '2026-06-01', NULL, 18000.00, 'Design and develop a responsive corporate marketing website with modern UI and automated testing.', 1, '2026-03-11 19:08:04');

-- --------------------------------------------------------

--
-- Table structure for table `project_assignment`
--

CREATE TABLE `project_assignment` (
  `assignment_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `pool_member_id` int(11) NOT NULL,
  `assigned_on` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_required_skill`
--

CREATE TABLE `project_required_skill` (
  `project_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL,
  `required_experience_level_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `project_required_skill`
--

INSERT INTO `project_required_skill` (`project_id`, `skill_id`, `required_experience_level_id`) VALUES
(1, 4, 1),
(1, 3, 2),
(2, 5, 2),
(3, 1, 2),
(4, 2, 2),
(2, 3, 3),
(3, 7, 3),
(4, 6, 3);

-- --------------------------------------------------------

--
-- Table structure for table `skill`
--

CREATE TABLE `skill` (
  `skill_id` int(11) NOT NULL,
  `skill_name` varchar(80) NOT NULL,
  `skill_type` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `skill`
--

INSERT INTO `skill` (`skill_id`, `skill_name`, `skill_type`) VALUES
(7, 'Docker', 'DevOps'),
(6, 'HTML/CSS', 'Frontend'),
(1, 'Java', 'Backend'),
(3, 'JavaScript', 'Frontend'),
(2, 'JUnit', 'Testing'),
(5, 'PHP', 'Backend'),
(4, 'SQL', 'Database');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`client_id`),
  ADD UNIQUE KEY `uq_client_email` (`email`),
  ADD KEY `fk_client_contact_method` (`contact_method_id`);

--
-- Indexes for table `lu_contact_method`
--
ALTER TABLE `lu_contact_method`
  ADD PRIMARY KEY (`contact_method_id`),
  ADD UNIQUE KEY `uq_contact_method_name` (`method_name`);

--
-- Indexes for table `lu_experience_level`
--
ALTER TABLE `lu_experience_level`
  ADD PRIMARY KEY (`experience_level_id`),
  ADD UNIQUE KEY `uq_experience_level_name` (`level_name`);

--
-- Indexes for table `lu_project_phase`
--
ALTER TABLE `lu_project_phase`
  ADD PRIMARY KEY (`phase_id`),
  ADD UNIQUE KEY `uq_phase_name` (`phase_name`);

--
-- Indexes for table `pool_member`
--
ALTER TABLE `pool_member`
  ADD PRIMARY KEY (`pool_member_id`),
  ADD UNIQUE KEY `uq_pool_member_email` (`email`);

--
-- Indexes for table `pool_member_skill`
--
ALTER TABLE `pool_member_skill`
  ADD PRIMARY KEY (`pool_member_id`,`skill_id`),
  ADD KEY `idx_pms_skill` (`skill_id`),
  ADD KEY `idx_pms_experience_level` (`experience_level_id`);

--
-- Indexes for table `project`
--
ALTER TABLE `project`
  ADD PRIMARY KEY (`project_id`),
  ADD KEY `idx_project_client` (`client_id`),
  ADD KEY `idx_project_phase` (`phase_id`);

--
-- Indexes for table `project_assignment`
--
ALTER TABLE `project_assignment`
  ADD PRIMARY KEY (`assignment_id`),
  ADD UNIQUE KEY `uq_pa_member` (`pool_member_id`),
  ADD KEY `idx_pa_project` (`project_id`);

--
-- Indexes for table `project_required_skill`
--
ALTER TABLE `project_required_skill`
  ADD PRIMARY KEY (`project_id`,`skill_id`),
  ADD KEY `fk_prs_experience_level` (`required_experience_level_id`),
  ADD KEY `idx_prs_skill` (`skill_id`);

--
-- Indexes for table `skill`
--
ALTER TABLE `skill`
  ADD PRIMARY KEY (`skill_id`),
  ADD UNIQUE KEY `uq_skill_name_type` (`skill_name`,`skill_type`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `lu_contact_method`
--
ALTER TABLE `lu_contact_method`
  MODIFY `contact_method_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `lu_experience_level`
--
ALTER TABLE `lu_experience_level`
  MODIFY `experience_level_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `lu_project_phase`
--
ALTER TABLE `lu_project_phase`
  MODIFY `phase_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pool_member`
--
ALTER TABLE `pool_member`
  MODIFY `pool_member_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `project`
--
ALTER TABLE `project`
  MODIFY `project_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_assignment`
--
ALTER TABLE `project_assignment`
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `skill`
--
ALTER TABLE `skill`
  MODIFY `skill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `fk_client_contact_method` FOREIGN KEY (`contact_method_id`) REFERENCES `lu_contact_method` (`contact_method_id`) ON UPDATE CASCADE;

--
-- Constraints for table `pool_member_skill`
--
ALTER TABLE `pool_member_skill`
  ADD CONSTRAINT `fk_pms_experience_level` FOREIGN KEY (`experience_level_id`) REFERENCES `lu_experience_level` (`experience_level_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pms_member` FOREIGN KEY (`pool_member_id`) REFERENCES `pool_member` (`pool_member_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pms_skill` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`skill_id`) ON UPDATE CASCADE;

--
-- Constraints for table `project`
--
ALTER TABLE `project`
  ADD CONSTRAINT `fk_project_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_project_phase` FOREIGN KEY (`phase_id`) REFERENCES `lu_project_phase` (`phase_id`) ON UPDATE CASCADE;

--
-- Constraints for table `project_assignment`
--
ALTER TABLE `project_assignment`
  ADD CONSTRAINT `fk_pa_member` FOREIGN KEY (`pool_member_id`) REFERENCES `pool_member` (`pool_member_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pa_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `project_required_skill`
--
ALTER TABLE `project_required_skill`
  ADD CONSTRAINT `fk_prs_experience_level` FOREIGN KEY (`required_experience_level_id`) REFERENCES `lu_experience_level` (`experience_level_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prs_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prs_skill` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`skill_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
