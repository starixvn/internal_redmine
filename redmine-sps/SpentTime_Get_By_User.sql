DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpentTime_Get_By_User`(IN username NVARCHAR(50), IN fromDate DATE, IN toDate DATE)
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
		FROM redmine.time_entries AS te
			JOIN redmine.users AS us ON te.user_id = us.id
			JOIN redmine.issues AS iss ON te.issue_id = iss.id
			JOIN redmine.users AS usass ON iss.assigned_to_id = usass.id
			JOIN redmine.projects AS pr ON te.project_id = pr.id
			JOIN redmine.trackers AS tc ON iss.tracker_id = tc.id
			JOIN redmine.issue_statuses AS stt ON iss.status_id = stt.id
		WHERE (us.firstname LIKE username OR us.lastname LIKE username) 
				AND pr.id <> 16 
				AND te.spent_on BETWEEN fromDate AND toDate
		ORDER BY us.firstname ASC, te.spent_on DESC, pr.name DESC;
	END$$
DELIMITER ;
