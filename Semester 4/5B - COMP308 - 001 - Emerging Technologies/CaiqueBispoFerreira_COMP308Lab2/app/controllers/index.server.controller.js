var Student = require('mongoose').model('Student');

exports.render  = function (req, res, next) {
    res.render("index", {
        title : "Homepage"        
    });
}

exports.signin  = function (req, res, next) {
    res.render("signin", {
        title : "Login Page"        
    });
}

exports.login  = function (req, res, next) {
    var email = req.body.email;
    var password = req.body.password;
    
    console.log("login with email: "+email)
    Student.findOne({email: email, password: password}, function (err, student) {
        if (err) {
            return next(err);
        } else {
            console.log("login-findOne",JSON.stringify(student))

            var session = req.session;
            session.studentId = student._id;
            session.studentFirstName = student.firstName;
            session.studentLastName = student.lastName;
            session.email = student.email

            console.log("redirecting to submit_assessment_feedback")
            res.redirect("submit_assessment_feedback");
        }
    });
}