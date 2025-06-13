function approach(val1, val2, amount) {
    if (val1 < val2) {
        return min(val1 + amount, val2);
    } else {
        return max(val1 - amount, val2);
    }
}

function string_is_real(_string) {
	var s = _string;
	var n = string_length(string_digits(s));
	return n > 0 && n == string_length(s) - (string_ord_at(s, 1) == ord("-")) - (string_pos(".", s) != 0);
}