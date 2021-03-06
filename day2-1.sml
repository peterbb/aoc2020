
local open Parser in
    infix // <*> <|>

    val line: (int * int * char * string) Parser.t =
        number
        // exact_char #"-"
        <*> number
        // exact_char #" "
        <*> char
        // exact_string ": "
        <*> rest_of_line
        <|> (fn (((min, max), c), password) => (min, max, c, password))

    val input = Parser.exec (list line // eof)
end

fun print_line (min, max, c, password) =
    println (
        Int.toString min
        ^ "-"
        ^ Int.toString max
        ^ " "
        ^ Char.toString c
        ^ ": "
        ^ password
    )

fun is_valid (min, max, c, password) =
    String.explode password
    |> List.filter (fn c' => c = c')
    |> List.length
    |> (fn valid => min <= valid andalso valid <= max)

fun loop [] valid = println $ Int.toString valid
  | loop (line :: rest) valid = (
        print (if is_valid line then "XXX " else "");
        print_line line;
        loop rest (if is_valid line then valid + 1 else valid)
    )

val () = case input of
    | NONE => println "parsing failed"
    | SOME input => loop input 0
