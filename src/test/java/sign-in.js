function(creds) {
    var temp = creds.username + ':' + creds.password;
    var Base64 = Java.type("java.util.Base64");
    var token = Base64.getEncoder().encodeToString(temp.bytes);
    return 'Basic ' + token;
}