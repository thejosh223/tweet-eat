package tweet_eat.bolt

import backtype.storm.topology.base.BaseRichBolt
import backtype.storm.task.OutputCollector
import backtype.storm.task.TopologyContext
import backtype.storm.topology.OutputFieldsDeclarer
import backtype.storm.tuple.Tuple
import backtype.storm.tuple.Values
import twitter4j.Status
import backtype.storm.tuple.Fields

/**
 * Extracts features from a tweet
 */
class FeatureExtractorBolt extends BaseRichBolt {
    var _collector: OutputCollector = null
    
	override def prepare(conf: java.util.Map[_,_], context: TopologyContext, collector: OutputCollector) {
	  _collector = collector
	}
    
    override def execute(tuple: Tuple) {
      val stat: Status = tuple.getValue(0).asInstanceOf[Status]
      val body:String = stat.getText()
  
      _collector.emit(tuple, new Values(stat))
      _collector.ack(tuple)
    }
     
    override def declareOutputFields(declarer: OutputFieldsDeclarer) {
      declarer.declare(new Fields("tweet", "features"))
    }

}