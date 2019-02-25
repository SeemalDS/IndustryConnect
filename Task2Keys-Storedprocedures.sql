--a)Stored Procedure  : Given owner Id build stored procedure to find properties info   for that owner on dashboard.
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerPropertiesInfo]    Script Date: 25/02/2019 12:27:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	<Given owner Id build stored procedure to find properties info 
--               for that owner on dashboard. >
-- =============================================
CREATE PROCEDURE [dbo].[GetOwnerPropertiesInfo] @oId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

   SELECT
   OwnerId,
   per.FirstName + ' ' + per.MiddleName + ' ' + per.LastName AS 'Owner Name',
   p.Id AS 'Property Id',
   pt.Name AS 'Property Type',
   a.Number + ' ' + a.Street + ' ' + a.suburb + ' ' + a.city + ' ' + a.Region + ' ' + a.PostCode AS ' Property Address',
   p.Name AS 'Property Name',
   p.Description AS 'Property Description',
   p.LandSqm,
   p.FloorArea,
   p.IsActive,
   p.IsOwnerOccupied,
   YearBuilt,
   Bedroom,
   Bathroom,
   ParkingSpace,
   TargetRent,
   tpf.Name AS 'TargetRentType' 
FROM
   [dbo].[OwnerProperty] op 
   JOIN
      [dbo].[Property] p 
      ON op.PropertyId = p.Id 
   JOIN
      [dbo].[PropertyType] pt 
      ON pt.PropertyTypeId = p.PropertyTypeId 
   JOIN
      [dbo].[Address] a 
      ON p.AddressId = a.AddressId 
   JOIN
      TenantPaymentFrequencies tpf 
      ON p.TargetRentTypeId = tpf.Id 
   JOIN
      [dbo].[Person] per 
      ON op.OwnerId = per.Id 
WHERE
   op.OwnerId = @oId
	
END
GO

---------------------------------------------------------------------------------------------------------------------------------------------
--b)Stored Procedure  : Given owner Id build stored procedure to find rental applications info for owner’s rental listing on dashboard.

USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerListingRentalApplications]    Script Date: 25/02/2019 12:28:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	<Given owner Id build stored procedure to
--               find rental applications info for owner’s 
--               rental listing on dashboard>
-- =============================================
CREATE PROCEDURE [dbo].[GetOwnerListingRentalApplications] @oId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

  sELECT
   op.OwnerId,
   ra.Id AS 'Rental Application Id',
   RentalListingId,
   per.FirstName + ' ' + per.LastName AS 'Applicant Name',
   ras.Status AS 'Application Status',
   Note,
   TenantsCount,
   ra.IsActive,
   IsViewedByOwner 
FROM
   [dbo].[OwnerProperty] op 
   JOIN
      [dbo].[Property] p 
      ON op.PropertyId = p.Id 
   JOIN
      [dbo].[RentalListing] rl 
      ON op.PropertyId = rl.PropertyId 
   JOIN
      [dbo].[RentalApplication] ra 
      ON rl.Id = ra.RentalListingId 
   JOIN
      [dbo].[Person] per 
      ON per.id = ra.PersonId 
   JOIN
      [dbo].[RentalApplicationStatus] ras 
      ON ras.Id = ra.ApplicationStatusId 
WHERE
   op.OwnerId = @oId
	
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------
--c) Stored Procedure  : Given owner Id build stored procedure to find Rental Status info for owner’s rental listing on dashboard. 

USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerRentalStatusInfo]    Script Date: 25/02/2019 12:29:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	<Given owner Id build stored procedure to
--               find rental applications info for owner’s 
--               rental listing on dashboard>
-- =============================================
CREATE PROCEDURE [dbo].[GetOwnerRentalStatusInfo] @oId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

  SELECT
   rl.Id 'Rental Listing Id',
   op.PropertyId,
   op.OwnerId,
   rl.Description,
   rl.Furnishing,
   rl.IdealTenant,
   rl.MovingCost,
   rl.TargetRent,
   rl.IdealTenant,
   rl.PetsAllowed,
   rl.Title,
   rls.Status
FROM
   [dbo].[RentalListing] rl 
   JOIN
      [dbo].[OwnerProperty] op 
      ON op.PropertyId = rl.PropertyId 
   JOIN
      [dbo].[RentalListingStatus] rls 
      ON rls.Id = rl.RentalStatusId 
WHERE
   op.OwnerId = @oId
	
END
GO


------------------------------------------------------------------------------------------------------------------------------------
--d) Stored Procedure : Given owner Id build stored procedure to find info for owner’s tenant requests on dashboard. 
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerTenantRequest]    Script Date: 25/02/2019 12:30:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	<Given owner Id build stored procedure to find 
--               info for owner’s tenant requests on dashboard>
-- =============================================
CREATE PROCEDURE [dbo].[GetOwnerTenantRequest] @oId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

 SELECT
   tjr.Id AS 'TenantJobId',
   OwnerId,
   PropertyId,
   JobDescription,
   tjs.Name AS 'Status',
   MaxBudget,
   Title 
FROM
   [dbo].[TenantJobRequest] tjr 
   JOIN
      [dbo].[TenantJobStatus] tjs 
      ON tjs.Id = tjr.JobStatusId 
WHERE
   OwnerId = @oId
	
