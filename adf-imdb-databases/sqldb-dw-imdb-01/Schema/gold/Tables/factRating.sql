CREATE TABLE [gold].[factRating] (
	[RatingId]		INT				NOT NULL	IDENTITY(1,1),
	[MovieId]		INT				NOT NULL,
	[TVSeriesId]	INT				NOT NULL,
	[IsMovie]		BIT				NOT NULL,
	[IsTVSeries]	BIT				NOT NULL,
	[AverageRating]	DECIMAL(3,1)	NOT NULL,
	[NumberOfVotes]	INT				NOT NULL,
	CONSTRAINT [PK_gold_factRating] PRIMARY KEY CLUSTERED ([RatingId]),
	CONSTRAINT [FK_gold_factRating_MovieId] FOREIGN KEY ([MovieId]) REFERENCES [gold].[dimMovie]([MovieId]),
	CONSTRAINT [FK_gold_factRating_TVSeriesId] FOREIGN KEY ([TVSeriesId]) REFERENCES [gold].[dimTVSeries]([TVSeriesId])
);