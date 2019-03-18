require 'set'

Point = Struct.new(:x, :y)

def neighbors(point)
  [
    [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, -1], [0, 1]
  ].map { |(dx, dy)| Point.new(point.x + dx, point.y + dy) }
end

def neighborhood(points)
  (points + points.flat_map { |point| neighbors(point) }).uniq
end

def alive?(points_alive, point)
  points_alive.include?(point)
end

def becomes_alive?(points_alive, point)
  neighbors_alive = neighbors(point).count { |neighbor| alive?(points_alive, neighbor) }

  neighbors_alive == 3 || (neighbors_alive == 2 && alive?(points_alive, point))
end

def game_step(points_alive)
  neighborhood(points_alive).select { |point| becomes_alive?(points_alive, point) }.to_set
end

points_alive = [
  [1, 1],
  [1, 2],
  [2, 2],
  [2, 1],

  [21, 19],
  [19, 19],
  [20, 19],
  [20, 20],
  [20, 21],
  [21, 21],
  [22, 21],
].map { |(x, y)| Point.new(x, y) }

def print_map(points_alive, frame_number)
  system('clear')
  puts "Frame ##{frame_number}, alive: #{points_alive.size}"
  (0...45).each do |x|
    (0...45).each do |y|
      point = Point.new(x, y)

      print alive?(points_alive, point) ? '#' : ' '
    end
    puts
  end
end

100.times do |i|
  print_map(points_alive, i)
  points_alive = game_step(points_alive)
  sleep 1
end
