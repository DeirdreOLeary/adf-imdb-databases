CREATE TABLE [gold].[bridgeActor] (
    [DateLastUpdated]	DATETIME2(2)	NOT NULL	DEFAULT GETUTCDATE(),   /* DATETIME2(2) uses 6 bytes & has ms precision whereas DATETIME uses 8 bytes */
	[ActorId]			INT				NOT NULL,
	[RatingId]			INT				NOT NULL,
	CONSTRAINT [PK_gold_bridgeActor] PRIMARY KEY CLUSTERED ([ActorId], [RatingId]),
	CONSTRAINT [FK_gold_bridgeActor_ActorId] FOREIGN KEY ([ActorId]) REFERENCES [gold].[dimActor]([ActorId]),
	CONSTRAINT [FK_gold_bridgeActor_RatingId] FOREIGN KEY ([RatingId]) REFERENCES [gold].[factRating]([RatingId])
);