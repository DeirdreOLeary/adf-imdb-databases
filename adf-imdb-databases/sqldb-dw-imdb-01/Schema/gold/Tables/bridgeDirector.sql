CREATE TABLE [gold].[bridgeDirector] (
    [DateLastUpdated]	DATETIME2(2)	NOT NULL	DEFAULT GETUTCDATE(),   /* DATETIME2(2) uses 6 bytes & has ms precision whereas DATETIME uses 8 bytes */
	[DirectorId]		INT				NOT NULL,
	[RatingId]			INT				NOT NULL,
	CONSTRAINT [PK_gold_bridgeDirector] PRIMARY KEY CLUSTERED ([DirectorId], [RatingId]),
	CONSTRAINT [FK_gold_bridgeDirector_DirectorId] FOREIGN KEY ([DirectorId]) REFERENCES [gold].[dimDirector]([DirectorId]),
	CONSTRAINT [FK_gold_bridgeDirector_RatingId] FOREIGN KEY ([RatingId]) REFERENCES [gold].[factRating]([RatingId])
);