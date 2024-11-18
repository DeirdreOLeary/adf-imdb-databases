/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
			truncate the bronze tables.

Pipeline:	pl_data_bronze_extract_files (adf-imdb-to-sqldb-01)

Activity:	Truncate all bronze tables

***********************************************************************************************/
CREATE PROCEDURE [bronze].[ADF_Truncate_Tables]
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Truncate all bronze tables */
		TRUNCATE TABLE [bronze].[name_basics];
        TRUNCATE TABLE [bronze].[title_basics];
        TRUNCATE TABLE [bronze].[title_crew];
        TRUNCATE TABLE [bronze].[title_episode];
        TRUNCATE TABLE [bronze].[title_principals];
        TRUNCATE TABLE [bronze].[title_ratings];

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO