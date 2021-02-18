import std/[
  strutils, strformat,
  httpclient, json
]

import cligen
import regex

# regex for matching valid URLs
const urlRe = re"^(https?:\/\/)?((([a-z\d]([a-z\d-]*[a-z\d])*)\.)+[a-z]{2,}|((\d{1,3}\.){3}\d{1,3}))(\:\d+)?(\/[-a-z\d%_.~+]*)*(\?[;&a-z\d%_.~+=-]*)?(\#[-a-z\d_]*)?$"

# api response received upon creating a paste/shortened URL
type
  ApiResponse = object
    msg: string
    paste_id: string

# shortens a URL and prints out shortened URL to stdout
proc shorten(url: seq[string]) =
  if len(url) == 0: # if user enters blank URL, quit
    quit("fatal: You must specify a url to shorten.", 1)

  if len(url) > 1: # warn the user if they enter more than one positional argument
    echo "warn: more than one argument specified. choosing the first"
  
  if not url[0].match(urlRe): # if user enters invalid URL, quit
    quit(&"fatal: {url[0]} is not a valid url.", 1)

  # initialize a new http client and set content type headers
  var client = newHttpClient()
  client.headers = newHttpHeaders({ "Content-Type": "application/json" })

  # initialize POST request body
  let body = %* {
    "is_url": true,
    "content": url[0]
  }

  # make request to katbin API
  let res = client.request("https://api.katb.in/api/paste", httpMethod = HttpPost, body = $body)
  if res.code != Http201: # if request is not successful, quit
    quit("fatal: the server returned an error", 1)

  # close http client
  client.close()

  # serialize response
  let parsedRes = parseJson(res.body).to(ApiResponse)

  # print shortened url
  echo &"success: shortened url is available at https://katb.in/{parsedRes.paste_id}"


proc main =
  dispatchMulti([shorten, help = { # dispatch CLI procs to cligen
    "url": "The url to shorten"
  }])

main() # run main proc