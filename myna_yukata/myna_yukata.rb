include_theme("yoku0825")

proc_name = "mynagirl-background-image"

### Static draw
@slide_background_image  = "myna_yukata_left_rev.png"
include_theme("slide-background-image")

### Dynamic draw
#@slide_background_image  = "myna.png"
#match(Slide) do |slides|
#  loader = ImageLoader.new(find_file(@slide_background_image))
#  resized = false
#
#  slides.delete_pre_draw_proc_by_name(proc_name)
#
#  slides.add_pre_draw_proc(proc_name) do |slide, canvas, x, y, w, h, simulation|
#    unless simulation
#      unless loader.nil?
#        unless resized
#          loader.resize(nil, canvas.height * 0.9)
#          resized = true
#        end
#        loader.draw(canvas, canvas.width * 0.5, canvas.height * 0.07)
#      end
#    end
#    [x, y, w, h]
#  end
#end
