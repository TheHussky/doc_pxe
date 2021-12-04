from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
if __name__ == '__main__':
    server_address = ('0.0.0.0', 8000)
    handler=SimpleHTTPRequestHandler
    httpd = ThreadingHTTPServer(server_address, handler)
    print('running server at %s:%d' % server_address)
    
    httpd.serve_forever()