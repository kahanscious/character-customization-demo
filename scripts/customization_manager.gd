extends Node

signal color_updated(color: Color)

var character_data: CharacterData


func _ready() -> void:
	character_data = CharacterData.new()
	print("Manager initialized with skin color: ", character_data.skin_color)


func update_skin_color(new_color: Color) -> void:
	if not character_data:
		push_error("No character data available!")

	if new_color.a < 1.0:
		push_warning("Color alpha ignore for skin tone.")
		new_color.a = 1.0

	character_data.skin_color = new_color
	color_updated.emit(new_color)
