import std/[terminal, strutils, os, parseopt]
import std/[httpclient, json]

import constants

var content: string

if isatty(stdin):
    let cliParams = commandLineParams()
    if len(cliParams) == 0:
        echo missingArgs
        quit(1)
    
    var p = initOptParser(cliParams)
    while true:
        p.next()
        case p.kind
        of cmdEnd: break
        of cmdArgument: content.add(" " & p.key)
        of cmdShortOption, cmdLongOption:
            if p.key == "h" or p.key == "help":
                echo helpText
                quit(0)
            else:
                echo unexpectedArg
                quit(1)
else:
    content = readAll(stdin).strip()

var client = newHttpClient()
client.headers = newHttpHeaders({ "Content-Type": "application/json" })
let body = %*{
    "paste": {
        "content": content
    }
}

let res = client.request("https://katb.in/api/paste", httpMethod = HttpPost, body = $body)
if res.status != "201 Created":
    echo "Something went wrong"
    quit(1)
else:
    let id = parseJson(res.body)["id"].getStr()
    echo "https://katb.in/" & id
