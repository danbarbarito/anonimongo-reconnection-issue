import std/tables
import ./db

#### Helpers ####

proc toBson[T: tuple | object](o: T): BsonDocument =
  result = bson()
  for k, v in o.fieldPairs:
    result[k] = v

#### Views ####

type ViewDocument* = object
  time*: float

proc getAllViews*(client: Mongo[AsyncSocket]): Future[seq[ViewDocument]] {.gcsafe,async.} =
  var c = client.getCollection("views")
  let documents = await c.findAll(sort = bson { "_id": -1 })
  for d in documents:
    result.add(d.to ViewDocument)

proc insertView*(client: Mongo[AsyncSocket], view: ViewDocument): Future[WriteResult] {.gcsafe,async.} =
  var c = client.getCollection("views")
  let document = @[view.toBson]
  result = await c.insert(document)