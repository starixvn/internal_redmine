DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Issue_Count_Issues_By_Month`()
BEGIN
		#1. Số lượng issues được tạo trong từng tháng từ lúc xài Redmine đến nay, phân loại theo Tracker
		SELECT 
			tc.name
			, MONTH(iss.created_on) as month
			, YEAR(iss.created_on) as year
			, count(*) as total
		FROM redmine.issues as iss 
			JOIN redmine.trackers as tc 
			on iss.tracker_id = tc.id
		GROUP BY tc.id, YEAR(iss.created_on), MONTH(iss.created_on);

	END$$
DELIMITER ;
