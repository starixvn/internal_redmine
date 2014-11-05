DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpentTime_Get_By_Month_And_Tracker`(IN trackerName NVARCHAR(50), IN month SMALLINT, IN year SMALLINT)
BEGIN
	SELECT 
			pr.name AS 'Project Name'
			, CONCAT(us.firstname, ' ', us.lastname) AS 'User'
			, SUM(te.hours) AS 'Total Spent Hours'
		FROM redmine.time_entries AS te
			JOIN redmine.users AS us ON te.user_id = us.id
			JOIN redmine.projects AS pr ON te.project_id = pr.id
			JOIN redmine.issues AS iss ON iss.id = te.issue_id
			JOIN redmine.trackers AS tk ON iss.tracker_id = tk.id
		WHERE pr.id <> 16 
				AND MONTH(te.spent_on) = month 
				AND YEAR(te.spent_on) = year
				AND tk.name = trackerName
		GROUP BY pr.name, us.firstname
		ORDER BY pr.name ASC, us.firstname ASC;
END$$
DELIMITER ;
