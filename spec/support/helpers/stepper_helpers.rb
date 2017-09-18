module Helpers
  def step(description)
    @__steps_taken ||= 0
    @__steps_taken += 1
    line = caller_locations(1, 1)[0].lineno

    puts "Step #{@__steps_taken}) ".colorize(
      color: :light_blue, background: :black
    ) + "#{description}:#{line}".colorize(
      color: :green, background: :black
    )

    yield if block_given?
  end
end
