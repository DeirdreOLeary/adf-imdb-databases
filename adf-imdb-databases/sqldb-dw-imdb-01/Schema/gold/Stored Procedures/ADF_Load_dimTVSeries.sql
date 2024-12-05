/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            load data from the silver TVSeries table to the gold dimTVSeries table.

Pipeline:	pl_data_gold_load_data (adf-imdb-to-sqldb-01)

Activity:	Load dimTVSeries data

***********************************************************************************************/
CREATE PROCEDURE [gold].[ADF_Load_dimTVSeries]
    @ETLTimestamp DATETIME2(2)
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Wrap all the changes to gold.dimTVSeries in a transaction so that they are all rolled back if any part fails */
        BEGIN TRANSACTION

             /* The dimTVSeries table always needs a default "zero" record for Unknown. If it doesn't exist, insert it */
            IF NOT EXISTS (
                SELECT * 
                FROM [gold].[dimTVSeries]
                WHERE [TVSeriesId] = 0
            )
            BEGIN
            
                SET IDENTITY_INSERT [gold].[dimTVSeries] ON;

                INSERT INTO [gold].[dimTVSeries] (
                    [TVSeriesId],
                    [DateLastUpdated],
                    [TitleKey],
	                [Title],
                    [StartYear],
	                [EndYear],
	                [NumberOfSeasons],
	                [NumberOfEpisodes],
	                [Genres]
                )
                VALUES (
                    0,
                    @ETLTimestamp,
                    '0000000000',
                    'Unknown',
                    NULL,
                    NULL,
                    '0',
                    '0',
                    NULL
                );

                SET IDENTITY_INSERT [gold].[dimTVSeries] OFF;

            END;

            /* Update 1 of 2: Update changed records by joining silver & gold tables on the natural keys */
            WITH ChangedTVSeries AS (
                SELECT [TitleKey],
	                [Title],
                    [StartYear],
	                [EndYear],
	                [NumberOfSeasons],
	                [NumberOfEpisodes],
	                [Genres]
                FROM [silver].[TVSeries]
            )
            UPDATE [gold].[dimTVSeries]
                SET [DateLastUpdated] = @ETLTimestamp,
                [Title] = ct.[Title],
                [StartYear] = ct.[StartYear],
                [EndYear] = ct.[EndYear],
                [NumberOfSeasons] = ct.[NumberOfSeasons],
                [NumberOfEpisodes] = ct.[NumberOfEpisodes],
                [Genres] = ct.[Genres]
            FROM [gold].[dimTVSeries] gdt
            INNER JOIN ChangedTVSeries ct
            ON gdt.[TitleKey] = ct.[TitleKey];

            /* Update 2 of 2: Insert new records based on the natural keys
               (i.e. those key combinations that do not already exist in the gold dimTVSeries table) */
            WITH NewTVSeries AS (
                SELECT @ETLTimestamp AS [DateLastUpdated],
                    [TitleKey],
	                [Title],
                    [StartYear],
	                [EndYear],
	                [NumberOfSeasons],
	                [NumberOfEpisodes],
	                [Genres]
                FROM [silver].[TVSeries] st
                WHERE NOT EXISTS (
                    SELECT *
                    FROM [gold].[dimTVSeries] gdt
                    WHERE gdt.[TitleKey] = st.[TitleKey]
                )
            )
            INSERT INTO [gold].[dimTVSeries] (
                [DateLastUpdated],
                [TitleKey],
                [Title],
                [StartYear],
	            [EndYear],
	            [NumberOfSeasons],
	            [NumberOfEpisodes],
                [Genres]
            )
            SELECT [DateLastUpdated],
                [TitleKey],
                [Title],
                [StartYear],
	            [EndYear],
	            [NumberOfSeasons],
	            [NumberOfEpisodes],
                [Genres]
            FROM NewTVSeries;

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