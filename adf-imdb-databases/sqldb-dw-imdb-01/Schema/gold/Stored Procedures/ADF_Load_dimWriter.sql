/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            load data from the silver Writers table to the gold dimWriter table.

Pipeline:	pl_data_gold_load_data (adf-imdb-to-sqldb-01)

Activity:	Load dimWriter data

***********************************************************************************************/
CREATE PROCEDURE [gold].[ADF_Load_dimWriter]
    @ETLTimestamp DATETIME2(2)
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Wrap all the changes to gold.dimWriter in a transaction so that they are all rolled back if any part fails */
        BEGIN TRANSACTION

             /* The dimWriter table always needs a default "zero" record for Unknown. If it doesn't exist, insert it */
            IF NOT EXISTS (
                SELECT * 
                FROM [gold].[dimWriter]
                WHERE [WriterId] = 0
            )
            BEGIN
            
                SET IDENTITY_INSERT [gold].[dimWriter] ON;

                INSERT INTO [gold].[dimWriter] (
                    [WriterId],
                    [DateLastUpdated],
                    [NameKey],
                    [TitleKey],
                    [Name],
                    [BirthYear],
                    [DeathYear]
                )
                VALUES (
                    0,
                    @ETLTimestamp,
                    '0000000000',
                    '0000000000',
                    'Unknown',
                    NULL,
                    NULL
                );

                SET IDENTITY_INSERT [gold].[dimWriter] OFF;

            END;

            /* Update 1 of 2: Update changed records by joining silver & gold tables on the natural keys */
            WITH ChangedWriters AS (
                SELECT [NameKey],
                    [TitleKey],
                    [Name],
                    [BirthYear],
                    [DeathYear]
                FROM [silver].[Writers]
            )
            UPDATE [gold].[dimWriter]
                SET [DateLastUpdated] = @ETLTimestamp,
                [Name] = cw.[Name],
                [BirthYear] = cw.[BirthYear],
                [DeathYear] = cw.[DeathYear]
            FROM [gold].[dimWriter] gdw
            INNER JOIN ChangedWriters cw
            ON gdw.[NameKey] = cw.[NameKey]
                AND gdw.[TitleKey] = cw.[TitleKey];

            /* Update 2 of 2: Insert new records based on the natural keys
               (i.e. those key combinations that do not already exist in the gold dimWriter table) */
            WITH NewWriters AS (
                SELECT @ETLTimestamp AS [DateLastUpdated],
                    [NameKey],
                    [TitleKey],
                    [Name],
                    [BirthYear],
                    [DeathYear]
                FROM [silver].[Writers] sw
                WHERE NOT EXISTS (
                    SELECT *
                    FROM [gold].[dimWriter] gdw
                    WHERE gdw.[NameKey] = sw.[NameKey]
                        AND gdw.[TitleKey] = sw.[TitleKey]
                )
            )
            INSERT INTO [gold].[dimWriter] (
                [DateLastUpdated],
                [NameKey],
                [TitleKey],
                [Name],
                [BirthYear],
                [DeathYear]
            )
            SELECT [DateLastUpdated],
                [NameKey],
                [TitleKey],
                [Name],
                [BirthYear],
                [DeathYear]
            FROM NewWriters;

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