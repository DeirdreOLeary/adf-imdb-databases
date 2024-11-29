CREATE TABLE [silver].[Directors] (
	[NameKey]		VARCHAR(10)		NOT NULL,
	[TitleKey]		VARCHAR(10)		NOT NULL,
	[Name]			VARCHAR(255)	NOT NULL,
	[BirthYear]		CHAR(4)			NULL,
	[DeathYear]		CHAR(4)			NULL,
	CONSTRAINT [PK_silver_Directors]  PRIMARY KEY CLUSTERED ([NameKey], [TitleKey])
);