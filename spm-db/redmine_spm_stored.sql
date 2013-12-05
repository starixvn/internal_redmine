DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`splitter` $$
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
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_database_getall` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_database_getall`()
BEGIN

  SELECT d.Id
         ,d.Name
         ,d.Description
         ,d.UserID
         ,d.Password
         ,d.ServerId AS Id
         ,s.Name
         ,s.Description
         ,s.IPLocal
         ,s.IPUAT
         ,s.IPProduction
  FROM spm_databases AS d
  LEFT JOIN spm_servers AS s ON d.ServerId = s.Id;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_databases_delete` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_databases_delete`(DatabaseId INT)
BEGIN
DELETE FROM spm_databases WHERE Id = DatabaseId;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_databases_insert` $$
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

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_favorities_issues_delete` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_favorities_issues_delete`(Username VARCHAR(100),IdIssue INT)
BEGIN
DECLARE tempUserId  INT;
SELECT Id INTO tempUserId
FROM Users WHERE LOWER(Login) = LOWER(Username) lIMIT 1;

DELETE FROM spm_favorities_issues WHERE UserId = tempUserId AND IssueId = IdIssue;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_favorities_issues_getbyuser` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_favorities_issues_getbyuser`(Username VARCHAR(100))
BEGIN

  DECLARE UserId  INT;
  SELECT Id INTO UserId
  FROM users WHERE LOWER(Login) = LOWER(Username) lIMIT 1;

  SELECT i.Id,i.Subject AS Name
  FROM spm_favorities_issues AS fi
  INNER JOIN issues AS i ON fi.Issueid = i.Id
  WHERE fi.UserId = UserId;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_favorities_issues_insert` $$
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
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_servers_delete` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_servers_delete`(ServerId INT)
BEGIN
DELETE FROM spm_servers WHERE id = ServerId;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_servers_getall` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_servers_getall`()
BEGIN

  SELECT Id
          ,Name
          ,IPLocal
          ,IPUAT
          ,IPProduction
          ,Description
  FROM spm_servers;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_servers_insert` $$
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

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_storeprocedures_delete` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_storeprocedures_delete`(StoreId INT)
BEGIN

  DELETE FROM spm_storeprocedures WHERE id = StoreId;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_storeprocedures_getbyissueid` $$
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
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_storeprocedures_insert` $$
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
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_storeprocedures_updatestatus` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_storeprocedures_updatestatus`(StoreId varchar(255),StatusId INT,Username VARCHAR(100))
BEGIN

DECLARE UserId  INT;
SELECT Id INTO UserId
FROM users WHERE LOWER(Login) = LOWER(Username) lIMIT 1;

CALL splitter(StoreId, ',');

UPDATE spm_storeprocedures
SET Status = StatusId, ModifiedBy = UserId
WHERE Id in (select split_value from splitResults);

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `redmine`.`spm_users_getall` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spm_users_getall`()
BEGIN
  SELECT DISTINCT Id,Login AS Username,FirstName, LastName
  FROM users WHERE Login IS NOT NULL AND Login <> '';
END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `redmine`.`stringSplit` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `stringSplit`(
x VARCHAR(255),
delim VARCHAR(12),
pos INT) RETURNS varchar(255) CHARSET latin1
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1), delim, '') $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `redmine`.`substrCount` $$
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
END $$

DELIMITER ;