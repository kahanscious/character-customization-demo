extends Node

signal color_updated(color: Color)
signal customization_updated

var character_data: CharacterData
var outfit_options: Array[CustomizationOption] = []
var hair_options: Array[CustomizationOption] = []
var hat_options: Array[CustomizationOption] = []


func _ready() -> void:
	character_data = CharacterData.new()
	print("Manager initialized with skin color: ", character_data.skin_color)
	_load_customization_options()


func update_skin_color(new_color: Color) -> void:
	if not character_data:
		push_error("No character data available!")

	if new_color.a < 1.0:
		push_warning("Color alpha ignore for skin tone.")
		new_color.a = 1.0

	character_data.skin_color = new_color
	color_updated.emit(new_color)


func update_part(part: CharacterData.BodyPart, index: int) -> void:
	match part:
		CharacterData.BodyPart.OUTFIT:
			character_data.selected_outfit = index
		CharacterData.BodyPart.HAIR:
			character_data.selected_hair = index
		CharacterData.BodyPart.HAT:
			character_data.selected_hat = index
	customization_updated.emit()


func update_color(part: CharacterData.BodyPart, color: Color) -> void:
	match part:
		CharacterData.BodyPart.OUTFIT:
			character_data.outfit_color = color
		CharacterData.BodyPart.BASE:
			character_data.skin_color = color
		CharacterData.BodyPart.HAIR:
			character_data.hair_color = color
		CharacterData.BodyPart.HAT:
			character_data.hat_color = color
	customization_updated.emit()


func _load_customization_options() -> void:
	_add_option(outfit_options, "res://assets/outfit_1.png", "Casual Outfit")
	_add_option(outfit_options, "res://assets/outfit_2.png", "Formal Outfit")

	_add_option(hair_options, "res://assets/hair_base1.png", "Short Hair")
	_add_option(hair_options, "res://assets/hair_base2.png", "Long Hair")

	_add_option(hat_options, "res://assets/hat_base1.png", "Cap")
	_add_option(hat_options, "res://assets/hat_base2.png", "Beanie")


func _add_option(array: Array[CustomizationOption], path: String, name: String) -> void:
	var option := CustomizationOption.new()
	if ResourceLoader.exists(path):
		option.texture = load(path)
		option.name = name
		array.append(option)
	else:
		push_warning("Resource not found: ", path)


func randomize_character() -> void:
	character_data.skin_color = Color(
		randf_range(0.4, 0.95), randf_range(0.2, 0.85), randf_range(0.1, 0.75), 1.0
	)

	if outfit_options.is_empty():
		push_warning("No outfits available")
		return

	character_data.outfit_color = Color(
		randf_range(0.2, 1.0), randf_range(0.2, 1.0), randf_range(0.2, 1.0), 1.0
	)
	character_data.selected_outfit = randi() % outfit_options.size()

	character_data.hair_color = Color(
		randf_range(0.2, 1.0), randf_range(0.2, 1.0), randf_range(0.2, 1.0), 1.0
	)
	character_data.selected_hair = randi() % hair_options.size()

	character_data.hat_color = Color(
		randf_range(0.2, 1.0), randf_range(0.2, 1.0), randf_range(0.2, 1.0), 1.0
	)
	character_data.selected_hat = randi() % hat_options.size()

	customization_updated.emit()


func reset_character() -> void:
	character_data.selected_outfit = -1
	character_data.selected_hat = -1
	character_data.selected_hair = -1
	character_data.outfit_color = Color(1, 1, 1, 1)
	character_data.skin_color = Color(0.98, 0.84, 0.65, 1.0)
	customization_updated.emit()
