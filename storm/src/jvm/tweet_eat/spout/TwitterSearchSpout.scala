package tweet_eat.spout

import scala.collection.JavaConversions.asJavaIterator
import scala.collection.JavaConversions.asScalaIterator

import backtype.storm.Config
import backtype.storm.spout.SpoutOutputCollector
import backtype.storm.task.TopologyContext
import backtype.storm.topology.OutputFieldsDeclarer
import backtype.storm.topology.base.BaseRichSpout
import backtype.storm.tuple.Fields
import backtype.storm.tuple.Values
import backtype.storm.utils.Utils
import twitter4j.Query
import twitter4j.QueryResult
import twitter4j.Status
import twitter4j.Twitter
import twitter4j.TwitterFactory
import twitter4j.conf.ConfigurationBuilder

/** Receives and emits tweets according to a search query (as defined in Config) */
class TwitterSearchSpout extends BaseRichSpout {
  var _collector: SpoutOutputCollector = null
  var resultIterator: Iterator[Status] = null
  var earliestIdx:Long = -1
  var twitter: Twitter = null
  var query: Query = null

  override def open(conf: java.util.Map[_, _], context: TopologyContext, collector: SpoutOutputCollector) {
    _collector = collector
    query = new Query(tweet_eat.Config.restaurants.map('"' + _ + '"').mkString(" OR "))
    query.setCount(100)
    query.setResultType(Query.RECENT)
    
    val fact: TwitterFactory = new TwitterFactory(new ConfigurationBuilder()
    	.setOAuthConsumerKey("krVmkXyrdU7SXwHYPsMPCQ")
    	.setOAuthConsumerSecret("RLr2Szy5wCj0x50fp80I9IRsQDtpxxyWnyVYcTKz9s")
    	.setOAuthAccessToken("14140533-PHnyGX196EW7kRrkBbz8Kiy1xg8HE3uUsmjCfYuTg")
    	.setOAuthAccessTokenSecret("xh9Mf04pSzstsMsVKkJ7nmVK5KRHoDCLNDZXLD3iCM").build())
    twitter = fact.getInstance()
    val queryResult = twitter.search(query)
    resultIterator = queryResult.getTweets().iterator()
  }

  override def nextTuple() {
    if (!resultIterator.hasNext()) {
      Utils.sleep(10000)
      query.setMaxId(earliestIdx-1)
      val queryResult = twitter.search(query)
      resultIterator = queryResult.getTweets().iterator()
    }
    val stat = resultIterator.next()
    earliestIdx = if (earliestIdx == -1) stat.getId() else Math.min(stat.getId(), earliestIdx)
    _collector.emit(new Values(stat))

  }

  override def close() {

  }

  override def getComponentConfiguration(): java.util.Map[String, Object] = {
    val ret: Config = new Config()
    ret.setMaxTaskParallelism(1)
    ret
  }

  override def ack(id: AnyRef) {

  }

  override def fail(id: AnyRef) {

  }

  override def declareOutputFields(declarer: OutputFieldsDeclarer) {
    declarer.declare(new Fields("tweet"))
  }
}