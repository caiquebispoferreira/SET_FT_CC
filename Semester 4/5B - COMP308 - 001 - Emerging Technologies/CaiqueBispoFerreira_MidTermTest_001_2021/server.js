// The server.js file is the main file of your Node.js application 
// It will load the express.js file as a module to bootstrap your Express application
//
//The process.env.NODE_ENV variable is set to the default 'development‘
//value if itdoesn 't exist.
// Set the 'NODE_ENV' variable
process.env.NODE_ENV = process.env.NODE_ENV || 'development';
// Load the module dependencies
const configureMongoose = require('./config/mongoose'),
    configureExpress = require('./config/express');
// Create a new Mongoose connection instance
var db = configureMongoose();
// Create a new Express application instance
var app = configureExpress();
// Use the Express application instance to listen to the '3000' port
app.listen(3000);
// Log the server status to the console
console.log('Server running at http://localhost:3000/');
// Use the module.exports property to expose our Express application instance for external usage
module.exports = app; //returns the application object
