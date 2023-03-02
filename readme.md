# gossip glomers - fly distributed system challenges

1. `cd maelstrom`

2. challenge 1 echo: `./maelstrom test -w echo --bin ~/go/bin/maelstrom-echo --node-count 1 --time-limit 10`

3. challenge 2 unique id generation: `./maelstrom test -w unique-ids --bin ~/go/bin/maelstrom-unique-ids --time-limit 30 --rate 1000 --node-count 3 --availability total --nemesis partition`

4. challenge 3a broadcast: `./maelstrom test -w broadcast --bin ~/go/bin/maelstrom-broadcast --node-count 1 --time-limit 20 --rate 10`

5. challenge 3b broadcast: `./maelstrom test -w broadcast --bin ~/go/bin/maelstrom-broadcast --node-count 5 --time-limit 20 --rate 10`