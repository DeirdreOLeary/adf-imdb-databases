CREATE TABLE [bronze].[name_basics] (
	[nconst]			VARCHAR(255)	NOT NULL,	/* Setting 255 as the default for strings at the bronze layer */
	[primaryName]		VARCHAR(255)	NOT NULL,
	[birthYear]			VARCHAR(255)	NOT NULL,	/* Should be either YYYY format or '\N' if missing */
	[deathYear]			VARCHAR(255)	NOT NULL,	/* Should be either YYYY format or '\N' if missing */
	[primaryProfession]	VARCHAR(255)	NOT NULL,
	[knownForTitles]	VARCHAR(255)	NOT NULL
);