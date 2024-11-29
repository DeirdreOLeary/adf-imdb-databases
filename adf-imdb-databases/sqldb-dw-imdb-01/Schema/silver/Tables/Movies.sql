CREATE TABLE [silver].[Movies] (
	[TitleKey]			VARCHAR(10)		NOT NULL,
	[Title]				VARCHAR(500)	NOT NULL,
	[ReleaseYear]		CHAR(4)			NULL,
	[RuntimeInMinutes]	INT				NULL,
	[Genres]			VARCHAR(255)	NULL,
	CONSTRAINT [PK_silver_Movies]  PRIMARY KEY CLUSTERED ([TitleKey])
);