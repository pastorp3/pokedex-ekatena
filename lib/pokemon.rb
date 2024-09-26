class Pokemon
  attr_reader :name, :number, :types, :skill, :stats

  def initialize(name:, number:, types:, skill:, stats:)
    @name = name
    @number = number
    @types = types.join(', ')
    @skill = skill
    @stats = stats
  end
end