DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpentTime_Get_By_Feature`()
BEGIN
	SELECT 
		pr.name AS 'Project Name', 
		iss.id AS 'Feature Id', 
		iss.subject AS 'Feature Name', 
		CONCAT(assignee.firstname, ' ', assignee.lastname) AS 'Assignee',
		iss_stt.name AS 'Status',
		cus_evi.value AS 'Environment',
		iss.start_date AS 'Start Date',
		iss.due_date AS 'Due Date',
		iss.estimated_hours AS 'Total Estimated Time',
		SUM(te.hours) AS 'Total Spent Time' 
	FROM redmine.issues AS iss
	LEFT JOIN redmine.projects AS pr ON iss.project_id = pr.id
	LEFT JOIN redmine.issues AS subiss ON iss.id = subiss.root_id
	LEFT JOIN redmine.time_entries AS te ON te.issue_id = subiss.id 
	LEFT JOIN redmine.users AS assignee ON iss.assigned_to_id = assignee.id
	LEFT JOIN redmine.issue_statuses as iss_stt ON iss.status_id = iss_stt.id
	LEFT JOIN redmine.custom_values AS cus_evi ON iss.id = cus_evi.customized_id
	WHERE iss.tracker_id = 6
		AND cus_evi.custom_field_id = 8
	GROUP BY iss.id
	ORDER BY pr.name ASC;
END$$
DELIMITER ;
