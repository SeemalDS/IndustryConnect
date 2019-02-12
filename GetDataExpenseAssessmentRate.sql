USE [KeysOnboardDb]
GO
/****** Object:  StoredProcedure [dbo].[GetDataExpenseAssessmentRate]   
 Script Date: 12/02/2019 3:28:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <12/02/2019>
-- Description:	<This procedure gets the assessment rate to
--               populate the Expense report for property A>
-- =============================================
 IF 
    EXISTS(SELECT 1 FROM sys.procedures 
          WHERE Name = 'GetDataExpenseAssessmentRate')
BEGIN
    DROP PROCEDURE dbo.GetDataExpenseAssessmentRate
END

GO

  
CREATE PROCEDURE [dbo].[GetDataExpenseAssessmentRate] AS BEGIN 
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET 
  NOCOUNT ON;
-- Insert statements for procedure here
SELECT
   Amount,
   pe.Description,
   FORMAT(pe.DATE, 'dd MMM yyyy') AS DATE 
FROM
   Person p 
   JOIN
      OwnerProperty op 
      ON p.Id = op.OwnerId 
   JOIN
      Property pp 
      ON op.PropertyId = pp.Id 
   JOIN
      Address a 
      ON a.AddressId = pp.AddressId 
   JOIN
      PropertyExpense pe 
      ON pe.PropertyId = pp.Id 
   JOIN
      TenantProperty tp 
      ON pp.Id = tp.PropertyId 
   JOIN
      TenantPaymentFrequencies tpf 
      ON tp.PaymentFrequencyId = tpf.Id 
WHERE
   FirstName = 'ABDC' 
  
  END

GO


