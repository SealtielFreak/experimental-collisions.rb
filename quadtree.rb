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


AreaNode = Struct.new(:x, :y, :width, :height)

def area(x, y, w, h)
  AreaNode.new(x, y, w, h)
end

def include?(item, other)
  other.x + other.width > item.x and other.x < item.x + item.width and other.y + item.height > item.y and other.y < item.y + item.height
end

class QuadNode

  attr_accessor :top_left, :top_right, :bottom_left, :bottom_right
  attr_reader :x, :y, :width, :height, :points

  def initialize(x, y, w, h, limits_w, limits_h)
    @x = x
    @y = y
    @width = w
    @height = h
    @limits_w = limits_w.to_f
    @limits_h = limits_h.to_f
  end

  def insert(other)
    w = @width.to_f / 2
    h = @height.to_f / 2

    if w >= @limits_w and h >= @limits_h
      if include?(area(@x, @y, w, h), other)
        @top_left = QuadNode.new(@x, @y, w, h, @limits_w, @limits_h) if @top_left.nil?
        return @top_left.insert other
      elsif include?(area(@x + w, @y, w, h), other)
        @top_right = QuadNode.new(@x + w, @y, w, h, @limits_w, @limits_h) if @top_right.nil?
        return @top_right.insert other
      elsif include?(area(@x, @y + h, w, h), other)
        @bottom_left = QuadNode.new(@x, @y + h, w, h, @limits_w, @limits_h) if @bottom_left.nil?
        return @bottom_left.insert other
      elsif include?(area(@x + w, @y + h, w, h), other)
        @bottom_right = QuadNode.new(@x + w, @y + h, w, h, @limits_w, @limits_h) if @bottom_right.nil?
        return @bottom_right.insert other
      end
    end

    return insert_other other if include? self, other
  end

  def each(&block)
    @top_left&.each(&block)
    @top_right&.each(&block)
    @bottom_left&.each(&block)
    @bottom_right&.each(&block)
    block.call(@points) unless @points.nil?
  end

  def size
    count = 0
    count += @points.size unless @points.nil?
    count += @top_left&.size unless @top_left.nil?
    count += @top_right&.size unless @top_right.nil?
    count += @bottom_left&.size unless @bottom_left.nil?
    count += @bottom_right&.size unless @bottom_right.nil?
    count
  end

  private

  def insert_other(other)
    @points = [] if @points.nil?
    @points << other if @points.size < 16
    true
  end
end

class QuadTree
  def initialize(cells)
    @w_limit = cells
    @h_limit = cells

    reset
  end

  def insert(other)
    @root.insert other
  end

  alias << insert
  alias add insert

  def each(&block)
    @root.each(&block)
  end

  def size
    @root.size
  end

  def reset
    @root = nil
    @root = QuadNode.new(0, 0, Window.width, Window.height, @w_limit, @h_limit)
  end

  alias clear reset
end
