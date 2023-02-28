package main

import (
	"encoding/json"
	"log"

	maelstrom "github.com/jepsen-io/maelstrom/demo/go"
)

func main() {
	n := maelstrom.NewNode()

	type b1 = struct {
		Message any `json:"message"`
	}

	store := []any{}

	n.Handle("broadcast", func(msg maelstrom.Message) error {
		var body b1
		if err := json.Unmarshal(msg.Body, &body); err != nil {
			return err
		}

		resp := map[string]any{}
		resp["type"] = "broadcast_ok"
		store = append(store, body.Message)

		return n.Reply(msg, resp)
	})

	n.Handle("read", func(msg maelstrom.Message) error {
		var body map[string]any
		if err := json.Unmarshal(msg.Body, &body); err != nil {
			return err
		}

		body["type"] = "read_ok"
		body["messages"] = store

		return n.Reply(msg, body)
	})

	n.Handle("topology", func(msg maelstrom.Message) error {
		body := map[string]any{}
		// if err := json.Unmarshal(msg.Body, &body); err != nil {
		// 	return err
		// }

		body["type"] = "topology_ok"

		return n.Reply(msg, body)
	})

	if err := n.Run(); err != nil {
		log.Fatal(err)
	}

}
