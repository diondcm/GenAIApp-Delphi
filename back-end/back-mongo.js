const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const util = require('./utils.js')

const app = express()
app.use(bodyParser.json())
app.use(cors())


const { MongoClient, ServerApiVersion } = require('mongodb');
const uri = "YOUR-MONGO-URI";

const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: false,
    deprecationErrors: true,
  }
});

const fs = require('fs');
const { OpenAI } = require("openai");
const { title } = require('process')
const openai = new OpenAI({apiKey: "YOUR-OPENAI-API-KEY"});

async function run() {
    try {
        const filePath = 'embedding_result.json';
        let filefouded = false;
        fs.access(filePath, fs.constants.F_OK, (err) => {
            if (err) {
              console.error('File does not exist', err);
              filefouded = false;
              return;
            }
        
            fs.readFile(filePath, 'utf8', (readErr, data) => {
              if (readErr) {
                console.error('Error reading file', readErr);
                filefouded = false;
                return;
              }
        
              try {
                const embedding = JSON.parse(data);
                filefouded = true;
                console.log('Embedding result:', embedding);
              } catch (parseError) {
                console.error('Error parsing JSON', parseError);
              }
            });
        });

        if (!filefouded) {
            const embedding = await openai.embeddings.create({
                model: "text-embedding-ada-002",
                input: "A story about a robot learning to understand human emotions",
                encoding_format: "float",
            });

            fs.writeFile('embedding_result.json', JSON.stringify(embedding, null, 2), (err) => {
                if (err) {
                console.error('Error writing file', err);
                } else {
                console.log('Embedding result saved to embedding_result.json');
                }
            });          
        }

        await client.connect();

        const database = client.db("sample_mflix");
        const coll = database.collection("embedded_movies");

        const agg = [
            {
              '$vectorSearch': {
                'index': 'rrf-vector-search', 
                'path': 'plot_embedding',
                'queryVector': embedding.data[0].embedding, 
                'numCandidates': 150, 
                'limit': 10
              }
            }, {
              '$project': {
                '_id': 0, 
                'plot': 1, 
                'title': 1, 
                'score': {
                  '$meta': 'vectorSearchScore'
                }
              }
            }
          ];
        const result = coll.aggregate(agg);

        for await (const doc of result) {
            console.dir(JSON.stringify(doc));
        }

          
    } finally {
        await client.close();
    }
}

app.listen(8800, () => {
    console.log('Server started');	
})

app.get('/', async (req, res) => {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write("Local server");
    res.end();
})

app.route('/api/embedding_sample').post(
	async (req,res) => { 
	
        const embedding = await openai.embeddings.create({
            model: "text-embedding-ada-002",
            input: req.body.search,
            encoding_format: "float",
        });
        res.send(embedding);
})

app.route('/api/movies').post(
	async (req,res) => { 
	
        await client.connect();

        const database = client.db("sample_mflix");
        const movies = database.collection('embedded_movies');
        const options = {
            limit: 50 
        };
        
        const movieCursor = await movies.find({}, options);
        const movieArray = await movieCursor.toArray();
        let movieList = [];
        for (const doc of movieArray) {
            movieList.push({ _id: doc._id, title: doc.title, plot: doc.plot, poster: doc.poster} );
        }

        res.send(movieList);
		
})	

app.route('/api/embedded_movies').post(
	async (req,res) => { 
	
        const embedding = await openai.embeddings.create({
            model: "text-embedding-ada-002",
            input: req.body.search,
            encoding_format: "float",
        });

        await client.connect();

        const database = client.db("sample_mflix");
        const coll = database.collection("embedded_movies");

        const agg = [
            {
              '$vectorSearch': {
                'index': 'rrf-vector-search', 
                'path': 'plot_embedding',
                'queryVector': embedding.data[0].embedding, 
                'numCandidates': 150, 
                'limit': 10
              }
            }, {
              '$project': {
                '_id': 0, 
                'plot': 1, 
                'title': 1, 
                'score': {
                  '$meta': 'vectorSearchScore'
                }
              }
            }
          ];
        const result = coll.aggregate(agg);

        let movieList = [];
        for await (const doc of result) {
            movieList.push({ _id: doc._id, title: doc.title, plot: doc.plot, poster: doc.poster} );
        }

        res.send(movieList);
        		
})	

app.route('/api/movies_email').post(
	async (req,res) => { 
	
        const embedding = await openai.embeddings.create({
            model: "text-embedding-ada-002",
            input: req.body.search,
            encoding_format: "float",
        });
          
        await client.connect();

        const database = client.db("sample_mflix");
        const coll = database.collection("embedded_movies");

        const agg = [
            {
              '$vectorSearch': {
                'index': 'rrf-vector-search', 
                'path': 'plot_embedding',
                'queryVector': embedding.data[0].embedding, 
                'numCandidates': 150, 
                'limit': 10
              }
            }, {
              '$project': {
                '_id': 0, 
                'plot': 1, 
                'title': 1, 
                'score': {
                  '$meta': 'vectorSearchScore'
                }
              }
            }
          ];
        const result = coll.aggregate(agg);

        let movieList = [];
        for await (const doc of result) {
            movieList.push({ _id: doc._id, title: doc.title, plot: doc.plot, poster: doc.poster} );
        }

        const response = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [{ role: 'user', content: 'Create a short formal selling email, based on this movie list: ' +  JSON.stringify(movieList)}], 
            temperature: 0.7,
          });

        res.send(response.choices[0].message.content);
        		
})	


