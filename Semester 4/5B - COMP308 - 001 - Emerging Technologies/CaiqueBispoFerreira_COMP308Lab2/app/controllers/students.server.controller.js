var Student = require('mongoose').model('Student');

exports.signup  = function (req, res, next) {
    res.render("signup", {
        title : "Sign Up as a Student"        
    });
}

exports.studentByEmail = function (req, res, next, email) {
    console.log("studentByEmail",email)
    Student.findOne({
        email: email 
    }, (err, student) => {
        if (err) {
            return next(err);
        } else {
            req.student = student;
            console.log("studentByEmail",student);
            // Call the next middleware
            next();
        }
    });
};

exports.post = function (req, res, next) {
    var student = new Student(req.body); 
    console.log("body: " + JSON.stringify(req.body));

    student.save(function (err) {
        if (err) {
            return next(err);
        } else {
            //res.json(student);

            res.redirect("signin");
        }
    });
};

exports.list = function (req, res, next) {
    Student.find({}, function (err, students) {
        if (err) {
            return next(err);
        } else {
            //res.json(students);
            res.render("students", {
                title : "Students Page",
                students : students,        
            });
        }
    });
};
