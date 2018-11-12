'use strict'; //use stricter rules,(eg: need to decalre variable first)
const
    bodyParser = require('body-parser'),
    config = require('config'),//hiding password
    express = require('express'),
    request = require('request');//mimic website server

var app = express();//determine language
var port = process.env.PORT || process.env.port || 5000;//port may be capital or small size
app.set('port',port);
app.use(bodyParser.json());//structure are json
const MOVIE_API_KEY = config.get('MovieDB_API_Key');

app.listen(app.get('port'),function(){
    console.log('[app.listen]Node app is running on port',app.get('port'));
});//use the port to provide service

module.exports = app;

//main application
app.post('/webhook',function(req, res){//when append '/webhook', start application
    let data = req.body;
    let queryMovieName = data.queryResult.parameters.MovieName;//get movie name
    let propertiesObject = {
        query:queryMovieName,
        api_key:MOVIE_API_KEY,
        language:"zh-TW"//assign language
    };
    request({
        uri:"http://api.themoviedb.org/3/search/movie?",
        json:true,
        qs:propertiesObject
    },function(error, response, body){
        if(!error && response.statusCode == 200){ //if successful, it would return 200
            if(body.results.length!=0){ // To confirm got data or not
                var thisFulfillmentMessages=[];
                var movieTitleObject={};
                //get the first data
                if(body.results[0].title == queryMovieName){ // To confirm exectly the same or not
                    movieTitleObject.text={text:[body.results[0].title]};
                }else{
                    movieTitleObject.text={text:["系統內最相關的電影是"+body.results[0].title]};
                }
                thisFulfillmentMessages.push(movieTitleObject);
                //need to consider the situation that data is not found or lost
                //use if to protect the program to run
                if(body.results[0].overview){ // To confirm if there exists movie introduction
                    var movieOverViewObject={};
                    movieOverViewObject.text={text:[body.results[0].overview]};
                    thisFulfillmentMessages.push(movieOverViewObject);
                }
                if(body.results[0].poster_path){ // To confirm if there exists movie poster image
                    var movieImageObject={};
                    movieImageObject.image={imageUri:"https://image.tmdb.org/t/p/w185/"+body.results[0].poster_path};
                    thisFulfillmentMessages.push(movieImageObject);
                }
                res.json({fulfillmentMessages:thisFulfillmentMessages});
            }else{
                res.json({fulfillmentText:"很抱歉，系統裡面沒有這部電影"});
            }
        }else{
            console.log("[the MovieDB] failed");
        }
    });
});