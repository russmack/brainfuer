% This is an Erlang implementation of a Brainfuck interpreter.
% Run with: brainfuer:start("helloworld.bf").
-module(brainfuer).
-export([start/1]).

start(Filename) ->
    Src = readall(Filename),
    print_out("Source: ~w~n", [Src]),
    start_eval(Src).

start_eval(Src) -> eval(Src, array:new(30000, [{default, 0}]), 1, 0, 0).

eval(Src, _, Src_ptr, _, _) when Src_ptr > erlang:length(Src) ->
    print_out("Finished.");

eval(Src, Registers, Src_ptr, Reg_ptr, Nested) ->
    print_out("~nRegisters : ~w~n", [Registers]),
    case lists:nth(Src_ptr, Src) of
        $+ ->
            print_out("+"),
            Curr_reg_val = array:get(Reg_ptr, Registers),
            New_registers = array:set(Reg_ptr, Curr_reg_val + 1, Registers),
            eval(Src, New_registers, Src_ptr + 1, Reg_ptr, Nested);
        $- ->
            print_out("-"),
            Curr_reg_val = array:get(Reg_ptr, Registers),
            New_registers = array:set(Reg_ptr, Curr_reg_val - 1, Registers),
            eval(Src, New_registers, Src_ptr + 1, Reg_ptr, Nested);
        $> ->
            print_out(">"),
            eval(Src, Registers, Src_ptr + 1, Reg_ptr + 1, Nested);
        $< ->
            print_out("<"),
            eval(Src, Registers, Src_ptr + 1, Reg_ptr - 1, Nested);
        $[ ->
            print_out("["),
            eval(Src, Registers, Src_ptr + 1, Reg_ptr, Nested + 1);
        $] ->
            print_out("]"),
            case array:get(Reg_ptr, Registers) of
                0 -> 
                    eval(Src, Registers, Src_ptr + 1, Reg_ptr, Nested - 1);
                _ -> 
                    Loop_start = skip(Src, Src_ptr - 1, 0),
                    eval(Src, Registers, Loop_start, Reg_ptr, Nested)
            end;
        $. ->
            print_out("."),
            io:format("~c", [array:get(Reg_ptr, Registers)]),
            eval(Src, Registers, Src_ptr + 1, Reg_ptr, Nested)
    end.

skip(Src, Src_ptr, Loop_count) ->
    case lists:nth(Src_ptr, Src) of
        $] -> skip(Src, Src_ptr - 1, Loop_count + 1);
        $[ -> 
            case Loop_count of 
                0 -> Src_ptr;
                _ -> skip(Src, Src_ptr - 1, Loop_count - 1)
            end;
        _  -> skip(Src, Src_ptr - 1, Loop_count)
    end.

readall(Filename) ->
    {ok, Device} = file:open(Filename, [read]),
    try get_all_lines(Device)
    after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof -> [];
        Line -> Line ++ get_all_lines(Device)
    end.

print_out(String) -> print_out(String, []).
print_out(String, Args) ->
    case enabled of 
        enabled -> ok;
        _ -> io:format(String, Args)
    end.
