// Load the Mongoose module and Schema object
var mongoose = require('mongoose'),
    Schema = mongoose.Schema;
// Define a new 'AppointmentSchema'
var AppointmentSchema = new Schema({
    cardNumber: { type: String, unique: true, required: true },
    vaccineSite: String,
    priorityArea: {
        type: String,
        enum: ['80+', 'Healthcare', 'Essential']
    },
    dateTime:  {
        type: Date,
        default: Date.now
    },
    cancelled: Boolean
});

mongoose.model('Appointment', AppointmentSchema);
