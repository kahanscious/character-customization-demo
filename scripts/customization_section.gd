class_name CustomizationSection extends VBoxContainer

signal option_selected(index: int)
signal color_changed(color: Color)

@onready var title_label: Label = $TitleLabel
@onready var option_button: OptionButton = $OptionButton
@onready var color_grid: GridContainer = $MarginContainer/ColorGrid

const OUTFIT_COLORS := [
	Color(0.2, 0.4, 0.8),  # Blue - good base for tinting
	Color(0.8, 0.2, 0.2),  # Red - vibrant but not overwhelming
	Color(0.2, 0.8, 0.2),  # Green - natural looking
	Color(0.8, 0.8, 0.2),  # Yellow - good for accent colors
	Color(0.8, 0.4, 0.8),  # Purple - royal tones
	Color(0.2, 0.2, 0.2),  # Black - for dark outfits
	Color(1.0, 1.0, 1.0),  # White - maximum tinting flexibility
]

var has_none_option: bool = false
var current_color: Color


func setup(
	title: String, options: Array, initial_selection: int = 0, show_color: bool = false
) -> void:
	title_label.text = title
	option_button.item_selected.connect(_on_option_selected)

	if options.is_empty():
		option_button.visible = false
	else:
		option_button.clear()
		for option in options:
			option_button.add_item(option)

		if initial_selection >= 0:
			option_button.selected = initial_selection + (1 if has_none_option else 0)

	if show_color:
		_setup_color_swatches()
	else:
		color_grid.visible = false


func _setup_color_swatches() -> void:
	for color in OUTFIT_COLORS:
		var button := Button.new()
		button.custom_minimum_size = Vector2(30, 30)

		var normal_style = _create_color_stylebox(color)
		var hover_style = _create_color_stylebox(color, true)

		button.add_theme_stylebox_override("normal", normal_style)
		button.add_theme_stylebox_override("hover", hover_style)

		button.pressed.connect(_create_color_pressed_callback(color))

		color_grid.add_child(button)


func _create_color_stylebox(color: Color, is_hover: bool = false) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 15
	style.corner_radius_top_right = 15
	style.corner_radius_bottom_left = 15
	style.corner_radius_bottom_right = 15

	if is_hover:
		style.border_width_left = 2
		style.border_width_right = 2
		style.border_width_top = 2
		style.border_width_bottom = 2
		style.border_color = Color.WHITE

	return style


func _create_color_pressed_callback(color: Color) -> Callable:
	return func(): color_changed.emit(color)


func _on_option_selected(index: int) -> void:
	option_selected.emit(index)


func update_selection(index: int) -> void:
	if index >= 0 and index < option_button.item_count:
		option_button.selected = index


func update_color(new_color: Color) -> void:
	current_color = new_color
	_update_selected_color_visuals()


func _update_selected_color_visuals() -> void:
	for button in color_grid.get_children():
		var style: StyleBoxFlat = button.get_theme_stylebox("normal")
		var is_selected = style.bg_color == current_color
		var hover_style = _create_color_stylebox(style.bg_color, is_selected)
		var normal_style = _create_color_stylebox(style.bg_color, is_selected)
		button.add_theme_stylebox_override("normal", normal_style)
		button.add_theme_stylebox_override("hover", hover_style)
		button.add_theme_stylebox_override("pressed", hover_style)
