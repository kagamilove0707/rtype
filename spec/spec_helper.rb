$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rtype'

include RType
include RType::Tree

def type_match(a, b)
  env = TypeEnv.new
  env.unify a.type(env), b
end
