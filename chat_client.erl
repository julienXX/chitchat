-module(chat_client).

-compile(export_all).

register_nickname(Nick) ->
    message_router:register_nick(Nick, fun(Msg) -> chat_client:print_message(Nick, Msg) end).

unregister_nickname(Nick) ->
    message_router:unregister_nick(Nick).

send_message(Target, Msg) ->
    message_router:send_chat_message(Target, Msg).

print_message(Nick, Msg) ->
    io:format("~p received: ~p~n", [Nick, Msg]).

start_router() ->
    message_router:start().
