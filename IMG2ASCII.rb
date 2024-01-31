# -*- Author: Ali -*-
# -*- Info:  -*-
# Description: This Ruby script converts an image to ASCII art using the ChunkyPNG library.
#              It takes an image file path as a command-line argument and generates a text file
#              containing the ASCII representation of the image.

require 'chunky_png'

# Define the characters to represent different pixel intensity levels
ASCII_PIXELS = "@%#*+=-:. "

# Function to map pixel value to ASCII character
def pixel_to_ascii(pixel_value)
  index = (pixel_value * (ASCII_PIXELS.length - 1) / 255).to_i
  ASCII_PIXELS[index]
end

# Function to convert an image to ASCII art
def convert_to_ascii(image_path)
  image = ChunkyPNG::Image.from_file(image_path)
  
  width = image.width
  height = image.height
  
  ascii_art = []
  
  height.times do |y|
    row = ""
    width.times do |x|
      pixel = image[x, y]
      luminance = (0.3 * ChunkyPNG::Color.r(pixel) + 0.59 * ChunkyPNG::Color.g(pixel) + 0.11 * ChunkyPNG::Color.b(pixel)).to_i
      row += pixel_to_ascii(luminance)
    end
    ascii_art << row
  end
  
  ascii_art.join("\n")
end

# Main program
if ARGV.length != 1
  puts "Usage: IMG2ASCII.rb <image_path>"
  exit 1
end

image_path = ARGV[0]
ascii_art = convert_to_ascii(image_path)

output_filename = "#{File.basename(image_path, ".*")}_ascii_art.txt"
File.open(output_filename, "w") do |file|
  file.puts ascii_art
end

puts "ASCII art saved to #{output_filename}"
