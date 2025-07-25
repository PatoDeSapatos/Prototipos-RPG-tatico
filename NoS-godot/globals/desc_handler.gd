class_name DescHandler extends Resource

static func format_text_colors(text: String) -> String:
	var colors = preload("res://resources/words_and_colors.json")
	var parsed_text = text.split(" ")
	
	# Add collor
	for i in parsed_text.size():
		var punctuation = ""
		var word = ""
		
		for l in parsed_text[i]:
			if (l.to_lower() in "abdcefghijklmnopqrstuvwxyzçãâõôáóíà"):
				word += l
			else:
				punctuation += l
		
		var color_code = colors.data.get(word.to_lower())
		
		if (color_code != null):
			var rgb = color_code.split(", ")
			var color = Color(float(rgb[0])/255, float(rgb[1])/255, float(rgb[2])/255)
			parsed_text[i] = "[color=#%s]%s[/color]%s" % [color.to_html(), word, punctuation]
	
	return " ".join(parsed_text)
