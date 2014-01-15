CREATE DATABASE  IF NOT EXISTS `redmine` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `redmine`;
-- MySQL dump 10.13  Distrib 5.6.15, for Win64 (x86_64)
--
-- Host: localhost    Database: redmine
-- ------------------------------------------------------
-- Server version	5.6.15-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `spm_servers`
--

DROP TABLE IF EXISTS `spm_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spm_servers` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `IPLocal` varchar(50) DEFAULT NULL,
  `IPUAT` varchar(50) DEFAULT NULL,
  `IPProduction` varchar(50) DEFAULT NULL,
  `Description` varchar(100) CHARACTER SET ascii DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spm_storeprocedures`
--

DROP TABLE IF EXISTS `spm_storeprocedures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spm_storeprocedures` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ServerId` int(10) unsigned NOT NULL,
  `DatabaseId` int(10) unsigned NOT NULL,
  `Name` varchar(300) NOT NULL,
  `IsFunction` bit(1) NOT NULL DEFAULT b'0',
  `ActionName` varchar(10) DEFAULT NULL,
  `ModifiedBy` int(10) unsigned NOT NULL,
  `Status` int(10) unsigned NOT NULL,
  `Description` varchar(300) NOT NULL,
  `IssueId` int(10) unsigned NOT NULL,
  `ModifiedDate` datetime DEFAULT NULL,
  `DeveloperId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Id`) USING BTREE,
  KEY `IssueId` (`IssueId`)
) ENGINE=InnoDB AUTO_INCREMENT=961 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spm_favorities_issues`
--

DROP TABLE IF EXISTS `spm_favorities_issues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spm_favorities_issues` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `IssueId` int(10) unsigned NOT NULL,
  `UserId` varchar(45) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IssueId_UserId` (`IssueId`,`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spm_databases`
--

DROP TABLE IF EXISTS `spm_databases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spm_databases` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Description` varchar(100) CHARACTER SET ascii DEFAULT NULL,
  `ServerId` int(10) unsigned DEFAULT NULL,
  `UserID` varchar(100) NOT NULL,
  `Password` varchar(300) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'redmine'
--
/*!50003 DROP FUNCTION IF EXISTS `stringSplit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `stringSplit`(
x VARCHAR(255),
delim VARCHAR(12),
pos INT) RETURNS varchar(255) CHARSET latin1
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1), delim, '') ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `substrCount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `substrCount`(s VARCHAR(255), ss VARCHAR(255)) RETURNS tinyint(3) unsigned
    READS SQL DATA
BEGIN
DECLARE count TINYINT(3) UNSIGNED;
DECLARE offset TINYINT(3) UNSIGNED;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET s = NULL;
SET count = 0;
SET offset = 1;
REPEAT
IF NOT ISNULL(s) AND offset > 0 THEN
SET offset = LOCATE(ss, s, offset);
IF offset > 0 THEN
SET count = count + 1;
SET offset = offset + 1;
END IF;
END IF;
UNTIL ISNULL(s) OR offset = 0 END REPEAT;
RETURN count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `splitter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `splitter`(x varchar(255), delim varchar(12))
BEGIN
SET @Valcount = substrCount(x,delim)+1;
SET @v1=0;
drop table if exists splitResults;
create temporary
table splitResults (split_value varchar(255));
WHILE (@v1 < @Valcount) DO
set @val = stringSplit(x,delim,@v1+1);
INSERT INTO splitResults (split_value) VALUES (@val);
SET @v1 = @v1 + 1;
END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_databases_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_databases_delete`(DatabaseId INT)
BEGIN
DELETE FROM spm_databases WHERE Id = DatabaseId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_databases_getall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_databases_getall`()
BEGIN

  SELECT d.Id
         ,d.Name
         ,d.Description
         ,d.UserID
         ,"" as Password
         ,s.Id AS Id
         ,s.Name
         ,s.Description
         ,s.IPLocal
         ,s.IPUAT
         ,s.IPProduction
  FROM spm_databases AS d
  LEFT JOIN spm_servers AS s ON d.ServerId = s.Id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_databases_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_databases_insert`(DatabaseId INT,Name VARCHAR(100), Description VARCHAR(100),ServerId INT,UserLogin VARCHAR(100),UserPassword VARCHAR(300))
BEGIN
INSERT INTO spm_databases(Id,Name,Description,ServerId,UserId,Password)
VALUES(DatabaseId,Name,Description,ServerId,UserLogin,UserPassword)
ON DUPLICATE KEY
UPDATE Name = Name,
       Description = Description,
       ServerId = ServerId,
       UserId = UserLogin,
       Password = UserPassword;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_favorities_issues_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_favorities_issues_delete`(Username VARCHAR(100),IdIssue INT)
