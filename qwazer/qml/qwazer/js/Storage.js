var NO_VALUE = "Unknown";

//storage.js - taken from http://www.developer.nokia.com/Community/Wiki/How-to_create_a_persistent_settings_database_in_Qt_Quick_(QML)
// First, let's create a short helper function to get the database connection
function getDatabase() {
     return openDatabaseSync("qwazer", "0.0.6", "QwazerSettings", 100000);
}

// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // tx.executeSql('DROP TABLE IF EXISTS settings');
            // Create the settings table if it doesn't already exist
            // If the table exists, this is skipped
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS favoriteLocations(name TEXT UNIQUE, details TEXT)');
          });

    db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM favoriteLocations;');
            for(var i = 0; i < rs.rows.length; i++) {
                var location = rs.rows.item(i).details;
                favoriteLocations.append(JSON.parse(location));
            }
         });
}

// This function is used to write a setting into the database
function setSetting(setting, value) {
    console.log("save " + setting + " " + value);
   // setting: string representing the setting name (eg: “username”)
   // value: string representing the value of the setting (eg: “myUsername”)
   var db = getDatabase();
   var res = "";
   db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
  // The function returns “OK” if it was successful, or “Error” if it wasn't
  return res;
}
// This function is used to retrieve a setting from the database
function getSetting(setting) {
   var db = getDatabase();
   var res="";
   db.transaction(function(tx) {
     var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
     if (rs.rows.length > 0) {
          res = rs.rows.item(0).value;
     } else {
         res = NO_VALUE;
     }
  })

  console.log("load " + setting + " " + res);

  // The function returns “Unknown” if the setting was not found in the database
  // For more advanced projects, this should probably be handled through error codes
  return res;
}

function setObjectSetting(setting, value)
{
    setSetting(setting, value? JSON.stringify(value) : NO_VALUE);
}

function getObjectSetting(setting)
{
    var value = getSetting(setting);
    return isValidValue(value) && value !== "" ? JSON.parse(value) : NO_VALUE;
}

function setBooleanSetting(setting, value)
{
    setSetting(setting, value);
}

function getBooleanSetting(setting)
{
    var value = getSetting(setting);
    return isValidValue(value) ? value == 'true' : NO_VALUE;
}

function isValidValue(value)
{
    return value != NO_VALUE;
}

function addFavorite(details)
{
    var parsedDetails = JSON.stringify(details);
    console.log("add favorite " + parsedDetails);
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO favoriteLocations VALUES (?,?);', [details.name,parsedDetails]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}

function removeFavorite(name)
{
    console.log("remove favorite " + name);
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM favoriteLocations WHERE name = ?;', [name]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}

function isFavorite(name)
{
    console.log("check if location is favorite " + name);
    var db = getDatabase();
    var res = false;
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM favoriteLocations WHERE name = ?;', [name]);
        if (rs.rows.length > 0)
        {
            res = true;
        }
    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}
