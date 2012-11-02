myUtil = require '../util'
decodeHTML = (require 'entities').decodeHTML5

root_url = 'http://jwc.scu.edu.cn/jwc/frontPage.action'
exports.urls = urls = ["http://jwc.scu.edu.cn/jwc/frontPage.action"]

exports.newsUrlFormat = newsUrlFormat = "newsShow\\\.action\\\?news\\\.id=(\\\d+)"

exports.mapper = (path) =>
  cmpValue = (path.match (new RegExp(newsUrlFormat)))[1]
  [myUtil.buildUrl(root_url, path), parseInt(cmpValue)]

exports.getTitle = (html) ->
  html = html.toString()
  title_regex = /<td align="center" style="font-size:24px"><b>(.*?)<\/b><\/td>/

  title = (html.match title_regex)[1]
  return decodeHTML(title)



exports.getContent = (html) ->
  html = html.toString()
  body_regex = /<input type="hidden" name="news.content" value="([\s\S]*?)" id="news_content"\/>/

  body = (html.match body_regex)[1]

  attachment_regex = /(<table width="900" border="0" cellspacing="0" cellpadding="0" align="center">\s+<tr><td colspan="2"><hr><\/td><\/tr>[\s\S]*?<\/table>)/

  attachment_content = (html.match attachment_regex)
  return decodeHTML(body + attachment_content)

