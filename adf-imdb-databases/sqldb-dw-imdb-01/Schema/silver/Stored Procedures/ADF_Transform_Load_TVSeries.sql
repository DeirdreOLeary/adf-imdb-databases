/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            transform data from the bronze title_basics table to the silver TVSeries table.

Pipeline:	pl_trans_silver_transform_load_data (adf-imdb-to-sqldb-01)

Activity:	Transform and Load TV Series data

***********************************************************************************************/
CREATE PROCEDURE [silver].[ADF_Transform_Load_TVSeries]
AS
    SET NOCOUNT ON;

    BEGIN TRY
        
        /* Get the details from the bronze titles_basics table for all non-adult TV series with 
           a primary title. Transform & load the data into the silver TVSeries table. */
		;WITH [EpisodesNulled] AS (
			SELECT [parentTconst]
				,CASE [seasonNumber]
					WHEN '\N' THEN NULL
					ELSE CAST([seasonNumber] AS SMALLINT)
				END AS [seasonNumber]
				,CASE [episodeNumber]
					WHEN '\N' THEN NULL
					ELSE CAST([episodeNumber] AS INT)
				END AS [episodeNumber]
			FROM [bronze].[title_episode]
		)
		,[SeasonsAndEpisodes] AS (
			SELECT [parentTconst]
				,ISNULL(MAX([seasonNumber]), 0) AS [NumberOfSeasons]
				,COUNT([episodeNumber]) AS [NumberOfEpisodes]
			FROM [EpisodesNulled]
			GROUP BY [parentTconst]
		)
        ,[TVSeriesTitles] AS (
            SELECT LEFT(t.[tconst], 10) AS [TitleKey],
                LEFT(t.[primaryTitle], 500) AS [Title],
                CASE t.[startYear]
                    WHEN '\N' THEN NULL
                    ELSE CAST(t.[startYear] AS CHAR(4))
                END AS [StartYear],
                CASE t.[endYear]
                    WHEN '\N' THEN NULL
                    ELSE CAST(t.[endYear] AS CHAR(4))
                END AS [EndYear],
                s.[NumberOfSeasons],
                s.[NumberOfEpisodes],
                CASE t.[genres]
                    WHEN '\N' THEN NULL
                    ELSE LEFT(t.[genres], 255)
                END AS [Genres]
			    FROM [bronze].[title_basics] t
			    INNER JOIN [SeasonsAndEpisodes] s
			    ON t.[tconst] = s.[parentTconst]
			    WHERE t.[titleType] = 'tvSeries'
				    AND t.[isAdult] = '0'
                    AND [primaryTitle] <> '\N'
        )
        INSERT INTO [silver].[TVSeries] (
            [TitleKey],
	        [Title],
	        [StartYear],
            [EndYear],
	        [NumberOfSeasons],
            [NumberOfEpisodes],
	        [Genres]
        )
        SELECT [TitleKey],
	        [Title],
	        [StartYear],
            [EndYear],
	        [NumberOfSeasons],
            [NumberOfEpisodes],
	        [Genres]
        FROM [TVSeriesTitles];

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO