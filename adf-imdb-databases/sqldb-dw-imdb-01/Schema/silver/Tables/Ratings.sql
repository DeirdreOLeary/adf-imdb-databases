CREATE TABLE [silver].[Ratings] (
	[TitleKey]		VARCHAR(10)		NOT NULL,
	[AverageRating]	DECIMAL(3,1)	NOT NULL,
	[NumberOfVotes]	INT				NOT NULL,
	CONSTRAINT [PK_silver_Ratings]  PRIMARY KEY CLUSTERED ([TitleKey])
);