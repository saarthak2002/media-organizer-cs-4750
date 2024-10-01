const { userService } = require("../services")

const getUser = (request, response) => {
    response.send("get the user here")
}

const postUser = async (request, response) => {
    const requestBody = request.body
    if(requestBody["email"] && requestBody["password"] && requestBody["firstName"] && requestBody["lastName"]) {
        
        // check if user with email already exists
        const userWithEmail = await userService.findUserByEmail(requestBody["email"])

        if(!userWithEmail) { // return HTTP 500 if problem with DB
            response.status(500).end();
            return;
        }

        if(userWithEmail.recordset) {
            if(userWithEmail.recordset.length > 0) {
                response.status(409).end("A user with this email already exists");
            }
            else {
                const newUser = await userService.createUser(requestBody["email"], requestBody["password"], requestBody["firstName"], requestBody["lastName"])

                if(!newUser) { // return HTTP 500 if problem with DB
                    response.status(500).end();
                    return;
                }

                console.log(newUser)
                response.send("creating new user");
            }
        }
        else {
            response.status(500).end();
        }
        
    } else {
        response.status(400).end("Bad Request");
    }
}

module.exports = {
    getUser,
    postUser
}