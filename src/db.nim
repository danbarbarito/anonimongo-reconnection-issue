import std/os
import anonimongo
export anonimongo

var gMongoClient*: Mongo[AsyncSocket]

proc mongoClient*(): Mongo[AsyncSocket] =
  {.cast(gcsafe).}:
    return gMongoClient
  
#### Helpers ####

proc newMongoClient*(connectionString: string, poolconn: int = 1): Mongo[AsyncSocket] =
  var m = newMongo[AsyncSocket](MongoUri connectionString, poolconn = poolconn)
  if not waitfor m.connect:
    quit "Cannot connect to MongoDB"
  if not waitFor m.authenticate[:SHA1Digest]():
    quit "Cannot login to MongoDB"
  return m

proc getCollection*(client: Mongo[AsyncSocket], collectionName: string): Collection[AsyncSocket] =
  result = client[getEnv("mongodbDatabase")][collectionName]