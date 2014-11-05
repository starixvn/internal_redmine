DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpentTime_Get_By_Month_Group_By_Project`(IN month SMALLINT, IN year SMALLINT)
BEGIN
	SELECT 
			pr.name AS 'Project Name'
			, CONCAT(us.firstname, ' ', us.lastname) AS 'User'
			, SUM(te.hours) AS 'Total Spent Hours'
		FROM redmine.time_entries AS te
			JOIN redmine.users AS us ON te.user_id = us.id
			JOIN redmine.projects AS pr ON te.project_id = pr.id
		WHERE pr.id <> 16 
				AND MONTH(te.spent_on) = month 
				AND YEAR(te.spent_on) = year
		GROUP BY pr.name, us.firstname
		ORDER BY pr.name ASC, us.firstname ASC;
END$$
DELIMITER ;
