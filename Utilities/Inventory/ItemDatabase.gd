# ItemDatabase.gd
extends Node

var items = {
	"Seeds_Colors":
		{
			"displayName": "Seed Packet - Colors",
			"type": "seed",
			"description": "small packet of seeds to be planted on balcony",
			"isQuestItem": false,
			"isGiftable": true,
			"isEdible": false,
			"inMuseumable": false,
			"inMuseum": false,
			"stackable": true,
			"texture": ""
		},
	"Seeds_Days":
		{
			"displayName": "Seed Packet - Days",
			"type": "seed",
			"description": "small packet of seeds to be planted on balcony",
			"isQuestItem": false,
			"isGiftable": true,
			"isEdible": false,
			"inMuseumable": false,
			"inMuseum": false,
			"stackable": true,
			"texture": ""
		},
	"Seeds_Months":
		{
			"displayName": "Seed Packet - Months",
			"type": "seed",
			"description": "small packet of seeds to be planted on balcony",
			"isQuestItem": false,
			"isGiftable": true,
			"isEdible": false,
			"inMuseumable": false,
			"inMuseum": false,
			"stackable": true,
			"texture": ""
		},
	"Seeds_Animals":
		{
			"displayName": "Seed Packet - Animals",
			"type": "seed",
			"description": "small packet of seeds to be planted on balcony",
			"isQuestItem": false,
			"isGiftable": true,
			"isEdible": false,
			"inMuseumable": false,
			"inMuseum": false,
			"stackable": true,
			"texture": ""
		},
	"Coin":
		{
			"displayName": "Dropped Coin",
			"type": "money",
			"description": "coin found on the ground",
			"isQuestItem": true,
			"isGiftable": true,
			"isEdible": false,
			"inMuseumable": false,
			"inMuseum": false,
			"stackable": true,
			"texture": "res://PlaceholdersDeleteMe/Basic_GUI_Bundle/Icons/Icon_Small_Coin.png",
		},
	"Gem":
		{
			"displayName": "Beautiful Gem",
			"type": "gem",
			"description": "shiny gem worth a lot",
			"isQuestItem": false,
			"isGiftable": true,
			"isEdible": false,
			"inMuseumable": true,
			"inMuseum": false,
			"stackable": true,
			"texture": "res://PlaceholdersDeleteMe/Basic_GUI_Bundle/Icons/Icon_Small_Diamond.png",
		},
	"Heart":
		{
			"displayName": "Health",
			"type": "heart",
			"description": "shiny heart - not worth much",
			"isQuestItem": false,
			"isGiftable": true,
			"isEdible": false,
			"inMuseumable": true,
			"inMuseum": false,
			"stackable": true,
			"texture": "res://PlaceholdersDeleteMe/Icon - Heart.png",
		},
}

# Function to get item data by its unique ID
func getItemData(itemID: String):
	return items.get(itemID, null)

# Function to filter by property
func getItemsByType(itemType: String):
	var filteredItems = {}
	for itemID in items.keys():
		if items[itemID]["type"] == itemType:
			filteredItems[itemID] = items[itemID]
	return filteredItems

func getItemTexture(itemID: String):
	var itemData = getItemData(itemID)
	if itemData and itemData["texture"] != "":
		return load(itemData["texture"])
	return null # return null if no texture is set

func getItemInfo(itemID:String, infoNeeded:String):
	var itemData = getItemData(itemID)
	if itemData and itemData[infoNeeded] != "":
		return itemData[infoNeeded]
