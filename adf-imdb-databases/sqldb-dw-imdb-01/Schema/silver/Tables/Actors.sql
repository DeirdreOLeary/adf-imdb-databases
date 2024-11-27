CREATE TABLE [silver].[Actors] (
	[NameKey]		VARCHAR(10)		NOT NULL,
	[TitleKey]		VARCHAR(10)		NOT NULL,
	[Name]			VARCHAR(255)	NOT NULL,
	[Character]		VARCHAR(255)	NOT NULL,
	[BirthYear]		CHAR(4)			NULL,
	[DeathYear]		CHAR(4)			NULL,
	CONSTRAINT [PK_silver_Actors]  PRIMARY KEY CLUSTERED ([NameKey], [TitleKey], [Character])
);