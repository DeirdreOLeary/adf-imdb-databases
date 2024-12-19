CREATE TABLE [gold].[dimDirector] (
	[DirectorId]		INT				NOT NULL	IDENTITY(1,1),			/* Surrogate key */
    [DateLastUpdated]	DATETIME2(2)	NOT NULL	DEFAULT GETUTCDATE(),   /* DATETIME2(2) uses 6 bytes & has ms precision whereas DATETIME uses 8 bytes */
	[NameKey]			VARCHAR(10)		NOT NULL,							/* Natural key */
	[TitleKey]			VARCHAR(10)		NOT NULL,							/* Natural key */
	[Name]				VARCHAR(255)	NOT NULL,
	[BirthYear]			CHAR(4)			NULL,
	[DeathYear]			CHAR(4)			NULL,
	CONSTRAINT [PK_gold_dimDirector] PRIMARY KEY CLUSTERED ([DirectorId])
);