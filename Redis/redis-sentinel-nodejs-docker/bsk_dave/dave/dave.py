import cherrypy
import DockerStats
import json
import salt.client


class DockerStats:
    """
    Walks accreoss infrastructure and collects docker stats
    """

    def __init__(self):
        self.local = salt.client.LocalClient()
        dockerStats = self.local.cmd('node*', 'cmd.run', ["docker stats --no-stream $(docker ps -a --format={{.Names}})|sed 's/ \/ /\//g'|sed 's/ %/%/g'|sed 's/ B/B/g'|sed 's/ kB/kB/g'|sed 's/ MB/MB/g'|sed 's/ GB/GB/g'|sed 's/ MiB/MiB/g'|sed 's/ GiB/GiB/g'|sed 's/MEM USAGE/MEM_USAGE/g'|sed 's/ I\/O/_I\/O/g'|sed 's/ \{2,\}/;/g'"])
        resultsArray = []
        fieldsNames  = [];
        for node in dockerStats:
                nodeDetails = {}
                nodeDetails['dockAddr'] = self.getAddress(node, 'docker0')
                nodeDetails['hostName'] = node
                nodeDetails['hostAddr'] = self.getAddress(node, 'eth0')
                nodeDetails['containers'] = []
                containers = dockerStats.get(node).split('\n')
                for k,v in enumerate(containers):
                        if k == 0:
                                fieldsNames = v.split(';')
                        else:
                                fields = v.split(';')
                                values = dict(zip(fieldsNames,v.split(';')))
                                nodeDetails['containers'].append(values)
                resultsArray.append(nodeDetails)

        self.resultsArray = resultsArray
        self.resultsJSON  = json.dumps(resultsArray)


    def getAddress(self, node, iface):
        result = self.local.cmd(node, 'cmd.run', ["ifconfig "+iface+" | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"])
        return result.get(node)

    def getResultsArray(self):
        return self.resultsArray

        def getResultsJSON(self):
                return self.resultsJSON

 
class DataView(object):
    exposed = True
    @cherrypy.tools.accept(media='application/json')
    def GET(self):
        ds = DockerStats()
        return ds.resultsJSON
 
def CORS():
    cherrypy.response.headers["Access-Control-Allow-Origin"] = "http://localhost"
 
if __name__ == '__main__':
    conf = {
        '/': {
            'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
            'tools.CORS.on': True,
        }
    }
    cherrypy.tools.CORS = cherrypy.Tool('before_handler', CORS)
    cherrypy.server.socket_host = 'manager'
    cherrypy.quickstart(DataView(), '/stats', conf)
