CREATE TABLE [bronze].[title_basics] (
	[tconst]			VARCHAR(255)	NOT NULL,	/* Setting 255 as the default for strings at the bronze layer */
	[titleType]			VARCHAR(255)	NOT NULL,
	[primaryTitle]		VARCHAR(500)	NOT NULL,
	[originalTitle]		VARCHAR(500)	NOT NULL,
	[isAdult]			VARCHAR(255)	NOT NULL,
	[startYear]			VARCHAR(255)	NOT NULL,	/* Should be either YYYY format or '\N' if missing */
	[endYear]			VARCHAR(255)	NOT NULL,	/* Should be either YYYY format or '\N' if missing */
	[runtimeMinutes]	VARCHAR(255)	NOT NULL,	/* Should be either INT or '\N' if missing */
	[genres]			VARCHAR(255)	NOT NULL
);