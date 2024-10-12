extends Node

var k
var currentScene = ""
var nextScene = ""
var psptScene = "res://Utilities/StartUpScreens/PassportCreation.tscn"
var mainStreet = "res://Zones/MainStreet/MainStreet.tscn"
var house = ""

var simpleUI = false

var cardDeck:Array

# Books
var bookcaseOpen: bool = false
var currentReading: String = "catsday3"
var recentReading: String = "catsday1"
var booksOwned = ["catsday","catsday2","catsday3","catsday1","catsday","catsday1","catsday2",]




func changeScene(destination):
	k = get_tree().change_scene_to_file(destination)


func moveOn():
	match currentScene:
		"title": nextScene = "psptScene"
		"passport": nextScene = "mainStreet"
	k = get_tree().change_scene_to_file(get(nextScene))
		
