# gossip glomers - fly distributed system challenges

## Go implementation

1. `cd maelstrom`

2. challenge 1 echo: `./maelstrom test -w echo --bin ~/go/bin/maelstrom-echo --node-count 1 --time-limit 10`

3. challenge 2 unique id generation: `./maelstrom test -w unique-ids --bin ~/go/bin/maelstrom-unique-ids --time-limit 30 --rate 1000 --node-count 3 --availability total --nemesis partition`

4. challenge 3a broadcast: `./maelstrom test -w broadcast --bin ~/go/bin/maelstrom-broadcast --node-count 1 --time-limit 20 --rate 10`

5. challenge 3b broadcast: `./maelstrom test -w broadcast --bin ~/go/bin/maelstrom-broadcast --node-count 5 --time-limit 20 --rate 10`

## OCaml implementation

Translated the rust [`maelstrom-node`](https://github.com/sitano/maelstrom-rust-node/blob/main/src/protocol.rs#L41) to ocaml

1. `cd maelstrom`

2. challenge 1 echo

   ```
   dune build

   ./maelstrom test -w echo --bin ../ocaml/_build/default/bin/01-echo/main.exe --node-count 1 --time-limit 10
   ```

3. challenge 2 unique ids

   ```
   dune build

   ./maelstrom test -w unique-ids --bin ../ocaml/_build/default/bin/02-unique-ids/main.exe --time-limit 30 --rate 1000 --node-count 3 --availability total --nemesis partition
   ```
