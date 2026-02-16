/.qi.import`ipc;
/.qi.import`log;
.qi.frompkg[`alpaca;`norm]

\d .alpaca

header:"GET ",.conf.endpoint," HTTP/1.1\r\n","Host: stream.data.alpaca.markets\r\n","\r\n";
tickers:$[1=count l:`$","vs .conf.tickers;first l;l]
tname:$[1=count l:`$"Alpaca",/:-1_'@[;0;upper]each","vs .conf.feed;first l;l]

sendtotp:{
        if["t"~f:first x`T;:neg[H](`.u.upd;`AlpacaTrade;norm.trades x)];
        if["q"~f;:neg[H](`.u.upd;`AlpacaQuote;norm.quotes x)];
        if["b"~f;:neg[H](`.u.upd;`AlpacaBar;norm.bars x)]
 }
insertlocal:{
    if["t"~f:first x`T;(t:`AlpacaTrade)insert norm.trades x];
    if["q"~f;(t:`AlpacaQuote)insert norm.quotes x];
    if["b"~f;(t:`.AlpacaBar)insert norm.bars x];
    if[not`g=attr get[t]`sym;update `g#sym from t]
 }
.z.ws:{
    {if[first[x`T]in"tqb";f:first x`T;:$[.qi.isproc;sendtotp;insertlocal]x]
    if[`success~first`$x`T;
        if[`connected=msg:first`$x`msg;:neg[.z.w] .j.j`action`key`secret!("auth";.conf.apikey;.conf.secretkey)];
        if[`authenticated~first msg;
            :neg[.z.w] .j.j(`action,a)!$[1-count tickers;b:string`subscribe,count[a:`$","vs .conf.feed]#enlist tickers;@[b;1_til count b;enlist]]]]
    }each .j.k x
 }

start:{[target]
    if[.qi.isproc;
        if[null H::.ipc.conn .qi.tosym target;
            if[null H::first c:.ipc.tryconnect target;
            .log.fatal"Could not connect to ",.qi.tostr[target]," '",last[c],"'. Exiting"]];] 
    .log.info "Connection sequence initiated...";
    if[not h:first c:.qi.try[.conf.url;header;0Ni];
        :.log.error err:c 2];
    if[h;.log.info"Connection success"];
 }
