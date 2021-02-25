// Load the Mongoose module and Schema object
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const AssessmentFeedbackSchema = new Schema({
    courseCode: String,
    courseName: String,
    program: String,
    semester: String,
    expectationClarity: String,
    gradingFairness: String,
    gradingFeedback: String,
    eCentennialUse: Boolean,
    timelyFeedback: Boolean,
    date: {
        type: Date,
        default: Date.now
    },
    student: {
        type: Schema.Types.ObjectId,
        ref: 'Student'
    }
});

mongoose.model('AssessmentFeedback', AssessmentFeedbackSchema);