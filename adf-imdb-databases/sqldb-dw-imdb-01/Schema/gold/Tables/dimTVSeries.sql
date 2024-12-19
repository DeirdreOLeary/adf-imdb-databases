CREATE TABLE [gold].[dimTVSeries] (
	[TVSeriesId]		INT				NOT NULL	IDENTITY(-1,-1),		/* Surrogate key */
		/* TVSeries Ids start at -1 with a negative increment to prevent overlap with Movie Ids */
    [DateLastUpdated]	DATETIME2(2)	NOT NULL	DEFAULT GETUTCDATE(),   /* DATETIME2(2) uses 6 bytes & has ms precision whereas DATETIME uses 8 bytes */
	[TitleKey]			VARCHAR(10)		NOT NULL,							/* Natural key */
	[Title]				VARCHAR(500)	NOT NULL,
	[StartYear]			CHAR(4)			NULL,
	[EndYear]			CHAR(4)			NULL,
	[NumberOfSeasons]	SMALLINT		NOT NULL,
	[NumberOfEpisodes]	SMALLINT		NOT NULL,
	[Genres]			VARCHAR(255)	NULL,
	CONSTRAINT [PK_gold_dimTVSeries] PRIMARY KEY CLUSTERED ([TVSeriesId])
);