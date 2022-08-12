=begin

  MIT License

  Copyright (c) 2021 Diego Sealtiel Valderrama García

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

=end

require_relative 'config'
require_relative 'quadtree'
require_relative 'box'

set title: "Object collision with optimization. Boxes: #{@amount}, Cell size: #{@cell_size}"

@boxes = Array.new(@amount) { Box.new }
@tree = QuadTree.new(@cell_size)

update do

  @boxes.each do |box|
    box.remove unless @tree.insert box
  end

  @tree.each do |boxes|
    boxes&.each do |box|
      box.update boxes
    end
  end

  Information.text = "FPS: #{(get :fps).to_i}, Cache size: #{@tree.size}"
  @tree.clear
end


show


