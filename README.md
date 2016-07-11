# sentiment_api

forman start will run the api on localhost:5000

```
api url
http://nlp.carma.com 

end points
 - get '/'    # gives u a status (i am up)
 - post '/sentiment'#up just sentiment
 - post '/summary'# just summary
 - post '/summary_sentiment' #summarizes the text and then calcualtes
   sentiment
 - post '/all'          # does all above post and gives u a summary,
   sentiment and summarized sentiment

 ```



 ```
 required headers
 Accept: application/json
 Content-Type: application/json


 get end point does require authentication
 post goes in header
 Authorization: Token=cc628bs56kv1qf2wf32jyk4h0000gn
 ```
