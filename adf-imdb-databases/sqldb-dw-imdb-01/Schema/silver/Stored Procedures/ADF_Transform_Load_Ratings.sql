/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            transform data from the bronze title_ratings table to the silver Ratings table.

Pipeline:	pl_trans_silver_transform_load_data (adf-imdb-to-sqldb-01)

Activity:	Transform and Load Ratings data

***********************************************************************************************/
CREATE PROCEDURE [silver].[ADF_Transform_Load_Ratings]
AS
    SET NOCOUNT ON;

    BEGIN TRY
        
        /* Get the ratings from the bronze title_ratings table for all non-adult movies & TV series 
           with a primary title. Transform & load the data into the silver Ratings table. */
        ;WITH [MovieAndTVRatings] AS (
            SELECT LEFT(t.[tconst], 10) AS [TitleKey],
                r.[averageRating] AS [AverageRating],
                r.[numVotes] AS [NumberOfVotes]
            FROM [bronze].[title_basics] t
            INNER JOIN [bronze].[title_ratings] r
            ON t.[tconst] = r.[tconst]
            WHERE [titleType] IN ('movie', 'tvSeries')
                AND [isAdult] = 0
                AND [primaryTitle] <> '\N'
        )
        INSERT INTO [silver].[Ratings] (
            [TitleKey],
	        [AverageRating],
	        [NumberOfVotes]
        )
        SELECT [TitleKey],
	        [AverageRating],
	        [NumberOfVotes]
        FROM [MovieAndTVRatings];

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO