-module(message_router).

-define(SERVER, message_router).

-compile(export_all).

start() ->
    Pid = spawn(message_router, route_messages, [dict:new()]),
    erlang:register(?SERVER, Pid).

stop() ->
    ?SERVER ! shutdown.

send_chat_message(Target, MsgBody) ->
    ?SERVER ! {send_chat_msg, Target, MsgBody}.

register_nick(ClientName, PrintFun) ->
    ?SERVER ! {register_nick, ClientName, PrintFun}.

unregister_nick(ClientName) ->
    ?SERVER ! {unregister_nick, ClientName}.

route_messages(Clients) ->
    receive
        {send_chat_msg, ClientName, MsgBody} ->
            ?SERVER ! {recv_chat_msg, ClientName, MsgBody},
            route_messages(Clients);
        {recv_chat_msg, ClientName, MsgBody} ->
            case dict:find(ClientName, Clients) of
                {ok, PrintFun} ->
                    PrintFun(MsgBody);
                error ->
                    io:format("Unknown client~n")
            end,
            route_messages(Clients);
        {register_nick, ClientName, PrintFun} ->
            route_messages(dict:store(ClientName, PrintFun, Clients));
        {unregister_nick, ClientName} ->
            route_messages(dict:erase(ClientName, Clients));
        shutdown ->
            io:format("Shutting down~n");
        Unexpected ->
            io:format("[Warning] Received ~p~n", [Unexpected]),
            route_messages(Clients)
    end.
