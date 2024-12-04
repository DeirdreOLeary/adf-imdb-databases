CREATE TABLE [gold].[dimMovie] (
	[MovieId]			INT				NOT NULL	IDENTITY(1,1),	/* Surrogate key */
		/* Movie Ids start at 1 with a positive increment to prevent overlap with TVSeries Ids */
	[TitleKey]			VARCHAR(10)		NOT NULL,					/* Natural key */
	[Title]				VARCHAR(500)	NOT NULL,
	[ReleaseYear]		CHAR(4)			NULL,
	[RuntimeInMinutes]	INT				NULL,
	[Genres]			VARCHAR(255)	NULL,
	CONSTRAINT [PK_gold_dimMovie] PRIMARY KEY CLUSTERED ([MovieId])
);