(* structure and signature *)

module PrioQueue =
struct
  type priority = int
  type 'a queue = Empty | Node of priority * 'a * 'a queue * 'a queue
  let empty = Empty
  let rec insert queue prio elt =
    match queue with
      Empty -> Node (prio, elt, Empty, Empty)
    | Node (p, e, left, right) ->
      if prio <= p
      then Node (prio, elt, insert right p e, left)
      else Node (p, e, insert right prio elt, left)
  exception Queue_is_empty
  let rec remove_top = function
      Empty -> raise Queue_is_empty
    | Node (prio, elt, left, Empty) -> left
    | Node (prio, elt, Empty, right) -> right
    | Node (prio, elt, (Node(lprio, lelt, _ , _ ) as left),
            (Node(rprio, relt, _ , _ ) as right)) ->
      if lprio <= rprio
      then Node(lprio, lelt, remove_top left, right)
      else Node(rprio, relt, left, remove_top right)
  let extract = function
    | Empty -> raise Queue_is_empty
    | Node (prio, elt, _, _) as queue -> (prio, elt, remove_top queue)
end;;


module type PRIOQUEUE =
sig
  type priority = int 
  type 'a queue
  val empty : 'a queue
  val insert : 'a queue -> priority -> 'a  -> 'a queue
  val extract : 'a queue -> priority * 'a * 'a queue
  exception Queue_is_empty
end;;



module PrioQueueOpt  =
struct
  include PrioQueue 
  let remove_top_opt x =
    try Some(remove_top x) with Queue_is_empty -> None
  let extract_opt x =
    try Some (extract x) with Queue_is_empty -> None
end;;


module type PRIOQUEUE_WITH_OPT = 
sig
  include PRIOQUEUE
  val extract_opt : 'a queue -> (priority * 'a * 'a queue) option
end;;

(* module functor *)


type comparison = Less | Equal | Greater;;

module type ORDERED_TYPE =
sig
  type t
  val compare : t -> t -> comparison
end;;


module Set =
  functor (Elt : ORDERED_TYPE) ->
  struct
    type element = Elt.t
    type set = element list
    let empty = []
    let rec add x s =
      match s with
        [] -> [x]
      | hd :: tl ->
        match Elt.compare x hd with
          Equal -> s
        | Less -> x :: s
        | Greater -> hd :: add x tl
    let rec member x s =
      match s with
        [] -> false
      | hd :: tl ->
        match Elt.compare x hd with
          Equal -> true
        | Less -> false
        | Greater -> member x tl
  end;;


module OrderedString =
struct
  type t = string
  let compare (x : t) y =
    if x = y
    then Equal
    else if x < y
    then Less
    else Greater
end;;


module AbstractOrderedString = (OrderedString : ORDERED_TYPE)

module NoCaseString =
struct
  type t = string
  let compare (x : t) (y : t) =
    let lx = String.lowercase_ascii x
    and ly = String.lowercase_ascii y
    in if lx = ly
    then Equal
    else if lx < ly
    then Less
    else Greater
end;;


module AbstractNoCaseString = (NoCaseString : ORDERED_TYPE)

module Natural =
struct
  type t = int
  let compare (x : t) (y : t)  =
    if x = y then Equal else if x < y  then Less else Greater
end;;


module AbstractNatural = (Natural : ORDERED_TYPE)


(* Observation A *)

(* Applying the module functor Set to OrderedString, even if we 
   add type annotation  : ORDERED_TYPE, does not cause the module
   type ORDERED_TYPE to be imposed on OrderedString. However, if 
   we explicitly apply the type annotation to define an abstract
   module, then although the module functor still works, the 
   implementation of the type t is now hidden and the complier 
   can no longer identify it with string *)
                         
module OrderedStringSet = Set(OrderedString : ORDERED_TYPE);;
OrderedStringSet.(add "hello" empty);;
module NoCaseStringSet = Set(NoCaseString);;
NoCaseStringSet.(add "hello" empty);;
module NaturalSet = Set(Natural  : ORDERED_TYPE);;
NaturalSet.(add 100 empty);;

(* The following calls will fail due to the fact that 
   the implemetation of the type t is hidden by abstraction *)

(* 
module AbstractOrderedStringSet = Set(AbstractOrderedString);;
AbstractOrderedStringSet.(add "hello" empty);;
module AbstractNoCaseStringSet = Set(AbstractNoCaseString);;
AbstractNoCaseStringSet.(add "hello" empty);;
module AbstractNaturalSet = Set(AbstractNatural);;
AbstractNaturalSet.(add 100  empty);;
*)


(* Observation B *)

(*

If we define the module type in the following way, where the type t 
is explicitly associated with atring,

module type ORDERED_TYPE =
sig
  type t = string
  val compare : t -> t -> comparison
end;;

Then when we define

module NaturalSet = Set(Natural  : ORDERED_TYPE);;

there will be a type conflict between type t = int from Natural 
and type t = string from Set. This problem persists even if we 
write:

module NaturalSet = Set(Natural);;

*)


(*

From Observation A and B above we can conclude that a signature 
where type alias is absent, i.e. export type t instand of type t = int,
can on the one hand be used to hide information and restrict acsess, as 
per Observation A,  while on the other hand can be used to serve as a
minimum requirement to define a module functor, as per Observation B.  

*)

module type SETFUNCTOR =
  functor (Elt : ORDERED_TYPE) ->
  sig
    type element = Elt.t
    type set
    val empty : set
    val add : element -> set -> set
    val member : element -> set -> bool
  end;;



