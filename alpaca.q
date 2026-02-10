\e 1
.qi.import`ipc;
.qi.import`log;
.qi.frompkg[`alpaca;`norm]
\d .alpaca

url:`$":wss://stream.data.alpaca.markets:443"
header:"GET ",.conf.endpoint," HTTP/1.1\r\n","Host: stream.data.alpaca.markets\r\n","\r\n"
tickers:`$","vs .conf.tickers
tname:`$-1_@[.conf.feed;0;upper]

/H:hopen 5009
/i:0
.z.ws:{
    /i::i+1;if[i=6;:dbg];0N!.j.k x;
    {if[4<count x;:neg[H](`.u.upd;tname;.alpaca.norm[`$.conf.feed] x)];
    if[`success~first`$x`T;
            if[(msg:first`$x`msg)=`connected;neg[.z.w] .j.j`action`key`secret!("auth";.conf.apikey;.conf.secretkey)];
            if[`authenticated~first msg;neg[.z.w] .j.j(`action;`$.conf.feed)!("subscribe";tickers)]]
    }each .j.k x
 }

/conn:url header

start:{[target]
    if[null H::.ipc.conn .qi.tosym target;
        if[null H::first c:.ipc.tryconnect target;
            .log.fatal"Could not connect to ",.qi.tostr[target]," '",last[c],"'. Exiting"]];
    .log.info "Connection sequence initiated...";
    if[not h:first c:.qi.try[url;header;0Ni];
        .log.error err:c 2;
        if[err like"*Protocol*";
            if[.z.o in`l64`m64;
                .log.info"Try setting the env variable:\nexport SSL_VERIFY_SERVER=NO"]]];
    if[h;.log.info"Connection success"];
    }
/
/(`$":wss://stream.data.alpaca.markets:443")"GET /v2/test HTTP/1.1\r\nHost: stream.data.alpaca.markets\r\n\r\n"

wscat -c wss://stream.data.alpaca.markets/v2/iex   --execute '{"action": "auth", "key": "PKPHWIVR6N4YU2ON2D5TJDYWB6", "secret": "5HMBNJhRruFq7gBMLrDQuQ3k8
xtVbwnxYk44BUBAiMTD"}'   --execute '{"action": "subscribe", "bars": ["AAPL"]}'   | tee alpaca_data.json

wscat -c :wss://stream.data.alpaca.markets/v2/test   --execute '{"action": "auth", "key": "PKPHWIVR6N4YU2ON2D5TJDYWB6", "secret": "5HMBNJhRruFq7gBMLrDQuQ3k8
xtVbwnxYk44BUBAiMTD"}'   --execute '{"action": "subscribe", "trades": ["FAKEPACA"]}'
'{"action": "auth", "key": "PKPHWIVR6N4YU2ON2D5TJDYWB6", "secret": "5HMBNJhRruFq7gBMLrDQuQ3k8xtVbwnxYk44BUBAiMTD"}'
'{"action": "subscribe", "trades": ["FAKEPACA"]}'


/ 4. Validate the Upgrade
/ As per your text, a success returns a list: (handle; HTTP Response)
/ A failure returns the handle as 0Ni.
h: first conn
resp: last conn

if[h=0Ni; 
    show "Connection Failed:"; 
    show resp; 
    exit 1]

show "Connected! Handle is: ",string h

/ 5. Authenticate (Alpaca V2)
/ Sent immediately after connection is confirmed.
authMsg: .j.j `action`key`secret!("auth";.conf.apikey;.conf.secretkey)
neg[h] authMsg

/ 6. Subscribe (Alpaca V2)
/ We subscribe to 'trades' for Apple (AAPL)
subMsg: .j.j `action`trades!("subscribe"; enlist "FAKEPACA")
neg[h] subMsg

