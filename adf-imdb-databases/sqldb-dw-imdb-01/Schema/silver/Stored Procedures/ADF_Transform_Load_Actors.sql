/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            transform data from the bronze name_basics & title_principals tables to the silver Actors table.

Pipeline:	pl_trans_silver_transform_load_data (adf-imdb-to-sqldb-01)

Activity:	Transform & Load Actors data

***********************************************************************************************/
CREATE PROCEDURE [silver].[ADF_Transform_Load_Actors]
AS
    SET NOCOUNT ON;

    BEGIN TRY
        
        /* Get the details from the bronze name_basics & title_principals tables for all actors & associated characters.
           Transform & load the data into the silver Actors table. */
		;WITH [ActorNames] AS (
            SELECT LEFT(nb.[nconst], 10) AS [NameKey],
                LEFT(tp.[tconst], 10) AS [TitleKey],
                LEFT(nb.[primaryName], 255) AS [Name],
                CASE tp.[characters]
                    WHEN '\N' THEN ''
                    ELSE LEFT(tp.[characters], 255)
                END AS [Character],
                CASE nb.[birthYear]
                    WHEN '\N' THEN NULL
                    ELSE LEFT(nb.[birthYear], 4)
                END AS [BirthYear],
                CASE nb.[deathYear]
                    WHEN '\N' THEN NULL
                    ELSE LEFT(nb.[deathYear], 4)
                END AS [DeathYear]
            FROM [bronze].[name_basics] nb
            INNER JOIN [bronze].[title_principals] tp
            ON nb.[nconst] = tp.[nconst]
            WHERE [category] IN ('actor', 'actress')
		)
        INSERT INTO [silver].[Actors] (
            [NameKey],
	        [TitleKey],
	        [Name],
	        [BirthYear],
	        [DeathYear],
	        [Character]
        )
        SELECT [NameKey],
	        [TitleKey],
	        [Name],
	        [BirthYear],
	        [DeathYear],
	        [Character]
        FROM [ActorNames];

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO