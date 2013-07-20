chitchat
========

Erlang Chat app

Send a message from the router to the router:

```erlang
P = message_router:start().
P ! {send_chat_msg, P, "Hello!"}.
```

Send a message from a client to the router:

```erlang
chat_client:send_message(P, P, "Hello from client").
```

Send a message from a client to another router:
```erlang
P1 = message_router:start().
chat_client:send_message(P, P1, "Hello from client to router #1").
```

Stop message router:
```erlang
message_router:stop(P).
```

Conversation afetr refactoring:
```erlang
P1 = message_router:start().
  <0.136.0>
P2 = message_router:start().
  <0.138.0>
chat_client:send_message(P1, P2, "Hello P2!").
  Received "Hello P2!"
  {send_chat_msg,<0.138.0>,"Hello P2!"}
chat_client:send_message(P2,P1,"How are you P1?").
  Received "How are you P1?"
  {send_chat_msg,<0.136.0>,"How are you P1?"}
```
