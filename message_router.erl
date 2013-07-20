-module(message_router).

-define(SERVER, message_router).

-compile(export_all).

start() ->
    Pid = spawn(message_router, route_messages, [dict:new()]),
    erlang:register(?SERVER, Pid).

stop() ->
    ?SERVER ! shutdown.

send_chat_message(Target, Msg) ->
    ?SERVER ! {send_chat_msg, Target, Msg}.

register_nick(ClientName, ClientPid) ->
    ?SERVER ! {register_nick, ClientName, ClientPid}.

unregister_nick(ClientName) ->
    ?SERVER ! {unregister_nick, ClientName}.

route_messages(Clients) ->
    receive
        {send_chat_msg, ClientName, Msg} ->
            case dict:find(ClientName, Clients) of
                {ok, ClientPid} ->
                    ClientPid ! {printmsg, Msg};
                error ->
                    io:format("Error: Unknown client: ~p~n", [ClientName])
            end,
            route_messages(Clients);
        {register_nick, ClientName, ClientPid} ->
            route_messages(dict:store(ClientName, ClientPid, Clients));
        {unregister_nick, ClientName} ->
            case dict:find(ClientName, Clients) of
                {ok, ClientPid} ->
                    ClientPid ! stop,
                    route_messages(dict:erase(ClientName, Clients));
                error ->
                    io:format("Error: Unknown client: ~p~n", [ClientName]),
                    route_messages(Clients)
            end;
        shutdown ->
            io:format("Shutting down~n");
        Unexpected ->
            io:format("[Warning] Received ~p~n", [Unexpected]),
            route_messages(Clients)
    end.
