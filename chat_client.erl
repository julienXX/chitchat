-module(chat_client).

-compile(export_all).

send_message(Source, Target, MsgBody) ->
    message_router:send_chat_message(Source, Target, MsgBody).

print_message(MsgBody) ->
    io:format("Received: ~p~n", [MsgBody]).

start_router() ->
    message_router:start(fun chat_client:print_message/1).
