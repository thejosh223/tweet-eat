package tweet_eat.bolt

import backtype.storm.topology.base.BaseRichBolt
import backtype.storm.task.OutputCollector
import backtype.storm.task.TopologyContext
import backtype.storm.topology.OutputFieldsDeclarer
import backtype.storm.tuple.Tuple
import backtype.storm.tuple.Values
import twitter4j.Status
import backtype.storm.tuple.Fields
import com.mongodb.casbah.MongoClient

/**
 * Labels a tweet as belonging to a restaurant
 */
class RestaurantLabellingBolt extends BaseRichBolt {
    var _collector: OutputCollector = null
    var wordCounts: collection.mutable.Map[String, Int] = new collection.mutable.HashMap[String, Int]()
    private val splitterRegex = """\W""".r
    
	override def prepare(conf: java.util.Map[_,_], context: TopologyContext, collector: OutputCollector) {
	  _collector = collector
	}
    
    override def execute(tuple: Tuple) {
      val stat: Status = tuple.getValue(0).asInstanceOf[Status]
      val body:String = stat.getText()
  
      tweet_eat.Config.restaurants.foreach((restaurant) => {
        if (body.toLowerCase().indexOf(restaurant.toLowerCase()) != -1) {
          _collector.emit(tuple, new Values(stat, restaurant))
        }
      })

      _collector.ack(tuple)
    }
     
    override def declareOutputFields(declarer: OutputFieldsDeclarer) {
      declarer.declare(new Fields("tweet", "restaurant"))
    }

}