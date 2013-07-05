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

/** Generates a noisy sentiment label for a tweet */
class NoisyLabelBolt extends BaseRichBolt {
    var _collector: OutputCollector = null
    private val _happyRegex = """:\)|:D|:-D|:-\)|\(:|\(-:|<3|awesome|great|excellent|superb|delicious|satisf|ganda|addict|!!!|XD|=\)|=D|\(=|^[.]^|^_^|love|amazing|fun|best""".r
    private val _sadRegex = """:\(|:<|:'\(|:-\(|>:|D:|T[.]T|horribl|disgust|dirt|shit|barf|poor|\):|\)-:|pangit|puta|pota|pangit|putragis|lintik|punyeta|suck|worst""".r
    private var mongoClient: MongoClient = null
    
	override def prepare(conf: java.util.Map[_,_], context: TopologyContext, collector: OutputCollector) {
	  _collector = collector
	  
	  mongoClient = MongoClient(MongoClientURI(tweet_eat.Config.dbUri))
	}
    
    
    
    override def execute(tuple: Tuple) {
      val stat: Status = tuple.getValue(0).asInstanceOf[Status]
      val body:String = stat.getText()
      val restaurant: String = tuple.getValue(1).asInstanceOf[String]
    
      val nHappyMatches:Int = _happyRegex.findAllIn(body.toLowerCase()).size
      val nSadMatches:Int = _sadRegex.findAllIn(body.toLowerCase()).size
      if (nHappyMatches != nSadMatches) {
        val label: Int = (if (nHappyMatches > nSadMatches) 1 else 0)
        mongoClient("tweet_eat")("restaurants").update(MongoDBObject("name" -> restaurant),
            $setOnInsert("nHappy" -> 0, "nSad" -> 0),
            upsert=true)
        mongoClient("tweet_eat")("restaurants").update(MongoDBObject("name" -> restaurant), $inc("nHappy" -> label, "nSad" -> (label^1)))
        try {
        	mongoClient("tweet_eat")("tweets").insert(MongoDBObject("_id" -> stat.getId(), "restaurant" -> restaurant, "label" -> label, "body" -> body, "retweets" -> stat.getRetweetCount(), "followers" -> stat.getUser().getFollowersCount()))
        } catch {
          // pass
          case _: Throwable => 
        }
        //_collector.emit(tuple, new Values(stat, tuple.getValue(1), label.asInstanceOf[AnyRef]))
      }
      _collector.ack(tuple)
    }
     
    override def declareOutputFields(declarer: OutputFieldsDeclarer) {
      declarer.declare(new Fields("tweet", "restaurant", "label"))
    }

}