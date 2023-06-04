# gossip glomers - fly distributed system challenges

## Maelstrom OCaml client

You can find the implementation in `/ocaml/lib/maelstrom`.

## Go implementation

1. `cd maelstrom`

2. challenge 1 echo: `./maelstrom test -w echo --bin ~/go/bin/maelstrom-echo --node-count 1 --time-limit 10`

3. challenge 2 unique id generation: `./maelstrom test -w unique-ids --bin ~/go/bin/maelstrom-unique-ids --time-limit 30 --rate 1000 --node-count 3 --availability total --nemesis partition`

4. challenge 3a broadcast: `./maelstrom test -w broadcast --bin ~/go/bin/maelstrom-broadcast --node-count 1 --time-limit 20 --rate 10`

5. challenge 3b broadcast: `./maelstrom test -w broadcast --bin ~/go/bin/maelstrom-broadcast --node-count 5 --time-limit 20 --rate 10`

## OCaml implementation

Translated the rust [`maelstrom-node`](https://github.com/sitano/maelstrom-rust-node/blob/main/src/protocol.rs#L41) to ocaml

1. `cd maelstrom`
2. dune build

### 1 echo

```
./maelstrom test -w echo --bin ../ocaml/_build/default/bin/01-echo/main.exe --node-count 1 --time-limit 10
```

### 2 unique ids

```
./maelstrom test -w unique-ids --bin ../ocaml/_build/default/bin/02-unique-ids/main.exe --time-limit 30 --rate 1000 --node-count 3 --availability total --nemesis partition
```

### 3a single-node broadcast

```
./maelstrom test -w broadcast --bin ../ocaml/_build/default/bin/03a-broadcast/main.exe --node-count 1 --time-limit 20 --rate 10
```

### 3b multi-node broadcast

```
./maelstrom test -w broadcast --bin ../ocaml/_build/default/bin/03b-multi-node-broadcast/main.exe --node-count 5 --time-limit 20 --rate 10
```

### 3c fault tolerant broadcast

```
./maelstrom test -w broadcast --bin ../ocaml/_build/default/bin/03c-fault-tolerant-broadcast/main.exe --node-count 5 --time-limit 20 --rate 10 --nemesis partition
```

### 3d efficient broadcast

```
./maelstrom test -w broadcast --bin ../ocaml/_build/default/bin/03d-efficient-broadcast/main.exe --node-count 25 --time-limit 20 --rate 100 --latency 100
```

### 3e efficient broadcast, faster

```
./maelstrom test -w broadcast --bin ../ocaml/_build/default/bin/03e-efficient-broadcast-faster/main.exe --node-count 25 --time-limit 20 --rate 100 --latency 100
```

### 4 grow-only counter

```
./maelstrom test -w g-counter --bin ../ocaml/_build/default/bin/04-grow-only-counter/main.exe  --node-count 3 --rate 100 --time-limit 20 --nemesis partition
```
