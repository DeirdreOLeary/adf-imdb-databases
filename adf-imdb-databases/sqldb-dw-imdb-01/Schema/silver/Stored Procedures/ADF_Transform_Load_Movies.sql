﻿/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            transform data from the bronze title_basics table to the silver Movies table.

Pipeline:	pl_trans_silver_transform_load_data (adf-imdb-to-sqldb-01)

Activity:	Transform and Load Movies data

***********************************************************************************************/
CREATE PROCEDURE [silver].[ADF_Transform_Load_Movies]
AS
    SET NOCOUNT ON;

    BEGIN TRY
        
        /* Get the details from the bronze titles_basics table for all non-adult movies with 
           a primary title. Transform & load the data into the silver Movies table. */
        ;WITH [MovieTitles] AS (
            SELECT LEFT([tconst], 10) AS [TitleKey],
                LEFT([primaryTitle], 500) AS [Title],
                CASE [startYear]
                    WHEN '\N' THEN NULL
                    ELSE CAST([startYear] AS CHAR(4))
                END AS [ReleaseYear],
                CASE [runtimeMinutes]
                    WHEN '\N' THEN NULL
                    ELSE CAST([runtimeMinutes] AS INT)
                END AS [RuntimeInMinutes],
                CASE [genres]
                    WHEN '\N' THEN NULL
                    ELSE LEFT([genres], 255)
                END AS [Genres]
            FROM [bronze].[title_basics]
            WHERE [titleType] = 'movie'
                AND [isAdult] = 0
                AND [primaryTitle] <> '\N'
        )
        INSERT INTO [silver].[Movies] (
            [TitleKey],
	        [Title],
	        [ReleaseYear],
	        [RuntimeInMinutes],
	        [Genres]
        )
        SELECT [TitleKey],
            [Title],
            [ReleaseYear],
            [RuntimeInMinutes],
            [Genres]
        FROM [MovieTitles];

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO