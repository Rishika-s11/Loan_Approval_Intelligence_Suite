-- 1. Write queries to count approved vs. rejected loans  

SELECT 
    Loan_Status,
    COUNT(*) AS Total_Count
FROM dbo.cleaned_loan_approval_dataset
GROUP BY Loan_Status;



-- 2. Analyze approval rates by Education

SELECT 

    Education,
    COUNT(*) AS Total_Applications,
    SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) AS Approved,
    ROUND(
        (SUM(CASE WHEN Loan_Status = 'Approved' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2
        ) AS Approval_Rate_Percent
FROM dbo.cleaned_loan_approval_dataset
GROUP BY Education
ORDER BY Approval_Rate_Percent DESC;



-- 3. Use CASE statements to classify risk levels 

SELECT 
    loan_id,
    income_annum,
    loan_amount,
    CASE 
        WHEN loan_amount > (income_annum * 0.8) THEN 'High Risk'
        WHEN loan_amount BETWEEN (income_annum * 0.5) AND (income_annum * 0.8) THEN 'Medium Risk'
        WHEN loan_amount < (income_annum * 0.5) THEN 'Low Risk'
        ELSE 'Unknown'
    END AS Risk_Level
FROM dbo.cleaned_loan_approval_dataset;



-- 4. Create views for Overall Approval Summary

--GO
--CREATE VIEW dbo.Approval_Summary AS
--SELECT 
--    COUNT(*) AS Total_Applications,
--    SUM(CASE WHEN Loan_Status = 'Approved' THEN 1 ELSE 0 END) AS Total_Approved,
--    SUM(CASE WHEN Loan_Status = 'Rejected' THEN 1 ELSE 0 END) AS Total_Rejected,
--    ROUND(
--        (SUM(CASE WHEN Loan_Status = 'Approved' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
--        2
--    ) AS Approval_Rate_Percent
--FROM dbo.cleaned_loan_approval_dataset;
--GO


SELECT * FROM dbo.Approval_Summary;



-- 5. Write subqueries to find top 5 income earners 

SELECT TOP 5 *
FROM (
    SELECT 
        loan_id,
        income_annum,
        loan_amount
    FROM dbo.cleaned_loan_approval_dataset
) AS income_table
ORDER BY income_annum DESC;



-- 6. Use window functions to rank applicants by income 

SELECT 
    loan_id,
    income_annum,
    loan_amount,
    RANK() OVER (ORDER BY income_annum DESC) AS income_rank
FROM dbo.cleaned_loan_approval_dataset
ORDER BY income_rank;



-- 7. Filter Applicants with Missing or Invalid CIBIL Scores 

SELECT *
FROM dbo.cleaned_loan_approval_dataset
WHERE cibil_score IS NULL
   OR cibil_score = 0
   OR cibil_score < 300
   OR cibil_score > 900;



-- 8. Find applicants whose total asset value is greater than their loan amount

SELECT 
    loan_id,
    income_annum,
    loan_amount,
    (residential_assets_value + commercial_assets_value + luxury_assets_value + bank_asset_value) AS total_assets,
    loan_status
FROM dbo.cleaned_loan_approval_dataset
WHERE (residential_assets_value + commercial_assets_value + luxury_assets_value + bank_asset_value) > loan_amount
ORDER BY total_assets DESC;



-- 9. Average CIBIL score and income by employment type

SELECT 
    self_employed,
    ROUND(AVG(cibil_score), 2) AS avg_cibil_score,
    ROUND(AVG(income_annum), 2) AS avg_income
FROM dbo.cleaned_loan_approval_dataset
GROUP BY self_employed
ORDER BY avg_cibil_score DESC;



-- 10. Average Loan Amount and Income by Number of Dependents

SELECT 
    no_of_dependents,
    ROUND(AVG(income_annum), 2) AS avg_income,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    COUNT(*) AS total_applicants
FROM dbo.cleaned_loan_approval_dataset
GROUP BY no_of_dependents
ORDER BY no_of_dependents;




-- End --




