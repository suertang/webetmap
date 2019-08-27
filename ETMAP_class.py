# coding: utf-8
from bottle import route, run,static_file
from bottle import request,view
import ProcessET

@route('/')
@view('abc')
def upload():
    pass

@route('/', method = 'POST')
def do_upload():
    uploads = request.files.getall('data[]')
    a=ProcessET.gen(uploads)
    qlist=[float(x) for x in request.POST.get('qlist').split(',')]
    
    return a.json_gen(qlist)
  
@route('/<name:re:images|css|js>/<path:path>')
def static_img(name,path):
    return static_file(path,root="./"+name)

@route('/favicon.ico')
def fav():
    return static_file("favicon.ico",root="./")



#run(host='0.0.0.0', port=8080, debug=True)
run(host='0.0.0.0', port=8080, debug=True,server='cherrypy')