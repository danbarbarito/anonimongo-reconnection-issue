import std/os, std/strutils
import prologue
import prologue/middlewares/sessions/memorysession
import anonimongo
import ./urls
import ./db

let env = loadPrologueEnv(".env")

const envs = @[
  (name: "appName", default: "Do This with Me"),
  (name: "debug", default: "true"),
  (name: "port", default: "8080"),
  (name: "secretKey", default: "secret"),
  (name: "mongodbConnectionString", default: ""),
  (name: "mongodbDatabase", default: "anonimongo_reconnection_issue"),
  (name: "mongodbPoolSize", default: "1")
]

proc maybeSetEnv(key: string, value: string, default: string = "") =
  if not existsEnv(key): putEnv(key, env.getOrDefault(key, value))

for e in envs:
  maybeSetEnv(e.name, e.default)

let settings = newSettings(
  appName = getEnv("appName"),
  debug = bool(getEnv("debug") == "true"),
  port = Port(parseInt(getEnv("port"))),
  secretKey = getEnv("secretKey")
)

gMongoClient = newMongoClient(getEnv("mongodbConnectionString"), parseInt(getEnv("mongodbPoolSize")))

var app = newApp(settings = settings)
app.use(sessionMiddleware(settings, path = "/"))
app.addRoute(urls.viewUrlPatterns, "")
app.run()