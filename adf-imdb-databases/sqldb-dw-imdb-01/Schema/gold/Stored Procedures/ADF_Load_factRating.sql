/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            load data from the silver Ratings table to the gold factRating table.

Pipeline:	pl_data_gold_load_data (adf-imdb-to-sqldb-01)

Activity:	Load factRating data

***********************************************************************************************/
CREATE PROCEDURE [gold].[ADF_Load_factRating]
    @ETLTimestamp DATETIME2(2)
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Wrap all the changes to gold.factRating in a transaction so that they are all rolled back if any part fails */
        BEGIN TRANSACTION;

            /* Update 1 of 2: Update changed records by joining silver & gold tables on the Movie/TVSeries Ids */
            WITH MovieAndTV AS (
                SELECT [MovieId],
                    0 AS [TVSeriesId],
                    [TitleKey],
                    1 AS [IsMovie],
                    0 AS [IsTVSeries]
                FROM [gold].[dimMovie]
                UNION ALL
                SELECT 0 AS [MovieId],
                    [TVSeriesId],
                    [TitleKey],
                    0 AS [IsMovie],
                    1 AS [IsTVSeries]
                FROM [gold].[dimTVSeries]
                WHERE [TVSeriesId] <> 0 /* The Unknown value is taken from the dimMovies table */
            ),
            ChangedRatings AS (
                SELECT mt.[MovieId],
	                mt.[TVSeriesId],
                    mt.[IsMovie],
                    mt.[IsTVSeries],
                    sr.[AverageRating],
                    sr.[NumberOfVotes]
                FROM [silver].[Ratings] sr
                INNER JOIN MovieAndTV mt
                ON sr.[TitleKey] = mt.[TitleKey]
            )
            UPDATE [gold].[factRating]
                SET [DateLastUpdated] = @ETLTimestamp,
                [IsMovie] = cr.[IsMovie],
                [IsTVSeries] = cr.[IsTVSeries],
                [AverageRating] = cr.[AverageRating],
                [NumberOfVotes] = cr.[NumberOfVotes]
            FROM [gold].[factRating] gfr
            INNER JOIN ChangedRatings cr
            ON gfr.[MovieId] = cr.[MovieId]
                AND gfr.[TVSeriesId] = cr.[TVSeriesId];

            /* Update 2 of 2: Insert new records based on the Movie/TVSeries Ids
               (i.e. those Ids that do not already exist in the gold factRating table) */
            WITH MovieAndTV AS (
                SELECT [MovieId],
                    0 AS [TVSeriesId],
                    [TitleKey],
                    1 AS [IsMovie],
                    0 AS [IsTVSeries]
                FROM [gold].[dimMovie]
                UNION ALL
                SELECT 0 AS [MovieId],
                    [TVSeriesId],
                    [TitleKey],
                    0 AS [IsMovie],
                    1 AS [IsTVSeries]
                FROM [gold].[dimTVSeries]
                WHERE [TVSeriesId] <> 0 /* The Unknown value is taken from the dimMovies table */
            ),
            NewRatings AS (
                SELECT @ETLTimestamp AS [DateLastUpdated],
                    mt.[MovieId],
	                mt.[TVSeriesId],
                    mt.[IsMovie],
                    mt.[IsTVSeries],
                    sr.[AverageRating],
                    sr.[NumberOfVotes]
                FROM [silver].[Ratings] sr
                INNER JOIN MovieAndTV mt
                ON sr.[TitleKey] = mt.[TitleKey]
                WHERE NOT EXISTS (
                    SELECT *
                    FROM [gold].[factRating] gfr
                    WHERE gfr.[MovieId] = mt.[MovieId]
                        AND gfr.[TVSeriesId] = mt.[TVSeriesId]
                )
            )
            INSERT INTO [gold].[factRating] (
                [DateLastUpdated],
                [MovieId],
                [TVSeriesId],
                [IsMovie],
                [IsTVSeries],
                [AverageRating],
                [NumberOfVotes]
            )
            SELECT [DateLastUpdated],
                [MovieId],
                [TVSeriesId],
                [IsMovie],
                [IsTVSeries],
                [AverageRating],
                [NumberOfVotes]
            FROM NewRatings;

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
        BEGIN
            
            ROLLBACK
            
        END
            
        ;THROW

    END CATCH

GO