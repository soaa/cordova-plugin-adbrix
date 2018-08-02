var exec = require('cordova/exec');

var AdbrixPlugin = {
	firstTimeExperience: function(options, successCallback, errorCallback) {
		exec(successCallback, errorCallback, "AdbrixPlugin", "firstTimeExperience", [options]);
	},
	retention: function(options, successCallback, errorCallback) {
		exec(successCallback, errorCallback, "AdbrixPlugin", "retention", [options]);
	},
	setAge: function(age, successCallback, errorCallback) {
		exec(successCallback, errorCallback, "AdbrixPlugin", "setAge", [age]);
	},
	setGender: function(gender, successCallback, errorCallback) {
		exec(successCallback, errorCallback, "AdbrixPlugin", "setGender", [gender]);
	},
  deeplinkOpen: function(url, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "AdbrixPlugin", "deeplinkOpen", [url]);
  }
}

module.exports = AdbrixPlugin;
