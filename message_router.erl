-module(message_router).

-compile(export_all).

start(PrintFun) ->
    spawn(message_router, route_messages, [PrintFun]).

stop(RouterPid) ->
    RouterPid ! shutdown.

send_chat_message(Source, Target, MsgBody) ->
    Source ! {send_chat_msg, Target, MsgBody}.

route_messages(PrintFun) ->
    receive
        {send_chat_msg, Target, MsgBody} ->
            Target ! {recv_chat_msg, MsgBody},
            route_messages(PrintFun);
        {recv_chat_msg, MsgBody} ->
            PrintFun(MsgBody);
        shutdown ->
            io:format("Shutting down~n");
        Unexpected ->
            io:format("[Warning] Received ~p~n", [Unexpected]),
            route_messages(PrintFun)
    end.
