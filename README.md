# RType

Rubyで書いた、小さな型推論器なのですー＞ω＜

## インストール

Bundlerで作ったので多分、

```
$ git clone https://github.com/kagamilove0707/rtype.git && cd rtype
$ rake install
```

で試せるのではないかと思いますです（・ω・）

## 使い方

`rake install`して、

```console
$ rtype
(rtype)| let id = fun x -> x in id 1
let id = fun x -> x in id 1 :: int
(rtype)| :{
(rtype)| let zero = fun z s -> z in
(rtype)| let succ = fun n z s -> s (n z s) in
(rtype)| succ zero
(rtype)| :}
let zero = fun z s -> z in
let succ = fun n z s -> s (n z s) in
succ zero
 :: 'a5 -> ('a5 -> 'a13) -> 'a13
(rtype)| :q
```

みたいな感じでどうでしょう（・・）？？

## TODO

重要課題！！

- [x] パーサーの作成
- [ ] 評価器の作成
- [ ] ドキュメントの作成

そんなに重要じゃないのです（・ω・）

- [ ] 型システムの拡張

## こんとりびゅーてぃんぐ

1. フォークするのです！ ( https://github.com/kagamilove0707/rtype/fork )
2. ブランチを作るのです！ (`git checkout -b my-new-feature`)
3. 変更して、それをコミットするのです！ (`git commit -am 'Add some feature'`)
4. プッシュするのです！ (`git push origin my-new-feature`)
5. Pull Requestを作るのです！
