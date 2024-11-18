/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
			truncate the silver tables.

Pipeline:	pl_trans_silver_transform_load_data (adf-imdb-to-sqldb-01)

Activity:	Truncate silver tables

***********************************************************************************************/
CREATE PROCEDURE [silver].[ADF_Truncate_Tables]
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Truncate all silver tables */
		TRUNCATE TABLE [silver].[Actors];
        TRUNCATE TABLE [silver].[Directors];
		TRUNCATE TABLE [silver].[Movies];
        TRUNCATE TABLE [silver].[Ratings];
		TRUNCATE TABLE [silver].[TVSeries];
        TRUNCATE TABLE [silver].[Writers];

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO