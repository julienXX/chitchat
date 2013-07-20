chitchat
========

Erlang Chat app

Send a message from the router to the router:

```erlang
P = spawn(message_router, route_messages, []).
P ! {send_chat_msg, P, "Hello!"}.
```

Send a message from a client to the router:

```erlang
chat_client:send_message(P, P, "lol").
```