END
GO

-------------------------------------------------------------------------------------------------------------------------

--e) Stored Procedure : Given owner Id build stored procedure to find jobs quotes info for owner’s market jobs on dashboard. 
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerJobsQuotesInfo]    Script Date: 25/02/2019 12:31:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	<Given owner Id build stored procedure to find 
--               info for owner’s Job Quotes Info
--               for market on dashboard>
-- =============================================
CREATE PROCEDURE [dbo].[GetOwnerJobsQuotesInfo] @oId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

SELECT
   j.JobRequestId,
   PropertyId,
   OwnerId,
   j.ProviderId,
   Amount,
   Status,
   j.Note,
   PaymentAmount,
   JobStartDate,
   JobEndDate,
   JobDescription,
   JobStatusId,
   MaxBudget,
   PercentDone 
FROM
   [dbo].[JobQuote] jq 
   JOIN
      [dbo].[Job] j 
      ON j.JobRequestId = jq.JobRequestId
WHERE
   OwnerId = @oId
	
END
GO


------------------------------------------------------------------------------------------------------------------------------
--f) Stored Procedure : Given tenant id  build stored procedure to find rental info (payments due, landlord info ) for that tenant  on dashboard. 
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetTenantRentalInfo]    Script Date: 25/02/2019 12:32:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	< Given tenant id  build stored procedure to find rental info 
--               (payments due, landlord info ) for that tenant  on dashboard>
-- =============================================
CREATE PROCEDURE [dbo].[GetTenantRentalInfo] @tId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

 SELECT
   tp.Id,
   tp.TenantId,
   tp.PropertyId,
   op.OwnerId,
   FirstName + ' ' + per.LastName 'LandLord Name',
   tp.PaymentAmount,
   tp.PaymentDueDate,
   tp.PaymentStartDate,
   tp.LastQueuedPaymentRemind,
   tpf.Name 
FROM
   [dbo].[TenantProperty] tp 
   JOIN
      [dbo].[OwnerProperty] op 
      ON tp.PropertyId = op.PropertyId 
   JOIN
      [dbo].[Person] per 
      ON per.id = op.OwnerId 
   JOIN
      [dbo].[TenantPaymentFrequencies] tpf 
      ON tpf.Id = tp.PaymentFrequencyId 
WHERE
   tp.TenantId = @tID
	
END
GO

-----------------------------------------------------------------------------------------------------------------------------------
--g) Stored Procedure : Given tenant id  build stored procedure to find rental applications info for that tenant  on dashboard. 
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetTenantRentalAppInfo]    Script Date: 25/02/2019 12:34:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	< Given tenant id  build stored procedure to find rental applications 
--                info for that tenant  on dashboard. >
-- =============================================
CREATE PROCEDURE [dbo].[GetTenantRentalAppInfo] @tId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
SELECT
   ra.Id 'Rental Application Id',
   ra.RentalListingId,
   ra.PersonId,
   per.FirstName + ' ' + per.LastName 'Tenant Name',
   ra.Note,
   ras.Status,
   TenantIdNo,
   ra.TenantIdType,
   ra.TenantsCount,
   ra.IsActive,
   ra.IsViewedByOwner 
FROM
   [dbo].[Tenant] t 
   JOIN
      [dbo].[Person] per 
      ON per.id = t.Id 
   JOIN
      [dbo].[RentalApplication] ra 
      ON ra.PersonId = per.Id 
   JOIN
      [dbo].[RentalApplicationStatus] ras 
      ON ras.Id = ra.ApplicationStatusId
WHERE
   t.Id = @tID
	
END
GO
----------------------------------------------------------------------------------------------------------------------------------
--h) Stored Procedure : Given tenant id  build stored procedure to find info for landlord requests to that tenant  on dashboard. 
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetTenantLandlordRequests]    Script Date: 25/02/2019 1:14:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	< Given tenant id  build stored procedure 
--                to find info for landlord requests to that tenant  on dashboard>
-- =============================================
CREATE PROCEDURE [dbo].[GetTenantLandlordRequests] @tId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
SELECT
   op.OwnerId,
   tp.TenantId,
   op.PropertyId,
   pr.RequestMessage,
   pr.RequestStatusId,
   pr.RequestTypeId,
   pr.Reason,
   pr.RecipientId,
   pr.IsActive,
   pr.ToOwner,
   pr.ToTenant,
   rs.Name,
   rt.Name 
FROM
   [dbo].[TenantProperty] tp 
   JOIN
      [dbo].[PropertyRequest] pr 
      ON pr.PropertyId = tp.PropertyId 
   JOIN
      [dbo].[OwnerProperty] op 
      ON op.PropertyId = tp.PropertyId 
   JOIN
      [dbo].[RequestStatus] rs 
      ON rs.Id = pr.RequestStatusId 
   JOIN
      [dbo].[RequestType] rt 
      ON rt.Id = pr.RequestTypeId 
WHERE
   ToTenant = 1 
   AND tp.TenantId = @tId
	
END
GO

