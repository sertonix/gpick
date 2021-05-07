local gpick = require('gpick')
local color = require('gpick/color')
local helpers = require('helpers')
local _ = gpick._
local round = helpers.round
local clamp = helpers.clamp
local format = helpers.format
local split = helpers.split
local options = require('options')
local serializeWebHex = function(colorObject)
	if not colorObject then return nil end
	local c = colorObject:getColor()
	if options.upperCase then
		return '#' .. string.format('%02X%02X%02X', round(c:red() * 255), round(c:green() * 255), round(c:blue() * 255))
	else
		return '#' .. string.format('%02x%02x%02x', round(c:red() * 255), round(c:green() * 255), round(c:blue() * 255))
	end
end
local deserializeWebHex = function(text, colorObject)
	local c = color:new()
	local findStart, findEnd, red, green, blue = string.find(text, '#([%x][%x])([%x][%x])([%x][%x])[^%x]?')
	if findStart ~= nil then
		red = tonumber(red, 16)
		green = tonumber(green, 16)
		blue = tonumber(blue, 16)
		c:red(red / 255)
		c:green(green / 255)
		c:blue(blue / 255)
		colorObject:setColor(c)
		return 1 - (math.atan(findStart - 1) / math.pi) - (math.atan(string.len(text) - findEnd) / math.pi)
	else
		return -1
	end
end
local serializeWebHexNoHash = function(colorObject)
	if not colorObject then return nil end
	local c = colorObject:getColor()
	if options.upperCase then
		return string.format('%02X%02X%02X', round(c:red() * 255), round(c:green() * 255), round(c:blue() * 255))
	else
		return string.format('%02x%02x%02x', round(c:red() * 255), round(c:green() * 255), round(c:blue() * 255))
	end
end
local deserializeWebHexNoHash = function(text, colorObject)
	local c = color:new()
	local findStart, findEnd, red, green, blue = string.find(text, '([%x][%x])([%x][%x])([%x][%x])[^%x]?')
	if findStart ~= nil then
		red = tonumber(red, 16)
		green = tonumber(green, 16)
		blue = tonumber(blue, 16)
		c:red(red / 255)
		c:green(green / 255)
		c:blue(blue / 255)
		colorObject:setColor(c)
		return 1 - (math.atan(findStart - 1) / math.pi) - (math.atan(string.len(text) - findEnd) / math.pi)
	else
		return -1
	end
end
local serializeWebHex3Digit = function(colorObject)
	if not colorObject then return nil end
	local c = colorObject:getColor()
	if options.upperCase then
		return '#' .. string.format('%01X%01X%01X', round(c:red() * 15), round(c:green() * 15), round(c:blue() * 15))
	else
		return '#' .. string.format('%01x%01x%01x', round(c:red() * 15), round(c:green() * 15), round(c:blue() * 15))
	end
end
local deserializeWebHex3Digit = function(text, colorObject)
	local c = color:new()
	local findStart, findEnd, red, green, blue = string.find(text, '#([%x])([%x])([%x])[^%x]?')
	if findStart ~= nil then
		red = tonumber(red, 16)
		green = tonumber(green, 16)
		blue = tonumber(blue, 16)
		c:red(red / 15)
		c:green(green / 15)
		c:blue(blue / 15)
		colorObject:setColor(c)
		return 1 - (math.atan(findStart - 1) / math.pi) - (math.atan(string.len(text) - findEnd) / math.pi)
	else
		return -1
	end
end
local serializeCssHsl = function(colorObject)
	local c = colorObject:getColor()
	c = c:rgbToHsl()
	return 'hsl(' .. string.format('%d, %d%%, %d%%', round(c:hue() * 360), round(c:saturation() * 100), round(c:lightness() * 100)) .. ')'
end
local serializeCssRgb = function(colorObject)
	local c = colorObject:getColor()
	return 'rgb(' .. string.format('%d, %d, %d', round(c:red() * 255), round(c:green() * 255), round(c:blue() * 255)) .. ')'
end
local serializeColorCssBlock = function(colorObject, position)
	if not colorObject then return nil end
	local c = colorObject:getColor()
	local hsl = c:rgbToHsl()
	local result = '';
	if position.first then
		result = '/**\n * Generated by Gpick ' .. gpick.version .. '\n'
	end
	local name = colorObject:getName()
	if not name then
		name = ''
	end
	result = result .. ' * ' .. name .. ': '
	if options.upperCase then
		result = result .. '#' .. string.format('%02X%02X%02X', round(c:red() * 255), round(c:green() * 255), round(c:blue() * 255))
	else
		result = result .. '#' .. string.format('%02x%02x%02x', round(c:red() * 255), round(c:green() * 255), round(c:blue() * 255))
	end
	result = result .. ', rgb(' .. string.format('%d, %d, %d', round(c:red() * 255), round(c:green() * 255), round(c:blue() * 255)) .. '), hsl(' .. string.format('%d, %d%%, %d%%', round(c:hue() * 360), round(c:saturation() * 100), round(c:lightness() * 100)) .. ')'
	if position.last then
		result = result .. '\n */'
	end
	return result
