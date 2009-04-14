class Array
  def recursively(&block)
    map do |item|
      if item.is_a?(self.class)
        item.recursively(&block)
      else
        yield item
      end
    end
  end
  
  def recursively!(&block)
    replace(recursively(&block))
  end
end

class Hash
  def recursively(&block)
    inject({}) do |hash, (key, value)|
      if value.is_a?(Hash)
        hash[key] = value.recursively(&block)
      else
        hash[key] = value
      end
      yield hash
    end
  end
  
  def recursively!(&block)
    replace(recursively(&block))
  end
end
