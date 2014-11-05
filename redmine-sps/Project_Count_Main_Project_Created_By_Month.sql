DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Project_Count_Main_Project_Created_By_Month`()
BEGIN
		select 
			MONTH(created_on) as month
			, YEAR(created_on)
			, count(*) as total_main_project
		from redmine.projects
		where parent_id is null
		group by YEAR(created_on), MONTH(created_on);
	END$$
DELIMITER ;
