-module(message_router).

-compile(export_all).

route_messages() ->
    receive
        {send_chat_msg, Target, MsgBody} ->
            Target ! {recv_chat_msg, MsgBody};
        {recv_chat_msg, MsgBody} ->
            io:format("Received ~p~n", [MsgBody]);
        Unexpected ->
            io:format("[Warning] Received ~p~n", [Unexpected])
    end,
    route_messages().