end
local deserializeCssRgb = function(text, colorObject)
	local c = color:new()
	local findStart, findEnd, red, green, blue = string.find(text, 'rgb%(([%d]*)[%s]*,[%s]*([%d]*)[%s]*,[%s]*([%d]*)%)')
	if findStart ~= nil then
		c:rgb(math.min(1, red / 255), math.min(1, green / 255), math.min(1, blue / 255))
		colorObject:setColor(c)
		return 1 - (math.atan(findStart - 1) / math.pi) - (math.atan(string.len(text) - findEnd) / math.pi)
	else
		return -1
	end
end
local serializeCssColorHex = function(colorObject)
	return 'color: ' .. serializeWebHex(colorObject)
end
local serializeCssBackgroundColorHex = function(colorObject)
	return 'background-color: ' .. serializeWebHex(colorObject)
end
local serializeCssBorderColorHex = function(colorObject)
	return 'border-color: ' .. serializeWebHex(colorObject)
end
local serializeCssBorderTopColorHex = function(colorObject)
	return 'border-top-color: ' .. serializeWebHex(colorObject)
end
local serializeCssBorderRightColorHex = function(colorObject)
	return 'border-right-color: ' .. serializeWebHex(colorObject)
end
local serializeCssBorderBottomColorHex = function(colorObject)
	return 'border-bottom-color: ' .. serializeWebHex(colorObject)
end
local serializeCssBorderLeftHex = function(colorObject)
	return 'border-left-color: ' .. serializeWebHex(colorObject)
end
local serializeCsvRgb = function(colorObject)
	local c = colorObject:getColor()
	return format('%f,%f,%f', c:red(), c:green(), c:blue())
end
local serializeCsvRgbTab = function(colorObject)
	local c = colorObject:getColor()
	return format('%f\t%f\t%f', c:red(), c:green(), c:blue())
end
local serializeCsvRgbSemicolon = function(colorObject)
	local c = colorObject:getColor()
	return format('%f;%f;%f', c:red(), c:green(), c:blue())
end
local serializeValueRgb = function(colorObject)
	local c = colorObject:getColor()
	return format('%f, %f, %f', c:red(), c:green(), c:blue())
end
local deserializeValueRgb = function(text, colorObject)
	local findStart, findEnd, values = split(text, '%.?%d+%.?%d*', '[,;\t]+', 3)
	if findStart ~= nil then
		clamp(values, 0, 1)
		local c = color:new()
		c:rgb(table.unpack(values))
		colorObject:setColor(c)
		return 1 - (math.atan(findStart - 1) / math.pi) - (math.atan(string.len(text) - findEnd) / math.pi)
	else
		return -1
	end
end
gpick:addConverter('color_web_hex', _("Web: hex code"), serializeWebHex, deserializeWebHex)
gpick:addConverter('color_web_hex_3_digit', _("Web: hex code (3 digits)"), serializeWebHex3Digit, deserializeWebHex3Digit)
gpick:addConverter('color_web_hex_no_hash', _("Web: hex code (no hash symbol)"), serializeWebHexNoHash, deserializeWebHexNoHash)
gpick:addConverter('color_css_hsl', _("CSS: hue saturation lightness"), serializeCssHsl)
gpick:addConverter('color_css_rgb', _("CSS: red green blue"), serializeCssRgb, deserializeCssRgb)
gpick:addConverter('css_color_hex', 'CSS(color)', serializeCssColorHex)
gpick:addConverter('css_background_color_hex', 'CSS(background-color)', serializeCssBackgroundColorHex)
gpick:addConverter('css_border_color_hex', 'CSS(border-color)', serializeCssBorderColorHex)
gpick:addConverter('css_border_top_color_hex', 'CSS(border-top-color)', serializeCssBorderTopColorHex)
gpick:addConverter('css_border_right_color_hex', 'CSS(border-right-color)', serializeCssBorderRightColorHex)
gpick:addConverter('css_border_bottom_color_hex', 'CSS(border-bottom-color)', serializeCssBorderBottomColorHex)
gpick:addConverter('css_border_left_hex', 'CSS(border-left-color)', serializeCssBorderLeftHex)
gpick:addConverter('csv_rgb', 'CSV RGB', serializeCsvRgb, deserializeValueRgb)
gpick:addConverter('csv_rgb_tab', 'CSV RGB ' .. _'(tab separator)', serializeCsvRgbTab, deserializeValueRgb)
gpick:addConverter('csv_rgb_semicolon', 'CSV RGB ' .. _'(semicolon separator)', serializeCsvRgbSemicolon, deserializeValueRgb)
gpick:addConverter('color_css_block', 'CSS block', serializeColorCssBlock)
gpick:addConverter('value_rgb', _('RGB values'), serializeValueRgb, deserializeValueRgb)
return {}