------------------------------------------------------------------------------------------------------------------
--i) Stored Procedure : Given service supplier id  build stored procedure to find jobs info for user  on dashboard. 
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetSupplierJobsInfo]    Script Date: 25/02/2019 1:16:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	< Given service supplier id  
--                build stored procedure to find jobs info for user  on dashboard.>
-- =============================================
CREATE PROCEDURE [dbo].[GetSupplierJobsInfo] @sId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	SELECT
   j.Id 'Job Id',
   j.PropertyId,
   j.OwnerId,
   j.ProviderId,
   j.JobDescription,
   j.JobStartDate,
   j.JobEndDate,
   j.MaxBudget,
   j.PaymentAmount,
   j.PercentDone,
   j.ServiceUpdate,
   spjs.Name 
FROM
   [dbo].[Job] j 
   JOIN
      [dbo].[ServiceProviderJobStatus] spjs 
      ON spjs.Id = j.JobStatusId 
WHERE
   j.ProviderId = @sId
END
GO

-------------------------------------------------------------------------------------------------------------------------
--j)Stored Procedure : Given service supplier id  build stored procedure to find quotes info for user  on dashboard.
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetSupplierQuotesInfo]    Script Date: 25/02/2019 1:16:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	<  Given service supplier id  build stored procedure to find quotes 
--                 info for user  on dashboard.> 
-- =============================================
CREATE PROCEDURE [dbo].[GetSupplierQuotesInfo] @sId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

SELECT
   Id 'Job Quote Id',
   JobRequestId,
   ProviderId,
   Amount,
   Status,
   Note,
   IsViewed 
FROM
   [dbo].[JobQuote] 
WHERE
   ProviderId = @sId

END
GO

-------------------------------------------------------------------------------------------------------------------
--k)Stored Procedure : Given owner Id search string, sort order string and page number, build Stored Procedure to 
find his properties with search, sort and pagination. 

USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerPropertiesSearchPagingSorting]    Script Date: 25/02/2019 1:18:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================
-- Author:		<Seemal Dsouza>
-- Create date: <23/02/2019>
-- Description:	< Given owner Id search string, sort order string and page number, 
--                build Stored Procedure to find his properties with search, sort and pagination. >
-- ================================================================================ 
CREATE PROCEDURE [dbo].[GetOwnerPropertiesSearchPagingSorting]
(
    -- Optional Filters for Dynamic Search
    @OwnerID          INT = NULL, 
    @PropertyName     NVARCHAR(50) = NULL, 
    @PropertyID       INT = NULL, 
    -- Pagination
    @PageNbr            INT = 1,
    @PageSize           INT = 10,
    -- Sort Details
    @SortCol            NVARCHAR(20) = ''
)
AS
BEGIN
    DECLARE
        @1OwnerID          INT, 
        @1PropertyName     NVARCHAR(50) = NULL, 
        @1PropertyID       INT, 
     
        @lPageNbr   INT,
        @lPageSize  INT,
        @lSortCol   NVARCHAR(20),
        @lFirstRec  INT,
        @lLastRec   INT,
        @lTotalRows INT
 
    SET @1OwnerID         = LTRIM(RTRIM(@OwnerID))
    SET @1PropertyName    = LTRIM(RTRIM(@PropertyName))
    SET @1PropertyID      = LTRIM(RTRIM(@PropertyID))
	
	
    SET @lPageNbr   = @PageNbr
    SET @lPageSize  = @PageSize
    SET @lSortCol   = LTRIM(RTRIM(@SortCol))
     
    SET @lFirstRec  = ( @lPageNbr - 1 ) * @lPageSize
    SET @lLastRec   = ( @lPageNbr * @lPageSize + 1 ) 
    SET @lTotalRows = @lFirstRec - @lLastRec + 1
 
    ; WITH CTE_Results
    AS (
        SELECT ROW_NUMBER() OVER (ORDER BY
            CASE WHEN @lSortCol = 'OwnerID_Asc' THEN OwnerID
                END ASC,
            CASE WHEN @lSortCol = 'OwnerID_Desc' THEN OwnerID
                END DESC, 
 
            CASE WHEN @lSortCol = 'PropertyName_Asc' THEN Name
                END ASC,
            CASE WHEN @lSortCol = 'PropertyName_Desc' THEN Name
                END DESC, 
 
            CASE WHEN @lSortCol = 'PropertyID_Asc' THEN PropertyID 
                END ASC,
            CASE WHEN @lSortCol = 'PropertyID_Desc' THEN PropertyID 
                END DESC

            ) AS ROWNUM,
            op.OwnerId, 
            p.Name PropertyName, 
			op.PropertyId
        FROM [dbo].[OwnerProperty] op
        JOIN [dbo].[Property] p
         ON op.PropertyId = p.Id
         WHERE 
         (@1OwnerID IS NULL OR op.OwnerID = @1OwnerID)
        AND (@1PropertyName IS NULL OR p.Name LIKE '%' + @1PropertyName + '%')
        AND (@1PropertyID IS NULL OR op.PropertyId = @1PropertyID )
		)
    SELECT OwnerId,
	       PropertyName,
           PropertyId
    FROM CTE_Results AS CPC
    WHERE
        ROWNUM > @lFirstRec 
    AND ROWNUM < @lLastRec
    ORDER BY ROWNUM ASC
         
END
GO

-----------------------------------------------------------------------------------------------------------------------------------
--l)Stored Procedure : Given owner Id, search string, sort order string, page size, page number, build stored procedure to find all rental listing owned by this owner including any media (photo). 


USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerRentalListingSearchPagingSorting]    Script Date: 25/02/2019 1:19:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 
CREATE PROCEDURE [dbo].[GetOwnerRentalListingSearchPagingSorting]
(
    -- Optional Filters for Dynamic Search
    @OwnerID          INT = NULL, 
    @RentalListingID  INT = NULL, 
    @PropertyID       INT = NULL, 
	@Description      NVARCHAR(100) = NULL, 
	@AvailableDate    DATE = NULL,
	@TargetRent       INT = NULL, 
	@MovingCost       INT = NULL,
	@OccupantCounT    INT = NULL,
    -- Pagination
    @PageNbr            INT = 1,
    @PageSize           INT = 100,
    -- Sort Details
    @SortCol            NVARCHAR(20) = ''
)
AS
BEGIN
    DECLARE
        @1OwnerID          INT, 
        @1RentalListingID  INT,
        @1PropertyID       INT, 
		@1Description      NVARCHAR(100),
	    @1AvailableDate    DATE,
	    @1TargetRent       INT,
	    @1MovingCost       INT,
	    @1OccupantCount    INT,
		
     
        @lPageNbr   INT,
        @lPageSize  INT,
        @lSortCol   NVARCHAR(20),
        @lFirstRec  INT,
        @lLastRec   INT,
        @lTotalRows INT
 
    SET @1OwnerID            = LTRIM(RTRIM(@OwnerID))
    SET @1RentalListingID    = LTRIM(RTRIM(@RentalListingID))
    SET @1PropertyID         = LTRIM(RTRIM(@PropertyID))
	SET @1Description        = LTRIM(RTRIM(@Description))
	SET @1AvailableDate      = LTRIM(RTRIM(@AvailableDate))
	SET @1TargetRent         = LTRIM(RTRIM(@TargetRent))
	SET @1MovingCost         = LTRIM(RTRIM(@MovingCost))
	SET @1OccupantCount      = LTRIM(RTRIM(@OccupantCount))
	
	
    SET @lPageNbr   = @PageNbr
    SET @lPageSize  = @PageSize
    SET @lSortCol   = LTRIM(RTRIM(@SortCol))
     
    SET @lFirstRec  = ( @lPageNbr - 1 ) * @lPageSize
    SET @lLastRec   = ( @lPageNbr * @lPageSize + 1 ) 
    SET @lTotalRows = @lFirstRec - @lLastRec + 1
 
    ; WITH CTE_Results
    AS (
        SELECT ROW_NUMBER() OVER (ORDER BY
            CASE WHEN @lSortCol = 'OwnerID_Asc' THEN OwnerID
                END ASC,
            CASE WHEN @lSortCol = 'OwnerID_Desc' THEN OwnerID
                END DESC, 
 
            CASE WHEN @lSortCol = 'RentalListingID_Asc' THEN rl.Id
                END ASC,
            CASE WHEN @lSortCol = 'RentalListingID_Desc' THEN rl.id
                END DESC, 
 
            CASE WHEN @lSortCol = 'PropertyID_Asc' THEN op.PropertyID 
                END ASC,
            CASE WHEN @lSortCol = 'PropertyID_Desc' THEN op.PropertyID 
                END DESC,
				
		    CASE WHEN @lSortCol = 'Description_Asc' THEN rl.Description 
                END ASC,
            CASE WHEN @lSortCol = 'Description_Desc' THEN rl.Description
                END DESC,
				
			CASE WHEN @lSortCol = 'AvailableDate_Asc' THEN AvailableDate 
                END ASC,
            CASE WHEN @lSortCol = 'AvailableDate_Desc' THEN AvailableDate
                END DESC,
				
			CASE WHEN @lSortCol = 'TargetRent_Asc' THEN TargetRent 
                END ASC,
            CASE WHEN @lSortCol = 'TargetRent_Desc' THEN TargetRent
                END DESC,
				
			CASE WHEN @lSortCol = 'MovingCost_Asc' THEN MovingCost
                END ASC,
            CASE WHEN @lSortCol = 'MovingCost_Desc' THEN MovingCost 
                END DESC,
				
			CASE WHEN @lSortCol = 'OccupantCount_Asc' THEN OccupantCount
                END ASC,
            CASE WHEN @lSortCol = 'OccupantCount_Desc' THEN OccupantCount 
                END DESC

            ) AS ROWNUM,
            OwnerId,
			rl.Id 'RentalListingID',
			rl.PropertyId,
			rl.Description,
			AvailableDate,
			MovingCost,
            TargetRent,
			OccupantCount,
			PetsAllowed,
			Furnishing,
			pm.NewFileName 
			FROM [dbo].[RentalListing] rl
            JOIN [dbo].[OwnerProperty] op
            ON op.PropertyId = rl.PropertyId
			LEFT JOIN [dbo].[PropertyMedia] pm
			ON op.PropertyId = pm.PropertyId
          WHERE
         (@1OwnerID IS NULL OR op.OwnerID = @1OwnerID)
        AND (@1RentalListingID IS NULL OR rl.Id = @1RentalListingID)
        AND (@1PropertyID IS NULL OR op.PropertyId = @1PropertyID )
		AND (@1Description IS NULL OR rl.Description LIKE '%' + @1Description + '%')
		AND (@1AvailableDate IS NULL OR AvailableDate = @1AvailableDate)
		AND (@1TargetRent IS NULL OR TargetRent = @1TargetRent )
		AND (@1MovingCost IS NULL OR MovingCost = @1MovingCost )
		AND (@1OccupantCount IS NULL OR OccupantCount = @1OccupantCount )
		)
    SELECT OwnerId,
	       RentalListingID,
           PropertyId,
		   Description,
		   AvailableDate,
		   MovingCost,
		   TargetRent,
		   OccupantCount,
		   PetsAllowed,
		   Furnishing,
		   NewFileName
    FROM CTE_Results AS CPC
    WHERE
        ROWNUM > @lFirstRec 
    AND ROWNUM < @lLastRec
    ORDER BY ROWNUM ASC
         
