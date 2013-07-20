-module(chat_client).

-compile(export_all).

register_nickname(Nick) ->
    Pid = spawn(chat_client, handle_messages, [Nick]),
    message_router:register_nick(Nick, Pid).

unregister_nickname(Nick) ->
    message_router:unregister_nick(Nick).

send_message(Target, Msg) ->
    message_router:send_chat_message(Target, Msg).

handle_messages(Nick) ->
    receive
       {printmsg, Msg} ->
            io:format("~p received: ~p~n", [Nick, Msg]);
       stop ->
            ok
    end.

start_router() ->
    message_router:start().
