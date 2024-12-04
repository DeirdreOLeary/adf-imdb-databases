CREATE TABLE [gold].[bridgeDirector] (
	[DirectorId]	INT	NOT NULL,
	[RatingId]		INT	NOT NULL,
	CONSTRAINT [PK_gold_bridgeDirector] PRIMARY KEY CLUSTERED ([DirectorId], [RatingId]),
	CONSTRAINT [FK_gold_bridgeDirector_DirectorId] FOREIGN KEY ([DirectorId]) REFERENCES [gold].[dimDirector]([DirectorId]),
	CONSTRAINT [FK_gold_bridgeDirector_RatingId] FOREIGN KEY ([RatingId]) REFERENCES [gold].[factRating]([RatingId])
);