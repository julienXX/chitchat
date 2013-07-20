-module(chat_client).

-compile(export_all).

send_message(RouterPid, Target, MsgBody) ->
    RouterPid ! {send_chat_msg, Target, MsgBody}.
