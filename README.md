# OriginStamp-MacOS
Oficial client for the Blockchain-based timestamp service at www.originstamp.org

The OriginStamp Team: André and Bela - http://www.originstamp.org/about

OriginStamp is a non-commercial trusted timestamping service that can be used free of charge and anonymously. Trusted timestamping enables you to prove that you were the originator of an information (e.g. text or any other media file) at a certain time. 
Use cases include proving… 
… a task was completed prior to a certain date. 
… a photo or video has been recorded prior to a certain date. 
… a contract has been signed prior to a certain date. 
… an idea for a patent already existed prior to signing a NDA or prior to a certain date.

How does it work?

Trusted timestamping isn’t new. Even before computers existed information could be hashed and the hash could be published in a newspaper. However, OriginStamp.org allows you to anonymously timestamp information in a tamper proof way within seconds at no costs. 
This is how it works:
Originstamp concept
You submit your content either per email or through your browser. You can use plain text or any file format such as: PDF, MS Word, and audio or a video files. If you use the browser the file is hashed in your browser and only the hash is transmitted to the OriginStamp.org server.
Several times each day, OriginStamp creates a new hash from all submitted hashes. Using Base 58 encoding this hash is then used to create a new Bitcoin address to which the smallest transactionable amount of Bitcoins (0.00000001 BTC) are transferred. By making this transaction the hash is permanently embedded in the distributed Bitcoin blockchain. After the transaction in the blockchain has taken place it is impossible to alter the timestamp of a hash. In addition, the hash is immediately published to twitter.
Now everyone in the world with access to the internet can easily verify the hash either by using this website or by checking, e.g. blockchain.info, or by using the blockchain itself.

This timestamping services uses the cryptographic blockchain of the virtual currency bitcoin. The blockchain was designed to be tamper proof. If they could be manipulated than the whole currency would be worthless. In addition to the blockchain we also publish the hash immediately on twitter.

