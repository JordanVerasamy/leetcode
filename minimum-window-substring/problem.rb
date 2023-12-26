# @param {String} s
# @param {String} t
# @return {String}

def min_window(s, t)
  Problem.new(s, t).solve
end

class ProgressHash
  attr_accessor :hash, :num_not_satisfied

  def initialize(t)
    @hash = Hash.new
    t.each_char do |char|
      hash[char] ||= 0
      hash[char] -= 1
    end
    @num_not_satisfied = hash.keys.count
    hash
  end

  def insert(char)
    return unless hash.key?(char)

    hash[char] += 1
    if hash[char] == 0
      # puts "satisfied!"
      @num_not_satisfied -= 1
    end
  end

  def remove(char)
    return unless hash.key?(char)

    hash[char] -= 1
    # puts "removed #{char}"
    # puts hash
    if hash[char] == -1
      # puts "unsatisfied!"
      @num_not_satisfied += 1
    end
  end

  def values
    hash.values
  end

  def to_s
    hash.to_s
  end

  def done?
    @num_not_satisfied == 0
  end

  def shortest_string_so_far
    @shortest_string_so_far ||= s
  end

  def [](*args)
    hash.[](*args)
  end
end

class Problem
  attr_accessor :s, :t

  def initialize(s, t)
    @s = s
    @t = t
  end

  def hash
    @hash ||= ProgressHash.new(t)
  end

  def initial_interval
    left_endpoint = 0
    right_endpoint = 0

    hash.insert(s[0])

    while !have_all_needed_chars?
      right_endpoint += 1
      return -1, -1 if right_endpoint > s.length - 1

      char = s[right_endpoint]
      hash.insert(char)
    end

    return left_endpoint, right_endpoint
  end

  def have_all_needed_chars?
    hash.done?
  end

  def solve
    left, right = initial_interval

    # puts "initial interval is #{s[left..right]}"

    return "" if left == right and left == -1

    shortest_string_so_far = s[left..right]

    while right != s.length - 1
      hash.remove(s[left])
      left += 1

      # puts "inched left forward: looking at #{s[left..right]}"

      # puts "#{left} #{right}"

      if s[left..right].length < shortest_string_so_far.length
        if have_all_needed_chars?
          shortest_string_so_far = s[left..right]
        end
      end

      while !have_all_needed_chars?
        if right >= s.length - 1
          # puts "can't inch any more, so abort. #{s[left..right]}"
          return shortest_string_so_far
        end
        right += 1

        # puts "inched right forward: looking at #{s[left..right]}"

        char = s[right]
        hash.insert(char)
        if s[left..right].length < shortest_string_so_far.length
          if have_all_needed_chars?
            shortest_string_so_far = s[left..right]
          end
        end
      end
    end

    loop do
      # puts "trimming the left bits off of our last candidate #{s[left..right]}"
      break if hash[s[left]] == 0
      break if left >= right

      hash.remove(s[left])
      left += 1
    end

    if s[left..right].length < shortest_string_so_far.length
      if have_all_needed_chars?
        shortest_string_so_far = s[left..right]
      end
    end

    # puts "final output: #{shortest_string_so_far}"

    shortest_string_so_far
  end
end

# puts min_window("ADOBECODEBANC", "ABC")
# puts min_window("a", "a")
# puts min_window("a", "aa")
# puts min_window("ab", "a")
# puts min_window("abc", "a")
# puts min_window("abc", "b")
puts min_window("abcabdebac", "cda") # should be cabd
