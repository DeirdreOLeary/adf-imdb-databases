CREATE TABLE [silver].[Directors] (
	[DirectorsId]	INT				NOT NULL	PRIMARY KEY,
	[NameKey]		VARCHAR(10)		NOT NULL,
	[TitleKey]		VARCHAR(10)		NOT NULL,
	[Name]			VARCHAR(255)	NOT NULL,
	[BirthYear]		CHAR(4)			NULL,
	[DeathYear]		CHAR(4)			NULL
);