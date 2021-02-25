exports.render = function(req, res){
    var session = req.session;
    var comments = req.body.comments;
    console.log("comments");
    res.render("thankyou", {
        title: "Thank You Page",
        email: session.email,
        comments: comments,
    });
}