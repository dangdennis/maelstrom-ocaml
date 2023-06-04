open Yojson.Safe.Util

let get_type msg = msg |> member "body" |> member "type" |> to_string
let get_sender msg = msg |> member "src" |> to_string
let get_node_id msg = msg |> member "body" |> member "node_id" |> to_string
let get_node_ids msg = msg |> member "body" |> member "node_ids" |> to_list |> List.map to_string
let get_msg_id msg = msg |> member "body" |> member "msg_id" |> to_int
