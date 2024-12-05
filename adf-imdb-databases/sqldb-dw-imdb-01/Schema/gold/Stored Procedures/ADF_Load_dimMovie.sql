/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            load data from the silver Movies table to the gold dimMovie table.

Pipeline:	pl_data_gold_load_data (adf-imdb-to-sqldb-01)

Activity:	Load dimMovie data

***********************************************************************************************/
CREATE PROCEDURE [gold].[ADF_Load_dimMovie]
    @ETLTimestamp DATETIME2(2)
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Wrap all the changes to gold.dimMovie in a transaction so that they are all rolled back if any part fails */
        BEGIN TRANSACTION

             /* The dimMovie table always needs a default "zero" record for Unknown. If it doesn't exist, insert it */
            IF NOT EXISTS (
                SELECT * 
                FROM [gold].[dimMovie]
                WHERE [MovieId] = 0
            )
            BEGIN
            
                SET IDENTITY_INSERT [gold].[dimMovie] ON;

                INSERT INTO [gold].[dimMovie] (
                    [MovieId],
                    [DateLastUpdated],
                    [TitleKey],
	                [Title],
	                [ReleaseYear],
	                [RuntimeInMinutes],
	                [Genres]
                )
                VALUES (
                    0,
                    @ETLTimestamp,
                    '0000000000',
                    'Unknown',
                    NULL,
                    NULL,
                    NULL
                );

                SET IDENTITY_INSERT [gold].[dimMovie] OFF;

            END;

            /* Update 1 of 2: Update changed records by joining silver & gold tables on the natural keys */
            WITH ChangedMovies AS (
                SELECT [TitleKey],
	                [Title],
	                [ReleaseYear],
	                [RuntimeInMinutes],
	                [Genres]
                FROM [silver].[Movies]
            )
            UPDATE [gold].[dimMovie]
                SET [DateLastUpdated] = @ETLTimestamp,
                [Title] = cm.[Title],
                [ReleaseYear] = cm.[ReleaseYear],
                [RuntimeInMinutes] = cm.[RuntimeInMinutes],
                [Genres] = cm.[Genres]
            FROM [gold].[dimMovie] gdm
            INNER JOIN ChangedMovies cm
            ON gdm.[TitleKey] = cm.[TitleKey];

            /* Update 2 of 2: Insert new records based on the natural keys
               (i.e. those key combinations that do not already exist in the gold dimMovie table) */
            WITH NewMovies AS (
                SELECT @ETLTimestamp AS [DateLastUpdated],
                    [TitleKey],
	                [Title],
	                [ReleaseYear],
	                [RuntimeInMinutes],
	                [Genres]
                FROM [silver].[Movies] sm
                WHERE NOT EXISTS (
                    SELECT *
                    FROM [gold].[dimMovie] gdm
                    WHERE gdm.[TitleKey] = sm.[TitleKey]
                )
            )
            INSERT INTO [gold].[dimMovie] (
                [DateLastUpdated],
                [TitleKey],
                [Title],
                [ReleaseYear],
                [RuntimeInMinutes],
                [Genres]
            )
            SELECT [DateLastUpdated],
                [TitleKey],
                [Title],
                [ReleaseYear],
                [RuntimeInMinutes],
                [Genres]
            FROM NewMovies;

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