const students = require('../../app/controllers/students.server.controller');

module.exports = function (app) {
    app.route('/students')
	    .post(students.post)
	    .get(students.list);

    app.route('/signup').get(students.signup);
}