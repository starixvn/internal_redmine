DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Issue_Count_Issues_By_Month_And_Year`(IN month SMALLINT, IN year SMALLINT)
BEGIN
		#1. Số lượng issues được tạo trong từng tháng từ lúc xài Redmine đến nay, phân loại theo Tracker
		select 
			tc.name
			, MONTH(iss.created_on) as month
			, YEAR(iss.created_on) as year, count(*) as total
		from redmine.issues as iss 
			join redmine.trackers as tc 
			on iss.tracker_id = tc.id
		where MONTH(iss.created_on) = month and YEAR(iss.created_on) = year
		group by tc.id, YEAR(iss.created_on), MONTH(iss.created_on);

	END$$
DELIMITER ;
