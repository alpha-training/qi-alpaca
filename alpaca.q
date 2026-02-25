.qi.requireconfs`ALPACAKEY`ALPACASECRET

if[first not enlist(.qi.tostr .qi.getconf[`ENDPOINT;"/v1beta3/crypto/us"])in enlist each("/v2/iex";"/v2/test";"/v1beta3/crypto/us";"/v1beta1/news";"/v1beta1/indicative");
    .qi.fatal"Make Sure Your ENDPOINT Is Entered Correctly! Check The Spelling"]

.qi.import`ipc;
.qi.frompkg[`alpaca;`norm]
.
\d .alpaca
if[not .qi.isproc;.qi.loadschemas`alpaca]
.qi.loadschemas`alpaca

URL:.qi.tosym .qi.getconf[`url;`:wss://stream.data.alpaca.markets:443]
header:"GET ",(feed:.qi.tostr .qi.getconf[`ENDPOINT;"/v1beta3/crypto/us"])," HTTP/1.1\r\n","Host: stream.data.alpaca.markets\r\n","\r\n";
tickers:`$$[sum","=(t:.qi.tostr .qi.getconf[`TICKERS;"ETH/USD"]);","vs t;enlist t]
tname:$[1=count l:`$"Alpaca",/:-1_'@[;0;upper]each","vs feed;first l;l]

sendtotp:{
    iscrypt:"/"in raze x`S;
    if["t"~f:first x`T;$[iscrypt;:neg[H](`.u.upd;`AlpacaCryptoT;norm.Ctrades x);:neg[H](`.u.upd;`AlpacaEquityT;norm.Etrades x)]];
    if["q"~f;$[iscrypt;:neg[H](`.u.upd;`AlpacaCryptoQ;norm.Cquotes x);:neg[H](`.u.upd;`AlpacaEquityQ;norm.Equotes x)]];
    if["b"~f;$[iscrypt;:neg[H](`.u.upd;`AlpacaCryptoB;norm.Cbars x);:neg[H](`.u.upd;`AlpacaEquityB;norm.Ebars x)]]
 }

insertlocal:{
    iscrypt:"/"in raze x`S;
    if["t"~f:first x`T;$[iscrypt;`.(t:`AlpacaCryptoT)insert norm.Ctrades x;(t:`AlpacaEquityT)insert norm.Etrades x]];
    if["q"~f;$[iscrypt;(t:`AlpacaCryptoQ)insert norm.Cquotes x;(t:`AlpacaEquityQ)insert norm.Equotes x]];
    if["b"~f;$[iscrypt;(t:`AlpacaCryptoB)insert norm.Cbars x;(t:`AlpacaEquityB)insert norm.Ebars x]];
    if[not`g=attr get[t]`sym;update`g#sym from t]
 }

.z.ws:{
    {if[(f:first x`T)in"tqb";:$[.qi.isproc;sendtotp;insertlocal]x];
    if[first 402=x`code;.qi.fatal"Ensure ALPACAKEY & ALPACASECRET Are Entered Correctly In .conf"];
    if[first 400=x`code;.qi.fatal"Ensure FEED is spelled correctly in .conf! (e.g trades rather than trade?)"];
    if[`success~`$x`T;
        if[`connected=msg:first`$x`msg;:neg[.z.w] .j.j`action`key`secret!("auth";.conf.ALPACAKEY;.conf.ALPACASECRET)];
        if[`authenticated~first msg;
            :neg[.z.w].j.j(`action,a)!`subscribe,count[a:`$","vs .qi.getconf[`FEED;"trades,quotes"]]#enlist string tickers]]
    }each .j.k x
 }

start::{
    if[.qi.isproc;
        if[null H::.ipc.conn`tp;
            if[null H::first c:.ipc.tryconnect .ipc.conns[`tp1]`port;
            .qi.fatal"Could not connect to ",.qi.tostr[`tp]," '",last[c],"'. Exiting"]];] 
    .qi.info "Connection sequence initiated...";
    if[not h:first c:0N!.qi.try[URL;header;0Ni]; / doctor might need a timeout on here 
        .qi.error err:c 2;
        if[err like"*Protocol*";
            if[.z.o in`l64`m64;
                .qi.fatal"Try setting the env variable:\nexport SSL_VERIFY_SERVER=NO"]]];
    if[h;.qi.info"Connection success"];
 }
\d .

/start`
/
f:first(`AlpacaTrades`norm.trades;`AlpacaQuote`norm.quotes;`AlpacaBar`norm.bars)where"tqb"=first x`T;
neg[`. `H](`.u.upd;f 0;(get` sv(`.alpaca;f 1))x)
 
if[""~.qi.try[get;".conf.ALPACAKEY";""]1;.qi.fatal"Make Sure Your API Key Is Entered Correctly!"]
if[""~.qi.try[get;".conf.ALPACASECRET";""]1;.qi.fatal"Make Sure Your Secret Key Is Entered Correctly!"]