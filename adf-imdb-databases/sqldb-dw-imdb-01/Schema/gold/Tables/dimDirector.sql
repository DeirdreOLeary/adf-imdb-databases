CREATE TABLE [gold].[dimDirector] (
	[DirectorId]	INT				NOT NULL,
	[NameKey]		VARCHAR(10)		NOT NULL,
	[TitleKey]		VARCHAR(10)		NOT NULL,
	[Name]			VARCHAR(255)	NOT NULL,
	[BirthYear]		CHAR(4)			NULL,
	[DeathYear]		CHAR(4)			NULL,
	CONSTRAINT [PK_gold_dimDirector] PRIMARY KEY CLUSTERED ([DirectorId])
);