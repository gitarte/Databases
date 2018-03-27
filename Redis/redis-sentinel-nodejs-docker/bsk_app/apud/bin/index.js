let os           = require('os');
let express      = require('express');
let bodyParser   = require('body-parser');
let cookieParser = require('cookie-parser');
let session      = require('express-session');
let path         = require('path');
let cassandra    = require('cassandra-driver');
let Redis        = require('ioredis');
let RedisStore   = require('connect-redis')(session);

//	Redis client
let redisClient = new Redis({
	'sentinels' : [
		{ 'host': 'node1.localdomain', 'port': 26379 },
		{ 'host': 'node2.localdomain', 'port': 26379 },
		{ 'host': 'node3.localdomain', 'port': 26379 }
	],
	'password'  : 'stupidpassword3',
	'name'      : 'myRedisMaster'
});

//	Cassandra client
let cassaClient = new cassandra.Client({
	'contactPoints' : [
		'node1.localdomain',
		'node2.localdomain',
		'node3.localdomain'
	],
	'keyspace' : 'bsk'
});
//	settings
let  app = express();
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());
app.use(cookieParser('jhbOUHB807JKBH87yjhjboBHjhbOUHB807JKBH87yjhjboBH'));
app.use(
	session({
		'secret': 'jhbOUHB807JKBH87yjhjboBHjhbOUHB807JKBH87yjhjboBH',
		'store' : new RedisStore({
			'client': redisClient,
			'pass'  : 'stupidpassword3'
		}),
		'resave'           : false,
		'saveUninitialized': true
	})
);
app.set('view engine', 'ejs');
app.set('views',       path.join(__dirname, '../', 'views'));
app.use('/static',     express.static(path.join(__dirname, '../', 'static')));

//	custom middleware that provides access to DB's
app.use(function(req, res, next){
	req.redisClient = redisClient;
	req.cassaClient = cassaClient;
	return next();
});
//	custom middleware for authentication
let auth = function(req, res, next) {
	if (req.session && req.session.auth) {
		return next();
	} else {
		return res.render('login', {
			"msg" : "Please log in"
		});
	}
};

//	routing
app.get('/', auth, function(req, res){
	const query = 'SELECT time,src,dst,title,value FROM app ORDER BY time;';
	req.cassaClient.execute(query, [], function(err, result) {
		data = []
		if (err) {
			console.log(err);
		} else {
                	rows = result.rows;
	                for (let i in rows) {
        	                row = {
                	                'time' : rows[i].time,
                        	        'src'  : rows[i].src,
                                	'dst'  : rows[i].dst,
	                                'title': rows[i].title,
        	                        'value': rows[i].value
                	        };
                        	data.push(JSON.stringify(row));
	                }
        	        data = data.sort().reverse().slice(0,9);

			for (let i in data) {
				data[i] = JSON.parse(data[i])
			}
        	}	

                res.render('index',{
                        'hostname': os.hostname(),
                        'data'    : data
                });
	});

	/*	
	req.redisClient.lrange('bsk_state', -10, -1, function(err, data){
		for (let i in data) {
			data[i] = JSON.parse(data[i]);
		}

		res.render('index',{
			'hostname': os.hostname(),
			'data'    : data
		});
	});
	*/
});

//	login and logout routing
app.get('/login',function(req, res){
	res.render('login');
});
app.post('/login',function(req, res){
	var u = req.body.username;
	var p = req.body.password;
	if (u === 'art' && p === 'gaw') {
		req.session.auth = true;
		res.redirect("/");
	} else {
		res.render('login', {
			"msg" : "Bad credentials"
		});
	}
});
app.get('/logout', function(req, res){
	if(req.session.key) {
		req.session.destroy(function(){
			res.redirect('/login');
		});
	} else {
		res.redirect('/login');
	}
});

//	starting app
app.listen(8080,function(){});
