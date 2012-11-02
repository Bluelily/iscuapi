iscuapi
=

这是为 http://iscu.sinaapp.com/ 做的 API，可惜的是，不知该去哪个云平台让它跑起来。本地倒是运行得不错。

requirements
==

mongodb >= 1.8
nodejs >= 0.6

本地运行
==

本地第一次运行时，先运行 initDB.js。再运行 mainFetcher.js。

默认是抓取 www.scu.edu.cn 和 jwc.scu.edu.cn 两个地方。

添加新的 fetcher
==

fetcher 就是用来判断所抓取的网页该如何处理的模块，逻辑很简单，见 fetchers 文件夹的两个示例。

增加新的 fetcher 文件后，要手动去 db.status 里面 insert 相应的条目，才可让 fetcher 被自动触发。具体可查看 db.status 里面的两个示例。
