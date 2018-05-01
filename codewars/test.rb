module Test
  def self.expect(expression, message)
    raise message unless expression
    puts "PASS #{message}"
  end
end
