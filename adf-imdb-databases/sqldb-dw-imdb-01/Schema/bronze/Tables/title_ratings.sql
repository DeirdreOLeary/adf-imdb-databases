CREATE TABLE [bronze].[title_ratings] (
	[tconst]		VARCHAR(255)	NOT NULL,	/* Setting 255 as the default for strings at the bronze layer */
	[averageRating]	DECIMAL(9,6)	NOT NULL,	/* Setting 9,6 as the default for decimals at the bronze layer */
	[numVotes]		INT				NOT NULL
);