BEGIN
DECLARE tempUserId  INT;
SELECT Id INTO tempUserId
FROM Users WHERE LOWER(Login) = LOWER(Username) lIMIT 1;

DELETE FROM spm_favorities_issues WHERE UserId = tempUserId AND IssueId = IdIssue;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_favorities_issues_getbyuser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_favorities_issues_getbyuser`(Username VARCHAR(100))
BEGIN

  DECLARE UserId  INT;
  SELECT Id INTO UserId
  FROM users WHERE LOWER(Login) = LOWER(Username) lIMIT 1;

  SELECT i.Id,i.Subject AS Name
  FROM spm_favorities_issues AS fi
  INNER JOIN issues AS i ON fi.Issueid = i.Id
  WHERE fi.UserId = UserId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_favorities_issues_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_favorities_issues_insert`(Username VARCHAR(100), IssueId INT)
BEGIN
DECLARE UserId  INT;
DECLARE tempId INT;

SELECT Id INTO UserId
FROM users WHERE LOWER(Login) = LOWER(Username) lIMIT 1;

SELECT COUNT(fi.Id) INTO tempId
FROM spm_favorities_issues AS fi WHERE fi.UserId = UserId AND fi.IssueId = IssueId;

IF tempId = 0
THEN
  INSERT INTO spm_favorities_issues(UserId,IssueId)
  VALUES(UserId,IssueId);
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_servers_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_servers_delete`(ServerId INT)
BEGIN
DELETE FROM spm_servers WHERE id = ServerId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_servers_getall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_servers_getall`()
BEGIN

  SELECT Id
          ,Name
          ,IPLocal
          ,IPUAT
          ,IPProduction
          ,Description
  FROM spm_servers;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_servers_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_servers_insert`(ServerId INT,Name VARCHAR(100),IPLocal VARCHAR(50),IPUAT VARCHAR(50),IPProduction VARCHAR(50),Description VARCHAR(100))
BEGIN

  INSERT INTO spm_servers(Id, Name, IPLocal, IPUAT, IPProduction, Description)
  VALUES(ServerId, Name, IPLocal, IPUAT, IPProduction, Description)
  ON DUPLICATE KEY
  UPDATE
    Name         = Name,
    IPLocal      = IPLocal,
    IPUAT        = IPUAT,
    IPProduction = IPProduction,
    Description  = Description;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_storeprocedures_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_storeprocedures_delete`(StoreId INT)
