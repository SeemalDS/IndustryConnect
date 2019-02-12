USE [KeysOnboardDb]
GO
/****** Object:  StoredProcedure [dbo].[GetDataExpenseReport]    
Script Date: 12/02/2019 3:20:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <12/02/2019>
-- Description:	<This procedure gets the data to 
--               populate the Expense report for property A>
-- =============================================
 IF 
    EXISTS(SELECT 1 FROM sys.procedures 
          WHERE Name = 'GetDataExpenseReport')
BEGIN
    DROP PROCEDURE dbo.GetDataExpenseReport
END

GO

CREATE PROCEDURE [dbo].[GetDataExpenseReport]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
      -- Insert statements for procedure here
SELECT
   pp.Name,
   p.FirstName,
   pp.Bathroom,
   pp.Bedroom,
   a.Number + ' ' + a.Street + ' ' + a.suburb + ' ' + a.city + ' ' + a.Region + ' ' + a.PostCode 'Address',
   tp.PaymentAmount,
   tpf.Name AS 'Frequency' 
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
      TenantProperty tp 
      ON pp.Id = tp.PropertyId 
   JOIN
      TenantPaymentFrequencies tpf 
      ON tp.PaymentFrequencyId = tpf.Id 
WHERE
   FirstName = 'ABDC';

END

GO