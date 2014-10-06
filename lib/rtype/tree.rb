require 'rtype/typeenv'

module RType::Tree
  # literals

  class Int
    def initialize(val)
      @val = val
    end

    attr_reader :val

    def type(env)
      RType::IntType
    end
  end

  class Bool
    def initialize(val)
      @val = val
    end

    attr_reader :val

    def type(env)
      RType::BoolType
    end
  end

  class Var
    def initialize(name)
      @name = name
    end

    attr_reader :name

    def type(env)
      env[@name]
    end
  end

  # syntaxs

  # if `cnd` then `thn` else `els`
  class If
    def initialize(cnd, thn, els)
      @cnd = cnd
      @thn = thn
      @els = els
    end

    attr_reader :cnd, :thn, :els

    def type(env)
      env.unify @cnd.type(env), BoolType
      env.unify @thn.type(env), @els.type(env)
    end
  end

  # let `name` = `val` in `expr`
  class Let
    def initialize(name, val, expr)
      @name = name
      @val = val
      @expr = expr
    end

    attr_reader :name, :val, :expr

    def type(env)
      env2 = env.new

      tvar = env2[@name] = env2.make_type_var
      env2.unify tvar, @val.type(env2)

      @expr.type env2
    end
  end

  # fun `arg` -> `expr`
  class Fun
    def initialize(arg, expr)
      @arg = arg
      @expr = expr
    end

    attr_reader :arg, :expr

    def type(env)
      env2 = env.new

      tvar = env2[@arg] = env2.make_type_var
      RType::FunType.new tvar, @expr.type(env2)
    end
  end

  # `f` `arg`
  class App
    def initialize(f, arg)
      @f = f
      @arg = arg
    end

    attr_reader :f, :arg

    def type(env)
      f_type = @f.type(env)
      arg_type = @arg.type(env)

      ret_type = env.make_type_var
      env.unify f_type, FunType.new(arg_type, ret_type)
      ret_type
    end
  end
end
