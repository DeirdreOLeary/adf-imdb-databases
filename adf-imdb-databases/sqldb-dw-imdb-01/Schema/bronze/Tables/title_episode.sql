CREATE TABLE [bronze].[title_episode] (
	[tconst]		VARCHAR(255)	NOT NULL,	/* Setting 255 as the default for strings at the bronze layer */
	[parentTconst]	VARCHAR(255)	NOT NULL,
	[seasonNumber]	INT				NOT NULL,
	[episodeNumber]	INT				NOT NULL
);