END
GO

-------------------------------------------------------------------------------------------------------------------------------
--m)Stored Procedure : Given owner Id, search string, sort order string, page size, page number, build stored procedure to find 
all requests from this owner to tenants including any media (photo, documents).
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerToTenantRequestsSearchPagingSorting]    Script Date: 25/02/2019 1:20:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ================================================================================
-- Author:		<Seemal Dsouza>
-- Create date: <24/02/2019>
-- Description:	< Given owner Id, search string, sort order string, page size, page 
--                number, build stored procedure to find all requests from this owner 
--                to tenants including any media (photo, documents)>
-- ================================================================================ 
CREATE PROCEDURE [dbo].[GetOwnerToTenantRequestsSearchPagingSorting]
(
    -- Optional Filters for Dynamic Search
    @OwnerID          INT = NULL,
    @TenantID         INT = NULL,
    @PropertyID       INT = NULL, 
    -- Pagination
    @PageNbr            INT = 1,
    @PageSize           INT = 10,
    -- Sort Details
    @SortCol            NVARCHAR(20) = ''
)
AS
BEGIN
    DECLARE
        @1OwnerID          INT, 
        @1TenantID         INT, 
        @1PropertyID       INT, 
     
        @lPageNbr   INT,
        @lPageSize  INT,
        @lSortCol   NVARCHAR(20),
        @lFirstRec  INT,
        @lLastRec   INT,
        @lTotalRows INT
 
    SET @1OwnerID         = LTRIM(RTRIM(@OwnerID))
    SET @1TenantID        = LTRIM(RTRIM(@TenantID))
    SET @1PropertyID      = LTRIM(RTRIM(@PropertyID))
	
	
    SET @lPageNbr   = @PageNbr
    SET @lPageSize  = @PageSize
    SET @lSortCol   = LTRIM(RTRIM(@SortCol))
     
    SET @lFirstRec  = ( @lPageNbr - 1 ) * @lPageSize
    SET @lLastRec   = ( @lPageNbr * @lPageSize + 1 ) 
    SET @lTotalRows = @lFirstRec - @lLastRec + 1
 
    ; WITH CTE_Results
    AS (
        SELECT ROW_NUMBER() OVER (ORDER BY
            CASE WHEN @lSortCol = 'OwnerID_Asc' THEN op.OwnerID
                END ASC,
            CASE WHEN @lSortCol = 'OwnerID_Desc' THEN op.OwnerID
                END DESC, 
 
            CASE WHEN @lSortCol = 'TenantID_Asc' THEN tp.TenantID
                END ASC,
            CASE WHEN @lSortCol = 'TenantID_Desc' THEN tp.TenantID
                END DESC, 
 
            CASE WHEN @lSortCol = 'PropertyID_Asc' THEN op.PropertyID 
                END ASC,
            CASE WHEN @lSortCol = 'PropertyID_Desc' THEN op.PropertyID 
                END DESC

            ) AS ROWNUM,
   pr.Id 'RequestId',
   op.OwnerId,
   tp.TenantId,
   op.PropertyId,
   pr.RequestMessage,
   pr.RequestStatusId,
   pr.RequestTypeId,
   pr.Reason,
   pr.RecipientId,
   pr.IsActive,
   pr.ToOwner,
   pr.ToTenant,
   rs.Name 'RequestStatus',
   rt.Name  'RequestType',
   prm.NewFileName 'MediaFileName'
FROM
   [dbo].[TenantProperty] tp 
   JOIN
      [dbo].[PropertyRequest] pr 
      ON pr.PropertyId = tp.PropertyId 
   JOIN
      [dbo].[OwnerProperty] op 
      ON op.PropertyId = tp.PropertyId 
   JOIN
      [dbo].[RequestStatus] rs 
      ON rs.Id = pr.RequestStatusId 
   JOIN
      [dbo].[RequestType] rt 
      ON rt.Id = pr.RequestTypeId 
   LEFT JOIN
      [dbo].[PropertyRequestMedia] prm 
      ON pr.Id = prm.PropertyRequestId 
WHERE
   ToTenant = 1
        AND(@1OwnerID IS NULL OR op.OwnerID = @1OwnerID)
        AND (@1TenantID IS NULL OR tp.TenantID = @1TenantID)
        AND (@1PropertyID IS NULL OR op.PropertyId = @1PropertyID )
		)
    SELECT  RequestId,
            OwnerId,
            TenantId,
            PropertyId,
            RequestMessage,
            RequestStatusId,
            RequestTypeId,
            Reason,
            RecipientId,
            IsActive,
            ToOwner,
            ToTenant,
            RequestStatus,
            RequestType,
            MediaFileName
    FROM CTE_Results AS CPC
    WHERE
        ROWNUM > @lFirstRec 
    AND ROWNUM < @lLastRec
    ORDER BY ROWNUM ASC
         
