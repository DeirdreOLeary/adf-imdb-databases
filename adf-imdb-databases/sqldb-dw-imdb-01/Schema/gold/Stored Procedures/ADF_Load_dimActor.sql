/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            load data from the silver Actors table to the gold dimActor table.

Pipeline:	pl_data_gold_load_data (adf-imdb-to-sqldb-01)

Activity:	Load dimActor data

***********************************************************************************************/
CREATE PROCEDURE [gold].[ADF_Load_dimActor]
    @ETLTimestamp DATETIME2(2)
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Wrap all the changes to gold.dimActor in a transaction so that they are all rolled back if any part fails */
        BEGIN TRANSACTION

             /* The dimActor table always needs a default "zero" record for Unknown. If it doesn't exist, insert it */
            IF NOT EXISTS (
                SELECT * 
                FROM [gold].[dimActor]
                WHERE [ActorId] = 0
            )
            BEGIN
            
                SET IDENTITY_INSERT [gold].[dimActor] ON;

                INSERT INTO [gold].[dimActor] (
                    [ActorId],
                    [DateLastUpdated],
                    [NameKey],
                    [TitleKey],
                    [Name],
                    [Character],
                    [BirthYear],
                    [DeathYear]
                )
                VALUES (
                    0,
                    @ETLTimestamp,
                    '0000000000',
                    '0000000000',
                    'Unknown',
                    'Unknown',
                    NULL,
                    NULL
                );

                SET IDENTITY_INSERT [gold].[dimActor] OFF;

            END;

            /* Update 1 of 2: Update changed records by joining silver & gold tables on the natural keys */
            WITH ChangedActors AS (
                SELECT [NameKey],
                    [TitleKey],
                    [Name],
                    [Character],
                    [BirthYear],
                    [DeathYear]
                FROM [silver].[Actors]
            )
            UPDATE [gold].[dimActor]
                SET [DateLastUpdated] = @ETLTimestamp,
                [Name] = ca.[Name],
                [Character] = ca.[Character],
                [BirthYear] = ca.[BirthYear],
                [DeathYear] = ca.[DeathYear]
            FROM [gold].[dimActor] gda
            INNER JOIN ChangedActors ca
            ON gda.[NameKey] = ca.[NameKey]
                AND gda.[TitleKey] = ca.[TitleKey];

            /* Update 2 of 2: Insert new records based on the natural keys
               (i.e. those key combinations that do not already exist in the gold dimActor table) */
            WITH NewActors AS (
                SELECT @ETLTimestamp AS [DateLastUpdated],
                    [NameKey],
                    [TitleKey],
                    [Name],
                    [Character],
                    [BirthYear],
                    [DeathYear]
                FROM [silver].[Actors] sa
                WHERE NOT EXISTS (
                    SELECT *
                    FROM [gold].[dimActor] gda
                    WHERE gda.[NameKey] = sa.[NameKey]
                        AND gda.[TitleKey] = sa.[TitleKey]
                )
            )
            INSERT INTO [gold].[dimActor] (
                [DateLastUpdated],
                [NameKey],
                [TitleKey],
                [Name],
                [Character],
                [BirthYear],
                [DeathYear]
            )
            SELECT [DateLastUpdated],
                [NameKey],
                [TitleKey],
                [Name],
                [Character],
                [BirthYear],
                [DeathYear]
            FROM NewActors;

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