BEGIN

  DELETE FROM spm_storeprocedures WHERE id = StoreId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_storeprocedures_getbyissueid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_storeprocedures_getbyissueid`(issueids varchar(255),includeChild BIT)
BEGIN
CALL splitter(issueids, ',');

IF includeChild = 0
THEN
SELECT sp.id
      ,sp.name
      ,sp.isfunction
      ,sp.actionname
      ,sp.status
      ,sp.description
      ,d.id
      ,d.name
      ,du.Id
      ,du.Login AS Username
      ,i.id
      ,i.subject AS Name
      ,u.id
      ,u.login AS Username
      ,s.id
      ,s.name
FROM issues AS i
  LEFT JOIN spm_storeprocedures AS sp ON sp.issueid = i.id
  LEFT JOIN spm_databases AS d ON sp.databaseid = d.id
  LEFT JOIN spm_servers AS s ON sp.serverid = s.id
  LEFT JOIN users AS u ON sp.modifiedby = u.id
  LEFT JOIN users AS du ON sp.developerid = du.id
WHERE (i.id in (select split_value from splitResults))
OR sp.Name Like issueids
ORDER BY sp.Id;
ELSE
  -- prepare a hierarchy level variable
  SET @hierlevel := 00000;

  -- prepare a variable for total rows so we know when no more rows found
  SET @lastRowCount := 0;

  -- pre-drop temp table
  DROP TABLE IF EXISTS MyHierarchy;

  -- now, create it as the first level you want...
  -- ie: a specific top level of all "no parent" entries
  -- or parameterize the function and ask for a specific "ID".
  -- add extra column as flag for next set of ID's to load into this.
  CREATE TABLE MyHierarchy AS
  SELECT U.ID
       , U.Parent_Id
       , U.Subject
       , 00 AS IDHierLevel
       , 00 AS AlreadyProcessed
  FROM
    issues U
  WHERE
    U.ID in (select split_value from splitResults);

  -- how many rows are we starting with at this tier level
  -- START the cycle, only IF we found rows...
  SET @lastRowCount := FOUND_ROWS();

  -- we need to have a "key" for updates to be applied against,
  -- otherwise our UPDATE statement will nag about an unsafe update command
  CREATE INDEX MyHier_Idx1 ON MyHierarchy (IDHierLevel);


  -- NOW, keep cycling through until we get no more records
  WHILE @lastRowCount > 0
  DO

    UPDATE MyHierarchy
    SET
      AlreadyProcessed = 1
    WHERE
      IDHierLevel = @hierLevel;

    -- NOW, load in all entries found from full-set NOT already processed
    INSERT INTO MyHierarchy
    SELECT DISTINCT U.ID
                  , U.Parent_Id
                  , U.Subject
                  , @hierLevel + 1 AS IDHierLevel
                  , 0 AS AlreadyProcessed
    FROM
      MyHierarchy mh
    JOIN issues U
    ON U.Parent_Id = mh.ID
    WHERE
      mh.IDHierLevel = @hierLevel;

    -- preserve latest count of records accounted for from above query
    -- now, how many acrual rows DID we insert from the select query
    SET @lastRowCount := ROW_COUNT();


    -- only mark the LOWER level we just joined against as processed,
    -- and NOT the new records we just inserted
    UPDATE MyHierarchy
    SET
      AlreadyProcessed = 1
    WHERE
      IDHierLevel = @hierLevel;

    -- now, update the hierarchy level
    SET @hierLevel := @hierLevel + 1;

  END WHILE;


  -- return the final set now
  -- SELECT DISTINCT ID
  -- FROM
  --  MyHierarchy;

  -- and we can clean-up after the query of data has been selected / returned.
  --    drop table if exists MyHierarchy;

  SELECT sp.id
      ,sp.name
      ,sp.isfunction
      ,sp.actionname
      ,sp.status
      ,sp.description
      ,d.id
      ,d.name
      ,du.Id
      ,du.Login AS Username
      ,i.id
      ,i.subject AS Name
      ,u.id
      ,u.login AS Username
      ,s.id
      ,s.name
FROM issues AS i
  LEFT JOIN spm_storeprocedures AS sp ON sp.issueid = i.id
  LEFT JOIN spm_databases AS d ON sp.databaseid = d.id
  LEFT JOIN spm_servers AS s ON sp.serverid = s.id
  LEFT JOIN users AS u ON sp.modifiedby = u.id
  LEFT JOIN users AS du ON sp.developerid = du.id
WHERE (i.id in (select ID from MyHierarchy))
OR sp.Name Like issueids
ORDER BY sp.Id;

END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_storeprocedures_getbyissueid2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_storeprocedures_getbyissueid2`(issueids varchar(255),includeChild BIT)
BEGIN
CALL splitter(issueids, ',');

IF includeChild = 0
THEN
SELECT DISTINCT(sp.id)
      ,sp.name
      ,sp.isfunction
      ,sp.actionname
      ,sp.status
      ,sp.description
      ,d.id
      ,d.name
      ,du.Id
      ,du.Login AS Username
      ,i.id
      ,i.subject AS Name
      ,u.id
      ,u.login AS Username
      ,s.id
      ,s.name
FROM issues AS i
  LEFT JOIN spm_storeprocedures AS sp ON sp.issueid = i.id
  LEFT JOIN spm_databases AS d ON sp.databaseid = d.id
  LEFT JOIN spm_servers AS s ON sp.serverid = s.id
  LEFT JOIN users AS u ON sp.modifiedby = u.id
  LEFT JOIN users AS du ON sp.developerid = du.id
