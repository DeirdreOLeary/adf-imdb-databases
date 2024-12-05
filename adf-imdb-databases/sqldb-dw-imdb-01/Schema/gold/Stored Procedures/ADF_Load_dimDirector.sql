/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            load data from the silver Directors table to the gold dimDirector table.

Pipeline:	pl_data_gold_load_data (adf-imdb-to-sqldb-01)

Activity:	Load dimDirector data

***********************************************************************************************/
CREATE PROCEDURE [gold].[ADF_Load_dimDirector]
    @ETLTimestamp DATETIME2(2)
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Wrap all the changes to gold.dimDirector in a transaction so that they are all rolled back if any part fails */
        BEGIN TRANSACTION

             /* The dimDirector table always needs a default "zero" record for Unknown. If it doesn't exist, insert it */
            IF NOT EXISTS (
                SELECT * 
                FROM [gold].[dimDirector]
                WHERE [DirectorId] = 0
            )
            BEGIN
            
                SET IDENTITY_INSERT [gold].[dimDirector] ON;

                INSERT INTO [gold].[dimDirector] (
                    [DirectorId],
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

                SET IDENTITY_INSERT [gold].[dimDirector] OFF;

            END;

            /* Update 1 of 2: Update changed records by joining silver & gold tables on the natural keys */
            WITH ChangedDirectors AS (
                SELECT [NameKey],
                    [TitleKey],
                    [Name],
                    [BirthYear],
                    [DeathYear]
                FROM [silver].[Directors]
            )
            UPDATE [gold].[dimDirector]
                SET [DateLastUpdated] = @ETLTimestamp,
                [Name] = cd.[Name],
                [BirthYear] = cd.[BirthYear],
                [DeathYear] = cd.[DeathYear]
            FROM [gold].[dimDirector] gdd
            INNER JOIN ChangedDirectors cd
            ON gdd.[NameKey] = cd.[NameKey]
                AND gdd.[TitleKey] = cd.[TitleKey];

            /* Update 2 of 2: Insert new records based on the natural keys
               (i.e. those key combinations that do not already exist in the gold dimDirector table) */
            WITH NewDirectors AS (
                SELECT @ETLTimestamp AS [DateLastUpdated],
                    [NameKey],
                    [TitleKey],
                    [Name],
                    [BirthYear],
                    [DeathYear]
                FROM [silver].[Directors] sd
                WHERE NOT EXISTS (
                    SELECT *
                    FROM [gold].[dimDirector] gdd
                    WHERE gdd.[NameKey] = sd.[NameKey]
                        AND gdd.[TitleKey] = sd.[TitleKey]
                )
            )
            INSERT INTO [gold].[dimDirector] (
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
            FROM NewDirectors;

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