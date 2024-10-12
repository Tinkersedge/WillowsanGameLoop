extends Node

var k
var outside:bool = true
var interiorSaveSpot:Vector2
var saveSpot:Vector2
var insideLocation:Vector2


# Go from building back to street
func goBuildToStreet(currentStreet):
	match currentStreet:
		0: Global.changeScene(Global.mainStreet)
		1: pass
		2: pass
		3: pass
		4: pass
	outside = true

# Go from street to building
func goInside(currentBuild):
	#print("In TransportMgr, currentBUild is ", currentBuild)
	Global.changeScene(currentBuild)
	outside = false

# Inside to Inside rooms
func changeRooms(destination):
	Global.changeScene(destination)
