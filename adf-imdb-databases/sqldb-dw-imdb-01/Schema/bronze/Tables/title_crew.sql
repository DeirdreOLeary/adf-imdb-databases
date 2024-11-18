CREATE TABLE [bronze].[title_crew] (
	[tconst]		VARCHAR(255)	NOT NULL,	/* Setting 255 as the default for strings at the bronze layer */
	[directors]		VARCHAR(MAX)	NOT NULL,
	[writers]		VARCHAR(MAX)	NOT NULL
);