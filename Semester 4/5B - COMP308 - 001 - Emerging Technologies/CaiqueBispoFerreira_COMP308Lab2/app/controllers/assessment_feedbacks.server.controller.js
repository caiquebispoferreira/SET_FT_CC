var AssessmentFeedback = require('mongoose').model('AssessmentFeedback');
var Student = require('mongoose').model('Student');

exports.list = function (req, res, next) { 
    var student = req.student   
    console.log("student",JSON.stringify(student))
    
    if (student != null){
        AssessmentFeedback.find({student: student.id}, (err, assessment_feedbacks) => {
            if (err) { return getErrorMessage(err); }
            //res.json(assessment_feedbacks);
            console.log("assessment_feedbacks",JSON.stringify(assessment_feedbacks))
            res.render('assessment_feedbacks', {
                title : "Assessment Feedbacks by "+ student.email,
                assessment_feedbacks: assessment_feedbacks,
                email: student.email
            });
        });
    } else {
        res.render("assessment_feedbacks", {
            title : "Assessment Feedback Page",
            assessment_feedbacks : [], 
            email : req.session.email   
        });
    }

};


exports.submitAssessmentFeedback = function (req, res){
    var session = req.session;
    console.log("rendering submit_assessment_feedback page")
    res.render("submit_assessment_feedback", {
        title : "Submit an assessment feedback",
        email : session.email,   
        studentId : session.studentId,
        studentLastName : session.studentLastName,
        studentFirstName : session.studentFirstName
    }); 
}




exports.post  = function (req, res, next) {
    var feedback = new AssessmentFeedback(req.body); 
    console.log("body: " + JSON.stringify(req.body));

    feedback.save(function (err) {
        if (err) {
            return next(err);
        } else {
            var session = req.session;
            session.email = req.body.email;
            session.courseCode = req.body.courseCode;
            session.courseName = req.body.courseName;

            res.redirect("thankyou");
        }
    });    
}



exports.thankyou = function(req, res){
    var session = req.session;

    res.render("thankyou", {
        title: "Thank You Page",
        email: session.email,
        courseCode : session.courseCode,
        courseName : session.courseName,
    });
}