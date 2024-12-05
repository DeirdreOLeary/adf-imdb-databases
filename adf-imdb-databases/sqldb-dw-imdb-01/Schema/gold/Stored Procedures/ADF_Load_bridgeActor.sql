﻿/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory pipeline to 
            load data from the silver Actors table to the gold bridgeActor table.

Pipeline:	pl_data_gold_load_data (adf-imdb-to-sqldb-01)

Activity:	Load bridgeActor data

***********************************************************************************************/
CREATE PROCEDURE [gold].[ADF_Load_bridgeActor]
    @ETLTimestamp DATETIME2(2)
AS
    SET NOCOUNT ON;

    BEGIN TRY

            /* Insert the new ActorId and RatingId combinations into the bridge table for Actors.
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
            Actors AS (
                SELECT [ActorId],
                    [TitleKey]
                FROM [gold].[dimActor]
            ),
            Bridge AS (
                SELECT a.[ActorId],
                    r.[RatingId]
                FROM Actors a
                INNER JOIN Ratings r
                ON a.[TitleKey] = r.[TitleKey]
            )
            INSERT INTO [gold].[bridgeActor] (
                [DateLastUpdated],
	            [ActorId],
	            [RatingId]
            )
            SELECT @ETLTimestamp AS [DateLastUpdated],
                [ActorId],
                [RatingId]
            FROM Bridge;

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO