package tweet_eat.bolt

import backtype.storm.topology.base.BaseRichBolt
import com.mongodb.casbah.Imports._
import backtype.storm.task.OutputCollector
import backtype.storm.task.TopologyContext
import backtype.storm.topology.OutputFieldsDeclarer
import backtype.storm.tuple.Tuple
import backtype.storm.tuple.Values
import twitter4j.Status
import backtype.storm.tuple.Fields
import com.mongodb.casbah.MongoClient
import com.mongodb.casbah.MongoClientURI

/**
 * Counts the frequency of each word in a bolt
 */
class WordCountBolt extends BaseRichBolt {
    var _collector: OutputCollector = null
    private val splitterRegex = """\W+""".r
    private var mongoClient: MongoClient = null
    
	override def prepare(conf: java.util.Map[_,_], context: TopologyContext, collector: OutputCollector) {
	  _collector = collector
	  
	  mongoClient = MongoClient(MongoClientURI(tweet_eat.Config.dbUri))
	}
    
    private def sigmoid(x: Double): Double = 1.0/(1.0 + Math.exp(-x))
    
    override def execute(tuple: Tuple) {
      val stat: Status = tuple.getValue(0).asInstanceOf[Status]
      val body:String = stat.getText()
      val restaurant:String = tuple.getValue(1).asInstanceOf[String]
      val wordsColl = mongoClient("tweet_eat")("words")
      
      val words = splitterRegex.split(body)
      val nFollowers = stat.getUser().getFollowersCount()
      
      words.foreach((word) => {
    	val lowered = word.toLowerCase()
        wordsColl.update(MongoDBObject("restaurant" -> restaurant, "word" -> lowered), $setOnInsert("count" -> 0), upsert=true)
        wordsColl.update(MongoDBObject("restaurant" -> restaurant, "word" -> lowered), $inc("count" -> 1) ++ $inc("weight" -> sigmoid((nFollowers-1)/10.0)))	
        //_collector.emit(tuple, new Values(stat, restaurant, word, )
      })
        
      
      _collector.ack(tuple)
    }
     
    override def declareOutputFields(declarer: OutputFieldsDeclarer) {
      declarer.declare(new Fields("tweet", "restaurant", "word", "count"))
    }

}