import std/asyncdispatch, std/strformat, std/times
import prologue
import ./db
import ./models

#### Routes ####
proc indexPage*(ctx: prologue.Context) {.async.} =
  let newView = ViewDocument(time: epochTime())
  let insertedView = await mongoClient().insertView(newView)
  let allViews = await mongoClient().getAllViews()
  let html = &"""
  <!DOCTYPE html>
  <html>
  <head>
      <title>Anonimongo Reconnection Issue</title>
  </head>
  <body>
      <h1>Anonimongo Reconnection Issue</h1>
      <p>You have viewed this page {allViews.len} times!</p>
  </body>
  </html>
  """
  resp htmlResponse(html)