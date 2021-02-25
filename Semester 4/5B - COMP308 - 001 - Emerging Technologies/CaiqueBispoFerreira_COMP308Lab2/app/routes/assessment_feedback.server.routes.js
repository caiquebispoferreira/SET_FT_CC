const assessment_feedbacks = require('../../app/controllers/assessment_feedbacks.server.controller');
const students = require('../../app/controllers/students.server.controller');

module.exports = function (app) {
  app.route('/assessment_feedbacks/:email')
      .get(assessment_feedbacks.list)
  app.param('email', students.studentByEmail)

  app.route('/assessment_feedbacks')
    .get(assessment_feedbacks.list)
    .post(assessment_feedbacks.post)
    
  app.route('/submit_assessment_feedback')
    .get(assessment_feedbacks.submitAssessmentFeedback)
      
  app.route('/thankyou')
    .get(assessment_feedbacks.thankyou);
}