chitchat
========

Erlang Chat app

Send a message:

```erlang
P = spawn(message_router, route_messages, []).
P ! {send_chat_msg, P, "Hello!"}.
```
