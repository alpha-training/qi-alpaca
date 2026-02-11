\e 1
.qi.import`ipc;
.qi.import`log;
.qi.frompkg[`alpaca;`norm]
\d .alpaca

header:"GET ",.conf.endpoint," HTTP/1.1\r\n","Host: stream.data.alpaca.markets\r\n","\r\n";
tickers:`$","vs .conf.tickers;
tname:`$-1_@[.conf.feed;0;upper]; / UpperCamel

.z.ws:{
    {if[4<count x;:neg[H](`.u.upd;tname;.alpaca.norm[`$.conf.feed] x)];
    if[`success~first`$x`T;
            if[`connected=msg:first`$x`msg;neg[.z.w] .j.j`action`key`secret!("auth";.conf.apikey;.conf.secretkey)];
            if[`authenticated~first msg;neg[.z.w] .j.j(`action;`$.conf.feed)!("subscribe";tickers)]]
    }each .j.k x
 }

start:{[target]
    if[null H::.ipc.conn .qi.tosym target;
        if[null H::first c:.ipc.tryconnect target;
            .log.fatal"Could not connect to ",.qi.tostr[target]," '",last[c],"'. Exiting"]];
    .log.info "Connection sequence initiated...";
    if[not h:first c:.qi.try[.conf.url;header;0Ni];
        .log.error err:c 2;
        if[err like"*Protocol*";
            if[.z.o in`l64`m64;
                .log.info"Try setting the env variable:\nexport SSL_VERIFY_SERVER=NO"]]];
    if[h;.log.info"Connection success"];
 }
