require 'rtype/tree'

module RType
  
  # 型(eg. int, bool...)
  class Type
    def initialize(name)
      @name = name
    end

    attr_reader :name

    def to_s
      "#{@name}"
    end

    def ==(other)
      self.equal? other
    end

    def type
      self
    end
  end

  BoolType = Type.new :bool
  IntType = Type.new :int

  # 型変数 (eg. 'a, 'b...)
  class TypeVar
    def initialize(name, type = self)
      @name = name
      @type = type
    end

    attr_reader :name
    attr_accessor :type

    def to_s
      @type == self ? "'#{@name}" : @type.to_s
    end

    def ==(other)
      self.equal? other
    end
  end

  # 関数の型(eg. 'a -> 'b, int -> bool)
  class FunType
    def initialize(arg_type, ret_type)
      @arg_type = arg_type
      @ret_type = ret_type
    end

    attr_accessor :arg_type, :ret_type

    def to_s
      arg_str = @arg_type.to_s
      if FunType === @arg_type.type
        arg_str = "(#{arg_str})"
      end
      "#{arg_str} -> #{@ret_type}"
    end

    def type
      self
    end

    def include_var?(var)
      [@arg_type, @ret_type].any? do |type|
        type = type.type
        if TypeVar === type
          var == type
        else
          type.include_var? var if type.respond_to? :include_var?
        end
      end
    end
  end


  # 型環境
  class TypeEnv
    @@tvarcount = 0

    def initialize(parent = nil)
      @parent = parent || {}
      @var = {}
    end

    def [](name)
      ret = @var[name] || @parent[name]
      raise NotDefinedError, "#{name} is not defined" unless ret
      ret
    end

    def []=(name, val)
      @var[name] = val
      val
    end

    def new
      TypeEnv.new self
    end

    def make_type_var
      @@tvarcount += 1
      TypeVar.new :"a#{@@tvarcount}"
    end

    def unify(a, b)
      a = a.type
      b = b.type
      case a
      when Type
        case b
        when Type
          raise NotUnifyError, "#{a} can't unify with #{b}" unless a.equal? b
          a
        when TypeVar
          b.type = a
          a
        else
          raise NotUnifyError, "#{a} can't unify with #{b}"
        end
      when TypeVar
        raise NotUnifyError, "#{a} can't unify with #{b}" if b.respond_to?(:include_var?) && b.include_var?(a)
        a.type = b
        b
      when FunType
        case b
        when TypeVar
          raise NotUnifyError, "#{a} can't unify with #{b}" if a.include_var?(b)
          b.type = a
        when FunType
          unify a.arg_type, b.arg_type
          unify a.ret_type, b.ret_type
        else
          raise NotUnifyError, "#{a} can't unify with #{b}"
        end
      end
    end
  end

  # 諸エラー

  class NotDefinedError < StandardError; end
  class NotUnifyError < StandardError; end
end
