fs = require 'fs'

fetcher_file = '../fetchers/jwc.scu.edu.cn'
page_file = 'jwc.html'

fetcher = require fetcher_file
mainFetcher = require '../mainFetcher'

fileContent = fs.readFileSync page_file, 'utf-8'

news_urls = fileContent.match(new RegExp(fetcher.newsUrlFormat, 'g'))
console.log "urls: #{news_urls.join("\n")}"

{urls, newsUrlFormat, mapper, getTitle, getContent} = fetcher
for url in urls
  console.log [url, newsUrlFormat, mapper, getTitle, getContent]

console.log (news_urls.map fetcher.mapper)

console.log 'end.....'




