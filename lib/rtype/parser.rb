require 'parslet'
require 'rtype/tree'

module RType

  class Parser < Parslet::Parser
    rule(:empty) { str("") }
    rule(:space) { match['\\s'].repeat(1) }
    rule(:space?) { space.maybe }

    def word w
      str(w) >> match['a-zA-Z0-9_'].absent? >> space?
    end
    RESERVED_WORDS = %w(if then else let in fun true false)
    rule(:keyword_if) { word("if") >> space? }
    rule(:keyword_then) { word("then") >> space? }
    rule(:keyword_else) { word("else") >> space? }
    rule(:keyword_let) { word("let") >> space? }
    rule(:keyword_in) { word("in") >> space? }
    rule(:keyword_fun) { word("fun") >> space? }

    rule(:lparen) { str("(") >> space? }
    rule(:rparen) { str(")") >> space? }
    rule(:arrow) { str("->") >> space? }
    rule(:assign) { str("=") >> space? }

    rule(:int) { match["0-9"].repeat(1).as(:int) >> space? }

    rule(:var) {
      RESERVED_WORDS.reduce(empty){|p, w| p >> word(w).absent? } >>
      (match["a-zA-Z_"] >> match["a-zA-Z0-9_"].repeat).as(:var) >> space?
    }
    rule(:bool) { (word("true") | word("false")).as(:bool) >> space? }

    rule(:if_expr) {
      keyword_if >> expr.as(:cond) >>
        keyword_then >> expr.as(:then) >>
        keyword_else >> expr.as(:else)
    }

    rule(:let_expr) {
      keyword_let >> var >> assign >> expr.as(:val) >>
        keyword_in >> expr.as(:expr)
    }

    rule(:fun_expr) {
      keyword_fun >> var.repeat(1).as(:args) >> arrow >> expr.as(:expr)
    }

    rule(:app_expr) {
      value.as(:f) >> value.repeat(1).as(:args)
    }

    rule(:value) {
      lparen >> value >> rparen |
      bool | int | var
    }

    rule(:expr) {
      if_expr.as(:if) |
      let_expr.as(:let) |
      fun_expr.as(:fun) |
      app_expr.as(:app) |
      value
    }

    root :expr
  end

  class Transform < Parslet::Transform
    rule(int: simple(:val)) { Tree::Int.new val.to_i }
    rule(bool: simple(:val)) { Tree::Bool.new val == "true" }
    rule(var: simple(:name)) { Tree::Var.new name.to_sym }

    rule(if: {cond: simple(:cond), then: simple(:thn), else: simple(:els)}) {
      Tree::If.new cond, thn, els
    }
    rule(let: {var: simple(:name), val: simple(:val), expr: simple(:expr)}) {
      Tree::Let.new name.to_sym, val, expr
    }
    rule(fun: {args: sequence(:args), expr: simple(:expr)}) {
      args.reverse.reduce(expr) {|e, arg| Tree::Fun.new arg.name, e }
    }
    rule(app: {f: simple(:f), args: sequence(:args)}) {
      f = Tree::App.new f, args.shift
      args.reduce(f) {|f, arg| Tree::App.new f, arg }
    }
  end
end
