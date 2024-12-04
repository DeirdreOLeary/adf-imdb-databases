CREATE TABLE [gold].[dimActor] (
	[ActorId]		INT				NOT NULL	IDENTITY(1,1),
	[NameKey]		VARCHAR(10)		NOT NULL,
	[TitleKey]		VARCHAR(10)		NOT NULL,
	[Name]			VARCHAR(255)	NOT NULL,
	[Character]		VARCHAR(255)	NOT NULL,
	[BirthYear]		CHAR(4)			NULL,
	[DeathYear]		CHAR(4)			NULL,
	CONSTRAINT [PK_gold_dimActor] PRIMARY KEY CLUSTERED ([ActorId])
);