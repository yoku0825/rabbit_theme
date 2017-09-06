### Defaults are in base/base.rb.
@image_with_frame        = false
@image_slide_number_image= "dolphin.png"
@image_timer_image       = "gray_dolphin.png"
@font_family             = find_font_family("Meiryo")
@monospace_font_family   = find_font_family("MS Gothic")
@preformatted_fill_color = "black"
set_graffiti_color("red")

### Default font sizes are too large for me.
@xx_large_font_size= screen_size(7   * Pango::SCALE)
@x_large_font_size = screen_size(5.5 * Pango::SCALE)
@large_font_size   = screen_size(3.5 * Pango::SCALE)
@normal_font_size  = screen_size(3   * Pango::SCALE)
@small_font_size   = screen_size(2.5 * Pango::SCALE)
@x_small_font_size = screen_size(2   * Pango::SCALE)
@xx_small_font_size= screen_size(1   * Pango::SCALE)

### Default row-margin is too large for me..
@space = screen_y(0.1)

### Table's contents
@table_header_font_props[:size]= @x_small_font_size
@table_cell_font_props[:size]  = @x_small_font_size

### Flag's slide-number
@image_slide_number_font_size= @large_font_size

### For rabbiter
@footer_comment_props ||= {
  "size" => (@x_small_font_size).ceil,
  "font_family" => @font_family,
  "color" => "red",
  "shadow-color" => "red"
}

include_theme("blue-bar")

### Pager
@slide_number_uninstall= false
include_theme("slide-number")

### Timer
#@image_timer_limit        = 40 * 60 # second
@image_timer_auto_updating= true
@image_timer_interval     = 1
include_theme("image-timer")


### Text wrapping in codes.
### Thank you @ktou!!  https://gist.github.com/kou/ce6f6ad1cbc3b7cec267
@preformatted_keep_in_size = true
#@syntax_highlighting_keep_in_size = true

@preformatted_fill_color = "black"
match("**", PreformattedBlock) do |blocks|
  blocks.prop_set("size", @small_font_size)
  blocks.prop_set("foreground", "white")
  blocks.wrap_mode = :char
  blocks.margin_right = screen_x(7)
end

match("**", CustomTag) do |tags|
  find_outer_block = lambda do |tag|
    element = tag
    while element.inline_element?
      element = element.parent
    end
    element
  end

  find_target = lambda do |tag|
    if tag.elements.empty?
      tag.parent
    else
      tag
    end
  end

  find_handler = lambda do |tag|
    handler = @tag_handlers[tag.name]
    return handler if handler
    @tag_handlers.each do |key, value|
      return value if key === tag.name
    end
    nil
  end

  tags.each do |tag|
    case tag.name
    when "left"
      find_outer_block.call(tag).align = "left"
    when "center"
      find_outer_block.call(tag).horizontal_centering = true
    when "right"
      find_outer_block.call(tag).align = "right"
    when "small"
      find_target.call(tag).prop_set("size", @small_font_size)
    when "x-small"
      find_target.call(tag).prop_set("size", @x_small_font_size)
    when "xx-small"
      find_target.call(tag).prop_set("size", @xx_small_font_size)
    when "large"
      find_target.call(tag).prop_set("size", @large_font_size)
    when "x-large"
      find_target.call(tag).prop_set("size", @x_large_font_size)
    when "xx-large"
      find_target.call(tag).prop_set("size", @xx_large_font_size)
    when /\A(normal|oblique|italic)\z/
      find_target.call(tag).prop_set("style", $1)
    when /\A([^-]*)-color\z/
      find_target.call(tag).prop_set("foreground", $1)
    when /\Amargin-(top|bottom|left|right)(?:\s*\*\s*(\d+))?\z/
      target = "margin_#{$1}"
      scale = Integer($2 || 1)
      outer_block = find_outer_block.call(tag)
      current_value = outer_block.send(target)
      outer_block.send("#{target}=", current_value + (@space * scale))
    else
      handler = find_handler.call(tag)
      if handler
        handler.call(:target => find_target.call(tag),
                     :outer_block => find_outer_block.call(tag))
      end
    end
  end
end
