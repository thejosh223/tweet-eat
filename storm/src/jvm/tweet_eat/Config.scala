package tweet_eat

/** Configuration for the tweet eat storm */
object Config {
	var dbUri: String = "mongodb://localhost:27017/"
	val dbCheckFreq = 100
	val restaurants = Array[String]("Mang Inasal", "Dencio's", "Razon's")
}