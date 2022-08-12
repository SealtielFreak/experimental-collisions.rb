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

def rand_except(range, except = 0)
  loop do
    n = rand range
    return n if n != except
  end
end

class Box < Square
  attr_accessor :speed_x, :speed_y

  def initialize
    super
    self.size = rand(1..5)
    self.x = rand(0..Window.width - @size)
    self.y = rand(0..Window.height - @size)
    self.color = 'random'
    @speed_x = rand_except(-5.0..5.0)
    @speed_y = rand_except(-5.0..5.0)
  end

  def move(goal_x, goal_y)
    self.x += goal_x
    self.y += goal_y
  end

  def update(boxes_arr)
    boxes = boxes_arr.clone
    boxes -= Array(self)

=begin
    Old resolution collision
  
    # Correction Axis Y
    move(0, @speed_y)
    boxes.each do |box|
      if include? box
        if @speed_y > 0
          self.y = box.y - self.size
        elsif @speed_y < 0
          self.y = box.y + box.size
        end
        @speed_y, box.speed_y = box.speed_y, @speed_y
      end
    end

    # Correction Axis X
    move(@speed_x, 0)
    boxes.each do |box|
      if self.include? box
        if @speed_x > 0
          self.x = box.x - self.size
        elsif @speed_x < 0
          self.x = box.x + box.size
        end
        @speed_x, box.speed_x = box.speed_x, @speed_x
      end
    end

=end

    move(@speed_x, @speed_y)
    boxes.each do |box|
      
      if include? box
        if @speed_y > 0
          self.y = box.y - self.size
        elsif @speed_y < 0
          self.y = box.y + box.size
        end
        
        if @speed_x > 0
          self.x = box.x - self.size
        elsif @speed_x < 0
          self.x = box.x + box.size
        end

        @speed_x, box.speed_x = box.speed_x, @speed_x
        @speed_y, box.speed_y = box.speed_y, @speed_y
      end

    end

    if self.x + @size > Window.width || self.x < 0
      @speed_x *= -1
      if self.x + @size > Window.width
        self.x = Window.width - self.size
      else
        self.x = 0
      end
    end

    if self.y + @size > Window.height || self.y < 0
      @speed_y *= -1
      if self.y + @size > Window.height
        self.y = Window.height - self.size
      else
        self.y = 0
      end
    end
  end

  def resolve_collision(box)
    if @speed_x > 0
      self.x = box.x + @size
    elsif @speed_x < 0
      self.x = box.x + box.size
    end
  end

  def include?(box)
    x = self.x
    y = self.y
    size = self.size
    x + size > box.x and x < box.x + box.size and y + size > box.y and y < box.y + box.size
  end
end