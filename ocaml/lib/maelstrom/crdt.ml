module GCounter = struct
  module StringMap = Map.Make (String)

  type t = int StringMap.t

  let empty : t = StringMap.empty

  let increment (counter : t) ~(value : int) ~(node : string) =
    let count =
      match StringMap.find_opt node counter with
      | None -> 0
      | Some count -> count
    in
    StringMap.add node (count + value) counter
  ;;

  let value (counter : t) : int =
    StringMap.fold (fun _ count acc -> acc + count) counter 0
  ;;

  let merge (counter1 : t) (counter2 : t) : t =
    StringMap.merge
      (fun _ count1 count2 ->
        match count1, count2 with
        | None, None -> None
        | Some c1, None -> Some c1
        | None, Some c2 -> Some c2
        | Some c1, Some c2 -> Some (max c1 c2))
      counter1
      counter2
  ;;

  let to_json (counter : t) : Yojson.t =
    StringMap.bindings counter
    |> List.map (fun (key, value) -> key, `Int value)
    |> fun bindings -> `Assoc bindings
  ;;

  let of_json (json_assoc : (string * Yojson.Safe.t) list) : t =
    json_assoc
    |> List.filter_map (fun (key, value) ->
         match value with
         | `Int i -> Some (key, i)
         | _ -> None)
    |> List.fold_left
         (fun crdt_state (key, value) -> StringMap.add key value crdt_state)
         StringMap.empty
  ;;
end
