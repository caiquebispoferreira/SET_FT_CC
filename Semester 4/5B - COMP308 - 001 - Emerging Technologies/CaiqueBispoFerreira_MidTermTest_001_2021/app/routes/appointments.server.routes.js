//Load the index controller
const index = require('../controllers/index.server.controller');
// Load the 'appointments' controller
const appointments = require('../controllers/appointments.server.controller');

// Define the routes module' method
module.exports = function (app) {
    // Set up the 'users' base routes
    //
    //show the 'index' page if a GET request is made to root
    app.route('/').get(index.render);
    //show the 'add_appointment' page if a GET request is made to /appointments
    app.route('/appointments').get(index.renderAdd);
    
    // a post request to /appointments will execute createAppointment method in appointments.server.controller
    app.route('/appointments').post(appointments.createAppointment);

    app.route('/list_appointments').get(appointments.readAppointments);

    // Set up the 'courses' parameterized routes
    app.route('/list_appointments/:cardNumber').get(appointments.read).delete(appointments.deleteByCardNumber)
    
    app.param('cardNumber', appointments.findAppointmentByCardNumber);

    
};
