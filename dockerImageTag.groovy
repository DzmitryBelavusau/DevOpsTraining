import groovy.json.JsonSlurper

URL dockerRegistry = new URL("http://10.70.5.202:5000/v2/task7/tags/list")
def taglist = new JsonSlurper().parseText(dockerRegistry.text)

return taglist.tags