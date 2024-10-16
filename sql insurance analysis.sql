
-- 1. Select all columns for all patients.
select * from insurance_data;

-- 2. Display the average claim amount for patients in each region.
select region, avg(claim) avg_amount from insurance_data group by region;

-- 3. Select the maximum and minimum BMI values in the table.
select min(bmi) min, max(bmi) max from insurance_data;

-- 4. Select the PatientID, age, and BMI for patients with a BMI between 40 and 50.
select PatientID, age, bmi from insurance_data where bmi between 40 and 50;

-- 5. Select the number of smokers in each region.
select region, count(smoker) No_of_smoker from insurance_data group by region;

-- 6. What is the average claim amount for patients who are both diabetic and smokers?
select avg(claim) from insurance_data where diabetic = "Yes" and smoker = "Yes";

-- 7. Retrieve all patients who have a BMI greater 
-- than the average BMI of patients who are smokers.
select * from insurance_data where smoker="Yes" and bmi > (select avg(bmi) from insurance_data where smoker = "Yes");


-- 8. Select the average claim amount for patients in each age group.
select 
case when age <18 then "under 18"
when age between 18 and 30 then "18-30"
when age between 31 and 50 then "31-50"
else "over 50" 
end as age_group, 
round(avg(claim),2) avg_claim from insurance_data group by age_group;



-- 9. Retrieve the total claim amount for each patient, 
-- along with the average claim amount across all patients (Using window function).
select PatientID, sum(claim) over(partition by PatientID) as total_claim, avg(claim) over() as avg_claim from insurance_data;


-- 10. Retrieve the top 3 patients with the highest claim amount, along with their 
-- respective claim amounts and the total claim amount for all patients.

select PatientID,claim ,sum(claim) over() total_claim from insurance_data order by claim desc limit 3;


-- 11. Select the details of patients who have a claim amount 
-- greater than the average claim amount for their region.

select * from insurance_data i1 where claim > (select avg(claim) from insurance_data i2 where i2.region =i1.region); 

select * from (select *, avg(claim) over(partition by region) as avg_claim from insurance_data) as subquery where claim > avg_claim;

-- 12. Retrieve the rank of each patient based on their claim amount.
select *, rank() over(order by claim desc) as P_rank from insurance_data;

-- 13. Select the details of patients along with their claim amount, 
-- and their rank based on claim amount within their region.

select *, rank() over(partition by region order by claim desc) as P_rank from insurance_data;
