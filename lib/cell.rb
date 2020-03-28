class Cell

  attr_accessor :content

  def initialize(content:)
    @content = content
  end

  def to_s
    @content.to_s
  end

  def ==(other)
    if other.class == Cell
      content == other.content
    else
      return false
    end
  end
end
