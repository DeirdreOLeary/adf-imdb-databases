CREATE TABLE [gold].[dimWriter] (
	[WriterId]		INT				NOT NULL	IDENTITY(1,1),	/* Surrogate key */
	[NameKey]		VARCHAR(10)		NOT NULL,					/* Natural key */
	[TitleKey]		VARCHAR(10)		NOT NULL,
	[Name]			VARCHAR(255)	NOT NULL,
	[BirthYear]		CHAR(4)			NULL,
	[DeathYear]		CHAR(4)			NULL,
	CONSTRAINT [PK_gold_dimWriter] PRIMARY KEY CLUSTERED ([WriterId])
);