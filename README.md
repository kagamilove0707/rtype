# RType

Rubyで書いた、小さな型推論器なのですー＞ω＜

## インストール

Bundlerで作ったので多分、

```
$ git clone https://github.com/kagamilove0707/rtype.git && cd rtype
$ bundle console
```

で試せるのではないかと思いますです（・ω・）

## 使い方

`bundle console`して、

```irb
irb(main):001:0> include RType; include RType::Tree
=> Object
irb(main):002:0> env = TypeEnv.new
=> #<RType::TypeEnv:0x007f9dd5be5530 @parent={}, @var={}>
irb(main):003:0> id = Fun.new(:x, Var.new(:x)) # let id x = x
=> #<RType::Tree::Fun:0x007f9dd5b61730 @arg=:x, @expr=#<RType::Tree::Var:0x007f9dd5b617f8 @name=:x>>
irb(main):004:0> puts id.type(env) # 型推論なのですー＞ω＜
'a2 -> 'a2
=> nil
```

みたいな感じでどうでしょう（・・）？？

## こんとりびゅーてぃんぐ

1. フォークするのです！ ( https://github.com/[my-github-username]/rtype/fork )
2. ブランチを作るのです！ (`git checkout -b my-new-feature`)
3. 変更して、それをコミットするのです！ (`git commit -am 'Add some feature'`)
4. プッシュするのです！ (`git push origin my-new-feature`)
5. Pull Requestを作るのです！
