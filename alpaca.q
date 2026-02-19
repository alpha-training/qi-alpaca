.qi.requireconfs`ALPACAKEY`ALPACASECRET`ENDPOINT`FEED`TICKERS`URL
.qi.import`log;

if[first not enlist(.qi.try[get;".conf.ENDPOINT";""]1)in enlist each("/v2/iex";"/v2/test";"/v1beta3/crypto/us";"/v1beta1/news";"/v1beta1/indicative");
    .log.fatal"Make Sure Your ENDPOINT Is Entered Correctly! Check The Spelling"]

.qi.import`ipc;
.qi.frompkg[`alpaca;`norm]

\d .alpaca
if[not .qi.isproc;.qi.loadschemas`alpaca]

URL:`:wss://stream.data.alpaca.markets:443
header:"GET ",.conf.ENDPOINT," HTTP/1.1\r\n","Host: stream.data.alpaca.markets\r\n","\r\n";
tickers:`$$[sum","=.conf.TICKERS;","vs .conf.TICKERS;enlist .conf.TICKERS]
tname:$[1=count l:`$"Alpaca",/:-1_'@[;0;upper]each","vs .conf.FEED;first l;l]

sendtotp:{
    iscrypt:"/"in raze x`S;
    if["t"~f:first x`T;$[iscrypt;:neg[H](`.u.upd;`AlpacaCryptoT;norm.Ctrades x);:neg[H](`.u.upd;`AlpacaEquityT.csv;norm.Etrades x)]];
    if["q"~f;$[iscrypt;:neg[H](`.u.upd;`AlpacaCryptoQ;norm.Cquotes x);:neg[H](`.u.upd;`AlpacaEquityQ;norm.Equotes x)]];
    if["b"~f;$[iscrypt;:neg[H](`.u.upd;`AlpacaCryptoB;norm.Cbars x);:neg[H](`.u.upd;`AlpacaEquityB;norm.Ebars x)]]
 }

insertlocal:{
    iscrypt:"/"in raze x`S;
    if["t"~f:first x`T;$[iscrypt;(t:`AlpacaCryptoT)insert norm.Ctrades x;(t:`AlpacaEquityT)insert norm.Etrades x]]; / 
    if["q"~f;$[iscrypt;(t:`AlpacaCryptoQ)insert norm.Cquotes x;(t:`AlpacaEquityQ)insert norm.Equotes x]];
    if["b"~f;$[iscrypt;(t:`AlpacaCryptoB)insert norm.Cbars x;(t:`AlpacaEquityB)insert norm.Ebars x]];
    if[not`g=attr get[t]`sym;update`g#sym from t]
 }

.z.ws:{
    {if[(f:first x`T)in"tqb";:$[.qi.isproc;sendtotp;insertlocal]x];
    if[first 402=x`code;.log.fatal"Ensure ALPACAKEY & ALPACASECRET Are Entered Correctly In .conf"];
    if[first 400=x`code;.log.fatal"Ensure FEED is Spelled Correctly In .conf! (e.g trades rather than trade?)"];
    if[`success~`$x`T;
        if[`connected=msg:first`$x`msg;:neg[.z.w] .j.j`action`key`secret!("auth";.conf.ALPACAKEY;.conf.ALPACASECRET)];
        if[`authenticated~first msg;
            :neg[.z.w] .j.j(`action,a)!@[b:string`subscribe,count[a:`$","vs .conf.FEED]#tickers;1_til count b;enlist]]]
    }each .j.k x
 }

start::{
    if[.qi.isproc;
        if[null H::.ipc.conn target:.proc.self`depends_on;
            if[null H::first c:.ipc.tryconnect .ipc.conns[`tp1]`port;
            .log.fatal"Could not connect to ",.qi.tostr[target]," '",last[c],"'. Exiting"]];] 
    .log.info "Connection sequence initiated...";
    if[not h:first c:0N!.qi.try[URL;header;0Ni]; / doctor might need a timeout on here 
        .log.error err:c 2;
        if[err like"*Protocol*";
            if[.z.o in`l64`m64;
                .log.info"Try setting the env variable:\nexport SSL_VERIFY_SERVER=NO"]]];
    if[h;.log.info"Connection success"];
 }
\d .

/start`
/
f:first(`AlpacaTrades`norm.trades;`AlpacaQuote`norm.quotes;`AlpacaBar`norm.bars)where"tqb"=first x`T;
neg[`. `H](`.u.upd;f 0;(get` sv(`.alpaca;f 1))x)
 
if[""~.qi.try[get;".conf.ALPACAKEY";""]1;.log.fatal"Make Sure Your API Key Is Entered Correctly!"]
if[""~.qi.try[get;".conf.ALPACASECRET";""]1;.log.fatal"Make Sure Your Secret Key Is Entered Correctly!"]