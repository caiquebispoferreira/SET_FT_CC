// using the ref to reference another document
//
// Load the Mongoose module and Schema object
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const StudentSchema = new Schema({
    firstName: String,
    lastName: String,
    favouriteSubject: String,
    strongestTechnicalSkill: String,
    email: {
        type: String,
        index: true,
        match: /.+\@.+\..+/
    },
    password: {
        type: String,
        validate: [
            (password) => password.length >= 6,
            'Password Should Be Longer'
        ]
    }    
});

mongoose.model('Student', StudentSchema);
