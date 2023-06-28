open Maelstrom
module GCounter = Crdt.GCounter

let gcounter = ref GCounter.empty

let handle_add msg =
  let delta = Message.get_add_delta msg in
  Print.print_stderr ("delta " ^ string_of_int delta);
  gcounter := GCounter.increment ~value:delta ~node:(Node.get_node_id ()) !gcounter;
  Node.send ~log:true (Message.get_sender msg) (`Assoc [ "type", `String "add_ok" ]);
  ()
;;

let handle_read msg =
  let count = GCounter.value !gcounter in
  Print.print_stderr ("count " ^ string_of_int count);
  Node.send
    (Message.get_sender msg)
    (`Assoc [ "type", `String "read_ok"; "value", `Int count ]);
  ()
;;

let handle_init _ =
  let set_interval action seconds =
    let rec loop () =
      Thread.delay seconds;
      action ();
      loop ()
    in
    let _ = Thread.create loop () in
    ()
  in
  set_interval
    (fun () ->
      let peers = Node.get_node_ids () in
      let state = GCounter.to_json !gcounter in
      Print.print_stderr ("state to sync " ^ Yojson.show state);
      peers
      |> List.iter (fun peer ->
           Node.send peer (`Assoc [ "type", `String "sync"; "state", state ]);
           ());
      ())
    1.0
;;

let handle_sync msg =
  let replication_state = Message.get_replication_state msg in
  let deserialized_state = GCounter.of_json replication_state in
  let new_state = GCounter.merge !gcounter deserialized_state in
  gcounter := new_state;
  ()
;;

let () =
  Maelstrom.run ~log:true (fun msg ->
    match Message.get_type msg with
    | "add" -> handle_add msg
    | "read" -> handle_read msg
    | "init" -> handle_init msg
    | "sync" -> handle_sync msg
    | _ -> ())
;;
