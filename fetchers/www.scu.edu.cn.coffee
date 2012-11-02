myUtil = require '../util'
Iconv = (require 'iconv').Iconv
$ = require 'jquery'

iconv = new Iconv('gbk', 'utf-8')

root_url = 'http://www.scu.edu.cn/'
exports.urls = urls = ["http://www.scu.edu.cn/", "http://www.scu.edu.cn/news/index.htm"]

# /news/cdxw/webinfo/2012/10/1343288846096372.htm
# /news/zt/rw/webinfo/2012/07/1340671841429294.htm
# /news/xsdt/webinfo/2012/06/1340067507504618.htm
# /news/jjxy/webinfo/2012/10/1343288843919362.htm
exports.newsUrlFormat = newsUrlFormat = "/(?:\\\w+\\\/){1,4}webinfo/\\\d+/\\\d+/(\\\d+).\\\w{3}"

exports.mapper = (path) =>
  cmpValue = (path.match (new RegExp(newsUrlFormat)))[1]
  [myUtil.buildUrl(root_url, path), parseInt(cmpValue)]

getdom = (html) ->
  html = iconv.convert(html).toString()
  html = html.replace /<%.*?%>/g, ''
  dom = $(html)

exports.getTitle = (html) ->
  dom = getdom(html)
  title = dom.find('td.borderCCCC table tbody tr td span').html()
  return title


exports.getContent = (html) ->
  dom = getdom(html)
  body = dom.find('#BodyLabel').html()
  return body


