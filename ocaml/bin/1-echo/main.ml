open Maelstrom

let () =
  Maelstrom.run (fun msg ->
    match Protocol.get_type msg with
    | "echo" -> ()
    | _ -> ())
;;
