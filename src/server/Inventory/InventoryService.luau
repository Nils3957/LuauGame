local InventoryService = {}

function InventoryService.AddItem(player, itemId, amount)
	-- 서버 사이드 아이템 추가 로직
	print("Adding item " .. itemId .. " to " .. player.Name)
end

function InventoryService.RemoveItem(player, itemId, amount)
	-- 서버 사이드 아이템 삭제/드롭 로직
	print("Removing item " .. itemId .. " from " .. player.Name)
end

return InventoryService
