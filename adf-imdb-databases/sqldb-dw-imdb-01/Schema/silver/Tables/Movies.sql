CREATE TABLE [silver].[Movies] (
	[MoviesId]			INT				NOT NULL	PRIMARY KEY,
	[TitleKey]			VARCHAR(10)		NOT NULL,
	[Title]				VARCHAR(500)	NOT NULL,
	[ReleaseYear]		CHAR(4)			NULL,
	[RuntimeInMInutes]	INT				NULL,
	[Genres]			VARCHAR(255)	NULL
);