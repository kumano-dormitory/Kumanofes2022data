require 'webrick'

srv = WEBrick::HTTPServer.new({
  DocumentRoot:   './html',
  BindAddress:    '127.0.0.1',
  Port:           8080,
})

srv.mount('/Kumanofes2022data', WEBrick::HTTPServlet::FileHandler, './docs')

srv.start