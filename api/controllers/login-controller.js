const { userService } = require("../services")

const postLogin = async (request, response) => {
    const requestBody = request.body
    if(requestBody["email"] && requestBody["password"]) {
        const userWithEmail = await userService.findUserByEmail(requestBody["email"]);

        if(!userWithEmail) { // return HTTP 500 if problem with DB
            response.status(500).end();
            return;
        }

        if(userWithEmail.recordset) {
            if(userWithEmail.recordset.length === 0) {
                response.status(404).end("User not found");
            }
            else {
                const dbPassword = userWithEmail.recordset[0]['passwordHash'];
                if(dbPassword === requestBody["password"]) {
                    let responseUserInfo = userWithEmail['recordset'][0];
                    delete responseUserInfo.passwordHash;
                    response.send(responseUserInfo);
                }
                else {
                    response.status(401).end("Incorrect password");
                }
            }
        }
        else {
            response.status(500).end();
        }
    }
    else {
        response.status(400).end("Bad Request");
    }
}

module.exports = {
    postLogin
}