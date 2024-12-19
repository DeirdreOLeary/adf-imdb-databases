/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            load data from the gold dim and fact tables to the gold bridgeWriter table.
            The bridge table is required because the relationship between writer and
            movie or tv series and the associated rating is many-to-many.

Pipeline:	pl_data_gold_load_data (adf-imdb-to-sqldb-01)

Activity:	Load bridgeWriter data

***********************************************************************************************/
CREATE PROCEDURE [gold].[ADF_Load_bridgeWriter]
    @ETLTimestamp DATETIME2(2)
AS
    SET NOCOUNT ON;

    BEGIN TRY

            /* Insert the new WriterId and RatingId combinations into the bridge table for Writers.
               We do not change existing entries for the bridge table. */
            WITH MovieAndTV AS (
                SELECT [MovieId],
                    0 AS [TVSeriesId],
                    [TitleKey]
                FROM [gold].[dimMovie]
                UNION ALL
                SELECT 0 AS [MovieId],
                    [TVSeriesId],
                    [TitleKey]
                FROM [gold].[dimTVSeries]
                WHERE [TVSeriesId] <> 0 /* The Unknown value is taken from the dimMovies table */
            ),
            Ratings AS (
                SELECT gfr.[RatingId],
                    mt.[TitleKey]
                FROM [gold].[factRating] gfr
                INNER JOIN MovieAndTV mt
                ON gfr.[MovieId] = mt.[MovieId]
                    AND gfr.[TVSeriesId] = mt.[TVSeriesId]
            ),
            Writers AS (
                SELECT [WriterId],
                    [TitleKey]
                FROM [gold].[dimWriter]
            ),
            Bridge AS (
                SELECT a.[WriterId],
                    r.[RatingId]
                FROM Writers a
                INNER JOIN Ratings r
                ON a.[TitleKey] = r.[TitleKey]
            )
            INSERT INTO [gold].[bridgeWriter] (
                [DateLastUpdated],
	            [WriterId],
	            [RatingId]
            )
            SELECT @ETLTimestamp AS [DateLastUpdated],
                [WriterId],
                [RatingId]
            FROM Bridge;

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO