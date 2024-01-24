extends Node

var player

var camera

var children = []

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
