CREATE TABLE [silver].[TVSeries] (
	[TVSeriesId]		INT				NOT NULL	PRIMARY KEY,
	[TitleKey]			VARCHAR(10)		NOT NULL,
	[Title]				VARCHAR(500)	NOT NULL,
	[StartYear]			CHAR(4)			NULL,
	[EndYear]			CHAR(4)			NULL,
	[NumberOfSeasons]	TINYINT			NOT NULL,
	[NumberOfEpisodes]	TINYINT			NOT NULL,
	[Genres]			VARCHAR(255)	NULL
);