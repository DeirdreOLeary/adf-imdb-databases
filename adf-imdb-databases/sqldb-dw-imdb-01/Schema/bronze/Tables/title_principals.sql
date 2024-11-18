﻿CREATE TABLE [bronze].[title_principals] (
	[tconst]		VARCHAR(255)	NOT NULL,	/* Setting 255 as the default for strings at the bronze layer */
	[ordering]		INT				NOT NULL,
	[nconst]		VARCHAR(255)	NOT NULL,
	[category]		VARCHAR(255)	NOT NULL,
	[job]			VARCHAR(300)	NOT NULL,
	[characters]	VARCHAR(500)	NOT NULL
);