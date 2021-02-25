exports.render = function ( req, res) {
    var session = req.session;

    res.render("comments", {
        title : "Comments Page",
        email : session.email,        
    });
};