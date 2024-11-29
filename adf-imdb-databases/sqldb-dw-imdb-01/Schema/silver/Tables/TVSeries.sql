CREATE TABLE [silver].[TVSeries] (
	[TitleKey]			VARCHAR(10)		NOT NULL,
	[Title]				VARCHAR(500)	NOT NULL,
	[StartYear]			CHAR(4)			NULL,
	[EndYear]			CHAR(4)			NULL,
	[NumberOfSeasons]	SMALLINT		NOT NULL,
	[NumberOfEpisodes]	SMALLINT		NOT NULL,
	[Genres]			VARCHAR(255)	NULL,
	CONSTRAINT [PK_silver_TVSeries]  PRIMARY KEY CLUSTERED ([TitleKey])
);