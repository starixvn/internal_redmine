DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpentTime_Get_By_Group`(IN groupName NVARCHAR(50), IN fromDate DATE, IN toDate DATE)
BEGIN
		SELECT 
			pr.name AS 'Project Name'
			, tc.name AS 'Tracker'
			, iss.id AS 'Issue Id'
			, iss.subject AS 'Issue'
			, stt.name AS 'Status'
			, CONCAT(usass.firstname, ' ', usass.lastname) AS 'Assignee'
			, iss.start_date AS 'Start Date'
			, iss.due_date AS 'Due Date'
			, iss.estimated_hours AS 'Estimate Hours'
			, CONCAT(us.firstname, ' ', us.lastname) AS 'Spent Time User'
			, te.hours AS 'Spent Hours'
			, te.updated_on AS 'Update Spent Time'
		FROM
			redmine.users AS g
			JOIN redmine.groups_users AS gus ON g.id = gus.group_id
			JOIN redmine.users AS us ON gus.user_id = us.id
			JOIN redmine.time_entries AS te ON us.id = te.user_id
			JOIN redmine.issues AS iss ON te.issue_id = iss.id
			JOIN redmine.users AS usass ON iss.assigned_to_id = usass.id
			JOIN redmine.projects AS pr ON te.project_id = pr.id
			JOIN redmine.trackers AS tc ON iss.tracker_id = tc.id
			JOIN redmine.issue_statuses AS stt ON iss.status_id = stt.id
		WHERE g.lastname LIKE groupName 
			AND pr.id <> 16 
			AND g.type = 'Group' 
			AND te.updated_on BETWEEN fromDate AND toDate
		ORDER BY us.firstname ASC, te.updated_on DESC, pr.name DESC;
	END$$
DELIMITER ;
