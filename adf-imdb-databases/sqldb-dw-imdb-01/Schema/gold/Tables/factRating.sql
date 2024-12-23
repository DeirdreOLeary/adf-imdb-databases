﻿CREATE TABLE [gold].[factRating] (
	[RatingId]			INT				NOT NULL	IDENTITY(1,1),			/* Surrogate key */
    [DateLastUpdated]	DATETIME2(2)	NOT NULL	DEFAULT GETUTCDATE(),   /* DATETIME2(2) uses 6 bytes & has ms precision whereas DATETIME uses 8 bytes */
	[MovieId]			INT				NOT NULL,
	[TVSeriesId]		INT				NOT NULL,
	[IsMovie]			BIT				NOT NULL,
	[IsTVSeries]		BIT				NOT NULL,
	[AverageRating]		DECIMAL(3,1)	NOT NULL,
	[NumberOfVotes]		INT				NOT NULL,
	CONSTRAINT [PK_gold_factRating] PRIMARY KEY CLUSTERED ([RatingId]),
	CONSTRAINT [FK_gold_factRating_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [gold].[dimMovie]([MovieId]),
	CONSTRAINT [FK_gold_factRating_TVSeriesId] FOREIGN KEY ([TVSeriesId]) REFERENCES [gold].[dimTVSeries]([TVSeriesId])
);