local files = {
	{"BuildUtility", "replace"},
	{"PlayingTeam", "post"},
	{"BalanceMisc", "post"},
}

for _, v in ipairs(files) do
	assert(ModLoader.SetupFileHook("lua/" .. v[1] .. ".lua", "lua/FewerBuildRestrictions/" .. v[1] .. ".lua", v[2]))
end
