let counter = ref 0
let read () = !counter

let write value = 
  
  counter := value