END
GO
---------------------------------------------------------------------------------------------------------------------------------
--n)Stored Procedure : Given owner Id, search string, sort order string, page size, page number, build stored procedure to jobs in marketplace that belong to this owner including any media (photo, documents).
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerMarketJobsSearchPagingSorting]    Script Date: 25/02/2019 1:22:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ================================================================================
-- Author:		<Seemal Dsouza>
-- Create date: <24/02/2019>
-- Description:	<  Given owner Id, search string, sort order string, page size, page number, 
--                 build stored procedure to jobs in marketplace that belong to this owner including 
--                 any media (photo, documents)>
-- ================================================================================ 
CREATE PROCEDURE [dbo].[GetOwnerMarketJobsSearchPagingSorting]
(
    -- Optional Filters for Dynamic Search
    @OwnerID          INT = NULL,
    @ProviderID       INT = NULL,
    @PropertyID       INT = NULL, 
    -- Pagination
    @PageNbr            INT = 1,
    @PageSize           INT = 10,
    -- Sort Details
    @SortCol            NVARCHAR(20) = ''
)
AS
BEGIN
    DECLARE
        @1OwnerID          INT, 
        @1ProviderID       INT, 
        @1PropertyID       INT, 
     
        @lPageNbr   INT,
        @lPageSize  INT,
        @lSortCol   NVARCHAR(20),
        @lFirstRec  INT,
        @lLastRec   INT,
        @lTotalRows INT
 
    SET @1OwnerID         = LTRIM(RTRIM(@OwnerID))
    SET @1ProviderID      = LTRIM(RTRIM(@ProviderID))
    SET @1PropertyID      = LTRIM(RTRIM(@PropertyID))
	
	
    SET @lPageNbr   = @PageNbr
    SET @lPageSize  = @PageSize
    SET @lSortCol   = LTRIM(RTRIM(@SortCol))
     
    SET @lFirstRec  = ( @lPageNbr - 1 ) * @lPageSize
    SET @lLastRec   = ( @lPageNbr * @lPageSize + 1 ) 
    SET @lTotalRows = @lFirstRec - @lLastRec + 1
 
    ; WITH CTE_Results
    AS (
        SELECT ROW_NUMBER() OVER (ORDER BY
            CASE WHEN @lSortCol = 'OwnerID_Asc' THEN OwnerID
                END ASC,
            CASE WHEN @lSortCol = 'OwnerID_Desc' THEN OwnerID
                END DESC, 
 
            CASE WHEN @lSortCol = 'ProviderID_Asc' THEN ProviderID
                END ASC,
            CASE WHEN @lSortCol = 'ProviderID_Desc' THEN ProviderID
                END DESC, 
 
            CASE WHEN @lSortCol = 'PropertyID_Asc' THEN j.PropertyID 
                END ASC,
            CASE WHEN @lSortCol = 'PropertyID_Desc' THEN j.PropertyID 
                END DESC

            ) AS ROWNUM,
   j.OwnerId,
   j.ProviderId,
   j.PropertyId,
   PaymentAmount,
   JobDescription,
   JobStartDate,
   JobEndDate,
   jm.NewFileName 'MediaFileName'
FROM
   [dbo].[Job] j 
   LEFT JOIN
      [dbo].[JobMedia] jm 
      ON j.Id = jm.JobId 
WHERE
            (@1OwnerID IS NULL OR OwnerID = @1OwnerID)
        AND (@1ProviderID IS NULL OR ProviderID = @1ProviderID)
        AND (@1PropertyID IS NULL OR j.PropertyId = @1PropertyID )
		)
    SELECT   
   OwnerId,
   ProviderId,
   PropertyId,
   PaymentAmount,
   JobDescription,
   JobStartDate,
   JobEndDate,
   MediaFileName
    FROM CTE_Results AS CPC
    WHERE
        ROWNUM > @lFirstRec 
    AND ROWNUM < @lLastRec
    ORDER BY ROWNUM ASC
         
END
GO


