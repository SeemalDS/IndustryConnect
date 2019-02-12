
--a) Display a list of all property names and their property id’s for Owner Id: 1426. 
SELECT
   p.Name AS 'Property Name',
   op.PropertyId AS 'Property Id' 
FROM
   [dbo].[OwnerProperty] op 
   JOIN
      [dbo].[Property] p 
      ON op.PropertyId = p.Id 
WHERE
   op.OwnerId = 1426

--b) Display the current home value for each property in question a).  
SELECT
   p.Name AS 'Property Name',
   op.PropertyId AS 'Property Id',
   CurrentHomeValue AS 'Current home Value' 
FROM
   [dbo].[OwnerProperty] op 
   JOIN
      [dbo].[Property] p 
      ON op.PropertyId = p.Id 
   JOIN
      [dbo].[PropertyFinance] pvh 
      ON op.PropertyId = pvh.PropertyId 
WHERE
   op.OwnerId = 1426
  
--c) For each property in question a), return the following: 

-- Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query that returns the sum of all payments from start date to end date 

SELECT
   prp.PropertyId,
   SUM(prp.amount) 'Payment Amount',
   tpf.Name 'Frequency Type',
   tp.StartDate,
   tp.EndDate 
FROM
   [dbo].[PropertyRentalPayment] prp 
   JOIN
      [dbo].[TenantPaymentFrequencies] tpf 
      ON prp.FrequencyType = tpf.Id 
   JOIN
      [dbo].[TenantProperty] tp 
      ON tp.PropertyId = prp.PropertyId 
WHERE
   prp.DATE BETWEEN tp.StartDate AND tp.EndDate 
   AND prp.PropertyId IN 
   (
      SELECT
         op.PropertyId 
      FROM
         [dbo].[OwnerProperty] op 
         JOIN
            [dbo].[Property] p 
            ON op.PropertyId = p.Id 
      WHERE
         op.OwnerId = 1426
   )
GROUP BY
   prp.PropertyId,
   tpf.Name,
   tp.StartDate,
   tp.EndDate 
ORDER BY
   1

   -- Using repayment amount, repayment frequency, start date and end date to write a query that returns the sum of all payments from start date to end date
SELECT
   prp.PropertyId,
   SUM(prp.amount) 'Payment Amount',
   tpf.Name 'Repayment Frequency' 
FROM
   [dbo].[PropertyRepayment] prp 
   JOIN
      [dbo].[TenantPaymentFrequencies] tpf 
      ON prp.FrequencyType = tpf.Id 
      AND prp.PropertyId IN 
      (
         SELECT
            op.PropertyId 
         FROM
            [dbo].[OwnerProperty] op 
            JOIN
               [dbo].[Property] p 
               ON op.PropertyId = p.Id 
         WHERE
            op.OwnerId = 1426
      )
GROUP BY
   prp.PropertyId,
   tpf.Name 
ORDER BY
   1

-- display the yield 
 SELECT
   op.PropertyId AS 'Property Id',
   p.Name AS 'Property Name',
   Yield 
FROM
   [dbo].[OwnerProperty] op 
   JOIN
      [dbo].[Property] p 
      ON op.PropertyId = p.Id 
   JOIN
      [dbo].[PropertyFinance] pf 
      ON p.Id = pf.PropertyId 
WHERE
   op.OwnerId = 1426
   
   
--d) Display all the jobs available in the market place (jobs that owners have advertised for service suppliers) 
SELECT
   MarketJobId,
   OwnerId,
   p.FirstName + ' ' + p.LastName AS 'Owner Name',
   ProviderId,
   c.Name AS 'Provider Company Name',
   JobDescription,
   JobStartDate,
   JobEndDate 
FROM
   [dbo].[Job] 
   JOIN
      [dbo].[JobWatchList] 
      ON OwnerId = PersonId 
   JOIN
      [dbo].[Person] p 
      ON p.Id = PersonId 
   JOIN
      [dbo].[ServiceProvider] sp 
      ON sp.Id = ProviderId 
   JOIN
      [dbo].[Company] c 
      ON sp.CompanyId = c.Id

--or 

SELECT
   MarketJobId,
   OwnerId,
   PropertyId,
   ProviderId,
   PaymentAmount,
   JobDescription,
   JobStartDate,
   JobEndDate 
FROM
   [dbo].[Job] 
   JOIN
      [dbo].[JobWatchList] 
      ON MarketJobId = Job.Id 
      AND IsActive = 1


--e) Display all property names, current tenants first and last names and rental payments per week/
--fortnight/month for the properties in question a)
 SELECT
   p.Name AS 'Property Name',
   op.PropertyId AS 'Property Id',
   per.FirstName,
   per.LastName,
   tp.PaymentAmount AS 'Rental Payment',
   tpf.Name AS 'Frequency type' 
FROM
   [dbo].[OwnerProperty] op 
   JOIN
      [dbo].[Property] p 
      ON op.PropertyId = p.Id 
   JOIN
      [dbo].[TenantProperty] tp 
      ON tp.PropertyId = p.Id 
   JOIN
      [dbo].Person per 
      ON per.Id = tp.TenantId 
   JOIN
      [dbo].[TenantPaymentFrequencies] tpf 
      ON tp.PaymentFrequencyId = tpf.Id 
WHERE
   op.OwnerId = 1426