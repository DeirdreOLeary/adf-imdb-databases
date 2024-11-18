CREATE TABLE [bronze].[title_episode] (
	[tconst]		VARCHAR(255)	NOT NULL,	/* Setting 255 as the default for strings at the bronze layer */
	[parentTconst]	VARCHAR(255)	NOT NULL,
	[seasonNumber]	VARCHAR(255)	NOT NULL,	/* Should be either INT or '\N' if missing */
	[episodeNumber]	VARCHAR(255)	NOT NULL	/* Should be either INT or '\N' if missing */
);