-module(message_router).

-define(SERVER, message_router).

-compile(export_all).

start() ->
    global:trans({?SERVER, ?SERVER},
                fun() ->
                        case global:whereis_name(?SERVER) of
                            undefined ->
                                Pid = spawn(message_router, route_messages, [dict:new()]),
                                global:register_name(?SERVER, Pid);
                            _ ->
                                ok
                        end
                end).

stop() ->
    global:trans({?SERVER, ?SERVER},
                fun() ->
                        case global:whereis(?SERVER) of
                            undefined ->
                                ok;
                            _ ->
                              global:send(?SERVER, shutdown)
                        end
                 end).

send_chat_message(Target, Msg) ->
    global:send(?SERVER, {send_chat_msg, Target, Msg}).

register_nick(ClientName, ClientPid) ->
    global:send(?SERVER, {register_nick, ClientName, ClientPid}).

unregister_nick(ClientName) ->
    global:send(?SERVER, {unregister_nick, ClientName}).

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