WHERE (i.id in (select split_value from splitResults))
ORDER BY sp.Id;
ELSE

  SELECT DISTINCT(sp.id)
      ,sp.name
      ,sp.isfunction
      ,sp.actionname
      ,sp.status
      ,sp.description
      ,d.id
      ,d.name
      ,du.Id
      ,du.Login AS Username
      ,i.id
      ,i.subject AS Name
      ,u.id
      ,u.login AS Username
      ,s.id
      ,s.name
FROM issues AS i  
  LEFT JOIN issues as i1 ON i1.parent_id = i.id
  LEFT JOIN issues as i2 ON i2.parent_id = i1.id
  LEFT JOIN issues as i3 ON i3.parent_id = i2.id
  LEFT JOIN issues as i4 ON i4.parent_id = i3.id
  LEFT JOIN spm_storeprocedures AS sp ON (sp.issueid = i.id or sp.issueid = i1.id or sp.issueid = i2.id or sp.issueid = i3.id or sp.issueid = i4.id)
  LEFT JOIN spm_databases AS d ON sp.databaseid = d.id
  LEFT JOIN spm_servers AS s ON sp.serverid = s.id
  LEFT JOIN users AS u ON sp.modifiedby = u.id
  LEFT JOIN users AS du ON sp.developerid = du.id
WHERE (i.id in (select split_value from splitResults))
ORDER BY sp.Id;

END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_storeprocedures_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_storeprocedures_insert`(
  INOUT StoreId  INT,
  ServerId     INT,
  DatabaseId   INT,
  Name         VARCHAR(300),
  IsFunction   BIT,
  ActionName   VARCHAR(10),
  ModifiedBy   VARCHAR(100),
  StatusId     INT,
  Description  VARCHAR(300),
  IssueId      INT,
  DeveloperUserId  INT)
BEGIN

  DECLARE UserId  INT;
  /*DECLARE tempId  INT;*/
  SELECT Id INTO UserId
  FROM users WHERE LOWER(Login) = LOWER(ModifiedBy) lIMIT 1;

  IF StoreId IS NULL OR StoreId = 0
  THEN
    INSERT INTO spm_storeprocedures(Id,ServerId,DatabaseId,Name,IsFunction,ActionName,ModifiedBy,Status,Description,IssueId,ModifiedDate,DeveloperId)
    VALUES(StoreId,ServerId,DatabaseId,Name,IsFunction,ActionName,UserId,StatusId,Description,IssueId,NOW(),DeveloperUserId)
    ON DUPLICATE KEY
    UPDATE ServerId   = ServerId,
        DatabaseId  = DatabaseId,
        Name        = Name,
        IsFunction  = IsFunction,
        ActionName  = ActionName,
        ModifiedBy  = UserId,
        Status      = StatusId,
        Description = Description,
        IssueId     = IssueId,
        ModifiedDate = NOW(),
        DeveloperId=DeveloperUserId;
  ELSE
    UPDATE spm_storeprocedures AS s
    SET s.ServerId   = ServerId,
        s.DatabaseId  = DatabaseId,
        s.Name        = Name,
        s.IsFunction  = IsFunction,
        s.ActionName  = ActionName,
        s.ModifiedBy  = UserId,
        s.Status      = StatusId,
        s.Description = Description,
        s.IssueId     = IssueId,
        s.ModifiedDate = NOW(),
        s.DeveloperId=DeveloperUserId
    WHERE s.Id = StoreId;
  END IF;

  SELECT LAST_INSERT_ID() INTO StoreId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_storeprocedures_updatestatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_storeprocedures_updatestatus`(StoreId varchar(255),StatusId INT,Username VARCHAR(100))
BEGIN

DECLARE UserId  INT;
SELECT Id INTO UserId
FROM users WHERE LOWER(Login) = LOWER(Username) lIMIT 1;

CALL splitter(StoreId, ',');

UPDATE spm_storeprocedures
SET Status = StatusId, ModifiedBy = UserId
WHERE Id in (select split_value from splitResults);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spm_users_getall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_users_getall`()
BEGIN
  SELECT DISTINCT Id,Login AS Username,FirstName, LastName
  FROM users WHERE Login IS NOT NULL AND Login <> '';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-01-15 17:09:44
