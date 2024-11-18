CREATE TABLE [silver].[Actors] (
	[ActorsId]		INT				NOT NULL	PRIMARY KEY,
	[NameKey]		VARCHAR(10)		NOT NULL,
	[TitleKey]		VARCHAR(10)		NOT NULL,
	[Name]			VARCHAR(255)	NOT NULL,
	[BirthYear]		CHAR(4)			NULL,
	[DeathYear]		CHAR(4)			NULL,
	[Character]		VARCHAR(255)	NULL
);