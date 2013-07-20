-module(message_router).

-compile(export_all).

start() ->
    spawn(message_router, route_messages, []).

stop(RouterPid) ->
    RouterPid ! shutdown.

send_chat_message(Source, Target, MsgBody) ->
    Source ! {send_chat_msg, Target, MsgBody}.

route_messages() ->
    receive
        {send_chat_msg, Target, MsgBody} ->
            Target ! {recv_chat_msg, MsgBody},
            route_messages();
        {recv_chat_msg, MsgBody} ->
            io:format("Received ~p~n", [MsgBody]),
            route_messages();
        shutdown ->
            io:format("Shutting down~n");
        Unexpected ->
            io:format("[Warning] Received ~p~n", [Unexpected]),
            route_messages()
    end.
