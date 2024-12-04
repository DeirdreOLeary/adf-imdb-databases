CREATE TABLE [gold].[dimMovie] (
	[MovieId]			INT				NOT NULL,
	[TitleKey]			VARCHAR(10)		NOT NULL,
	[Title]				VARCHAR(500)	NOT NULL,
	[ReleaseYear]		CHAR(4)			NULL,
	[RuntimeInMinutes]	INT				NULL,
	[Genres]			VARCHAR(255)	NULL,
	CONSTRAINT [PK_gold_dimMovie] PRIMARY KEY CLUSTERED ([MovieId])
);