----------------------------------------------------------------------------------------------------------------------
--o)Stored Procedure : Given owner Id, search string, sort order string, page size, page number, build stored procedure to find current maintenance (jobs) for all properties that belong to this owner including any media (photo, documents). 
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerMarketJobsSearchPagingSorting]    Script Date: 25/02/2019 1:23:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ================================================================================
-- Author:		<Seemal Dsouza>
-- Create date: <24/02/2019>
-- Description:	<  Given owner Id, search string, sort order string, page size, page number, 
--                 build stored procedure to jobs in marketplace that belong to this owner including 
--                 any media (photo, documents)>
-- ================================================================================ 
CREATE PROCEDURE [dbo].[GetOwnerMarketJobsSearchPagingSorting]
(
    -- Optional Filters for Dynamic Search
    @OwnerID          INT = NULL,
    @ProviderID       INT = NULL,
    @PropertyID       INT = NULL, 
    -- Pagination
    @PageNbr            INT = 1,
    @PageSize           INT = 10,
    -- Sort Details
    @SortCol            NVARCHAR(20) = ''
)
AS
BEGIN
    DECLARE
        @1OwnerID          INT, 
        @1ProviderID       INT, 
        @1PropertyID       INT, 
     
        @lPageNbr   INT,
        @lPageSize  INT,
        @lSortCol   NVARCHAR(20),
        @lFirstRec  INT,
        @lLastRec   INT,
        @lTotalRows INT
 
    SET @1OwnerID         = LTRIM(RTRIM(@OwnerID))
    SET @1ProviderID      = LTRIM(RTRIM(@ProviderID))
    SET @1PropertyID      = LTRIM(RTRIM(@PropertyID))
	
	
    SET @lPageNbr   = @PageNbr
    SET @lPageSize  = @PageSize
    SET @lSortCol   = LTRIM(RTRIM(@SortCol))
     
    SET @lFirstRec  = ( @lPageNbr - 1 ) * @lPageSize
    SET @lLastRec   = ( @lPageNbr * @lPageSize + 1 ) 
    SET @lTotalRows = @lFirstRec - @lLastRec + 1
 
    ; WITH CTE_Results
    AS (
        SELECT ROW_NUMBER() OVER (ORDER BY
            CASE WHEN @lSortCol = 'OwnerID_Asc' THEN OwnerID
                END ASC,
            CASE WHEN @lSortCol = 'OwnerID_Desc' THEN OwnerID
                END DESC, 
 
            CASE WHEN @lSortCol = 'ProviderID_Asc' THEN ProviderID
                END ASC,
            CASE WHEN @lSortCol = 'ProviderID_Desc' THEN ProviderID
                END DESC, 
 
            CASE WHEN @lSortCol = 'PropertyID_Asc' THEN j.PropertyID 
                END ASC,
            CASE WHEN @lSortCol = 'PropertyID_Desc' THEN j.PropertyID 
                END DESC

            ) AS ROWNUM,
   j.OwnerId,
   j.ProviderId,
   j.PropertyId,
   PaymentAmount,
   JobDescription,
   JobStartDate,
   JobEndDate,
   jm.NewFileName 'MediaFileName'
FROM
   [dbo].[Job] j 
   LEFT JOIN
      [dbo].[JobMedia] jm 
      ON j.Id = jm.JobId 
WHERE
            (@1OwnerID IS NULL OR OwnerID = @1OwnerID)
        AND (@1ProviderID IS NULL OR ProviderID = @1ProviderID)
        AND (@1PropertyID IS NULL OR j.PropertyId = @1PropertyID )
		)
    SELECT   
   OwnerId,
   ProviderId,
   PropertyId,
   PaymentAmount,
   JobDescription,
   JobStartDate,
   JobEndDate,
   MediaFileName
    FROM CTE_Results AS CPC
    WHERE
        ROWNUM > @lFirstRec 
    AND ROWNUM < @lLastRec
    ORDER BY ROWNUM ASC
         
END
GO

