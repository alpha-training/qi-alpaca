\e 1

url:`$":wss://stream.data.alpaca.markets/v2/test"
i:0
H:0Ni
/ Configuration
/
host:"stream.data.alpaca.markets"
port:"443" / SSL port
endpoint: "/v2/",.conf.mode
apikey:"PKPHWIVR6N4YU2ON2D5TJDYWB6"  / Replace with your KEY
apisecret:"5HMBNJhRruFq7gBMLrDQuQ3k8xtVbwnxYk44BUBAiMTD" / 1. Define the Message Handler (.z.ws)]
TICKERS:enlist"FAKEPACA"
\

/ This must be defined BEFORE opening the socket, as per your text.
.z.ws:{
    /i::i+1;if[i=2;:dbg];0N! .j.k x;
    {if[not`msg in key flip x;:neg[H](`.u.upd;T:`$first x `T;norm.A x)];
     if[T=`success;
            if[(msg:first `$x`msg)=`connected;neg[.z.w] .j.j`action`key`secret!("auth";.conf.apikey;.conf.apisecret);
            if[msg=`authenticated;neg[.z.w] .j.j`action`trades!("subscribe";TICKERS)]]]
    } each .j.k x


 }

req:"GET /v2/",.conf.mode," HTTP/1.1\r\n","Host: stream.data.alpaca.markets\r\n","\r\n"

conn:(`$":wss://stream.data.alpaca.markets:443") req

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
authMsg: .j.j `action`key`secret!("auth"; apiKey; apiSecret)
neg[h] authMsg

/ 6. Subscribe (Alpaca V2)
/ We subscribe to 'trades' for Apple (AAPL)
subMsg: .j.j `action`trades!("subscribe"; enlist "FAKEPACA")
neg[h] subMsg

/
wscat -c wss://stream.data.alpaca.markets/v2/iex   --execute '{"action": "auth", "key": "PKPHWIVR6N4YU2ON2D5TJDYWB6", "secret": "5HMBNJhRruFq7gBMLrDQuQ3k8
xtVbwnxYk44BUBAiMTD"}'   --execute '{"action": "subscribe", "bars": ["AAPL"]}'   | tee alpaca_data.json

apikey=PKPHWIVR6N4YU2ON2D5TJDYWB6
secretkey=5HMBNJhRruFq7gBMLrDQuQ3k8xtVbwnxYk44BUBAiMTD
tickers=JPM,AAPL,TSLA
mode=paper
feed=delayed_sip

wscat -c :wss://stream.data.alpaca.markets/v2/test   --execute '{"action": "auth", "key": "PKPHWIVR6N4YU2ON2D5TJDYWB6", "secret": "5HMBNJhRruFq7gBMLrDQuQ3k8
xtVbwnxYk44BUBAiMTD"}'   --execute '{"action": "subscribe", "trades": ["FAKEPACA"]}'
'{"action": "auth", "key": "PKPHWIVR6N4YU2ON2D5TJDYWB6", "secret": "5HMBNJhRruFq7gBMLrDQuQ3k8xtVbwnxYk44BUBAiMTD"}'
'{"action": "subscribe", "trades": ["FAKEPACA"]}'