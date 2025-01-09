extends Panel

@onready
var options_container: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/OptionsContainer
@onready var reset_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/ResetButton
@onready var randomize_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/RandomizeButton

const SECTION_SCENE := preload("res://scenes/customization_section.tscn")

var sections: Dictionary = {}


func _ready() -> void:
	_create_sections()
	_connect_buttons()

	CustomizationManager.customization_updated.connect(_update_ui_from_data)


func _connect_buttons() -> void:
	reset_button.pressed.connect(_on_reset_pressed)
	randomize_button.pressed.connect(_on_random_pressed)


func _create_sections() -> void:
	_add_color_section(
		"Skin Color", CharacterData.BodyPart.BASE, CustomizationManager.character_data.skin_color
	)
	_add_option_section(
		"Outfit", CharacterData.BodyPart.OUTFIT, CustomizationManager.outfit_options, true, true
	)
	_add_option_section(
		"Hair Style", CharacterData.BodyPart.HAIR, CustomizationManager.hair_options, true, true
	)
	_add_option_section(
		"Hat", CharacterData.BodyPart.HAT, CustomizationManager.hat_options, true, true
	)


func _add_color_section(title: String, part: CharacterData.BodyPart, initial_color: Color) -> void:
	var section := SECTION_SCENE.instantiate()
	options_container.add_child(section)

	section.setup(title, [], -1, true)

	section.color_changed.connect(
		func(color: Color): CustomizationManager.update_color(part, color)
	)

	sections[part] = section


func _add_option_section(
	title: String,
	part: CharacterData.BodyPart,
	options: Array[CustomizationOption],
	can_color: bool = false,
	allow_none: bool = false
) -> void:
	var section := SECTION_SCENE.instantiate()
	options_container.add_child(section)

	var option_names: Array[String] = []
	if allow_none:
		option_names.append("None")
	for option in options:
		option_names.append(option.name)

	var current_selection = CustomizationManager.character_data.get(
		"selected_" + CharacterData.BodyPart.keys()[part].to_lower()
	)

	if current_selection == -1 and allow_none:
		current_selection = 0
	elif current_selection >= 0 and allow_none:
		current_selection += 1

	section.setup(title, option_names, current_selection, can_color)
	section.has_none_option = allow_none

	section.option_selected.connect(
		func(index: int):
			var adjusted_index = allow_none_offset(index, allow_none)
			CustomizationManager.update_part(part, adjusted_index)
	)

	if can_color:
		section.color_changed.connect(
			func(color: Color): CustomizationManager.update_color(part, color)
		)

	sections[part] = section


func allow_none_offset(index: int, allow_none: bool) -> int:
	if not allow_none:
		return index

	if index == 0:
		return -1

	return index - 1


func _on_random_pressed() -> void:
	CustomizationManager.randomize_character()
	_update_ui_from_data()


func _on_reset_pressed() -> void:
	CustomizationManager.reset_character()
	_update_ui_from_data()


func _update_ui_from_data() -> void:
	for part in sections:
		var section = sections[part]
		var current_value = CustomizationManager.character_data.get(
			"selected_" + CharacterData.BodyPart.keys()[part].to_lower()
		)
		var current_color = CustomizationManager.character_data.get(
			CharacterData.BodyPart.keys()[part].to_lower() + "_color"
		)
		if current_value != null:
			var display_value = current_value
			if current_value == -1 and section.has_none_option:
				display_value = 0
			elif current_value >= 0 and section.has_none_option:
				display_value += 1

			if display_value >= 0:
				section.update_selection(display_value)

		if current_color != null:
			section.update_color(current_color)
