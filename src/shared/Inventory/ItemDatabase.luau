local ItemDatabase = {
	["Sword_01"] = {
		Name = "연습용 목검",
		Description = "초보 모험가를 위한 기본적인 목검입니다.",
		Type = "Weapon",
		Image = "rbxassetid://12768177", -- 기본 검 아이콘
		Stackable = false
	},
	["Apple"] = {
		Name = "사과",
		Description = "체력을 10 회복시켜주는 달콤한 사과입니다.",
		Type = "Consumable",
		Image = "rbxassetid://16215840", -- 기본 사과 아이콘
		Stackable = true
	},
	["HealthPotion"] = {
		Name = "체력 물약",
		Description = "체력을 즉시 50 회복시켜줍니다.",
		Type = "Consumable",
		Image = "rbxassetid://18409033", -- 물약 아이콘
		Stackable = true
	}
}

return ItemDatabase
