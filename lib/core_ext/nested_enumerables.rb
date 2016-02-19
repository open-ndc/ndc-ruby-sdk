# Included from https://github.com/chengguangnan/vine to avoid dependency

module Enumerable

  def segmentation(n)
    0.upto(size - 2).to_a.combination(n - 1).to_a.map do |s|
      [-1, * s, size - 1].each_cons(2).map {|i, j| self[(i + 1)..j] }
    end
  end

end

class String

  def is_number?
    true if Float(self) rescue false
  end

end


class Hash

  def access(path)
    value = self
    path.to_s.split('/').each do |p|
      if p.to_i.to_s == p
        value = value[p.to_i]
      else
        value = value[p].nil? ? value[p.to_sym] : value[p]
      end
      break if value.nil?
    end
    value
  end

  def access?(path)
    hash = self
    keys = path.to_s.split('/')
    keys.each_with_index do |k, i|
      if k.is_number?
        hash = hash[k.to_i]
      else
        k = k.to_sym
        if i == keys.size - 1
          hash = hash.has_key?(k)
        else
          hash = hash[k]
        end
      end
      break if hash.is_a?(TrueClass) || hash.is_a?(FalseClass) || !hash.is_a?(Hash)
    end

    hash == true
  end

  alias :hpath :access
  alias :hpath? :access?

end
