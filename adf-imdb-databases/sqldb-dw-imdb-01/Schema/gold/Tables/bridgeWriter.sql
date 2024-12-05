CREATE TABLE [gold].[bridgeWriter] (
    [DateLastUpdated]	DATETIME2(2)	NOT NULL	DEFAULT GETUTCDATE(),   /* DATETIME2(2) uses 6 bytes & has ms precision whereas DATETIME uses 8 bytes */
	[WriterId]			INT				NOT NULL,
	[RatingId]			INT				NOT NULL,
	CONSTRAINT [PK_gold_bridgeWriter] PRIMARY KEY CLUSTERED ([WriterId], [RatingId]),
	CONSTRAINT [FK_gold_bridgeWriter_WriterId] FOREIGN KEY ([WriterId]) REFERENCES [gold].[dimWriter]([WriterId]),
	CONSTRAINT [FK_gold_bridgeWriter_RatingId] FOREIGN KEY ([RatingId]) REFERENCES [gold].[factRating]([RatingId])
);