package main

import (
	"encoding/json"
	"log"

	maelstrom "github.com/jepsen-io/maelstrom/demo/go"
)

type BroadcastBody = struct {
	Message int32  `json:"message"`
	Type    string `json:"type"`
}

func retrySend(node *maelstrom.Node, msg int32, nodeId string) {
	body := BroadcastBody{
		Type:    "broadcast",
		Message: msg,
	}

	err := node.Send(nodeId, body)
	if err != nil {
		retrySend(node, msg, nodeId)
	}
}

func main() {
	n := maelstrom.NewNode()

	neighbors := []string{}
	store := map[int32]int32{}

	n.Handle("broadcast", func(msg maelstrom.Message) error {

		var body BroadcastBody
		if err := json.Unmarshal(msg.Body, &body); err != nil {
			return err
		}

		_, exists := store[body.Message]
		if !exists {
			store[body.Message] = body.Message
		}

		for _, node := range neighbors {
			go retrySend(n, body.Message, node)
		}

		resp := map[string]string{}
		resp["type"] = "broadcast_ok"

		return n.Reply(msg, resp)
	})

	n.Handle("read", func(msg maelstrom.Message) error {
		resp := map[string]any{}
		resp["type"] = "read_ok"
		msgs := []int32{}
		for _, v := range store {
			msgs = append(msgs, v)
		}
		resp["messages"] = msgs

		return n.Reply(msg, resp)
	})

	n.Handle("topology", func(msg maelstrom.Message) error {
		type Topology = map[string][]string

		type TopologyBody = struct {
			Type     string   `json:"type"`
			Topology Topology `json:"topology"`
		}

		var body TopologyBody
		if err := json.Unmarshal(msg.Body, &body); err != nil {
			return err
		}

		topology, exists := body.Topology[n.ID()]
		if exists {
			neighbors = append(neighbors, topology...)
		}

		resp := map[string]string{}
		resp["type"] = "topology_ok"

		return n.Reply(msg, resp)
	})

	if err := n.Run(); err != nil {
		log.Fatal(err)
	}

}
