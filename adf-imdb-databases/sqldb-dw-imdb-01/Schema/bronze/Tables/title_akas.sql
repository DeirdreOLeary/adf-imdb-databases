CREATE TABLE [bronze].[title_akas] (
	[titleId]			VARCHAR(255)	NOT NULL,	/* Setting 255 as the default for strings at the bronze layer */
	[ordering]			INT				NOT NULL,
	[title]				VARCHAR(255)	NOT NULL,
	[region]			VARCHAR(255)	NOT NULL,
	[language]			VARCHAR(255)	NOT NULL,
	[types]				VARCHAR(255)	NOT NULL,
	[attributes]		VARCHAR(255)	NOT NULL,
	[isOriginalTitle]	BIT				NOT NULL
);