return {
	s({ trig = "thumb", desc = "thumbnail + link to full media" },
		fmt('![]({path}-thumb.{ext}) ]({path2}.{ext2})',
			{ path = i(1, "path"), ext = i(2, "ext"), path2 = rep(1), ext2 = rep(2) })),
}
