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
chat_client:send_message(P, "Hello from client").
```

Send a message from a client to another router:
```erlang
P1 = chat_client:start_router().
chat_client:send_message(P1, "Hello from client to router #1").
```

Stop message router:
```erlang
message_router:stop(P).
```

Conversation:
```erlang
P1 = chat_client:start_router().
  <0.136.0>
P2 = chat_client:start_router().
  <0.138.0>
chat_client:send_message(P2, "Hello P2!").
  Received "Hello P2!"
  {send_chat_msg,<0.138.0>,"Hello P2!"}
chat_client:send_message(P1, "How are you P1?").
  Received "How are you P1?"
  {send_chat_msg,<0.136.0>,"How are you P1?"}
message_router:stop(P1).
  Shutting down
  shutdown
message_router:stop(P2).
  Shutting down
  shutdown
```

Nickname registration:
```erlang
chat_client:start_router().
  true
chat_client:register_nickname("Alice").
  {register_nick,"Alice",#Fun<chat_client.0.124345407>}
chat_client:send_message("Alice", "Hello Alice").
  "Alice" received: "Hello Alice"
  {send_chat_msg,"Alice","Hello Alice"}
chat_client:send_message("Alice", "Bye Alice").
  "Alice" received: "Bye Alice"
  {send_chat_msg,"Alice","Bye Alice"}
chat_client:unregister_nickname("Alice").
  {unregister_nick,"Alice"}
chat_client:send_message("Alice", "Bye Alice").
  Unknown client
  {send_chat_msg,"Alice","Bye Alice"}
```
