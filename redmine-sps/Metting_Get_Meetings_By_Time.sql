DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Meeting_Get_Meetings_By_Time`(IN fromDate DATE, IN toDate DATE)
BEGIN
		SELECT mt.id 
			, mt.date
			, pr.name AS 'Project Name' 
			, iss.id 'Issue Id'
			, iss.subject 'Issue'
			, mt.subject 'Subject'
			, mt.start_hour 'Start hour'
			, mt.end_hour 'End hour'
			, mt.estimated_hours 'Estimate hours'
			, te.hours 'Spent time'
			, CONCAT(usauthor.firstname, ' ', usauthor.lastname) AS 'Author'
			, CONCAT(' ', us.firstname, ' ', us.lastname) AS 'Participant'
			#, GROUP_CONCAT(CONCAT(' ', us.firstname, ' ', us.lastname)) AS 'Participants'
		FROM redmine.meetings AS mt 
			LEFT JOIN redmine.meetings_users AS mtus ON mt.id = mtus.meeting_id
			LEFT JOIN redmine.users AS us ON us.id = mtus.user_id
			LEFT JOIN redmine.users AS usauthor ON mt.author_id = usauthor.id
			LEFT JOIN redmine.issues AS iss ON mt.issue_id = iss.id
			LEFT JOIN redmine.projects as pr ON mt.project_id = pr.id
			LEFT JOIN redmine.time_entries as te ON te.meeting_id = mt.id
		WHERE mt.date BETWEEN fromDate AND toDate AND pr.id <> 16
		GROUP BY mt.date, mt.subject, mt.start_hour, mt.end_hour, mt.estimated_hours, mt.issue_id, mt.author_id, us.id;
	END$$
DELIMITER ;
