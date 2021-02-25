exports.render = function (req, res) {
    var session = req.session;
    session.email = req.body.email;
  
    res.redirect("/comments");
  };