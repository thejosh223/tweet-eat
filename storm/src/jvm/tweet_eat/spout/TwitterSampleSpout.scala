package tweet_eat.spout

import twitter4j.TwitterStream
import backtype.storm.topology.base.BaseRichSpout
import backtype.storm.spout.SpoutOutputCollector
import java.util.concurrent.LinkedBlockingQueue
import backtype.storm.topology.OutputFieldsDeclarer
import backtype.storm.task.TopologyContext
import backtype.storm.Config
import backtype.storm.tuple.Fields
import twitter4j.Status
import twitter4j.TwitterStreamFactory
import twitter4j.StatusListener
import twitter4j.conf.ConfigurationBuilder
import twitter4j.StatusDeletionNotice
import backtype.storm.tuple.Values
import backtype.storm.utils.Utils
import twitter4j.StallWarning

/** Receives and emits tweets from Twitter's public sample stream */
class TwitterSampleSpout extends BaseRichSpout {
  var _collector: SpoutOutputCollector = null
  var queue: LinkedBlockingQueue[Status] = null
  var _twitterStream: TwitterStream = null

  override def open(conf: java.util.Map[_, _], context: TopologyContext, collector: SpoutOutputCollector) {
    queue = new LinkedBlockingQueue[Status](1000)
    _collector = collector
    val listener: StatusListener = new StatusListener() {
      override def onStatus(status: Status) {
        queue.offer(status)
      }

      override def onDeletionNotice(sdn: StatusDeletionNotice) {

      }

      override def onTrackLimitationNotice(i: Int) {

      }

      override def onScrubGeo(l: Long, l1: Long) {

      }

      override def onException(e: Exception) {

      }
      override def onStallWarning(e: StallWarning) {
        
      }
    }
    val fact: TwitterStreamFactory = new TwitterStreamFactory(new ConfigurationBuilder().setOAuthConsumerKey("krVmkXyrdU7SXwHYPsMPCQ").setOAuthConsumerSecret("RLr2Szy5wCj0x50fp80I9IRsQDtpxxyWnyVYcTKz9s").setOAuthAccessToken("14140533-PHnyGX196EW7kRrkBbz8Kiy1xg8HE3uUsmjCfYuTg").setOAuthAccessTokenSecret("xh9Mf04pSzstsMsVKkJ7nmVK5KRHoDCLNDZXLD3iCM").build())
    _twitterStream = fact.getInstance()
    _twitterStream.addListener(listener)
    _twitterStream.sample()
  }

  override def nextTuple() {
	val ret: Status = queue.poll()
    if (ret == null) {
      Utils.sleep(50)
    } else {
      _collector.emit(new Values(ret))
    }
  }

  override def close() {
	  _twitterStream.shutdown()	
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