-module(brainfuer_SUITE).
-compile(export_all).

all() ->
    [test_noargs, 
     test_empty,
     test_one_arg].

test_noargs(_Config) ->
    %% TODO {error, _} = brainfuer:start().
    {ok, _} = {ok, "hello"}.

test_empty(_Config) ->
    %% TODO {error, _} = brainfuer:start("").
    {ok, _} = {ok, "hello"}.

test_one_arg(_Config) ->
    %% TODO {ok, ["HelloWorld"]} = brainfuer:start("helloworld.bf").
    {ok, _} = {ok, "hello"}.

