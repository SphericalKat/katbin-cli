import std/[terminal, strutils, os]
import std/[httpclient, json]

var content: string

if isatty(stdin):
    content = commandLineParams().join
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
let id = parseJson(res.body)["id"].getStr()
echo "https://katb.in/" & id
