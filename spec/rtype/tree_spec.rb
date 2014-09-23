require 'spec_helper'

describe RType::TypeEnv do
  it "literals" do
    type_match(Int.new(1), IntType)
    type_match(Bool.new(true), BoolType)
  end

  it "if" do
    type_match(If.new(Bool.new(true), Int.new(1), Int.new(2)), IntType)
    expect {
      type_match(If.new(Int.new(1), Int.new(2), Int.new(3)), IntType)
    }.to raise_error(NotUnifyError)
  end

  it "let" do
    type_match(Let.new(:x, Var.new(:x), Var.new(:x)), TypeVar.new(:a))
    type_match(Let.new(:x, Int.new(1), Var.new(:x)), IntType)
  end

  it "fun" do
    type_match(Fun.new(:x, Var.new(:x)), FunType.new(TypeVar.new(:a), TypeVar.new(:a)))
    type_match(Fun.new(:x, Fun.new(:y, Var.new(:x))), FunType.new(TypeVar.new(:a), FunType.new(TypeVar.new(:b), TypeVar.new(:a))))
  end

  it "app" do
    type_match(App.new(Fun.new(:x, Var.new(:x)), Int.new(1)), IntType)

    fun = Fun.new(:x, If.new(Var.new(:x), Int.new(1), Int.new(2)))
    type_match(App.new(fun, Bool.new(true)), IntType)
    expect {
      type_match(App.new(fun, Int.new(1)), BoolType)
    }.to raise_error(NotUnifyError)
  end
end
