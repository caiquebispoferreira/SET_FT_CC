const index = require('../../app/controllers/index.server.controller');
const students = require('../../app/controllers/students.server.controller');

module.exports = function (app) {
    app.get("/", index.render);
    app.get("/signin", index.signin);
    app.post("/signin", (req, res) => {
        index.login(req, res);
    });
}