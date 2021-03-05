// Load the 'Appointment' Mongoose model
var Appointment = require('mongoose').model('Appointment');

// Create a new 'createAppointment' controller method
exports.createAppointment = function (req, res, next) {
    // Create a new instance of the 'Appointment' Mongoose model
    var appointment = new Appointment(req.body);
    // Use the 'Appointment' instance's 'save' method to save a new appointment document
    appointment.save(function (err) {
        if (err) {
            // Call the next middleware with an error message
            return next(err);
        } else {
            // Use the 'response' object to send a JSON response
            res.redirect("/list_appointments");
        }
    });
};

// Create a new 'readAppointments' controller method
exports.readAppointments = function (req, res, next) {
    console.log('in readAppointments')
    // Use the 'Appointment' static 'find' method to retrieve the list of items
    Appointment.find({}, function (err, appointments) {
        console.log(appointments)
        if (err) {
            // Call the next middleware with an error message
            console.log('some error in readAppointment method')
            return next(err);
        } else {
            //
            res.render('appointments', {
                title: 'Appointments',
                appointments: appointments
            });
        }
    });
};


// 'read' controller method to display a appointment
exports.read = function(req, res) {
	// Use the 'response' object to send a JSON response
	res.json(req.appointment);
};


exports.deleteByCardNumber = function (req, res, next) {
    console.log("deleteByAppointmentId")
    
    Appointment.findOneAndDelete({ cardNumber : req.params.cardNumber}, (err, appointment) => {
        if (err) {
            console.log(err);
            // Call the next middleware with an error message
            return next(err);
        } else {
            console.log(appointment);
        
            // Use the 'response' object to send a JSON response
            res.redirect('/list_appointments'); //display all appointments
        }
    })
};

// ‘findAppointmentByAppointmentId’ controller method to find a appointment by its appointment id
exports.findAppointmentByCardNumber = function (req, res, next, cardNumber) {
	// Use the 'Course' static 'findOne' method to retrieve a specific appointment
	Appointment.findOne({
		cardNumber: cardNumber //using the appointment id instead of id
	}, (err, appointment) => {
		if (err) {
			// Call the next middleware with an error message
			return next(err);
		} else {
			// Set the 'req.appointment' property
            req.appointment = appointment;
            console.log(appointment);
			// Call the next middleware
			next();
		}
	});
};
