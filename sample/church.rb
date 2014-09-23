require 'rtype'

include RType
include RType::Tree

env = TypeEnv.new

zero = Fun.new(:s, Fun.new(:z, Var.new(:z)))
succ = Fun.new(:n, Fun.new(:s, Fun.new(:z, App.new(Var.new(:s), App.new(App.new(Var.new(:n), Var.new(:s)), Var.new(:z))))))
one = Fun.new(:s, Fun.new(:z, App.new(Var.new(:s), Var.new(:z))))

puts zero.type(env)
puts succ.type(env)
puts one.type(env)
