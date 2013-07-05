package tweet_eat;

import backtype.storm.LocalCluster
import backtype.storm.StormSubmitter
import backtype.storm.topology.TopologyBuilder
import tweet_eat.bolt.NoisyLabelBolt
import tweet_eat.bolt.RestaurantLabellingBolt
import tweet_eat.bolt.WordCountBolt
import tweet_eat.spout.TwitterFilterSpout
import tweet_eat.spout.TwitterSearchSpout

/**
 * This topology receives tweets and performs rudimentary sentiment analysis and word counts.
 */
object TweetEatTopology extends App {
    
        val builder = new TopologyBuilder();
        
        // in production, this will be a TwitterFilterSpout
        builder.setSpout("spout", new TwitterSearchSpout(), 1);
        
        
        builder.setBolt("restaurant", new RestaurantLabellingBolt, 10)
                 .shuffleGrouping("spout");
        builder.setBolt("label", new NoisyLabelBolt(), 10)
        		.shuffleGrouping("restaurant")
        builder.setBolt("count", new WordCountBolt(), 10)
        	.shuffleGrouping("restaurant");

        val conf = new backtype.storm.Config();
        conf.setDebug(true);

        
        if(args!=null && args.length > 0) {
            conf.setNumWorkers(3);
            
            StormSubmitter.submitTopology(args(0), conf, builder.createTopology());
        } else {        
            conf.setMaxTaskParallelism(3);

            val cluster = new LocalCluster();
            cluster.submitTopology("tweet-eat", conf, builder.createTopology());
        
            Thread.sleep(1000000000);

            cluster.shutdown();
        
    }
}
