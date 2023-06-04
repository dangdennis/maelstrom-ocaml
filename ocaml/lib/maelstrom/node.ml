let node_id : string ref = ref ""
let node_ids : string list ref = ref []
let state : int list ref = ref []
let set_node_id id = node_id := id
let get_node_id () = !node_id
let get_node_ids () = !node_ids
let generate_node_id () = get_node_id () ^ "-" ^ Uuid.generate_uuid ()
let read_state () = !state

let set_state new_state =
  state := List.concat [ new_state; !state ] |> Message.deduplicate_int
;;

let update_topology nodes = node_ids := nodes

let send ?(log = false) dest body =
  let reply_msg =
    `Assoc [ "src", `String (get_node_id ()); "dest", `String dest; "body", body ]
  in
  if log then Print.print_stderr (Yojson.to_string reply_msg);
  Print.print_stdout (Yojson.to_string reply_msg)
;;
