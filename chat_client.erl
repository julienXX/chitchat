-module(chat_client).

-compile(export_all).

send_message(Source, Target, MsgBody) ->
    message_router:send_chat_message(Source, Target, MsgBody).
