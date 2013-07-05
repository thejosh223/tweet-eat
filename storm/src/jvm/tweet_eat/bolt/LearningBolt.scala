package tweet_eat.bolt

import backtype.storm.topology.base.BaseRichBolt
import backtype.storm.task.OutputCollector
import backtype.storm.task.TopologyContext
import backtype.storm.topology.OutputFieldsDeclarer
import backtype.storm.tuple.Tuple
import backtype.storm.tuple.Values
import twitter4j.Status
import backtype.storm.tuple.Fields

class LearningBolt extends BaseRichBolt {
    var _collector: OutputCollector = null
    
    private val _happyRegex = """:\)|:D|:-D|:-\)|(:|(-:|<3|awesome|great|excellent|superb|delicious|satisf|ganda|addict|!!!|XD|=)|=D|(=|^.^|^_^""".r
    private val _sadRegex = """:\(|:<|:'\(|:-\(|>:|D:|T.T|horribl|disgust|dirt|shit|barf|poor|\):|\)-:|pangit|puta|pota|pangit|putragis|lintik|punyeta""".r
    
	override def prepare(conf: java.util.Map[_,_], context: TopologyContext, collector: OutputCollector) {
	  _collector = collector
	}
    
    override def execute(tuple: Tuple) {
      val stat: Status = tuple.getValue(0).asInstanceOf[Status]
      val body:String = stat.getText()
    
      val nHappyMatches:Int = _happyRegex.findAllIn(body).size
      val nSadMatches:Int = _sadRegex.findAllIn(body).size
      if (nHappyMatches != nSadMatches) {
        val label: Int = if (nHappyMatches > nSadMatches) 1 else 0
        _collector.emit(tuple, new Values(stat, label.asInstanceOf[AnyRef]))
      }
      _collector.ack(tuple)
    }
     
    override def declareOutputFields(declarer: OutputFieldsDeclarer) {
      declarer.declare(new Fields("tweet", "label"))
    }

}