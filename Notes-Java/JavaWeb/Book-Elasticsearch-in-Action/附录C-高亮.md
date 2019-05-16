# 附录C 高亮

## C.1 高亮的基础

```json
// 高亮两个字段中的词条
GET/POST localhost:9200/_search
{
	"query": {
		"query_string": {
			"query": "中国人民共和国国歌"
		}
	},
	"highlight": {
        // 指定需要高亮的字段
		"fields": {
			"name":{},
			"title":{}
		}
	}
}

// 结果
{
    "took": 35,
    "timed_out": false,
    "_shards": {
        "total": 5,
        "successful": 5,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": 3,
        "max_score": 1.380382,
        "hits": [
            {
                "_index": "book",
                "_type": "_doc",
                "_id": "6",
                "_score": 1.380382,
                "_source": {
                    "title": "中国人民共和国国歌"
                },
                "highlight": {
                    "title": [
                        "<em>中国人民</em><em>共和国</em><em>国歌</em>"
                    ]
                }
            },
            {
                "_index": "book",
                "_type": "_doc",
                "_id": "5",
                "_score": 0.5753642,
                "_source": {
                    "title": "中国人民共和国"
                },
                "highlight": {
                    "title": [
                        "<em>中国人民</em><em>共和国</em>"
                    ]
                }
            },
            {
                "_index": "book",
                "_type": "_doc",
                "_id": "4",
                "_score": 0.21110918,
                "_source": {
                    "title": "中国人民"
                },
                "highlight": {
                    "title": [
                        "<em>中国人民</em>"
                    ]
                }
            }
        ]
    }
}
```

### C.1.1 应该让用户看到什么

```json
// 使用 no_match_size 参数，强制高亮器返回所需的字段
GET localhost:9200/_search
{
	"query": {
		"query_string": {
			"query": "Elasticsearch"
		}
	},
	"highlight": {
        // 对于没有匹配的字段，最多显示 100 个字符
		"no_match_size": "100",
		"fields": {
			"title":{},
			"description":{}
		}
	},
    // 在高亮字段中，已经拥有了全部所需信息，所以可以关闭 _source 字段
	"_source": false
}
```

## C.2 高亮选项

### C.2.1 碎片的大小、顺序和数量

```json
// 全局和基于具体字段的 fragment_size
GET localhost:9200/_search
{
	"query": {
		"match": {
			"description": "Elasticsearch"
		}
	},
	"highlight": {
        // 全局性的碎片大小设置对于所有字段都有效
		"fragment_size": 10,
		"fields": {
			"description": {
                // 基于具体字段的碎片大小会覆盖全局设置
				"fragment_size": 100
			}
		}
	},
	"_source": false
}
// 结果
{
    "took": 29,
    "timed_out": false,
    "_shards": {
        "total": 32,
        "successful": 32,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": 9,
        "max_score": 1.0187805,
        "hits": [
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "112",
                "_score": 1.0187805,
                "_routing": "5",
                "highlight": {
                    "description": [
                        "We will discuss using <em>Elasticsearch</em> to index data in real time"
                    ]
                }
            },
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "114",
                "_score": 0.9906495,
                "_routing": "5",
                "highlight": {
                    "description": [
                        "We will walk through using Hadoop with <em>Elasticsearch</em> for big data crunching!"
                    ]
                }
            },
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "113",
                "_score": 0.9640304,
                "_routing": "5",
                "highlight": {
                    "description": [
                        "Representatives from Rangespan and Exonar will come and discuss how they use <em>Elasticsearch</em>"
                    ]
                }
            },
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "2",
                "_score": 0.8498512,
                "highlight": {
                    "description": [
                        "Get together to learn more about using <em>Elasticsearch</em>, the applications and neat things you can do with"
                    ]
                }
            },
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "104",
                "_score": 0.83018583,
                "_routing": "2",
                "highlight": {
                    "description": [
                        "A get together to talk about different ways to query <em>Elasticsearch</em>, what works best for different kinds"
                    ]
                }
            },
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "103",
                "_score": 0.72897595,
                "_routing": "2",
                "highlight": {
                    "description": [
                        "We can meet and greet and I will present on some <em>Elasticsearch</em> basics and how we use it."
                    ]
                }
            },
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "3",
                "_score": 0.43250346,
                "highlight": {
                    "description": [
                        "<em>Elasticsearch</em> group for ES users of all knowledge levels"
                    ]
                }
            },
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "108",
                "_score": 0.34545875,
                "_routing": "3",
                "highlight": {
                    "description": [
                        "We can piggyback on training by <em>Elasticsearch</em> to have some Q&A time with the ES devs"
                    ]
                }
            },
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "107",
                "_score": 0.30686,
                "_routing": "3",
                "highlight": {
                    "description": [
                        "Get a deep dive for what <em>Elasticsearch</em> is and how it can be used for logging with Logstash as well as"
                    ]
                }
            }
        ]
    }
}
```

### C.2.2 高亮标签和碎片编码

```json
// 定制高亮标签
GET localhost:9200/_search
{
	"query": {
		"match": {
			"description": "Elasticsearch"
		}
	},
	"highlight": {
		"pre_tags": ["<b>"],
		"post_tags": ["</b>"],
		"fields": {
			"description": {}
		}
	},
	"_source": false,
	"size": "2"
}
// 结果
{
    "took": 33,
    "timed_out": false,
    "_shards": {
        "total": 32,
        "successful": 32,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": 9,
        "max_score": 1.0187805,
        "hits": [
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "112",
                "_score": 1.0187805,
                "_routing": "5",
                "highlight": {
                    "description": [
                        "We will discuss using <b>Elasticsearch</b> to index data in real time"
                    ]
                }
            },
            {
                "_index": "get-together",
                "_type": "_doc",
                "_id": "114",
                "_score": 0.9906495,
                "_routing": "5",
                "highlight": {
                    "description": [
                        "We will walk through using Hadoop with <b>Elasticsearch</b> for big data crunching!"
                    ]
                }
            }
        ]
    }
}
```

