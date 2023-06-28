open Yojson.Safe.Util

let get_type msg = msg |> member "body" |> member "type" |> to_string
let get_sender msg = msg |> member "src" |> to_string
let get_node_id msg = msg |> member "body" |> member "node_id" |> to_string

let get_node_ids msg =
  msg |> member "body" |> member "node_ids" |> to_list |> List.map to_string
;;

let get_msg_id msg = msg |> member "body" |> member "msg_id" |> to_int
let get_broadcasted_value msg = msg |> member "body" |> member "message" |> to_int

let get_broadcasted_state msg =
  msg |> member "body" |> member "messages" |> to_list |> List.map to_int
;;

let get_add_delta msg = msg |> member "body" |> member "delta" |> to_int
let get_replication_state msg = msg |> member "body" |> member "state" |> to_assoc

module StringSet = Set.Make (String)
module IntSet = Set.Make (Int)

let deduplicate_str strings =
  let set = ref StringSet.empty in
  let add_unique_string str = set := StringSet.add str !set in
  List.iter add_unique_string strings;
  StringSet.elements !set
;;

let deduplicate_int strings =
  let set = ref IntSet.empty in
  let add_unique_int str = set := IntSet.add str !set in
  List.iter add_unique_int strings;
  IntSet.elements !set
;;

let get_topology msg =
  msg
  |> member "body"
  |> member "topology"
  |> to_assoc
  |> List.fold_left
       (fun (acc : string list) (_, nodes) ->
         let node_ids = nodes |> to_list |> List.map to_string in
         List.concat [ acc; node_ids ])
       []
  |> deduplicate_str
;;
