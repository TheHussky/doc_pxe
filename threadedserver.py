from http.server import HTTPServer, ThreadingHTTPServer, SimpleHTTPRequestHandler
import socketserver
def server():
    server_address = ('0.0.0.0', 8000)
    class ThreadingHTTPServer(socketserver.ThreadingMixIn, HTTPServer):
            pass
    httpd = ThreadingHTTPServer(server_address, SimpleHTTPRequestHandler)
    httpd.serve_forever()
if __name__=="__main__":
    server()