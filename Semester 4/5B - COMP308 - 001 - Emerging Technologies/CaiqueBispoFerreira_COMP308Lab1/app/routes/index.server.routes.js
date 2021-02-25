module.exports = function (app) {

    var index = require("../controllers/index.server.controller");
    var login = require("../controllers/login.server.controller");
    var display = require("../controllers/comments.server.controller");
    var thanks = require("../controllers/thankyou.server.controller");
  
    app.get("/", index.render);
    app.post("/",login.render);
    app.get("/comments", display.render);
    app.post("/comments", (req, res) => {
        thanks.render(req, res);
    });
    app.get("/thankyou", thanks.render);
};