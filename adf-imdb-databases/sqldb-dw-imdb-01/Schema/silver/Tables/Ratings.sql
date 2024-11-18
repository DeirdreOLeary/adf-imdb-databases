CREATE TABLE [silver].[Ratings] (
	[RatingsId]		INT				NOT NULL	PRIMARY KEY,
	[TitleKey]		VARCHAR(10)		NOT NULL,
	[AverageRating]	DECIMAL(3,1)	NOT NULL,
	[numVotes]		INT				NOT NULL
);