------------------------------------------------------------------------------------------------------------------------------------------
--p)Stored Procedure : Given owner Id, search string, sort order string, status string, page size, page number, build stored procedure to find all requests from tenants to this owner including any media (photo, documents). 
USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetOwnerToTenantRequestsSearchPagingSorting]    Script Date: 25/02/2019 1:24:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ================================================================================
-- Author:		<Seemal Dsouza>
-- Create date: <24/02/2019>
-- Description:	< Given owner Id, search string, sort order string, page size, page 
--                number, build stored procedure to find all requests from this owner 
--                to tenants including any media (photo, documents)>
-- ================================================================================ 
CREATE PROCEDURE [dbo].[GetOwnerToTenantRequestsSearchPagingSorting]
(
    -- Optional Filters for Dynamic Search
    @OwnerID          INT = NULL,
    @TenantID         INT = NULL,
    @PropertyID       INT = NULL, 
    -- Pagination
    @PageNbr            INT = 1,
    @PageSize           INT = 10,
    -- Sort Details
    @SortCol            NVARCHAR(20) = ''
)
AS
BEGIN
    DECLARE
        @1OwnerID          INT, 
        @1TenantID         INT, 
        @1PropertyID       INT, 
     
        @lPageNbr   INT,
        @lPageSize  INT,
        @lSortCol   NVARCHAR(20),
        @lFirstRec  INT,
        @lLastRec   INT,
        @lTotalRows INT
 
    SET @1OwnerID         = LTRIM(RTRIM(@OwnerID))
    SET @1TenantID        = LTRIM(RTRIM(@TenantID))
    SET @1PropertyID      = LTRIM(RTRIM(@PropertyID))
	
	
    SET @lPageNbr   = @PageNbr
    SET @lPageSize  = @PageSize
    SET @lSortCol   = LTRIM(RTRIM(@SortCol))
     
    SET @lFirstRec  = ( @lPageNbr - 1 ) * @lPageSize
    SET @lLastRec   = ( @lPageNbr * @lPageSize + 1 ) 
    SET @lTotalRows = @lFirstRec - @lLastRec + 1
 
    ; WITH CTE_Results
    AS (
        SELECT ROW_NUMBER() OVER (ORDER BY
            CASE WHEN @lSortCol = 'OwnerID_Asc' THEN op.OwnerID
                END ASC,
            CASE WHEN @lSortCol = 'OwnerID_Desc' THEN op.OwnerID
                END DESC, 
 
            CASE WHEN @lSortCol = 'TenantID_Asc' THEN tp.TenantID
                END ASC,
            CASE WHEN @lSortCol = 'TenantID_Desc' THEN tp.TenantID
                END DESC, 
 
            CASE WHEN @lSortCol = 'PropertyID_Asc' THEN op.PropertyID 
                END ASC,
            CASE WHEN @lSortCol = 'PropertyID_Desc' THEN op.PropertyID 
                END DESC

            ) AS ROWNUM,
   pr.Id 'RequestId',
   op.OwnerId,
   tp.TenantId,
   op.PropertyId,
   pr.RequestMessage,
   pr.RequestStatusId,
   pr.RequestTypeId,
   pr.Reason,
   pr.RecipientId,
   pr.IsActive,
   pr.ToOwner,
   pr.ToTenant,
   rs.Name 'RequestStatus',
   rt.Name  'RequestType',
   prm.NewFileName 'MediaFileName'
FROM
   [dbo].[TenantProperty] tp 
   JOIN
      [dbo].[PropertyRequest] pr 
      ON pr.PropertyId = tp.PropertyId 
   JOIN
      [dbo].[OwnerProperty] op 
      ON op.PropertyId = tp.PropertyId 
   JOIN
      [dbo].[RequestStatus] rs 
      ON rs.Id = pr.RequestStatusId 
   JOIN
      [dbo].[RequestType] rt 
      ON rt.Id = pr.RequestTypeId 
   LEFT JOIN
      [dbo].[PropertyRequestMedia] prm 
      ON pr.Id = prm.PropertyRequestId 
WHERE
   ToTenant = 1
        AND(@1OwnerID IS NULL OR op.OwnerID = @1OwnerID)
        AND (@1TenantID IS NULL OR tp.TenantID = @1TenantID)
        AND (@1PropertyID IS NULL OR op.PropertyId = @1PropertyID )
		)
    SELECT  RequestId,
            OwnerId,
            TenantId,
            PropertyId,
            RequestMessage,
            RequestStatusId,
            RequestTypeId,
            Reason,
            RecipientId,
            IsActive,
            ToOwner,
            ToTenant,
            RequestStatus,
            RequestType,
            MediaFileName
    FROM CTE_Results AS CPC
    WHERE
        ROWNUM > @lFirstRec 
    AND ROWNUM < @lLastRec
    ORDER BY ROWNUM ASC
         
END
GO
----------------------------------------------------------------------------------------------------------
q)Stored Procedure : Tenant my request with search, sort and pagination.

USE [KeysOnboardDb]
GO

/****** Object:  StoredProcedure [dbo].[GetTenantInfoSearchPagingSorting]    Script Date: 25/02/2019 1:24:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================
-- Author:		<Seemal Dsouza>
-- Create date: <24/02/2019>
-- Description:	<  Tenant Information with search, sort and pagination>
-- ================================================================================ 
CREATE PROCEDURE [dbo].[GetTenantInfoSearchPagingSorting]
(
    -- Optional Filters for Dynamic Search

    @TenantID         INT = NULL,
 
    -- Pagination
    @PageNbr            INT = 1,
    @PageSize           INT = 10,
    -- Sort Details
    @SortCol            NVARCHAR(20) = ''
)
AS
BEGIN
    DECLARE

        @1TenantID         INT, 

        @lPageNbr   INT,
        @lPageSize  INT,
        @lSortCol   NVARCHAR(20),
        @lFirstRec  INT,
        @lLastRec   INT,
        @lTotalRows INT
 
    SET @1TenantID        = LTRIM(RTRIM(@TenantID))
		
    SET @lPageNbr   = @PageNbr
    SET @lPageSize  = @PageSize
    SET @lSortCol   = LTRIM(RTRIM(@SortCol))
     
    SET @lFirstRec  = ( @lPageNbr - 1 ) * @lPageSize
    SET @lLastRec   = ( @lPageNbr * @lPageSize + 1 ) 
    SET @lTotalRows = @lFirstRec - @lLastRec + 1
 
    ; WITH CTE_Results
    AS (
        SELECT ROW_NUMBER() OVER (ORDER BY
            CASE WHEN @lSortCol = 'TenantID_Asc' THEN ID
                END ASC,
            CASE WHEN @lSortCol = 'TenantID_Desc' THEN ID
                END DESC

            ) AS ROWNUM,
   Id as TenantID,
   DateOfBirth,
   HomePhoneNumber,
   MobilePhoneNumber, 
   ResidentialAddress,
   HasProofOfIdentity 
FROM
   Tenant
WHERE
(@1TenantID IS NULL OR ID = @1TenantID)
)
SELECT 
   TenantID,
   DateOfBirth,
   HomePhoneNumber,
   MobilePhoneNumber, 
   ResidentialAddress,
   HasProofOfIdentity  
    FROM CTE_Results AS CPC
    WHERE
        ROWNUM > @lFirstRec 
    AND ROWNUM < @lLastRec
    ORDER BY ROWNUM ASC
         
END
GO


----------------------------------------------------------------------------------------------------------------
 


