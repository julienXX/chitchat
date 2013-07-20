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

Multi-node chat:
  - Start two different nodes:
  ```
  erl -sname node1 -setcookie chitchat
  ```
  ```
  erl -sname node2 -setcookie chitchat
  ```

  - let's test if the nodes see each other:
  ```
  (node1@imac-de-julien)1> net_adm:ping('node2@imac-de-julien').
    pong
  ```
  ```
  (node2@imac-de-julien)1> net_adm:ping('node1@imac-de-julien').
    pong
  ```

  - node1 will be the message router:
  ```erlang
  (node1@imac-de-julien)3> chat_client:start_router().
    yes
  ```

  - node2 can see the registered message_router:
  ```erlang
  (node2@imac-de-julien)2> global:registered_names().
    [message_router]
  ```

  - register a nickname 'Alice' on node1:
  ```erlang
  (node1@imac-de-julien)4> chat_client:register_nickname("Alice").
    <0.49.0>
  ```

  - register a nickname 'Bob' on node2:
  ```erlang
  (node2@imac-de-julien)4> chat_client:register_nickname("Bob").
    <5898.49.0>
  ```

  - Alice sends a message to Bob:
  ```erlang
  (node1@imac-de-julien)5> chat_client:send_message("Bob", "Hi Bob!").
    <0.49.0>
  ```

  - On Bob's side:
  ```erlang
  "Bob" received: "Hi Bob!"
  ```

  - Bob replies:
  ```erlang
  (node2@imac-de-julien)4> chat_client:send_message("Alice", "How R U Alice?").
    <5898.49.0>
  ```

  - On Alice's side:
  ```erlang
  "Alice" received: "How R U Alice?"
  ```

  - Now test unregistering Alice:
  ```erlang
  (node1@imac-de-julien)7> chat_client:unregister_nickname("Alice").
    <0.49.0>
  ```

  - Bob tries to send a message to Alice again:
  ```erlang
  (node2@imac-de-julien)5> chat_client:send_message("Alice", "U there?").
    <5898.49.0>
  ```

  - On node1 (the message router):
  ```
  Error: Unknown client: "Alice"
  ```
