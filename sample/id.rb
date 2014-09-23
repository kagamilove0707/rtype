require 'rtype'

include RType
include RType::Tree

env = TypeEnv.new

id = Fun.new(:x, Var.new(:x))
app_int = App.new(id, Int.new(0))
app_id = App.new(id, id)

puts id.type(env).to_s
puts app_int.type(env).to_s
puts app_id.type(env).to_s
