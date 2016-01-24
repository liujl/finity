# Description
A websocket game server template running on
<a href="http://openresty.org" target="_blank">OpenResty</a> (version: 1.9.7.2+)
<a href="http://redis.io" target="_blank">Redis</a> (version: 2.0.0+)
Mysql (version: 5.5+).

## Request json format
FORMAT: {"id": xxx, "event": "xxx", "args": xxx}
* <b>id</b>: integer, client specified event id which will be returned unchanged.
* <b>event</b>: string, event name, such as 'signin', 'ping', etc.
* <b>args</b>: any, arguments of this event, <b>NULLABLE</b>.

## Response json format
FORMAT: {"id": xxx, "event": "xxx", "args": xxx, "err": xxx}
* <b>id</b>: integer, client specified event id or <b>0</b> on broadcasting.
* <b>event</b>: string, event name, such as 'signin', 'ping', etc.
* <b>args</b>: any, arguments of this event, <b>NULLABLE</b>.
* <b>err</b>: integer, error code, <b>NULLABLE</b>.

## Error code
<pre>
UNKNOWN = -1, -- unknown error (bugs, json decoding, etc.)
MYSQL = 1, -- mysql query error
REDIS = 2, -- redis command error
HTTP = 3, -- http request error
INVALID_EVENT = 11, -- event not defined

LOCK = 1001, -- mysql optimistic lock
WATCH = 1002, -- redis transaction error

SIGNIN_ALREADY = 2001, -- already signed in
SIGNIN_UNAUTH = 2002, -- sid unauthorized
</pre>

## Event list

### ping
Ping event to keep the current connection.
This event should be sent only if sign in completed.
Idle connections will be closed within several seconds (actually 5 times of read timeout).

FORMAT: {"id": xxx, "event": "ping", "args": xxx}
* <b>args</b> can be omitted (better)

### signin
Sign in should be the first event sent to server.
Connection will be closed on any errors.

FORMAT: {"id": xxx, "event": "signin", "args": {"sid": "xxx"}}
* <b>sid</b> is a string obtained from gate server

### chat
Broadcast a message to all players online including sender-self.
FORMAT: {"id": xxx, "event": "chat", "args": xxx}
* <b>args</b> any type of message for broadcasting.

BROADCAST: {"id": 0, "event": "chat", "args": {"playerid": xxx, "message": xxx}
* <b>args.playerid</b> integer, sender player's id.
* <b>args.message</b> equals to <b>args</b> in request.

### TODO: OTHER EVENTS