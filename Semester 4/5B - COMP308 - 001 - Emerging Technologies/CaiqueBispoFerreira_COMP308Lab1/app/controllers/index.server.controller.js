exports.render = function ( req, res) {
    var email = req.body.email;
    var session = req.session;

    session.email= email;

    res.render("index", {
        title : "Login Page"        
    });
};