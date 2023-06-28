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

Too tired to debug. I think the general idea is right to track all the states held by each node. Each node is responsible for repeatedly broadcasting its state to all other nodes, and nodes merge the states they receive from other nodes into their own state. The state is a map from node id to the number of increments that node has performed. The merge function is just a map union with the max function as the merge function for duplicate keys. Since we're lazy, each node broadcasts its entire state.

A couple optimizations we can do is to batch outbound broadcasts to sync and send state deltas. To handle deltas though, each node would need to handle out-of-order messages and duplicate updates.

